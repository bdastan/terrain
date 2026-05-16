//+------------------------------------------------------------------+
//|  QuantBot v1.0 — Expert Advisor for MetaTrader 5                 |
//|  Strategies: Bollinger Breakout, Volume Trend, RSI Reversion,    |
//|              MACD Crossover, Golden Cross (user-selectable)       |
//|                                                                   |
//|  DISCLAIMER: Use at your own risk. Always test on demo account   |
//|  before live trading. Past performance ≠ future results.         |
//+------------------------------------------------------------------+

#property copyright "QuantBot v1.0"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>

//--- enums
enum ENUM_STRATEGY {
    STRATEGY_BOLLINGER_BREAKOUT  = 0,  // Bollinger Band Squeeze Breakout
    STRATEGY_VOLUME_TREND        = 1,  // Volume-Confirmed Trend
    STRATEGY_RSI_REVERSION       = 2,  // RSI Mean Reversion
    STRATEGY_MACD_CROSSOVER      = 3,  // MACD Crossover
    STRATEGY_GOLDEN_CROSS        = 4,  // Golden Cross SMA50/200
    STRATEGY_COMBINED            = 5,  // Multi-signal Combined (recommended)
};

enum ENUM_LOT_MODE {
    LOT_FIXED     = 0,  // Fixed lot size
    LOT_RISK_PCT  = 1,  // % of balance per trade (recommended)
};

//=== INPUT PARAMETERS =========================================================

input group "=== STRATEGY ==="
input ENUM_STRATEGY  InpStrategy       = STRATEGY_COMBINED;  // Strategy
input bool           InpUseLong        = true;               // Trade Long (Buy)
input bool           InpUseShort       = false;              // Trade Short (Sell) — crypto: disable

input group "=== RISK MANAGEMENT ==="
input ENUM_LOT_MODE  InpLotMode        = LOT_RISK_PCT;       // Lot sizing mode
input double         InpFixedLot       = 0.01;               // Fixed lot (if Fixed mode)
input double         InpRiskPct        = 1.0;                // Risk % per trade (if Risk% mode)
input double         InpStopLossPct    = 3.0;                // Stop-loss % from entry (0 = ATR-based)
input double         InpTakeProfitPct  = 6.0;                // Take-profit % from entry (0 = disable)
input double         InpAtrMultSL      = 2.0;                // ATR multiplier for stop-loss (if SL%=0)
input double         InpAtrMultTP      = 4.0;                // ATR multiplier for take-profit (if TP%=0)
input int            InpMaxOpenTrades  = 1;                  // Max simultaneous open positions
input double         InpMaxDailyLoss   = 5.0;                // Max daily loss % before halting (0=off)

input group "=== BOLLINGER BREAKOUT ==="
input int            InpBBPeriod       = 20;                 // BB period
input double         InpBBDev          = 2.0;                // BB standard deviations
input int            InpSqueezeLen     = 20;                 // Squeeze lookback (candles)
input double         InpSqueezePct     = 0.5;                // Squeeze threshold (BB width vs avg)

input group "=== VOLUME TREND ==="
input int            InpVolSMA         = 20;                 // Volume SMA period
input double         InpVolMult        = 1.5;                // Volume multiplier for confirmation
input int            InpTrendSMA       = 50;                 // Trend SMA period

input group "=== RSI ==="
input int            InpRSIPeriod      = 14;                 // RSI period
input int            InpRSIOversold    = 30;                 // RSI oversold level (buy)
input int            InpRSIOverbought  = 70;                 // RSI overbought level (sell)

input group "=== MACD ==="
input int            InpMACDFast       = 12;                 // MACD fast EMA
input int            InpMACDSlow       = 26;                 // MACD slow EMA
input int            InpMACDSignal     = 9;                  // MACD signal

input group "=== GOLDEN CROSS ==="
input int            InpSMAFast        = 50;                 // Fast SMA
input int            InpSMASlow        = 200;                // Slow SMA

input group "=== COMBINED SIGNAL ==="
input int            InpMinBullScore   = 4;                  // Min bull signals (of 5) to buy
input int            InpMinBearScore   = 4;                  // Min bear signals (of 5) to sell

input group "=== EXECUTION ==="
input ulong          InpMagicNumber    = 202600001;          // Magic number (EA identifier)
input int            InpSlippage       = 10;                 // Max slippage (points)
input string         InpComment        = "QuantBot_v1";      // Order comment

//=== GLOBAL VARIABLES =========================================================
CTrade      trade;
CPositionInfo posInfo;
CAccountInfo  accountInfo;

int  handleBB, handleATR, handleRSI, handleMACD, handleSMA50, handleSMA200;
int  handleVolSMA, handleTrendSMA;

double dailyStartBalance = 0;
datetime lastDayChecked  = 0;
datetime lastBarTime     = 0;

//=== INIT =====================================================================
int OnInit() {
    trade.SetExpertMagicNumber(InpMagicNumber);
    trade.SetDeviationInPoints(InpSlippage);
    trade.SetTypeFilling(ORDER_FILLING_IOC);
    trade.LogLevel(LOG_LEVEL_ERRORS);

    string sym = _Symbol;
    ENUM_TIMEFRAMES tf = _Period;

    handleBB      = iBands(sym, tf, InpBBPeriod, 0, InpBBDev, PRICE_CLOSE);
    handleATR     = iATR(sym, tf, 14);
    handleRSI     = iRSI(sym, tf, InpRSIPeriod, PRICE_CLOSE);
    handleMACD    = iMACD(sym, tf, InpMACDFast, InpMACDSlow, InpMACDSignal, PRICE_CLOSE);
    handleSMA50   = iMA(sym, tf, InpSMAFast, 0, MODE_SMA, PRICE_CLOSE);
    handleSMA200  = iMA(sym, tf, InpSMASlow, 0, MODE_SMA, PRICE_CLOSE);
    handleVolSMA  = iMA(sym, tf, InpVolSMA, 0, MODE_SMA, VOLUME_TICK);
    handleTrendSMA= iMA(sym, tf, InpTrendSMA, 0, MODE_SMA, PRICE_CLOSE);

    if (handleBB == INVALID_HANDLE || handleATR == INVALID_HANDLE ||
        handleRSI == INVALID_HANDLE || handleMACD == INVALID_HANDLE ||
        handleSMA50 == INVALID_HANDLE || handleSMA200 == INVALID_HANDLE) {
        Print("ERROR: Failed to create indicator handles");
        return INIT_FAILED;
    }

    dailyStartBalance = accountInfo.Balance();
    lastDayChecked    = TimeCurrent();

    Print("QuantBot v1.0 initialized | Strategy: ", EnumToString(InpStrategy),
          " | Symbol: ", sym, " | TF: ", EnumToString(tf));
    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {
    IndicatorRelease(handleBB);
    IndicatorRelease(handleATR);
    IndicatorRelease(handleRSI);
    IndicatorRelease(handleMACD);
    IndicatorRelease(handleSMA50);
    IndicatorRelease(handleSMA200);
    IndicatorRelease(handleVolSMA);
    IndicatorRelease(handleTrendSMA);
}

//=== MAIN TICK ================================================================
void OnTick() {
    // Only act on new bar close
    datetime currentBar = iTime(_Symbol, _Period, 0);
    if (currentBar == lastBarTime) return;
    lastBarTime = currentBar;

    // Daily loss protection
    if (InpMaxDailyLoss > 0 && IsDailyLossExceeded()) {
        Comment("QuantBot: Daily loss limit reached — halted for today.");
        return;
    }

    // Read indicator values (index 1 = last closed bar)
    double bb_upper[], bb_mid[], bb_lower[], atr[], rsi[];
    double macd_main[], macd_signal[], sma50[], sma200[];
    double vol_sma[], trend_sma[];

    if (!GetIndicatorData(bb_upper, bb_mid, bb_lower, atr, rsi,
                          macd_main, macd_signal, sma50, sma200,
                          vol_sma, trend_sma))
        return;

    // Compute strategy signal
    int signal = ComputeSignal(bb_upper, bb_mid, bb_lower, atr, rsi,
                                macd_main, macd_signal, sma50, sma200,
                                vol_sma, trend_sma);

    int openPositions = CountOpenPositions();

    // --- ENTRY ---
    if (signal == 1 && InpUseLong && openPositions < InpMaxOpenTrades) {
        double entry  = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
        double sl     = CalcStopLoss(entry, ORDER_TYPE_BUY, atr[1]);
        double tp     = CalcTakeProfit(entry, ORDER_TYPE_BUY, atr[1]);
        double lots   = CalcLotSize(entry, sl);
        if (lots > 0)
            trade.Buy(lots, _Symbol, entry, sl, tp, InpComment);
    }
    else if (signal == -1 && InpUseShort && openPositions < InpMaxOpenTrades) {
        double entry = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        double sl    = CalcStopLoss(entry, ORDER_TYPE_SELL, atr[1]);
        double tp    = CalcTakeProfit(entry, ORDER_TYPE_SELL, atr[1]);
        double lots  = CalcLotSize(entry, sl);
        if (lots > 0)
            trade.Sell(lots, _Symbol, entry, sl, tp, InpComment);
    }

    // --- EXIT (signal reversal) ---
    if (openPositions > 0) {
        ManageExistingPositions(signal);
    }

    // Display dashboard
    ShowDashboard(signal, openPositions, bb_upper[1], bb_mid[1], bb_lower[1],
                  rsi[1], macd_main[1], sma50[1], sma200[1]);
}

//=== SIGNAL COMPUTATION =======================================================
int ComputeSignal(const double &bb_upper[], const double &bb_mid[],
                  const double &bb_lower[], const double &atr[],
                  const double &rsi[], const double &macd_main[],
                  const double &macd_signal[], const double &sma50[],
                  const double &sma200[], const double &vol_sma[],
                  const double &trend_sma[]) {

    double close1 = iClose(_Symbol, _Period, 1);
    double close2 = iClose(_Symbol, _Period, 2);
    double open1  = iOpen(_Symbol, _Period, 1);
    double vol1   = iVolume(_Symbol, _Period, 1);

    switch (InpStrategy) {
        case STRATEGY_BOLLINGER_BREAKOUT:
            return SignalBollingerBreakout(bb_upper, bb_mid, bb_lower, close1, close2);
        case STRATEGY_VOLUME_TREND:
            return SignalVolumeTrend(close1, open1, vol1, vol_sma, trend_sma);
        case STRATEGY_RSI_REVERSION:
            return SignalRSI(rsi);
        case STRATEGY_MACD_CROSSOVER:
            return SignalMACD(macd_main, macd_signal);
        case STRATEGY_GOLDEN_CROSS:
            return SignalGoldenCross(sma50, sma200);
        case STRATEGY_COMBINED:
            return SignalCombined(close1, open1, rsi, macd_main, macd_signal,
                                  sma50, sma200, vol1, vol_sma);
        default:
            return 0;
    }
}

// ── Bollinger Breakout ────────────────────────────────────────────────────────
int SignalBollingerBreakout(const double &bbu[], const double &bbm[],
                             const double &bbl[], double close1, double close2) {
    // Compute BB width for recent candles to detect squeeze
    double width_now = bbu[1] - bbl[1];
    double width_avg = 0;
    for (int i = 1; i <= InpSqueezeLen; i++)
        width_avg += (bbu[i] - bbl[i]);
    width_avg /= InpSqueezeLen;

    bool squeeze = (width_now < width_avg * InpSqueezePct);

    // Previous candle inside bands, current breakout after squeeze
    bool was_inside = (close2 >= bbl[2] && close2 <= bbu[2]);
    if (was_inside || squeeze) {
        if (close1 > bbu[1]) return  1;   // Bullish breakout
        if (close1 < bbl[1]) return -1;   // Bearish breakout
    }
    return 0;
}

// ── Volume Trend ──────────────────────────────────────────────────────────────
int SignalVolumeTrend(double close1, double open1, double vol1,
                      const double &vol_sma[], const double &trend_sma[]) {
    bool high_vol    = (vol_sma[1] > 0 && vol1 > vol_sma[1] * InpVolMult);
    bool price_up    = (close1 > open1);
    bool above_trend = (close1 > trend_sma[1]);

    if (high_vol && price_up && above_trend)  return  1;
    if (high_vol && !price_up && !above_trend) return -1;
    return 0;
}

// ── RSI Mean Reversion ────────────────────────────────────────────────────────
int SignalRSI(const double &rsi[]) {
    // Buy: RSI crosses back above oversold from below
    if (rsi[1] > InpRSIOversold  && rsi[2] <= InpRSIOversold)  return  1;
    // Sell: RSI crosses back below overbought from above
    if (rsi[1] < InpRSIOverbought && rsi[2] >= InpRSIOverbought) return -1;
    return 0;
}

// ── MACD Crossover ────────────────────────────────────────────────────────────
int SignalMACD(const double &macd[], const double &sig[]) {
    if (macd[1] > sig[1] && macd[2] <= sig[2]) return  1;
    if (macd[1] < sig[1] && macd[2] >= sig[2]) return -1;
    return 0;
}

// ── Golden Cross ──────────────────────────────────────────────────────────────
int SignalGoldenCross(const double &fast[], const double &slow[]) {
    if (fast[1] > slow[1] && fast[2] <= slow[2]) return  1;   // Golden cross
    if (fast[1] < slow[1] && fast[2] >= slow[2]) return -1;   // Death cross
    return 0;
}

// ── Combined Multi-Signal ─────────────────────────────────────────────────────
int SignalCombined(double close1, double open1,
                   const double &rsi[], const double &macd[], const double &sig[],
                   const double &sma50[], const double &sma200[],
                   double vol1, const double &vol_sma[]) {
    int bull = 0;
    if (close1 > sma50[1])  bull++;
    if (close1 > sma200[1]) bull++;
    if (rsi[1] > 50)        bull++;
    if (macd[1] - sig[1] > 0) bull++;
    if (close1 > open1)     bull++;
    // Optional: volume confirmation
    if (vol_sma[1] > 0 && vol1 > vol_sma[1] * 1.2) {
        if (close1 > open1) bull++;
        else                bull--;
    }
    int bear = 5 - MathMin(bull, 5);
    if (bull >= InpMinBullScore) return  1;
    if (bear >= InpMinBearScore) return -1;
    return 0;
}

//=== POSITION MANAGEMENT ======================================================
void ManageExistingPositions(int newSignal) {
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (!posInfo.SelectByIndex(i)) continue;
        if (posInfo.Symbol() != _Symbol) continue;
        if (posInfo.Magic() != InpMagicNumber) continue;

        // Close on signal reversal
        if (posInfo.PositionType() == POSITION_TYPE_BUY && newSignal == -1)
            trade.PositionClose(posInfo.Ticket());
        else if (posInfo.PositionType() == POSITION_TYPE_SELL && newSignal == 1)
            trade.PositionClose(posInfo.Ticket());
    }
}

//=== RISK MANAGEMENT HELPERS ==================================================
double CalcStopLoss(double entry, ENUM_ORDER_TYPE type, double atr14) {
    double dist;
    if (InpStopLossPct > 0)
        dist = entry * InpStopLossPct / 100.0;
    else
        dist = atr14 * InpAtrMultSL;

    dist = MathMax(dist, SymbolInfoDouble(_Symbol, SYMBOL_POINT) * 10);

    return (type == ORDER_TYPE_BUY) ? entry - dist : entry + dist;
}

double CalcTakeProfit(double entry, ENUM_ORDER_TYPE type, double atr14) {
    if (InpTakeProfitPct == 0 && InpAtrMultTP == 0) return 0;

    double dist;
    if (InpTakeProfitPct > 0)
        dist = entry * InpTakeProfitPct / 100.0;
    else
        dist = atr14 * InpAtrMultTP;

    return (type == ORDER_TYPE_BUY) ? entry + dist : entry - dist;
}

double CalcLotSize(double entry, double sl) {
    if (InpLotMode == LOT_FIXED)
        return NormalizeLot(InpFixedLot);

    if (sl <= 0 || entry <= sl) return 0;

    double balance    = accountInfo.Balance();
    double risk_money = balance * InpRiskPct / 100.0;
    double sl_dist    = MathAbs(entry - sl);
    double tick_value = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double tick_size  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);

    if (tick_size <= 0 || tick_value <= 0) return NormalizeLot(InpFixedLot);

    double lot = risk_money / (sl_dist / tick_size * tick_value);
    return NormalizeLot(lot);
}

double NormalizeLot(double lot) {
    double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    double stepLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
    lot = MathFloor(lot / stepLot) * stepLot;
    return MathMax(minLot, MathMin(maxLot, lot));
}

int CountOpenPositions() {
    int count = 0;
    for (int i = 0; i < PositionsTotal(); i++) {
        if (posInfo.SelectByIndex(i) &&
            posInfo.Symbol() == _Symbol &&
            posInfo.Magic() == InpMagicNumber)
            count++;
    }
    return count;
}

bool IsDailyLossExceeded() {
    MqlDateTime now;
    TimeToStruct(TimeCurrent(), now);
    MqlDateTime last;
    TimeToStruct(lastDayChecked, last);

    if (now.day != last.day) {
        dailyStartBalance = accountInfo.Balance();
        lastDayChecked    = TimeCurrent();
        return false;
    }
    double loss_pct = (dailyStartBalance - accountInfo.Balance()) / dailyStartBalance * 100.0;
    return (loss_pct >= InpMaxDailyLoss);
}

//=== INDICATOR DATA READER ====================================================
bool GetIndicatorData(double &bbu[], double &bbm[], double &bbl[],
                      double &atr[], double &rsi[],
                      double &macd_m[], double &macd_s[],
                      double &sma50[], double &sma200[],
                      double &vol_sma[], double &trend_sma[]) {
    int bars = InpSMASlow + 10;

    ArraySetAsSeries(bbu, true); ArraySetAsSeries(bbm, true); ArraySetAsSeries(bbl, true);
    ArraySetAsSeries(atr, true); ArraySetAsSeries(rsi, true);
    ArraySetAsSeries(macd_m, true); ArraySetAsSeries(macd_s, true);
    ArraySetAsSeries(sma50, true); ArraySetAsSeries(sma200, true);
    ArraySetAsSeries(vol_sma, true); ArraySetAsSeries(trend_sma, true);

    if (CopyBuffer(handleBB,  1, 0, bars, bbu)     < bars) return false;
    if (CopyBuffer(handleBB,  0, 0, bars, bbm)     < bars) return false;
    if (CopyBuffer(handleBB,  2, 0, bars, bbl)     < bars) return false;
    if (CopyBuffer(handleATR, 0, 0, bars, atr)     < bars) return false;
    if (CopyBuffer(handleRSI, 0, 0, bars, rsi)     < bars) return false;
    if (CopyBuffer(handleMACD,0, 0, bars, macd_m)  < bars) return false;
    if (CopyBuffer(handleMACD,1, 0, bars, macd_s)  < bars) return false;
    if (CopyBuffer(handleSMA50,  0, 0, bars, sma50)    < bars) return false;
    if (CopyBuffer(handleSMA200, 0, 0, bars, sma200)   < bars) return false;
    if (CopyBuffer(handleVolSMA, 0, 0, bars, vol_sma)  < bars) return false;
    if (CopyBuffer(handleTrendSMA,0,0, bars, trend_sma)< bars) return false;

    return true;
}

//=== DASHBOARD ================================================================
void ShowDashboard(int signal, int openPos,
                   double bbu, double bbm, double bbl,
                   double rsi_val, double macd_val,
                   double sma50_val, double sma200_val) {
    string strat  = EnumToString(InpStrategy);
    string sig_str = (signal == 1 ? "▲ BUY" : signal == -1 ? "▼ SELL" : "● NEUTRAL");
    string sig_col = (signal == 1 ? "lime"  : signal == -1 ? "tomato" : "silver");

    double close = iClose(_Symbol, _Period, 1);
    double bal   = accountInfo.Balance();
    double eq    = accountInfo.Equity();
    double daily_pnl = eq - dailyStartBalance;

    string dash = "\n";
    dash += "════════════════════════════════\n";
    dash += "  QuantBot v1.0\n";
    dash += "════════════════════════════════\n";
    dash += "  Strategy : " + strat + "\n";
    dash += "  Signal   : " + sig_str + "\n";
    dash += "  Positions: " + IntegerToString(openPos) + "\n";
    dash += "────────────────────────────────\n";
    dash += "  Close    : " + DoubleToString(close, _Digits) + "\n";
    dash += "  BB Upper : " + DoubleToString(bbu, _Digits) + "\n";
    dash += "  BB Lower : " + DoubleToString(bbl, _Digits) + "\n";
    dash += "  RSI(14)  : " + DoubleToString(rsi_val, 1) + "\n";
    dash += "  MACD     : " + DoubleToString(macd_val, _Digits) + "\n";
    dash += "  SMA50    : " + DoubleToString(sma50_val, _Digits) + "\n";
    dash += "  SMA200   : " + DoubleToString(sma200_val, _Digits) + "\n";
    dash += "────────────────────────────────\n";
    dash += "  Balance  : " + DoubleToString(bal, 2) + "\n";
    dash += "  Daily P&L: " + DoubleToString(daily_pnl, 2) + "\n";
    dash += "════════════════════════════════\n";

    Comment(dash);
}

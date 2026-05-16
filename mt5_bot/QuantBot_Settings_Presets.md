# QuantBot v1.0 — Presets de configuration

## Preset 1 : BTC/ETH conservateur (recommandé pour débuter)
```
Strategy           = STRATEGY_COMBINED
UseLong            = true
UseShort           = false
LotMode            = LOT_RISK_PCT
RiskPct            = 0.5            ← 0.5% du capital par trade
StopLossPct        = 3.0            ← SL à 3%
TakeProfitPct      = 6.0            ← TP à 6% (ratio 1:2)
MaxOpenTrades      = 1
MaxDailyLoss       = 3.0
MinBullScore       = 4
```

## Preset 2 : Bollinger Breakout agressif (SOL, AVAX)
```
Strategy           = STRATEGY_BOLLINGER_BREAKOUT
LotMode            = LOT_RISK_PCT
RiskPct            = 1.0
StopLossPct        = 0              ← ATR-based stop
AtrMultSL          = 2.0
AtrMultTP          = 5.0
SqueezeLen         = 20
SqueezePct         = 0.5
MaxOpenTrades      = 1
MaxDailyLoss       = 5.0
```

## Preset 3 : RSI Reversion (BTC daily)
```
Strategy           = STRATEGY_RSI_REVERSION
LotMode            = LOT_RISK_PCT
RiskPct            = 1.0
StopLossPct        = 4.0
TakeProfitPct      = 8.0
RSIOversold        = 30
RSIOverbought      = 70
MaxOpenTrades      = 2              ← RSI peut générer plusieurs signaux
MaxDailyLoss       = 5.0
```

## Preset 4 : Actions traditionnelles (SPY, AAPL)
```
Strategy           = STRATEGY_GOLDEN_CROSS
UseLong            = true
UseShort           = false
LotMode            = LOT_RISK_PCT
RiskPct            = 1.0
StopLossPct        = 2.0
TakeProfitPct      = 0              ← Laisser courir, pas de TP fixe
AtrMultTP          = 0
SMAFast            = 50
SMASlow            = 200
MaxDailyLoss       = 3.0
```

## Règles de money management
- Ne jamais risquer plus de 1-2% par trade
- MaxDailyLoss à 3-5% maximum
- Toujours tester sur DEMO avant le compte réel
- Backtester sur au moins 2 ans de données dans MT5

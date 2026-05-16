"""
Trading strategies. Each strategy returns a pd.Series of signals:
  +1 = buy/long
  -1 = sell/short (or exit)
   0 = no position
"""
import pandas as pd
import numpy as np
from indicators import add_all_indicators


def _clean(df: pd.DataFrame) -> pd.DataFrame:
    return add_all_indicators(df).dropna()


# ─── Strategy 1: Golden Cross / Death Cross ───────────────────────────────────
def golden_cross(df: pd.DataFrame, fast: int = 50, slow: int = 200) -> pd.Series:
    """
    Buy when SMA-fast crosses above SMA-slow (Golden Cross).
    Sell when SMA-fast crosses below SMA-slow (Death Cross).
    """
    df = _clean(df)
    fast_col = f"sma{fast}"
    slow_col = f"sma{slow}"
    signal = pd.Series(0, index=df.index)
    cross_up = (df[fast_col] > df[slow_col]) & (df[fast_col].shift() <= df[slow_col].shift())
    cross_down = (df[fast_col] < df[slow_col]) & (df[fast_col].shift() >= df[slow_col].shift())
    signal[cross_up] = 1
    signal[cross_down] = -1
    return signal.reindex(df.index, fill_value=0)


# ─── Strategy 2: RSI Mean Reversion ───────────────────────────────────────────
def rsi_mean_reversion(df: pd.DataFrame, oversold: int = 30, overbought: int = 70) -> pd.Series:
    """
    Buy when RSI exits oversold zone (< oversold → crosses back above).
    Sell when RSI exits overbought zone (> overbought → crosses back below).
    """
    df = _clean(df)
    signal = pd.Series(0, index=df.index)
    buy = (df["rsi14"] > oversold) & (df["rsi14"].shift() <= oversold)
    sell = (df["rsi14"] < overbought) & (df["rsi14"].shift() >= overbought)
    signal[buy] = 1
    signal[sell] = -1
    return signal


# ─── Strategy 3: MACD Crossover ───────────────────────────────────────────────
def macd_crossover(df: pd.DataFrame) -> pd.Series:
    """
    Buy when MACD line crosses above signal line.
    Sell when MACD line crosses below signal line.
    """
    df = _clean(df)
    signal = pd.Series(0, index=df.index)
    cross_up = (df["macd"] > df["macd_signal"]) & (df["macd"].shift() <= df["macd_signal"].shift())
    cross_down = (df["macd"] < df["macd_signal"]) & (df["macd"].shift() >= df["macd_signal"].shift())
    signal[cross_up] = 1
    signal[cross_down] = -1
    return signal


# ─── Strategy 4: Bollinger Band Squeeze Breakout ──────────────────────────────
def bollinger_breakout(df: pd.DataFrame, squeeze_pct: float = 0.05) -> pd.Series:
    """
    Detect a Bollinger squeeze (low BB width) then trade the breakout.
    Buy if price breaks above upper band after a squeeze.
    Sell if price breaks below lower band after a squeeze.
    """
    df = _clean(df)
    signal = pd.Series(0, index=df.index)
    squeeze = df["bb_width"] < df["bb_width"].rolling(20).mean() * squeeze_pct * 10
    break_up = (df["close"] > df["bb_upper"]) & squeeze.shift()
    break_down = (df["close"] < df["bb_lower"]) & squeeze.shift()
    signal[break_up] = 1
    signal[break_down] = -1
    return signal


# ─── Strategy 5: Volume-Confirmed Trend ───────────────────────────────────────
def volume_trend(df: pd.DataFrame, vol_multiplier: float = 1.5) -> pd.Series:
    """
    Buy: price above SMA50, volume > vol_multiplier * avg volume, price up from yesterday.
    Sell: price below SMA50 with high volume.
    """
    df = _clean(df)
    signal = pd.Series(0, index=df.index)
    high_vol = df["volume_ratio"] > vol_multiplier
    price_up = df["close"] > df["close"].shift()
    above_trend = df["close"] > df["sma50"]
    buy = high_vol & price_up & above_trend
    sell = high_vol & ~price_up & ~above_trend
    signal[buy] = 1
    signal[sell] = -1
    return signal


# ─── Strategy 6: Combined Multi-Signal ────────────────────────────────────────
def combined_signal(df: pd.DataFrame) -> pd.Series:
    """
    Score-based: buy when 3+ bullish signals align, sell when 3+ bearish signals.
    Signals: price vs SMA50, price vs SMA200, RSI < 50 (bear) or > 50 (bull),
             MACD histogram positive/negative, close > open (bull candle).
    """
    df = _clean(df)
    bull = (
        (df["close"] > df["sma50"]).astype(int) +
        (df["close"] > df["sma200"]).astype(int) +
        (df["rsi14"] > 50).astype(int) +
        (df["macd_hist"] > 0).astype(int) +
        (df["close"] > df["open"]).astype(int)
    )
    bear = 5 - bull

    signal = pd.Series(0, index=df.index)
    signal[bull >= 4] = 1
    signal[bear >= 4] = -1
    return signal


STRATEGIES = {
    "Golden Cross (SMA50/200)": golden_cross,
    "RSI Mean Reversion": rsi_mean_reversion,
    "MACD Crossover": macd_crossover,
    "Bollinger Breakout": bollinger_breakout,
    "Volume Trend": volume_trend,
    "Combined Multi-Signal": combined_signal,
}

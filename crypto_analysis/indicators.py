"""
Technical indicators computed on OHLCV DataFrames.
"""
import pandas as pd
import numpy as np


def sma(series: pd.Series, period: int) -> pd.Series:
    return series.rolling(period).mean()


def ema(series: pd.Series, period: int) -> pd.Series:
    return series.ewm(span=period, adjust=False).mean()


def rsi(series: pd.Series, period: int = 14) -> pd.Series:
    delta = series.diff()
    gain = delta.clip(lower=0).rolling(period).mean()
    loss = (-delta.clip(upper=0)).rolling(period).mean()
    rs = gain / loss.replace(0, np.nan)
    return 100 - (100 / (1 + rs))


def macd(series: pd.Series, fast: int = 12, slow: int = 26, signal: int = 9):
    fast_ema = ema(series, fast)
    slow_ema = ema(series, slow)
    macd_line = fast_ema - slow_ema
    signal_line = ema(macd_line, signal)
    histogram = macd_line - signal_line
    return macd_line, signal_line, histogram


def bollinger_bands(series: pd.Series, period: int = 20, std_mult: float = 2.0):
    mid = sma(series, period)
    std = series.rolling(period).std()
    upper = mid + std_mult * std
    lower = mid - std_mult * std
    return upper, mid, lower


def atr(df: pd.DataFrame, period: int = 14) -> pd.Series:
    hl = df["high"] - df["low"]
    hc = (df["high"] - df["close"].shift()).abs()
    lc = (df["low"] - df["close"].shift()).abs()
    tr = pd.concat([hl, hc, lc], axis=1).max(axis=1)
    return tr.rolling(period).mean()


def add_all_indicators(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    close = df["close"]
    df["sma20"] = sma(close, 20)
    df["sma50"] = sma(close, 50)
    df["sma200"] = sma(close, 200)
    df["ema12"] = ema(close, 12)
    df["ema26"] = ema(close, 26)
    df["rsi14"] = rsi(close, 14)
    df["macd"], df["macd_signal"], df["macd_hist"] = macd(close)
    df["bb_upper"], df["bb_mid"], df["bb_lower"] = bollinger_bands(close)
    df["atr14"] = atr(df, 14)
    df["bb_width"] = (df["bb_upper"] - df["bb_lower"]) / df["bb_mid"]
    df["volume_sma20"] = sma(df["volume"], 20)
    df["volume_ratio"] = df["volume"] / df["volume_sma20"]
    return df

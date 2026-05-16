"""
Statistical pattern scanner: finds recurring price formations.
Looks for: consolidation breakouts, RSI divergences, volume spikes before big moves.
"""
import pandas as pd
import numpy as np
from indicators import add_all_indicators


def find_consolidations(df: pd.DataFrame, window: int = 10, range_pct: float = 0.05) -> pd.DataFrame:
    """
    Find periods where price consolidated (< range_pct range) then broke out.
    Returns each breakout event with the subsequent 1/2/4-week returns.
    """
    df = add_all_indicators(df).dropna()
    events = []

    for i in range(window, len(df) - 20):
        window_slice = df.iloc[i - window:i]
        price_range = (window_slice["close"].max() - window_slice["close"].min()) / window_slice["close"].mean()

        if price_range < range_pct:
            breakout_candle = df.iloc[i]
            prev_high = window_slice["close"].max()
            prev_low = window_slice["close"].min()

            direction = None
            if breakout_candle["close"] > prev_high * 1.01:
                direction = "UP"
            elif breakout_candle["close"] < prev_low * 0.99:
                direction = "DOWN"

            if direction:
                entry = breakout_candle["close"]
                ret_1w = (df["close"].iloc[min(i + 7, len(df) - 1)] / entry - 1) * 100
                ret_2w = (df["close"].iloc[min(i + 14, len(df) - 1)] / entry - 1) * 100
                ret_4w = (df["close"].iloc[min(i + 28, len(df) - 1)] / entry - 1) * 100
                events.append({
                    "date": df.index[i],
                    "direction": direction,
                    "consolidation_range_pct": round(price_range * 100, 2),
                    "entry_price": round(entry, 4),
                    "ret_1w_pct": round(ret_1w, 2),
                    "ret_2w_pct": round(ret_2w, 2),
                    "ret_4w_pct": round(ret_4w, 2),
                })

    return pd.DataFrame(events)


def find_rsi_divergences(df: pd.DataFrame, lookback: int = 5) -> pd.DataFrame:
    """
    Bullish divergence: price makes lower low but RSI makes higher low → potential reversal up.
    Bearish divergence: price makes higher high but RSI makes lower high → potential reversal down.
    """
    df = add_all_indicators(df).dropna()
    events = []

    for i in range(lookback, len(df) - 10):
        window = df.iloc[i - lookback:i + 1]
        curr = df.iloc[i]
        prev_idx = window["close"].idxmin()
        prev = df.loc[prev_idx]

        # Bullish divergence
        if (curr["close"] < prev["close"] and curr["rsi14"] > prev["rsi14"]):
            ret_2w = (df["close"].iloc[min(i + 14, len(df) - 1)] / curr["close"] - 1) * 100
            events.append({
                "date": df.index[i],
                "type": "BULLISH_DIVERGENCE",
                "price_change_pct": round((curr["close"] / prev["close"] - 1) * 100, 2),
                "rsi_change": round(curr["rsi14"] - prev["rsi14"], 2),
                "ret_2w_pct": round(ret_2w, 2),
            })

        prev_idx2 = window["close"].idxmax()
        prev2 = df.loc[prev_idx2]

        # Bearish divergence
        if (curr["close"] > prev2["close"] and curr["rsi14"] < prev2["rsi14"]):
            ret_2w = (df["close"].iloc[min(i + 14, len(df) - 1)] / curr["close"] - 1) * 100
            events.append({
                "date": df.index[i],
                "type": "BEARISH_DIVERGENCE",
                "price_change_pct": round((curr["close"] / prev2["close"] - 1) * 100, 2),
                "rsi_change": round(curr["rsi14"] - prev2["rsi14"], 2),
                "ret_2w_pct": round(ret_2w, 2),
            })

    return pd.DataFrame(events).drop_duplicates(subset=["date", "type"]) if events else pd.DataFrame()


def find_volume_spikes(df: pd.DataFrame, spike_mult: float = 3.0) -> pd.DataFrame:
    """
    Find days where volume is spike_mult × the 20-day average.
    Measure subsequent returns to see if volume spikes predict direction.
    """
    df = add_all_indicators(df).dropna()
    events = []

    spike_mask = df["volume_ratio"] >= spike_mult
    for i, (ts, row) in enumerate(df[spike_mask].iterrows()):
        idx = df.index.get_loc(ts)
        direction = "UP" if row["close"] > row["open"] else "DOWN"
        ret_1w = (df["close"].iloc[min(idx + 7, len(df) - 1)] / row["close"] - 1) * 100
        ret_2w = (df["close"].iloc[min(idx + 14, len(df) - 1)] / row["close"] - 1) * 100
        events.append({
            "date": ts,
            "direction": direction,
            "volume_ratio": round(row["volume_ratio"], 2),
            "rsi_at_spike": round(row["rsi14"], 1),
            "ret_1w_pct": round(ret_1w, 2),
            "ret_2w_pct": round(ret_2w, 2),
        })

    return pd.DataFrame(events)


def summarize_pattern(df: pd.DataFrame, pattern_name: str) -> dict:
    """Summarize hit rate and avg return for a pattern DataFrame."""
    if df.empty:
        return {"pattern": pattern_name, "count": 0}

    ret_col = [c for c in df.columns if "ret_" in c]
    summary = {"pattern": pattern_name, "count": len(df)}
    for col in ret_col:
        vals = df[col]
        summary[f"{col}_avg"] = round(vals.mean(), 2)
        summary[f"{col}_win_rate"] = round((vals > 0).mean() * 100, 1)
    return summary

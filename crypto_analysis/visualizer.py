"""
Chart generation: equity curves, drawdowns, signal overlays.
"""
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import numpy as np
from pathlib import Path

OUTPUT_DIR = Path(__file__).parent / "output"
OUTPUT_DIR.mkdir(exist_ok=True)


def plot_strategy_comparison(results: list, symbol: str) -> str:
    fig, axes = plt.subplots(2, 1, figsize=(14, 10))
    fig.suptitle(f"Strategy Comparison — {symbol}", fontsize=14, fontweight="bold")

    ax_eq, ax_bar = axes
    colors = plt.cm.tab10.colors

    for i, r in enumerate(results):
        norm = r.equity_curve / r.equity_curve.iloc[0] * 100
        ax_eq.plot(norm.index, norm.values, label=r.strategy_name, color=colors[i % 10], linewidth=1.5)

    # Buy & Hold
    bh = results[0].equity_curve.copy()
    bh_norm = pd.Series(
        np.linspace(100, 100 * (1 + results[0].buy_hold_return_pct / 100), len(bh)),
        index=bh.index
    )
    ax_eq.plot(bh_norm.index, bh_norm.values, "--", color="gray", label="Buy & Hold", linewidth=1.2)
    ax_eq.set_ylabel("Portfolio Value (base 100)")
    ax_eq.legend(fontsize=8, ncol=2)
    ax_eq.grid(True, alpha=0.3)

    # Bar chart: total return comparison
    names = [r.strategy_name.replace(" ", "\n") for r in results]
    returns = [r.total_return_pct for r in results]
    bar_colors = ["#2ecc71" if r >= 0 else "#e74c3c" for r in returns]
    bars = ax_bar.bar(names, returns, color=bar_colors, edgecolor="black", linewidth=0.5)
    ax_bar.axhline(results[0].buy_hold_return_pct, color="gray", linestyle="--", label=f"Buy&Hold {results[0].buy_hold_return_pct:.1f}%")
    ax_bar.set_ylabel("Total Return (%)")
    ax_bar.legend(fontsize=9)
    ax_bar.grid(True, axis="y", alpha=0.3)
    for bar, val in zip(bars, returns):
        ax_bar.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 1,
                    f"{val:.1f}%", ha="center", va="bottom", fontsize=8)

    plt.tight_layout()
    path = OUTPUT_DIR / f"{symbol}_strategies.png"
    plt.savefig(path, dpi=150, bbox_inches="tight")
    plt.close()
    return str(path)


def plot_price_with_signals(df: pd.DataFrame, signals: pd.Series, result, symbol: str) -> str:
    fig = plt.figure(figsize=(16, 10))
    gs = gridspec.GridSpec(3, 1, height_ratios=[3, 1, 1], hspace=0.05)

    ax_price = fig.add_subplot(gs[0])
    ax_rsi = fig.add_subplot(gs[1], sharex=ax_price)
    ax_macd = fig.add_subplot(gs[2], sharex=ax_price)

    from indicators import add_all_indicators
    d = add_all_indicators(df).dropna()

    ax_price.plot(d.index, d["close"], color="#2c3e50", linewidth=1.2, label="Close")
    ax_price.plot(d.index, d["sma50"], color="#3498db", linewidth=1, linestyle="--", label="SMA50", alpha=0.8)
    ax_price.plot(d.index, d["sma200"], color="#e67e22", linewidth=1, linestyle="--", label="SMA200", alpha=0.8)
    ax_price.fill_between(d.index, d["bb_upper"], d["bb_lower"], alpha=0.08, color="#9b59b6", label="BB")

    # Buy/sell markers
    buys = signals[signals == 1].reindex(d.index).dropna()
    sells = signals[signals == -1].reindex(d.index).dropna()
    ax_price.scatter(buys.index, d["close"].reindex(buys.index), marker="^", color="#27ae60", s=80, zorder=5, label="Buy")
    ax_price.scatter(sells.index, d["close"].reindex(sells.index), marker="v", color="#e74c3c", s=80, zorder=5, label="Sell")

    ax_price.set_title(
        f"{symbol} — {result.strategy_name} | Return: {result.total_return_pct:.1f}% | Sharpe: {result.sharpe_ratio:.2f} | MaxDD: {result.max_drawdown_pct:.1f}%",
        fontsize=10
    )
    ax_price.legend(fontsize=8, ncol=3)
    ax_price.grid(True, alpha=0.3)

    ax_rsi.plot(d.index, d["rsi14"], color="#8e44ad", linewidth=1)
    ax_rsi.axhline(70, color="red", linestyle="--", alpha=0.5, linewidth=0.8)
    ax_rsi.axhline(30, color="green", linestyle="--", alpha=0.5, linewidth=0.8)
    ax_rsi.fill_between(d.index, d["rsi14"], 50, where=d["rsi14"] > 50, alpha=0.2, color="green")
    ax_rsi.fill_between(d.index, d["rsi14"], 50, where=d["rsi14"] < 50, alpha=0.2, color="red")
    ax_rsi.set_ylabel("RSI(14)", fontsize=8)
    ax_rsi.set_ylim(0, 100)
    ax_rsi.grid(True, alpha=0.3)

    ax_macd.plot(d.index, d["macd"], color="#2980b9", linewidth=1, label="MACD")
    ax_macd.plot(d.index, d["macd_signal"], color="#e74c3c", linewidth=1, label="Signal")
    ax_macd.bar(d.index, d["macd_hist"], color=["#2ecc71" if v >= 0 else "#e74c3c" for v in d["macd_hist"]], alpha=0.5, width=2)
    ax_macd.axhline(0, color="black", linewidth=0.5)
    ax_macd.set_ylabel("MACD", fontsize=8)
    ax_macd.legend(fontsize=7)
    ax_macd.grid(True, alpha=0.3)

    plt.setp(ax_price.get_xticklabels(), visible=False)
    plt.setp(ax_rsi.get_xticklabels(), visible=False)

    path = OUTPUT_DIR / f"{symbol}_{result.strategy_name.replace(' ', '_').replace('/', '')}.png"
    plt.savefig(path, dpi=150, bbox_inches="tight")
    plt.close()
    return str(path)


def plot_pattern_stats(consolidations: pd.DataFrame, vol_spikes: pd.DataFrame, symbol: str) -> str:
    fig, axes = plt.subplots(1, 2, figsize=(14, 5))
    fig.suptitle(f"Pattern Analysis — {symbol}", fontsize=13, fontweight="bold")

    # Consolidation breakouts
    ax1 = axes[0]
    if not consolidations.empty:
        up = consolidations[consolidations["direction"] == "UP"]
        dn = consolidations[consolidations["direction"] == "DOWN"]
        ax1.bar(["UP 1w", "UP 2w", "UP 4w"], [up["ret_1w_pct"].mean(), up["ret_2w_pct"].mean(), up["ret_4w_pct"].mean()],
                color="#2ecc71", label=f"Breakout UP (n={len(up)})")
        ax1.bar(["DN 1w", "DN 2w", "DN 4w"], [dn["ret_1w_pct"].mean(), dn["ret_2w_pct"].mean(), dn["ret_4w_pct"].mean()],
                color="#e74c3c", label=f"Breakout DOWN (n={len(dn)})", alpha=0.7)
        ax1.axhline(0, color="black", linewidth=0.8)
        ax1.set_title("Consolidation Breakouts: Avg Return After")
        ax1.set_ylabel("Avg Return (%)")
        ax1.legend(fontsize=9)
        ax1.grid(True, axis="y", alpha=0.3)
    else:
        ax1.text(0.5, 0.5, "No consolidation\nbreakouts found", ha="center", va="center", transform=ax1.transAxes)
        ax1.set_title("Consolidation Breakouts")

    # Volume spikes
    ax2 = axes[1]
    if not vol_spikes.empty:
        up_vol = vol_spikes[vol_spikes["direction"] == "UP"]
        dn_vol = vol_spikes[vol_spikes["direction"] == "DOWN"]
        ax2.bar(["UP 1w", "UP 2w"], [up_vol["ret_1w_pct"].mean(), up_vol["ret_2w_pct"].mean()],
                color="#2ecc71", label=f"Vol Spike UP (n={len(up_vol)})")
        ax2.bar(["DN 1w", "DN 2w"], [dn_vol["ret_1w_pct"].mean(), dn_vol["ret_2w_pct"].mean()],
                color="#e74c3c", label=f"Vol Spike DOWN (n={len(dn_vol)})", alpha=0.7)
        ax2.axhline(0, color="black", linewidth=0.8)
        ax2.set_title("Volume Spikes (3× avg): Avg Return After")
        ax2.set_ylabel("Avg Return (%)")
        ax2.legend(fontsize=9)
        ax2.grid(True, axis="y", alpha=0.3)
    else:
        ax2.text(0.5, 0.5, "No volume spikes\nfound", ha="center", va="center", transform=ax2.transAxes)
        ax2.set_title("Volume Spikes")

    plt.tight_layout()
    path = OUTPUT_DIR / f"{symbol}_patterns.png"
    plt.savefig(path, dpi=150, bbox_inches="tight")
    plt.close()
    return str(path)

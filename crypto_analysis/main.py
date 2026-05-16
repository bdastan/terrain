"""
Main analysis runner.
Usage:
    python main.py                          # default: BTC + ETH, daily, 1000 days
    python main.py --symbols BTCUSDT ETHUSDT SOLUSDT --interval 1d --days 1500
    python main.py --symbols BTCUSDT --stop-loss 0.08
"""
import argparse
import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

import pandas as pd
from tabulate import tabulate

from data_fetcher import fetch_ohlcv
from strategies import STRATEGIES
from backtester import run_backtest
from pattern_scanner import find_consolidations, find_volume_spikes, find_rsi_divergences, summarize_pattern
from visualizer import plot_strategy_comparison, plot_price_with_signals, plot_pattern_stats


def run_analysis(symbols: list[str], interval: str, days: int, stop_loss: float | None):
    all_results = []

    for symbol in symbols:
        print(f"\n{'='*60}")
        print(f"  Fetching {symbol} | interval={interval} | {days} days")
        print(f"{'='*60}")

        try:
            df = fetch_ohlcv(symbol, interval=interval, days=days)
        except Exception as e:
            print(f"  ERROR fetching {symbol}: {e}")
            continue

        print(f"  Got {len(df)} candles from {df.index[0].date()} to {df.index[-1].date()}")

        # ── Backtests ─────────────────────────────────────────────
        results = []
        print(f"\n  Running {len(STRATEGIES)} strategies...")
        for name, fn in STRATEGIES.items():
            try:
                r = run_backtest(df, fn, symbol=symbol, strategy_name=name,
                                 stop_loss_pct=stop_loss)
                results.append(r)
                all_results.append(r)
            except Exception as e:
                print(f"    [{name}] ERROR: {e}")

        # Summary table
        if results:
            rows = [
                [r.strategy_name, f"{r.total_return_pct:+.1f}%",
                 f"{r.buy_hold_return_pct:+.1f}%", f"{r.alpha_pct:+.1f}%",
                 f"{r.sharpe_ratio:.2f}", f"{r.max_drawdown_pct:.1f}%",
                 r.n_trades, f"{r.win_rate_pct:.0f}%", f"{r.avg_trade_return_pct:+.1f}%"]
                for r in results
            ]
            headers = ["Strategy", "Return", "B&H", "Alpha", "Sharpe", "MaxDD",
                       "Trades", "WinRate", "AvgTrade"]
            print("\n" + tabulate(rows, headers=headers, tablefmt="rounded_outline"))

            # ── Charts ────────────────────────────────────────────
            cmp_path = plot_strategy_comparison(results, symbol)
            print(f"\n  Chart saved: {cmp_path}")

            # Best strategy by Sharpe
            best = max(results, key=lambda r: r.sharpe_ratio)
            sig_fn = STRATEGIES[best.strategy_name]
            signals = sig_fn(df)
            detail_path = plot_price_with_signals(df, signals, best, symbol)
            print(f"  Best strategy chart: {detail_path} ({best.strategy_name})")

        # ── Pattern Scan ──────────────────────────────────────────
        print(f"\n  Scanning patterns for {symbol}...")
        consolidations = find_consolidations(df)
        vol_spikes = find_volume_spikes(df)
        rsi_divs = find_rsi_divergences(df)

        pattern_path = plot_pattern_stats(consolidations, vol_spikes, symbol)
        print(f"  Pattern chart: {pattern_path}")

        def safe_filter(df, col, val):
            if df.empty or col not in df.columns:
                return pd.DataFrame()
            return df[df[col] == val]

        pattern_summaries = [
            summarize_pattern(safe_filter(consolidations, "direction", "UP"), "Consolidation Breakout UP"),
            summarize_pattern(safe_filter(consolidations, "direction", "DOWN"), "Consolidation Breakout DOWN"),
            summarize_pattern(safe_filter(vol_spikes, "direction", "UP"), "Volume Spike UP"),
            summarize_pattern(safe_filter(vol_spikes, "direction", "DOWN"), "Volume Spike DOWN"),
            summarize_pattern(safe_filter(rsi_divs, "type", "BULLISH_DIVERGENCE"), "RSI Bullish Divergence"),
            summarize_pattern(safe_filter(rsi_divs, "type", "BEARISH_DIVERGENCE"), "RSI Bearish Divergence"),
        ]

        print("\n  Pattern Statistics:")
        pat_rows = [[p["pattern"], p.get("count", 0),
                     f"{p.get('ret_2w_pct_avg', 0):+.1f}%",
                     f"{p.get('ret_2w_pct_win_rate', 0):.0f}%"]
                    for p in pattern_summaries]
        print(tabulate(pat_rows, headers=["Pattern", "Count", "Avg 2w Return", "Win Rate"],
                        tablefmt="simple"))

    # ── Cross-asset summary ────────────────────────────────────────────────────
    if len(all_results) > 1:
        print(f"\n\n{'='*60}")
        print("  CROSS-ASSET BEST PERFORMERS")
        print(f"{'='*60}")
        sorted_by_sharpe = sorted(all_results, key=lambda r: r.sharpe_ratio, reverse=True)[:5]
        top_rows = [[f"{r.symbol} / {r.strategy_name}",
                     f"{r.total_return_pct:+.1f}%", f"{r.sharpe_ratio:.2f}",
                     f"{r.max_drawdown_pct:.1f}%", r.n_trades]
                    for r in sorted_by_sharpe]
        print(tabulate(top_rows, headers=["Symbol / Strategy", "Return", "Sharpe", "MaxDD", "Trades"],
                        tablefmt="rounded_outline"))

    print("\n  Done. Charts saved in crypto_analysis/output/")


def main():
    parser = argparse.ArgumentParser(description="Crypto pattern analysis & backtesting")
    parser.add_argument("--symbols", nargs="+", default=["BTCUSDT", "ETHUSDT"],
                        help="Binance trading pairs (default: BTCUSDT ETHUSDT)")
    parser.add_argument("--interval", default="1d", choices=["1d", "1w", "4h", "1h"],
                        help="Candle interval (default: 1d)")
    parser.add_argument("--days", type=int, default=1000,
                        help="Days of history to fetch (default: 1000)")
    parser.add_argument("--stop-loss", type=float, default=None,
                        help="Stop-loss percentage e.g. 0.08 for 8%% (default: none)")
    args = parser.parse_args()

    run_analysis(args.symbols, args.interval, args.days, args.stop_loss)


if __name__ == "__main__":
    main()

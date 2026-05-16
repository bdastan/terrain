"""
Vectorized backtester: simulates a strategy on historical OHLCV data.
"""
import pandas as pd
import numpy as np
from dataclasses import dataclass, field
from typing import Callable


@dataclass
class BacktestResult:
    strategy_name: str
    symbol: str
    total_return_pct: float
    buy_hold_return_pct: float
    alpha_pct: float           # strategy - buy&hold
    sharpe_ratio: float
    max_drawdown_pct: float
    n_trades: int
    win_rate_pct: float
    avg_trade_return_pct: float
    equity_curve: pd.Series = field(repr=False)
    trades: pd.DataFrame = field(repr=False)


def run_backtest(
    df: pd.DataFrame,
    signal_fn: Callable,
    symbol: str,
    strategy_name: str,
    initial_capital: float = 10_000.0,
    fee_pct: float = 0.001,       # 0.1% per trade (Binance taker)
    stop_loss_pct: float = None,  # e.g. 0.08 = 8% stop loss
) -> BacktestResult:
    """
    Vectorized backtest.
    signal_fn must return a pd.Series with values {-1, 0, 1}.
    Position is held from buy signal to next sell signal.
    """
    signals = signal_fn(df)
    aligned_close = df["close"].reindex(signals.index)
    data = pd.DataFrame({"close": aligned_close, "signal": signals}).dropna()
    if len(data) < 2:
        raise ValueError(f"Not enough data after indicator warmup (only {len(data)} rows). Need more history.")

    position = 0
    cash = initial_capital
    holdings = 0.0
    entry_price = 0.0
    equity = []
    trades = []

    for i, (ts, row) in enumerate(data.iterrows()):
        price = row["close"]
        sig = row["signal"]

        # Stop-loss check
        if position == 1 and stop_loss_pct and entry_price > 0:
            if price <= entry_price * (1 - stop_loss_pct):
                # Forced exit
                sell_value = holdings * price * (1 - fee_pct)
                trade_return = (price - entry_price) / entry_price * 100
                trades.append({
                    "entry_ts": entry_ts, "exit_ts": ts,
                    "entry_price": entry_price, "exit_price": price,
                    "return_pct": trade_return, "exit_reason": "stop_loss"
                })
                cash = sell_value
                holdings = 0.0
                position = 0

        # Signal-based entry / exit
        if sig == 1 and position == 0:
            # Buy
            fee = cash * fee_pct
            holdings = (cash - fee) / price
            entry_price = price
            entry_ts = ts
            cash = 0.0
            position = 1

        elif sig == -1 and position == 1:
            # Sell
            sell_value = holdings * price * (1 - fee_pct)
            trade_return = (price - entry_price) / entry_price * 100
            trades.append({
                "entry_ts": entry_ts, "exit_ts": ts,
                "entry_price": entry_price, "exit_price": price,
                "return_pct": trade_return, "exit_reason": "signal"
            })
            cash = sell_value
            holdings = 0.0
            position = 0

        portfolio_value = cash + holdings * price
        equity.append(portfolio_value)

    equity_curve = pd.Series(equity, index=data.index)

    # Close any open position at end
    if position == 1:
        final_price = data["close"].iloc[-1]
        sell_value = holdings * final_price * (1 - fee_pct)
        trade_return = (final_price - entry_price) / entry_price * 100
        trades.append({
            "entry_ts": entry_ts, "exit_ts": data.index[-1],
            "entry_price": entry_price, "exit_price": final_price,
            "return_pct": trade_return, "exit_reason": "end_of_data"
        })
        equity_curve.iloc[-1] = sell_value

    trades_df = pd.DataFrame(trades) if trades else pd.DataFrame(
        columns=["entry_ts", "exit_ts", "entry_price", "exit_price", "return_pct", "exit_reason"]
    )

    # Metrics
    total_return = (equity_curve.iloc[-1] / initial_capital - 1) * 100
    bh_return = (data["close"].iloc[-1] / data["close"].iloc[0] - 1) * 100

    daily_returns = equity_curve.pct_change().dropna()
    sharpe = (daily_returns.mean() / daily_returns.std() * np.sqrt(252)
              if daily_returns.std() > 0 else 0.0)

    rolling_max = equity_curve.cummax()
    drawdown = (equity_curve - rolling_max) / rolling_max * 100
    max_dd = drawdown.min()

    n_trades = len(trades_df)
    win_rate = (trades_df["return_pct"] > 0).mean() * 100 if n_trades > 0 else 0.0
    avg_trade = trades_df["return_pct"].mean() if n_trades > 0 else 0.0

    return BacktestResult(
        strategy_name=strategy_name,
        symbol=symbol,
        total_return_pct=round(total_return, 2),
        buy_hold_return_pct=round(bh_return, 2),
        alpha_pct=round(total_return - bh_return, 2),
        sharpe_ratio=round(sharpe, 3),
        max_drawdown_pct=round(max_dd, 2),
        n_trades=n_trades,
        win_rate_pct=round(win_rate, 2),
        avg_trade_return_pct=round(avg_trade, 2),
        equity_curve=equity_curve,
        trades=trades_df,
    )

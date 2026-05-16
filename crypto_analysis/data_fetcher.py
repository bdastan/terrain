"""
Fetches OHLCV data from multiple sources:
 1. CoinGecko (crypto) — free, no auth
 2. Yahoo Finance via yfinance (crypto + stocks)
 3. Binance public API (may be geo-restricted)
"""
import requests
import pandas as pd
from datetime import datetime, timedelta
import time

try:
    import yfinance as yf
    HAS_YFINANCE = True
except ImportError:
    HAS_YFINANCE = False

BINANCE_BASE = "https://api.binance.com/api/v3"

# CoinGecko id mapping for common pairs
COINGECKO_IDS = {
    "BTCUSDT": "bitcoin",
    "ETHUSDT": "ethereum",
    "SOLUSDT": "solana",
    "BNBUSDT": "binancecoin",
    "XRPUSDT": "ripple",
    "ADAUSDT": "cardano",
    "DOGEUSDT": "dogecoin",
    "AVAXUSDT": "avalanche-2",
    "DOTUSDT": "polkadot",
    "MATICUSDT": "matic-network",
    "LINKUSDT": "chainlink",
    "LTCUSDT": "litecoin",
}

# Yahoo Finance ticker mapping
YAHOO_TICKERS = {
    "BTCUSDT": "BTC-USD",
    "ETHUSDT": "ETH-USD",
    "SOLUSDT": "SOL-USD",
    "BNBUSDT": "BNB-USD",
    "XRPUSDT": "XRP-USD",
    "ADAUSDT": "ADA-USD",
    "DOGEUSDT": "DOGE-USD",
    "AVAXUSDT": "AVAX-USD",
    "DOTUSDT": "DOT-USD",
    "MATICUSDT": "MATIC-USD",
    "LINKUSDT": "LINK-USD",
    "LTCUSDT": "LTC-USD",
}

YFINANCE_INTERVAL = {
    "1d": "1d",
    "1w": "1wk",
    "4h": "1h",
    "1h": "1h",
}


def _fetch_from_coingecko(symbol: str, days: int) -> pd.DataFrame:
    cg_id = COINGECKO_IDS.get(symbol)
    if not cg_id:
        raise ValueError(f"No CoinGecko mapping for {symbol}")

    url = f"https://api.coingecko.com/api/v3/coins/{cg_id}/ohlc"
    # CoinGecko OHLC supports max 365 days; use market_chart for longer history
    if days <= 365:
        params = {"vs_currency": "usd", "days": days}
        resp = requests.get(url, params=params, timeout=15)
        resp.raise_for_status()
        data = resp.json()
        df = pd.DataFrame(data, columns=["timestamp", "open", "high", "low", "close"])
        df["timestamp"] = pd.to_datetime(df["timestamp"], unit="ms")
        df.set_index("timestamp", inplace=True)
        df["volume"] = 0.0  # OHLC endpoint has no volume
        return df[["open", "high", "low", "close", "volume"]].astype(float)
    else:
        # Use market_chart for price history, reconstruct daily OHLC approximation
        params = {"vs_currency": "usd", "days": days, "interval": "daily"}
        resp = requests.get(
            f"https://api.coingecko.com/api/v3/coins/{cg_id}/market_chart",
            params=params, timeout=15
        )
        resp.raise_for_status()
        data = resp.json()
        prices = pd.DataFrame(data["prices"], columns=["timestamp", "close"])
        prices["timestamp"] = pd.to_datetime(prices["timestamp"], unit="ms").dt.normalize()
        prices.set_index("timestamp", inplace=True)
        prices["close"] = prices["close"].astype(float)
        # Approximate OHLC from daily close
        prices["open"] = prices["close"].shift(1).fillna(prices["close"])
        prices["high"] = prices[["open", "close"]].max(axis=1)
        prices["low"] = prices[["open", "close"]].min(axis=1)

        if "total_volumes" in data:
            vol = pd.DataFrame(data["total_volumes"], columns=["timestamp", "volume"])
            vol["timestamp"] = pd.to_datetime(vol["timestamp"], unit="ms").dt.normalize()
            vol.set_index("timestamp", inplace=True)
            prices["volume"] = vol["volume"].astype(float)
        else:
            prices["volume"] = 0.0

        return prices[["open", "high", "low", "close", "volume"]]


def _fetch_from_yfinance(symbol: str, interval: str, days: int) -> pd.DataFrame:
    if not HAS_YFINANCE:
        raise ImportError("yfinance not installed")
    ticker = YAHOO_TICKERS.get(symbol, symbol)
    yf_interval = YFINANCE_INTERVAL.get(interval, "1d")
    period = f"{days}d" if days <= 3650 else "max"
    df = yf.download(ticker, period=period, interval=yf_interval,
                     auto_adjust=True, progress=False)
    if df.empty:
        raise ValueError(f"yfinance returned no data for {ticker}")
    # Flatten MultiIndex columns (yfinance v0.2+)
    if isinstance(df.columns, pd.MultiIndex):
        df.columns = [col[0].lower() for col in df.columns]
    else:
        df.columns = [str(c).lower() for c in df.columns]
    df.index = pd.to_datetime(df.index)
    df.index.name = "timestamp"
    return df[["open", "high", "low", "close", "volume"]].astype(float)


def _fetch_from_binance(symbol: str, interval: str, days: int) -> pd.DataFrame:
    end_ms = int(datetime.utcnow().timestamp() * 1000)
    start_ms = int((datetime.utcnow() - timedelta(days=days)).timestamp() * 1000)
    url = f"{BINANCE_BASE}/klines"
    all_candles = []
    current_start = start_ms

    while current_start < end_ms:
        params = {
            "symbol": symbol,
            "interval": interval,
            "startTime": current_start,
            "endTime": end_ms,
            "limit": 1000,
        }
        resp = requests.get(url, params=params, timeout=10)
        resp.raise_for_status()
        candles = resp.json()
        if not candles:
            break
        all_candles.extend(candles)
        current_start = candles[-1][0] + 1
        if len(candles) < 1000:
            break
        time.sleep(0.1)

    if not all_candles:
        raise ValueError(f"No data returned for {symbol}")

    df = pd.DataFrame(all_candles, columns=[
        "timestamp", "open", "high", "low", "close", "volume",
        "close_time", "quote_vol", "trades", "taker_buy_base",
        "taker_buy_quote", "ignore"
    ])
    df["timestamp"] = pd.to_datetime(df["timestamp"], unit="ms")
    df.set_index("timestamp", inplace=True)
    for col in ["open", "high", "low", "close", "volume"]:
        df[col] = df[col].astype(float)
    return df[["open", "high", "low", "close", "volume"]]


def fetch_ohlcv(symbol: str, interval: str = "1d", days: int = 1000) -> pd.DataFrame:
    """
    Fetch OHLCV data with automatic source fallback:
    Binance → CoinGecko → Yahoo Finance
    symbol: 'BTCUSDT', 'ETHUSDT', or any Yahoo ticker (e.g. 'AAPL', 'SPY')
    """
    errors = []

    # Try Yahoo Finance first (best daily coverage, crypto + stocks)
    try:
        df = _fetch_from_yfinance(symbol, interval, days)
        if len(df) >= 50:
            print(f"    [source: Yahoo Finance] {len(df)} candles")
            return df
        errors.append(f"Yahoo Finance: only {len(df)} candles returned")
    except Exception as e:
        errors.append(f"Yahoo Finance: {e}")

    # Try Binance (granular, but may be geo-restricted)
    try:
        df = _fetch_from_binance(symbol, interval, days)
        print(f"    [source: Binance] {len(df)} candles")
        return df
    except Exception as e:
        errors.append(f"Binance: {e}")

    # Try CoinGecko as last resort (limited to 4-day candles for >90d)
    if symbol in COINGECKO_IDS:
        try:
            cg_days = min(days, 365)
            df = _fetch_from_coingecko(symbol, cg_days)
            print(f"    [source: CoinGecko] {len(df)} candles")
            return df
        except Exception as e:
            errors.append(f"CoinGecko: {e}")

    raise RuntimeError(f"All data sources failed for {symbol}:\n" + "\n".join(errors))

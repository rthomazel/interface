---
name: tiingo-api
description: Use when building or debugging an integration with the Tiingo API (api.tiingo.com) — API token auth, end-of-day stock/ETF/mutual fund prices (latest and historical), ticker metadata, symbol search, the supported tickers list, rate limits, or Tiingo's symbol format.
---

# Tiingo API

Daily US equity, ETF and mutual fund prices over REST. Docs: https://www.tiingo.com/documentation/end-of-day
(a JavaScript app, curl returns an empty shell; render it with a headless browser to read it).

Verified against the live API on 2026-11-14 with the free Starter plan unless marked **docs only**.

## Auth

Both work, per the docs (**docs only**; in the harness the token is attached for you and a `?token=` value is ignored):

- Header `Authorization: Token <API_TOKEN>`
- Query `?token=<API_TOKEN>`

Always send `Content-Type: application/json`. Without it `GET /api/test/` returns HTTP 200 with
`{"message": "You did not set the content type to 'application/json'"}` instead of data.

Never log, commit or return the token. Sanity check: `GET https://api.tiingo.com/api/test/`.

## Endpoints (end-of-day)

Base: `https://api.tiingo.com/tiingo/daily`

| Resource          | Path                                              |
| ----------------- | ------------------------------------------------- |
| Metadata          | `GET /{ticker}`                                   |
| Latest price      | `GET /{ticker}/prices`                            |
| Historical prices | `GET /{ticker}/prices?startDate=…&endDate=…`      |
| Symbol search     | `GET /tiingo/utilities/search?query={text}`       |

Tickers are case-insensitive (`voo` works).

### Price query parameters

| Param          | Notes                                                                                         |
| -------------- | --------------------------------------------------------------------------------------------- |
| `startDate`    | `YYYY-MM-DD`. Unpadded `2026-10-1` also works. Bad format: HTTP 400.                          |
| `endDate`      | Same. A weekend end date returns rows up to the last trading day.                             |
| `format`       | `json` (default) or `csv`. CSV is smaller and has plain `YYYY-MM-DD` dates.                   |
| `sort`         | `-date` for newest first. Default is oldest first.                                            |
| `columns`      | Comma list, e.g. `date,close,divCash`.                                                        |
| `resampleFreq` | `weekly` verified (returns the last trading day of each week); `monthly` is in the docs example. |

Omitting `startDate` returns only the latest row. `startDate=1990-01-01` returns the full history.

### Price row

| Field                                     | Type  | Notes                                                                           |
| ----------------------------------------- | ----- | ------------------------------------------------------------------------------- |
| `date`                                    | date  | Trading day. See date formats below.                                            |
| `open` `high` `low` `close`               | float | **Raw, unadjusted.** Use `close` to value holdings.                             |
| `volume`                                  | int64 | `0` for mutual funds.                                                           |
| `adjOpen` `adjHigh` `adjLow` `adjClose`   | float | Split and dividend adjusted (CRSP method); the latest row equals `close`.       |
| `adjVolume`                               | int64 | Adjusted volume.                                                                |
| `divCash`                                 | float | Cash dividend, on the ex-date.                                                  |
| `splitFactor`                             | float | `1.0` normally; `10.0` on a 10-for-1 split day.                                 |

Example: NVDA closed 1209.98 on 2024-06-06 and 121.79 on 2024-06-10 (split day, `splitFactor` 10.0), while
`adjClose` was a continuous ~120.65 to ~121.44. Mutual fund NAV is delivered in `open/high/low/close`.

### Metadata

`ticker`, `name`, `description`, `exchangeCode`, `startDate`, `endDate`. `endDate` is the latest available
price date; `startDate` and `endDate` are null when no price data exists. Meta is a good existence check:
unknown ticker is HTTP 404 `{"detail":"Not found."}`.

`exchangeCode` is descriptive only. Prices are looked up by ticker, never by exchange, and the code may
differ from other sources (VOO reports `NYSE`, it is listed on NYSE Arca).

### Search

`/tiingo/utilities/search?query=vanguard%20500` returns `name`, `ticker`, `permaTicker`,
`openFIGIComposite`, `assetType` (`Stock`, `ETF`, `Mutual Fund`), `isActive`, `countryCode`.
The docs mark it beta.

## Gotchas

- **Floats in JSON.** Prices arrive as JSON numbers (`694.385`, `120.6544165279`). If the consumer needs exact
  decimals, parse them as text (`json.Number` in Go), never through float64.
- **Date formats differ.** Latest row: `2026-11-13T00:00:00+00:00`. Range rows: `2026-11-13T00:00:00.000Z`.
  CSV: `2026-11-13`. Parse as a timestamp and keep the UTC date.
- **Empty is not an error.** An end before the start, or a start in the future, returns HTTP 200 `[]`.
  Only a malformed date is a 400 (body is a JSON array with a message string).
- **Symbol format.** Dashes replace periods for share classes: `BRK-B` works, `BRK.B` is 404. Preferred
  shares are `SYMBOL-P-CLASS` (`SPG-P-J`). Mutual funds usually end in `X`.
- **Latest row can lag.** On Saturday 2026-11-14 ETFs ended Friday (11-13) while mutual fund VTSAX ended
  Thursday (11-12). A missing day for a ticker is not an outage.
- **Timing (docs only).** Most US equity prices land about 5:30 PM Eastern, with corrections possible until
  8 PM. Mutual fund NAVs appear after 12 AM Eastern. Run daily jobs after that, never at the close.
- **No rate limit headers.** None were present on responses; watch for error responses instead.

## Limits and licensing

| Plan    | Price  | Unique symbols/month | Requests/hour | Requests/day | Bandwidth/month |
| ------- | ------ | -------------------- | ------------- | ------------ | --------------- |
| Starter | $0     | 500                  | 50            | 1,000        | 1 GB            |
| Power   | $30/mo | 110,531              | 10,000        | 100,000      | 40 GB           |

(From the pricing page.) The hourly counter resets every hour, the daily one at midnight EST and bandwidth on
the 1st of the month at midnight EST. There is no per-minute or per-second limit. Behaviour when exceeded
(status code, body) was not exercised and is **docs only: undocumented**.

Starter and Power are for internal and personal use only, no redistribution in any form. Commercial use needs
a Commercial account.

Sizing: one price row is about 260 bytes of JSON. A 16 year ETF history (4,071 rows) was one request and
about 1 MB. A daily refresh for tens of tickers is well under 1 MB a month. The 50 requests per hour cap is
the tight limit; throttle bulk backfills.

## Supported tickers file

`https://apimedia.tiingo.com/docs/tiingo/daily/supported_tickers.zip`, updated daily, about 800 KB, holds
`supported_tickers.csv` with about 109,000 rows and the columns `ticker, exchange, assetType, priceCurrency,
startDate, endDate`. It counts as one download from a different host and does not use API requests.
`assetType` is `Stock`, `ETF` or `Mutual Fund`. Use `priceCurrency` to check USD. It includes delisted and
reserved symbols, so confirm a symbol with the metadata endpoint (`endDate` not null) before relying on it.

## Not covered here

Real-time (`/iex`, which the docs recommend replacing with the 24x5 consolidated feed), websockets, news,
crypto, forex, fundamentals and fund fees. They exist per the docs and were not validated.

# AI Market Indicator Dashboard

An AI hardware cycle / market-retraction indicator, built from the physical AI supply chain
rather than trying to predict a top from stock prices alone.

> **Watch the physical AI supply chain for signs that demand is weakening and supply is catching
> up.**

## The indicators

1. **Big Tech capex growth** ([capex.md](./capex.md)) — track Microsoft, Amazon, Google, Meta,
   Oracle. Absolute spending matters less than the growth trend and forward guidance.
   Decelerating capex growth, delayed data centers, or reduced guidance = bearish. The primary
   **demand-side indicator**.

2. **GPU lead times + resale prices** ([gpu-scarcity.md](./gpu-scarcity.md)) — long lead times =
   GPUs remain scarce = bullish; shortening lead times = supply catching up = bearish; falling
   used/resale GPU prices = scarcity premium disappearing = bearish. Strongest signal: lead times
   falling + resale prices falling simultaneously. The **GPU scarcity indicator**.

3. **HBM / memory** ([memory.md](./memory.md)) — HBM (High Bandwidth Memory) is the specialized
   DRAM used alongside AI accelerators, made by Micron, SK Hynix, Samsung. Rising HBM
   prices/tight supply = strong AI accelerator demand; falling = potentially bearish. Track
   inventories and capacity expansion. Server DRAM is supporting evidence only — it competes with
   HBM for manufacturing capacity, so falling DRAM prices don't necessarily mean AI demand is
   falling.

4. **TSMC HPC** ([tsmc.md](./tsmc.md)) — TSMC manufactures chips for NVIDIA, AMD, Apple, etc. HPC
   (High Performance Computing) is a revenue category that includes a large amount of
   AI-related chip demand, though not exclusively AI. HPC revenue growth is a useful upstream
   proxy for high-performance compute demand; decelerating growth would be bearish.

5. **Advanced packaging / CoWoS** ([tsmc.md](./tsmc.md)) — CoWoS is TSMC's advanced packaging
   tech used to integrate GPUs/accelerators with HBM, and has been a bottleneck in AI accelerator
   production. High/rising utilization and orders = strong demand; falling = bearish. Capacity
   expansion itself isn't bearish — only concerning when capacity expands while
   utilization/orders weaken.

**AI efficiency** was considered as a sixth indicator and deliberately excluded from the core
dashboard. It's extremely difficult to interpret without knowing how AI usage is changing:

> **Hardware demand ≈ AI workload × compute required per unit of workload**

An efficiency improvement can _increase_ hardware demand if it causes AI usage to explode — e.g.
5× efficiency with 10× workload growth still requires roughly 2× the compute. So efficiency is
treated as a qualitative wildcard, not a quantitative market-timing signal. Instead its effect is
observed indirectly through indicator 5.2, the compute market (see
[compute-market.md](./compute-market.md)).

## Core dashboard

| Indicator                      | Bullish         | Bearish          |
| ------------------------------ | --------------- | ---------------- |
| Big Tech capex growth          | Accelerating    | Decelerating     |
| GPU lead times                 | Long/increasing | Short/decreasing |
| GPU resale prices              | High/increasing | Falling          |
| HBM prices/orders              | Tight/rising    | Falling          |
| Memory inventories             | Low             | Rising           |
| TSMC HPC growth                | Accelerating    | Decelerating     |
| Advanced packaging utilization | High/rising     | Falling          |

**Hierarchy:**

- **Primary signals**: Big Tech capex, GPU scarcity, HBM
- **Confirmation signals**: TSMC HPC, memory inventories, advanced packaging utilization

The ideal bearish setup isn't one indicator turning negative — it's multiple layers of the
physical supply chain deteriorating together:

> Big Tech capex growth ↓ → GPU lead times ↓ → GPU resale prices ↓ → HBM prices/orders ↓ → TSMC
> HPC growth ↓ → packaging utilization ↓

That cascade would suggest the transition from "customers desperately want hardware and can't get
enough" to "supply is catching up and customers are becoming less aggressive" — the thing we're
ultimately trying to identify, because by the time semiconductor revenue itself is declining, the
market may already have priced in the downturn.

## Snapshot

| Indicator                          | Sheet                                    | Current Read                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Last Updated |
| ---------------------------------- | ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| Big Tech capex growth | [capex.md](./capex.md) | Bullish/accelerating: aggregate Big Tech capex (MSFT+GOOGL+META+AMZN+ORCL) YoY growth accelerated again to +117.9% in Q3 2026 ($230.4B; +86.5% in Q2, +71-75% through most of 2025). Guidance held or firmed: Alphabet $195-205B unchanged with "significantly" more in 2027, Amazon ~$220B with "meaningfully more" in 2027, Meta narrowed up to $135-145B, Oracle FY27 $90-95B reaffirmed, Microsoft ~$170B for calendar 2026 (Q2 FY27 "over $50B"; Q1 came in below its own outlook on delayed third-party capacity, not weaker demand). No deceleration signal. | 2026-11-12 |
| GPU scarcity (lead times + resale) | [gpu-scarcity.md](./gpu-scarcity.md) | Mixed, little change: H100 SXM5 resale unchanged at $22-27K (Compute Exchange used-H100 supply still "Very High"); Vast.ai H100 on-demand $2.20-4.77/hr (median $2.43, 6 single-GPU listings); B200 rental $7.50-12.51/hr (median $9.96, 4 single-GPU listings) — both books thin. No fresh dated lead-time data again (aggregator figures unchanged from August, treated as no change observed). Upstream (TrendForce) still says HBM supply tight through 2027. | 2026-11-12 |
| HBM / memory | [memory.md](./memory.md) | Bullish/tight, yellow flag on Micron inventory now isolated: HBM direction carried forward (TrendForce 2026-09-29: 2027 blended ASP +121% YoY; nothing newer). Server/conventional DRAM +10-15% QoQ in 4Q26 per TrendForce research (a relayed ~20% figure uses a different basis and is not a revision). **SK Hynix inventory days fell to 119.0 (from 122.8) and Samsung (whole-co.) to 110.4 (from 124.5) in Q3 2026**, both on record revenue, so Micron's jump to 140.1 (FY26 Q4) looks like a company-specific supply-ramp build rather than sector normalization. Micron's next print (FY27 Q1, end ~2026-11-26) is the one to watch. | 2026-11-12 |
| TSMC HPC + CoWoS | [tsmc.md](./tsmc.md) | Bullish/accelerating: HPC platform revenue reached 68% of TSMC revenue in Q3 2026 (from 66% in Q2; +22% QoQ), est. HPC revenue ~$31.8B (+68% YoY, derived), total revenue $46.7B and full-year 2026 USD growth guidance raised to ~44%. 2026 capital budget reiterated at $60-64B with 2026-28 capex "significantly higher" than the prior three years. CoWoS/packaging unchanged-tight — no new bottleneck quote this quarter; C.C. Wei: "The gap between demand and supply are still quite big." No deceleration signal on either sub-indicator. | 2026-11-12 |
| Compute market (H100 spot/rental) | [compute-market.md](./compute-market.md) | Mixed/thin: ComputeTape CT-H100 median $5.42/hr, but the panel shrank to 4 providers (Cyfuture $3.66, Daytona $3.95, AWS $6.88, Azure $12.29) as Hyperstack, Crusoe, Lambda and CoreWeave dropped out, so the median rise is a composition effect (remaining prices unchanged; weak trend point, review for removal after ~a quarter). AWS and Azure still "Quota Gated". Vast.ai H100: 44 GPUs across 15 listings (42/15 in Oct), single-GPU median $2.43/hr. Nothing reads as a compute glut. | 2026-11-12 |

## Current read (narrative)

**All five indicators populated and current as of 2026-11-12: monthly layers (GPU scarcity, HBM pricing, server DRAM, compute market) refreshed in the Nov pass; capex, TSMC and memory inventory days updated for Q3 2026 (Oct earnings). Next: Micron FY27 Q1 (~late Dec), Q4 earnings in Jan 2027.**

Capex growth is accelerating, not decelerating — aggregate hyperscaler capex YoY hit +86.5% in Q2
2026, and forward guidance across all five companies points to more spend, not less, through the
rest of 2026 and into FY27. On its own this is a **bullish** read for the primary demand-side
indicator, i.e. the opposite of the setup this dashboard is watching for.

GPU scarcity gives a genuinely mixed first read, not a clean bullish or bearish signal. On-demand
H100 rental pricing looks like it's loosened materially from the 2024 peak (secondary sources put
it at $8-10/hr then vs. $1.60-2.52/hr on Vast.ai's live marketplace today) — taken alone that
would be bearish (scarcity premium fading). But H200/B200 procurement lead times through standard
hyperscaler/OEM channels are still running 36-52 weeks per multiple independent sources, gated by
HBM3e memory and TSMC CoWoS packaging capacity rather than GPU die supply — that's still a
bullish/tight read. The likely explanation is that the _on-demand spot rental_ market and the
_committed/contract hardware procurement_ market are decoupling: over 300 new neocloud providers
entered in 2025, fragmenting spot supply and pulling spot $/hr down, while long-lead-time
committed capacity (the kind hyperscalers actually build data centers around) remains bottlenecked
upstream at HBM/CoWoS. This lines up with what indicator 3 (HBM/memory) shows now that it's
gathered: HBM pricing is rising, server DRAM contract prices are forecast up 13-18% QoQ for 3Q26,
and Micron — the cleanest pure-play read among the three memory makers — has inventory days at a
series low (120.5, down from 146.1 seven quarters back), all consistent with the upstream
bottleneck story over the "scarcity is just fading" story implied by falling spot rental prices
alone. SK Hynix's inventory days are roughly flat/slightly down over the same window, reinforcing
the same read; Samsung's inventory days rose to a series high this quarter, but that figure is
whole-company (Samsung doesn't disclose DS/semiconductor-segment inventory separately) and
shouldn't be read as a memory-specific signal on its own. Taken together, indicator 3 is a
**bullish/tight** confirmation of indicators 1-2: the choke point does look like it's sitting
upstream at HBM/memory rather than at the GPU die itself.

Indicator 4 (TSMC HPC + CoWoS) closes the loop and is the most unambiguous confirmation gathered
so far. TSMC's HPC platform — the revenue category most exposed to AI accelerators — has grown
from 59% of TSMC's total revenue in Q1 2025 to 66% in Q2 2026, and that growth is _accelerating_
(+20% QoQ in Q2 2026, the fastest in the six quarters reviewed, following another +20% QoQ in Q1
2026). More strikingly, TSMC's own management is now describing advanced packaging as an active
bottleneck rather than simply strong demand: CEO C.C. Wei told analysts in July 2026 that
"packaging capacity is so tight that now it's limiting my customers' growth," and TSMC raised its
2026 capital budget twice in six months ($52-56B in January, to $60-64B by July) explicitly citing
demand strength. This is TSMC's most direct capacity-constraint statement across the six quarters
reviewed for this pass, and it corroborates indicator 2's GPU lead-time findings (HBM/CoWoS-gated,
not GPU-die-gated) and indicator 3's HBM/memory tightness from the _supplier's supplier_ side of
the chain. Across all four populated indicators, nothing yet says demand is weakening — every
layer of the physical supply chain checked so far (hyperscaler capex, GPU procurement lead times,
HBM/memory, and now TSMC's own advanced packaging capacity) points the same direction: tight and
getting tighter, not loosening.

**2026-10-07 update.** The monthly layers did not move the overall picture. HBM pricing outlook got
firmer (TrendForce's 2027 blended ASP forecast raised to +121% YoY, supply tight through 2027) and
server DRAM is still rising, if more slowly (+10-15% QoQ in 4Q26). The one new yellow flag is
Micron's inventory days jumping to 140.1 from 120.5, reversing the series low cited above; with
revenue at a record and gross margin ~87% it reads as a build into a supply ramp rather than a
demand miss, but it is worth watching: if SK Hynix (Oct 27) and Samsung (late Oct) also show rising
inventory days, that would start to look like normalization. The recent crashes in SK Hynix and
Samsung shares (Jul 2, Sep 28) are not reflected in any supply-chain indicator — their fundamentals
printed records — and are recorded in memory.md as context only. On the rental side, the ComputeTape
median fell to $4.12/hr purely from panel composition (existing providers' prices unchanged), and
Vast.ai's rentable H100 count roughly halved (83 to 42 GPUs): thin, not abundant.

**2026-11-12 update.** The quarterly layers all moved in the bullish direction and the monthly layers
were flat. Capex growth accelerated again (+117.9% YoY in Q3 2026) with guidance held or raised
across the board, and several companies already flag more spending in 2027; TSMC's HPC share hit
68% of revenue with the capital budget reiterated and packaging still tight. The one yellow flag
from October softened: SK Hynix and Samsung inventory days both fell in Q3, so Micron's jump to
140.1 now looks company-specific rather than a sector-wide build. On the monthly side nothing is
new: GPU resale, HBM direction and DRAM guidance are unchanged, and ComputeTape's panel shrinking to
four providers makes its median uninformative this month. Convergence across layers still points
the same way as before: tight, not loosening.

Indicator 5 (compute market — H100 spot/rental) is now populated, and it mostly corroborates
rather than extends the story from indicator 2, as anticipated. ComputeTape's CT-H100 index — an
independent, methodologically-documented on-demand price series across six providers — reads
$5.22/hr median as of mid-August 2026, flat week-over-week with zero same-provider price movement.
But the real signal is in the composition, not the median: the two hyperscaler constituents (AWS
$6.88/hr, Azure $12.29/hr) are both tagged "Quota Gated," while the three neoclouds (Hyperstack
$3.20/hr, Crusoe $3.90/hr, CoreWeave $6.16/hr) are "Available Limited" and only Lambda ($4.29/hr)
is fully "Available." Vast.ai's live marketplace shows the same shape independently — a
$1.60-$7.08/hr spread across just 11 single-GPU listings (median $2.52/hr) and only 83 total H100
SXM GPUs rentable across all 31 listings queried, a thin order book rather than a deep liquid
market. Taken together this is the demand-side mirror of indicator 2's supply-side finding:
hyperscaler-controlled committed capacity stays gated/expensive while a fragmented tier of
neoclouds and spot listings offers cheaper, thinner supply. Nothing here reads as "compute glut" —
available capacity is thin, not abundant, and pricing is flat rather than falling — so indicator 5
doesn't shift the overall picture, it reinforces the same tight-upstream, loosening-at-the-margins
structure indicators 1-4 already established.

The GPU spot/rental market should be interpreted cautiously as a **young, thin, and highly fragmented
segment of the broader AI compute market**, rather than as a direct proxy for overall GPU supply/demand.
Current evidence shows a meaningful divergence between cheaper on-demand pricing and still-constrained
committed infrastructure: hyperscaler and OEM procurement remains gated with 36–52 week lead times, while
spot marketplaces contain relatively little total capacity and are increasingly supplied by a growing number
of neocloud providers. This suggests that lower spot prices may reflect **market fragmentation and concentration
of demand in hyperscaler-grade infrastructure**, rather than a broad compute glut.

For the purposes of the cycle dashboard, spot rental pricing should therefore be treated as an **emerging
commoditization/depth indicator rather than a primary scarcity indicator**. A genuinely bearish signal would
require several things to occur together: substantially deeper spot-market availability, falling utilization,
persistent price declines, shorter committed-hardware lead times, and declining concentration of compute in hyperscalers.
The transition we ultimately care about is from a **concentrated, capacity-constrained market** toward a **deep, liquid,
commoditized market with excess capacity**.

See [updating.md](./updating.md) for the monthly/quarterly refresh process.

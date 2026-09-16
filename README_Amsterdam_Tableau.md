# Amsterdam Short-Term Rental Market Forecast & Supply Dynamics — Tableau

A Tableau dashboard analysing Amsterdam's short-term rental (STR) market across 6,377 active listings for the 2026–2027 forecast period. The dashboard maps listing density, seasonal booking velocity, neighbourhood yield by room type, and ends with a concrete pricing recommendation.

---

## What this project does

The dashboard answers three questions: where is supply concentrated, when does demand peak, and which room types and neighbourhoods generate the most revenue per listing. It closes with a data-driven recommendation on dynamic pricing timing and minimum stay policy.

---

## Tools

- **Tableau Desktop / Tableau Public**
- Map integration: Mapbox + OpenStreetMap
- Data source: Amsterdam short-term rental listing data (2026)

---

## Dashboard sections

### Header KPIs
| Metric | Value |
|---|---|
| Average Daily Rate (ADR) | €346.62 |
| Availability Rate | 40.66% |
| Projected Annual Revenue per Property | €18,296.92 |
| Active Listings | 6,377 |

---

### 1. Listing Density & Hotspots (Map)
A heatmap overlay on Amsterdam's street map showing where listings cluster. Supply is heaviest in **Centrum-West** and **Centrum-Oost**, with satellite concentrations in Bijlmer, Noord, and Bos en Lommer. The map uses a dot-density layer for individual listings and a thermal gradient for concentration.

---

### 2. 365-Day Seasonal Velocity (Dual-axis line chart)
Two overlaid series:
- **Forward Availability %** (blue) — tracks what proportion of the inventory is open for booking across the year
- **Forward Booked Units** (orange) — tracks actual booked unit volume

Key pattern: Availability drops to a **32.4% annual low in June** while booked units spike to ~6,200 — the strongest demand compression in the year. Demand stabilises in Q4 with availability recovering above 40%.

---

### 3. Neighbourhood Yield by Room Type (Bar chart)
Horizontal bars comparing average nightly yield across:
- Entire home/apartment
- Hotel room
- Private room
- Shared room

Broken down by neighbourhood (Bijlmer-Centrum, Bijlmer-Oost, Bos en Lommer, Buitenveldert-Zuid, Centrum-Oost, and more).

Key finding: Entire home/apartment listings in **Centrum-West and Centrum-Oost** exceed **€500/night**. Outer districts (Bijlmer, Noord) rely on private rooms priced at **€100–€180/night**.

---

### 4. Executive Summary (Embedded in dashboard)
> **Market scale:** 6,377 listings at an ADR of €346.62, yielding ~€18,296 annual revenue per property.
>
> **Seasonal peak:** Inventory availability hits a low of 32.4% in June as forward bookings spike to ~6,200 units.
>
> **Geographic concentration:** Pricing power sits in Centrum-West and Centrum-Oost (€500+/night for entire homes); outer districts run on lower-cost private rooms (€100–€180).
>
> **Strategic recommendation:** Raise rates by 20–30% from April to July to capture peak summer demand; enforce a 3-night minimum stay during low-demand periods.

---

## Room type filter
The dashboard includes a legend filter for room type (Entire home/apt · Hotel room · Private room · Shared room) allowing viewers to isolate any segment across all visuals simultaneously.

---

## Key findings for investors and operators

1. **June is the pricing window** — the gap between availability collapse and booking volume spike is widest in May–June; that is when dynamic pricing adjustments generate the most incremental revenue
2. **Centrum listings are in a different market** from outer districts — yield per night is 3–5× higher, which also means they face more regulatory scrutiny
3. **40.66% availability rate** across the full year suggests meaningful excess supply outside the June peak — a 3-night minimum in Q1 and Q4 reduces administrative costs without sacrificing much occupancy

---

## How to open

Open the `.twbx` packaged workbook in Tableau Desktop or Tableau Public. The map layer requires an active internet connection for Mapbox tile rendering.

---

## Files

```
[Amsterdam_STR_Dashboard.twbx]   — Packaged Tableau workbook
```

> A screenshot of the full dashboard is included in this repository for quick reference.

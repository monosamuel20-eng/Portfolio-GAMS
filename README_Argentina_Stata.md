# Argentina Macroeconomic Recovery Analysis — Stata

A time-series regression study of Argentina's macroeconomic performance from 1995 to 2025, focused on whether economic outcomes — GDP growth, unemployment, and poverty — improved measurably after the 2001 financial crisis.

---

## What this project does

Four annual datasets (GDP, unemployment, CPI, and poverty rate) are merged into a single Stata panel, variables are transformed for stationarity, and a dummy-variable regression framework separates the pre-crisis period (1995–2002) from the post-crisis recovery (2003–2025). Diagnostic tests check for unit roots, autocorrelation, heteroskedasticity, and multicollinearity before the final model is accepted.

---

## Tools

- **Stata** (time-series commands: `tsline`, `dfuller`, `estat bgodfrey`, `estat hettest`, `estat ovtest`, `estat vif`)
- **Datasets:** `gdp_clean.dta`, `unemployment_clean.dta`, `cpi_annual.dta`, `poverty_clean.dta`

---

## Workflow

### 1. Data preparation
Merge four `.dta` files on `year` using 1:1 merge, drop `_merge` indicators, and save as `argentina_panel.dta`.

### 2. Variable generation
| Variable | Definition |
|---|---|
| `gdp_growth` | Year-on-year percentage change in GDP |
| `inflation` | Year-on-year percentage change in CPI |
| `unemp_change` | First difference of unemployment rate |
| `ln_gdp`, `ln_cpi`, `ln_unemp` | Natural logs for stationarity testing |
| `post_crisis` | Binary dummy: 1 if year ≥ 2003, 0 otherwise |

### 3. Stationarity testing
Augmented Dickey-Fuller tests on `ln_gdp`, `ln_cpi`, `ln_unemp`, and `poverty_rate`. First differences `d_ln_gdp`, `d_ln_cpi`, `d_ln_unemp`, `d_pov` are generated and re-tested to confirm I(1) series.

### 4. Summary statistics and correlation
`tabstat` for mean, standard deviation, min, max, and N across key indicators. Pairwise correlation (`pwcorr`) with significance stars at the 5% level.

### 5. Regression models

**Main model** — Interaction specification:
```stata
reg ln_gdp c.d_ln_cpi##i.post_crisis c.unemp_change##i.post_crisis c.poverty_rate##i.post_crisis, robust
```

**Recovery magnitude** — Direct effect of crisis periodisation:
```stata
reg gdp_growth post_crisis, robust
reg unemployment post_crisis, robust
reg poverty_rate post_crisis, robust
```

### 6. Diagnostic tests
- `estat bgodfrey` — Breusch-Godfrey autocorrelation test
- `estat hettest` — Breusch-Pagan heteroskedasticity test
- `estat ovtest` — RESET test for functional form misspecification
- `estat vif` — Variance inflation factors for multicollinearity
- `qnorm residuals` — Normality check on model residuals
- `ttest` — Mean comparison of key indicators across pre- and post-crisis periods

### 7. Visualisation
- `tsline` of raw macroeconomic indicators over time
- Standardised (`egen z_*`) overlay plot with a vertical marker at 2002
- `tsline gdp_growth` for growth rate trajectory

---

## Key findings

- GDP growth, unemployment, and poverty all show statistically significant differences between the pre- and post-crisis periods under robust standard errors
- The log-linear main model captures non-linear adjustment in the post-crisis recovery trajectory
- Diagnostic tests indicate no serious autocorrelation or multicollinearity; heteroskedasticity is addressed through robust SEs

---

## How to run

```stata
* Open Stata, set your working directory, then:
do "Agetina_to_do_file.do"
```

Required data files must be in the working directory:
- `gdp_clean.dta`
- `unemployment_clean.dta`
- `cpi_annual.dta`
- `poverty_clean.dta`

---

## Files

```
Agetina_to_do_file.do   — Full Stata do-file
```

> Note: The filename reflects the working title used during the course. The analysis covers Argentina's full macroeconomic cycle 1995–2025.

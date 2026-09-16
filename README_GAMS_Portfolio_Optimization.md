# Financial Optimisation Models — GAMS

Five GAMS models built during postgraduate coursework in Economic and Financial Sciences at the Università degli Studi di Palermo. Each model solves a different portfolio or macroeconomic optimisation problem using real or simulated financial data loaded from GDX files.

---

## Tools

- **GAMS** (General Algebraic Modeling System)
- Solvers: `LP` (linear programming), `NLP` (non-linear programming)
- Data: `DJ.gdx` (Dow Jones assets), `YahooIndexes.gdx` (Yahoo Finance scenarios)

---

## Models

---

### 1. Markowitz Mean-Variance Portfolio Optimisation
**File:** `first_Markowitz2026.gms`
**Solver:** NLP (quadratic objective)

Solves the classic Markowitz problem: minimise portfolio variance subject to a target return and a budget constraint. The model also includes short-selling: each asset has a `short(i)` variable bounded below by zero, a short balance constraint limits total short exposure to 10%, and a CAPM beta constraint forces the portfolio beta to equal 1.0.

**Objective:** Minimise `sigmaSqrP = Σᵢⱼ xᵢ xⱼ σᵢⱼ`

**Constraints:**
- Budget: `Σᵢ xᵢ = 1`
- Target return: `Σᵢ xᵢ μᵢ = μP` (set to 0.01)
- Beta neutral: `Σᵢ xᵢ βᵢ = 1.0`
- Short balance: `Σᵢ short(i) = 0.1`

**Output:** Optimal weights `X.L`, short positions `short.L`, minimised portfolio variance `sigmaSqrP.L`

---

### 2. Efficient Frontier Mapping
**File:** `efficientyfrontier.gms`
**Solver:** NLP

Extends the Markowitz model to trace the full efficient frontier by solving the variance minimisation problem across 30 evenly spaced target return values (`PP_1` to `PP_30`) between a minimum and maximum return.

**Grid setup:**
```gams
mu_min = -0.01;
mu_max = 0.03;
mu_step = (mu_max - mu_min) / (CARD(p) - 1);
muValues(p) = mu_min + (ORD(p) - 1) * mu_step;
```

Each point on the frontier represents the minimum-variance portfolio for that target return. The resulting risk-return pairs are exported for visualisation in Python (see `README_Efficient_Frontier_Python.md`).

**Constraints:** Same as the Markowitz model, with `muP` updated per iteration.

---

### 3. Conditional Value-at-Risk (CVaR) Minimisation
**File:** `Cvar_Model.gms`
**Solver:** LP (linear reformulation)

Minimises the portfolio's Conditional Value-at-Risk (CVaR) — the expected loss in the worst `(1 - α)%` of scenarios — across 100 return scenarios loaded from `YahooIndexes.gdx`. CVaR is reformulated as a linear programme using the Rockafellar-Uryasev (2000) approach.

**Key parameters:**
- `alpha = 0.95` (95% confidence level)
- `c = 1,000,000` (initial capital in USD)

**Variables:**
- `x(i)` — amount invested in asset `i`
- `y(ss)` — excess loss above VaR in scenario `ss`
- `VaR` — Value-at-Risk threshold
- `Vp(ss)` — portfolio value in scenario `ss`

**Equations:**
```gams
PortfolioValueEq(ss):  Vp(ss) = Σᵢ xᵢ (1 + r(ss,i))
PortfolioLosses(ss):   Losses(ss) = -(Vp(ss) - c)
VarDevEq(ss):          y(ss) ≥ Losses(ss) - VaR
ConditionalVarEq:      z = VaR + [1/(1-α)] × Σₛ y(ss)
```

**Objective:** Minimise `z` (CVaR)
**Constraint:** Portfolio expected return ≥ 1.5% (`ExpectedReturn` equation)

**Output:** Optimal allocations `x.L`, Value-at-Risk threshold `VaR.L`

---

### 4. Expected Utility Maximisation (CRRA)
**File:** `Utility_Model.gms`
**Solver:** NLP

Maximises expected utility under a Constant Relative Risk Aversion (CRRA) utility function across 100 market scenarios. The model handles both the general case (`γ ≠ 1`) and the log-utility special case (`γ = 1`) using GAMS dollar-condition syntax.

**Key parameters:**
- `gamma = 2.0` (risk aversion coefficient)
- `Equity = 1,000,000` (initial capital)

**Variables:**
- `x(i)` — capital allocated to asset `i`
- `ROE(ss)` — return on equity in scenario `ss`
- `EU` — expected utility (objective)

**Utility function:**
```gams
EU = (1/|S|) × Σₛ [ (ROE(ss)^(1-γ) - 1) / (1-γ)  if γ ≠ 1
                     log(ROE(ss))                    if γ = 1 ]
```

**Output:** Optimal allocations `X.L`, maximised expected utility `EU.L`

---

### 5. Ramsey Optimal Growth Model
**File:** `RamseyGrowthModel.gms`
**Solver:** NLP (dynamic, 30-period horizon)

Solves a discrete-time Ramsey–Cass–Koopmans optimal growth model over 30 periods. The representative household chooses a consumption path to maximise discounted lifetime welfare, subject to a Cobb-Douglas production technology and capital accumulation.

**Parameters:**
| Parameter | Value | Description |
|---|---|---|
| `rho` | 0.05 | Discount rate |
| `g` | 0.03 | Labour growth rate |
| `delta` | 0.02 | Capital depreciation rate |
| `alpha` | 0.25 | Capital share in Cobb-Douglas production |
| `K0` | 3.0 | Initial capital stock |
| `C0` | 0.95 | Initial consumption |
| `L0` | 1.0 | Initial labour supply |

**TFP calibration:** `A = (C0 + I0) / (K0^α × L0^(1-α))` — calibrated to match initial conditions.

**Discount factor:** Standard exponential for non-terminal periods; terminal value uses the Gordon growth formula `(1/ρ) × (1+ρ)^(-(T-1))`.

**Equations:**
```gams
Production:    Y(t) = A × K(t)^α × L(t)^(1-α)
Allocation:    C(t) + I(t) = Y(t)
Accumulation:  K(t+1) = (1-δ) × K(t) + I(t)
Welfare:       W = Σₜ β(t) × log(C(t))
Terminal:      I(T) ≥ (g + δ) × K(T)
```

**Objective:** Maximise `W`
**Output:** Optimal paths `C.L`, `K.L`, `I.L` over 30 periods; maximised welfare `W.L`

---

## How to run

1. Install GAMS (academic or commercial licence) with a compatible NLP/LP solver (CONOPT for NLP, CPLEX or GLPK for LP)
2. Place the relevant GDX data file in the same directory as the `.gms` file:
   - `DJ.gdx` for `first_Markowitz2026.gms` and `efficientyfrontier.gms`
   - `YahooIndexes.gdx` for `Cvar_Model.gms` and `Utility_Model.gms`
   - No external data for `RamseyGrowthModel.gms`
3. Run from the GAMS IDE or command line:
```bash
gams first_Markowitz2026.gms
gams Cvar_Model.gms
gams RamseyGrowthModel.gms
```

---

## Files

```
first_Markowitz2026.gms    — Markowitz mean-variance model with short selling
efficientyfrontier.gms     — Efficient frontier grid (30 target-return points)
Cvar_Model.gms             — CVaR minimisation (LP, 100 scenarios)
Utility_Model.gms          — CRRA expected utility maximisation (NLP, 100 scenarios)
RamseyGrowthModel.gms      — Ramsey-Cass-Koopmans optimal growth (NLP, 30 periods)
```

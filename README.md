# Gamification & Commercial Success in Educational Math Apps
### An exploratory data analysis of Google Play Store open data (R)

> Bachelor's thesis (Trabajo Fin de Grado) — *Doble Grado en Educación Primaria + Matemáticas*, Universidad Rey Juan Carlos, 2025–2026.
> Author: **Laura Iglesias García**.

📄 **Live report:** `https://YOUR_USERNAME.github.io/gamification-math-apps-analysis/`
*(replace `YOUR_USERNAME` after publishing)*

---

## TL;DR

Do gamification mechanics (levels, rewards, rankings, avatars, feedback) actually
drive downloads of primary-school math apps? Using a **stratified random sample of
200 apps** drawn from a cleaned population of **4,218 educational math apps**, I fit
a **multiple linear regression (OLS)** with robust standard errors and a full
diagnostic and robustness protocol in **R**.

**Headline finding:** most mechanics show *no* significant association with downloads.
Only **reward systems** are a genuine differentiator (≈ **9.7× more downloads**,
β = 0.986, p = 0.008), a result that holds across four independent robustness checks.
The strongest overall driver is the **freemium model** (in-app purchases → ≈ 5.4×
downloads). Commercial popularity is **not** a proxy for pedagogical quality.

---

## Why this repository matters (for recruiters)

An end-to-end, **reproducible statistical analysis** built from raw open data — the
core workflow of a data analyst:

- **Data cleaning & ETL** — ~2.3M raw records → 4,218-app target population via
  deterministic, documented filters.
- **Sampling design** — stratified random sampling on log-transformed popularity;
  design weights verified as near-uniform, so unweighted OLS is unbiased.
- **Modelling** — multiple linear regression (OLS), log-level specification, two
  competing models compared via adjusted R² and an F-test.
- **Diagnostics** — VIF, Breusch–Pagan + **HC3 robust standard errors**,
  Shapiro–Wilk + Q-Q, Cook's distance.
- **Robustness & sensitivity** — non-parametric **bootstrap**, exact **Fisher**
  test, re-estimation without influential points, **Bayesian shrinkage** sensitivity.
- **Reliability** — inter-rater agreement via **Cohen's kappa**.
- **Reproducibility** — fixed seed (`set.seed(42)`), documented environment.

## Skills & tools

`R` · OLS regression · robust inference (HC3) · bootstrapping · Bayesian shrinkage ·
stratified sampling · hypothesis testing · reproducible research · Quarto
Packages: `dplyr`, `readr`, `stringr`, `readxl`, `writexl`, `car`, `lmtest`,
`sandwich`, `boot`, `irr`, `corrplot`, `TOSTER`.

---

## Repository structure

```
.
├── README.md                     # this file
├── index.qmd                     # Quarto landing page → GitHub Pages
├── _quarto.yml                   # Quarto project config
├── LICENSE                       # MIT (code)
├── .gitignore
├── .github/workflows/publish.yml # auto-publish the report to GitHub Pages
├── R/
│   ├── 00_run_all.R              # runs the whole pipeline in order
│   ├── 01_packages.R
│   ├── 02_population_strata.R
│   ├── 03_semantic_filter_validation.R
│   ├── 04_cohen_kappa.R
│   ├── 05_load_transform_impute.R
│   ├── 06_descriptives.R
│   ├── 07_independence_tests.R
│   ├── 08_correlation_matrix.R
│   ├── 09_model_I_ols_hc3.R
│   ├── 10_model_II_igam.R
│   ├── 11_diagnostics.R
│   ├── 12_robustness_rewards.R
│   └── 13_sensitivity_m0.R
├── data/README.md                # how to obtain the data (not committed)
├── report/                       # add the thesis PDF here
└── figures/                      # generated plots
```

> The R scripts correspond to the code listings in Appendix A of the thesis,
> split into logical, runnable files. Comments and local variable names are in
> English; the coded data-column names (`V_Niveles`, `EstratoPopularidad`, …) are
> kept in their original form so the code matches the source data (see
> [`data/README.md`](data/README.md) for the mapping).

## Data

The raw dataset is the public **Google Play Store Apps** repository
([Kaggle, gauthamp10, 2021](https://www.kaggle.com/datasets/gauthamp10/google-playstore-apps)).
It is **not** committed here (size + licensing). See [`data/README.md`](data/README.md).

## How to reproduce the analysis

```r
# Open the project at its ROOT (RStudio project or setwd to the repo root)
source("R/00_run_all.R")
```

Everything is seeded (`set.seed(42)`) for exact reproducibility. Generated tables
go to `outputs/`, figures to `figures/`.

## How the report is published

The site is built from `index.qmd` and deployed to **GitHub Pages** automatically
by `.github/workflows/publish.yml` on every push to `main`. See the last section of
this README's companion guide for the one-time Pages setup.

## Key results

| Predictor            | β        | p         | Interpretation                     |
|----------------------|----------|-----------|------------------------------------|
| Rewards              |  0.986   | 0.008 **  | ≈ 9.7× downloads (only gamification differentiator) |
| In-app purchases     |  0.736   | 0.005 **  | ≈ 5.4× downloads (freemium effect) |
| Advertising          |  0.501   | 0.001 *** | ≈ 3.2× downloads                   |
| Adjusted rating      | −1.846   | <0.001 ***| quality ≠ mass popularity          |
| Feedback             | −0.343   | 0.030 *   | marks niche / academic apps        |
| Levels / Ranking / Avatars | n.s.| —         | now baseline "hygiene" features    |

Model I: R²_adj = 0.248; F(9, 190) = 8.28, p < 0.001; n = 200.

## License

Code under the MIT License (`LICENSE`). The written thesis is © the author;
please cite rather than redistribute.

## Citation

> Iglesias García, L. (2026). *La gamificación en aplicaciones educativas de
> matemáticas para primaria: un análisis exploratorio de datos abiertos*
> [Bachelor's thesis, Universidad Rey Juan Carlos].

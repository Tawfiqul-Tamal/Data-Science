# Cars93 — Data Preparation & Exploratory Analysis in R

**Introduction to Data Science (IDS) · Midterm Project**

An end-to-end, reproducible data-preparation pipeline in base R, applied to the classic *Cars93* dataset and finished with a baseline multiple linear regression for predicting car price.

![Language](https://img.shields.io/badge/language-R-276DC3?logo=r&logoColor=white)
![Dependencies](https://img.shields.io/badge/dependencies-base%20R%20only-success)
![Reproducible](https://img.shields.io/badge/reproducible-set.seed(123)-informational)

---

## Table of Contents

1. [Overview](#overview)
2. [Dataset](#dataset)
3. [Repository Structure](#repository-structure)
4. [Getting Started](#getting-started)
5. [Methodology](#methodology)
6. [Results](#results)
7. [Limitations and Future Work](#limitations-and-future-work)
8. [Authors](#authors)
9. [References](#references)

---

## Overview

Real-world data is rarely model-ready. This project demonstrates the complete preparation workflow that precedes modelling:

| Stage | Covered |
|---|---|
| Data understanding | Loading, structure inspection, type conversion |
| Data quality | Missing values (two strategies), noise injection and correction, validity checks |
| Data transformation | Min–max normalisation, log transformation |
| Exploration | Outlier detection (IQR), descriptive statistics, visualisations |
| Modelling | 80/20 train–test split, correlation-based feature selection, linear regression |

The script is fully self-contained, uses **no external packages**, and is deterministic (`set.seed(123)`).

## Dataset

| Property | Detail |
|---|---|
| Source | `Cars93` from the R `MASS` package, mirrored on [Rdatasets](https://vincentarelbundock.github.io/Rdatasets/articles/data.html) |
| Observations | 93 car models sold in the US in 1993 |
| Variables | 28 columns (27 features plus a row index) |
| Numeric features | `Price`, `Min.Price`, `Max.Price`, `MPG.city`, `MPG.highway`, `EngineSize`, `Horsepower`, `RPM`, `Weight`, `Length`, `Wheelbase`, `Width`, `Fuel.tank.capacity`, and others |
| Categorical features | `Manufacturer`, `Model`, `Type`, `AirBags`, `DriveTrain`, `Cylinders`, `Man.trans.avail`, `Origin`, `Make` |
| Target variable | `Price` (USD thousands) |
| Native missing values | `Rear.seat.room` (2), `Luggage.room` (11) |

## Repository Structure

This project lives in the `MID Project/` folder of the `Data-Science` repository.

```text
Data-Science/
└── MID Project/
    ├── README.md                                     Project documentation
    ├── IDS_Midterm_Project.R                         Complete R script (full pipeline)
    ├── Cars93.csv                                    Raw dataset
    ├── Cars93_cleaned.csv                            Pipeline output (adds Price.norm, Horsepower.norm, Price.log)
    ├── Updated_IDS_Midterm_Report.docx               Written report
    ├── Output.docx                                   Program output document
    ├── Summer 2025 2026 IDS Midterm Project (1).pdf  Assignment brief
    └── VIVA_QA_Guide.docx                            Viva preparation guide
```

## Getting Started

**Requirements:** R 3.6 or later (verified on R 4.3.3). No packages to install.

```bash
git clone https://github.com/<your-username>/Data-Science.git
cd "Data-Science/MID Project"
Rscript IDS_Midterm_Project.R
```

Alternatively, open `IDS_Midterm_Project.R` in RStudio, set the working directory to the script location (*Session → Set Working Directory → To Source File Location*), and click **Source**.

The script reads `Cars93.csv` from the working directory and writes `Cars93_cleaned.csv` back to it. Because all random steps follow `set.seed(123)`, running the script top to bottom regenerates the committed `Cars93_cleaned.csv` exactly.

## Methodology

| # | Step | Approach |
|---|---|---|
| 1 | Load and inspect | `read.csv()`, `str()`, `summary()`, `dim()` |
| 2 | Type conversion | `Type`, `AirBags`, `DriveTrain`, `Origin` converted to factors |
| 3 | Missing values | 8 `Horsepower` and 6 `AirBags` values set to `NA`, then handled two ways: **(i)** discard rows via `na.omit()` (93 → 70 rows); **(ii)** impute with the mean (numeric) or mode (categorical), keeping all 93 rows |
| 4 | Noise handling | `+500` added to 5 `Price` values and the invalid label `"Ultra"` assigned to 3 `Type` values. Numeric noise is flagged with the **mean + 3·SD** rule and replaced by the median; invalid labels are flagged by value and replaced with `"Small"` |
| 5 | Validity checks | Confirms no non-positive `Price`, `MPG.city`, `Horsepower`, and no `Passengers` below 1 |
| 6 | Transformation | Min–max scaling of `Price` and `Horsepower` to [0, 1]; natural-log transform of `Price` |
| 7 | Outlier detection | 1.5 × IQR rule and boxplots on `Price` |
| 8 | Descriptive statistics | Mean, median, SD, variance; histograms, bar plot, scatter plot |
| 9 | Train–test split | Random 80/20 split: 74 training rows, 19 test rows |
| 10 | Feature selection and model | Pearson correlation with `Price`, then `lm(Price ~ Horsepower + Weight + EngineSize)` |

## Results

All figures below were produced by running `IDS_Midterm_Project.R` (R 4.3.3, seed 123).

### Data quality

| Check | Result |
|---|---|
| Native missing values | `Rear.seat.room`: 2, `Luggage.room`: 11 |
| Rows remaining after discarding all `NA` rows | 70 of 93 |
| `Horsepower` imputation value (mean) | 143.83 |
| `AirBags` imputation value (mode) | `Driver only` |
| Injected price noise detected by mean + 3·SD | 5 of 5 |
| Injected invalid `Type` labels detected | 3 of 3 |
| Invalid values (non-positive or impossible) | 0 |
| IQR outliers in `Price` | 3 (40.1, 47.9, 61.9 USD thousands) |

### Descriptive statistics for `Price` (USD thousands)

| Mean | Median | Std. dev. | Variance | Skewness |
|---|---|---|---|---|
| 19.50 | 18.40 | 9.59 | 91.91 | 1.57 (right-skewed) |

The distribution is right-skewed: 75% of cars are priced at or below 22.7, with a thin tail of luxury models. The log transform is applied to reduce this skew.

### Feature selection

| Feature | Pearson r with `Price` |
|---|---|
| `Horsepower` | **0.742** |
| `Weight` | 0.635 |
| `EngineSize` | 0.589 |
| `MPG.city` | −0.567 |

### Linear regression

`Price ~ Horsepower + Weight + EngineSize`, fitted on the training set (n = 74).

| Term | Estimate | Std. error | p-value |
|---|---|---|---|
| Intercept | −12.727 | 4.733 | 0.0090 |
| `Horsepower` | 0.1437 | 0.0234 | < 0.001 |
| `Weight` | 0.0060 | 0.0024 | 0.0157 |
| `EngineSize` | −2.452 | 1.413 | 0.0871 (not significant at 5%) |

| Metric | Value |
|---|---|
| Multiple R² | 0.595 |
| Adjusted R² | 0.578 |
| Residual standard error | 6.44 on 70 d.f. |
| F-statistic | 34.3 (p = 9.4 × 10⁻¹⁴) |

### Key takeaways

- `Horsepower` is the strongest predictor of `Price`, followed by `Weight`; both are statistically significant in the model.
- `EngineSize` is not significant once the other two are included. It is strongly correlated with `Weight` (r = 0.85) and `Horsepower` (r = 0.71), which suggests overlapping information (multicollinearity).
- The model explains about 60% of the variance in `Price` on the training data.

## Limitations and Future Work

- **No held-out evaluation yet.** The test set is created but not scored; reporting RMSE, MAE, and test-set R² is the natural next step.
- **Multicollinearity.** Check variance inflation factors and consider dropping `EngineSize`.
- **Model diagnostics.** Add residual-versus-fitted and Q–Q plots, and consider modelling `log(Price)` to handle skew and unequal variance (the maximum residual is about 30, driven by a luxury outlier).
- **Validation.** Replace the single random split with k-fold cross-validation.
- **Richer features.** Include categorical predictors (`Type`, `Origin`, `DriveTrain`) and try regularised models (Ridge, Lasso).
- **Simulated defects.** Missing values and noise are injected for coursework purposes. The mean + 3·SD rule works here because the injected noise is extreme, but it is not robust in general (outliers inflate both mean and SD); median/MAD or IQR-based rules are safer. Replacing invalid `Type` labels with `"Small"` is a simplification.

## Authors

- Md. Tawfiqul Islam Tamal
- Ashadullah Hil Galib
- Md. Omar Faruk Prodhan
- Syed Md. Saifullah Saif

## References

- Lock, R. H. (1993). *1993 New Car Data*. Journal of Statistics Education, 1(1).
- Venables, W. N., & Ripley, B. D. *Modern Applied Statistics with S* — `MASS` package (`Cars93`).
- Arel-Bundock, V. *Rdatasets*. <https://vincentarelbundock.github.io/Rdatasets/articles/data.html>

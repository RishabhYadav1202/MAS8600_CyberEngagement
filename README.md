# MAS8600 — Cyber Security MOOC Engagement (Runs 1–7)

This repository contains a reproducible analysis of learner engagement data from a Cyber Security MOOC delivered across seven course runs (Runs 1–7). The work follows the CRISP-DM methodology in two cycles:

- **Cycle 1:** Identify where learners disengage across course steps and how disengagement patterns differ by run.
- **Cycle 2:** Examine whether quiz engagement is associated with learner persistence (completion ratio).

The analysis uses **ProjectTemplate** for structured project loading and **renv** for package/environment reproducibility.

---

## Directory Map

- `config/`  
  ProjectTemplate configuration (`global.dcf`) controlling data loading, caching, and library loading.

- `data/`  
  Raw datasets (as supplied). Keep these unchanged.

- `munge/`  
  Data cleaning and feature engineering scripts. These create the cleaned per-run objects and analysis-ready tables:
  - `01_helpers.R` — helper functions (key standardisation; safe min/max for timestamps)
  - `02_clean_step_activity.R` — cleans step activity for each run (1–7)
  - `03_clean_question_response.R` — cleans question response for each run (1–7)
  - `04_build_analysis_objects.R` — builds per-run learner-step tables, quiz summaries, funnels, and learner persistence summaries

- `src/`  
  Optional analysis extensions (if needed).

- `reports/`  
  RMarkdown report:
  - `mooc_report.Rmd` — the main report (knit to HTML)

- `outputs/`  
  Generated outputs created by the scripts/report:
  - `outputs/plots/` — saved PNG plots
  - `outputs/*.csv` — summary tables (e.g., top drop-offs, funnel summaries)

- `renv.lock` and `renv/`  
  Environment management for reproducibility.

---

## Setup Instructions

### 1) Open the project
Open the `.Rproj` file in RStudio.

### 2) Restore packages (renv)
Run:

```r
install.packages("renv")
renv::restore()
```



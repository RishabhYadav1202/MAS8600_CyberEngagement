# Summary table: Funnel metrics per run     


stopifnot(exists("funnel_step_all"))

funnel_run <- funnel_step_all |>
  dplyr::group_by(run) |>
  dplyr::summarise(
    total_step_visits = sum(visited, na.rm = TRUE),
    mean_completion_rate = mean(completion_rate, na.rm = TRUE),
    biggest_drop = ifelse(all(is.na(drop_off_to_next)), NA_real_, max(drop_off_to_next, na.rm = TRUE)),
    .groups = "drop"
  )

readr::write_csv(funnel_run, "outputs/funnel_run_summary.csv")

cache("funnel_run")


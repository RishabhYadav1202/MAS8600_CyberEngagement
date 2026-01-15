stopifnot(exists("funnel_step_all"))

top_hits <- funnel_step_all |>
  dplyr::filter(!is.na(drop_off_to_next)) |>
  dplyr::group_by(run) |>
  dplyr::slice_max(drop_off_to_next, n = 10, with_ties = FALSE) |>
  dplyr::ungroup() |>
  dplyr::count(week_number, step_number, sort = TRUE)

readr::write_csv(top_hits, "outputs/repeated_dropoff_steps.csv")

cache("top_hits")


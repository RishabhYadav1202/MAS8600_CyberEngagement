# Plot 3: Funnel visits across steps by run 


stopifnot(exists("funnel_step_all"))

funnel_visits_plot <- funnel_step_all |>
  dplyr::arrange(run, week_number, step_number) |>
  dplyr::group_by(run) |>
  dplyr::mutate(step_index = dplyr::row_number()) |>
  dplyr::ungroup()

p_funnel_visits <- ggplot2::ggplot(
  funnel_visits_plot,
  ggplot2::aes(x = step_index, y = visited, group = factor(run))
) +
  ggplot2::geom_line() +
  ggplot2::facet_wrap(~ run, scales = "free_y") +
  ggplot2::labs(
    title = "Funnel: distinct learners visiting each step (by run)",
    x = "Step order within run",
    y = "Distinct learners visited"
  )

ggplot2::ggsave("outputs/plots/funnel_visits_by_run.png", p_funnel_visits, width = 12, height = 6)

cache("p_funnel_visits")


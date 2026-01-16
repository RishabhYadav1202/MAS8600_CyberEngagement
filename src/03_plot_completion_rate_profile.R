# Plot 2: Completion rate profile by run    

stopifnot(exists("funnel_step_all"))

funnel_step_plot <- funnel_step_all |>
  dplyr::arrange(run, week_number, step_number) |>
  dplyr::group_by(run) |>
  dplyr::mutate(step_index = dplyr::row_number()) |>
  dplyr::ungroup()

p_comp <- ggplot2::ggplot(
  funnel_step_plot,
  ggplot2::aes(x = step_index, y = completion_rate, group = factor(run))
) +
  ggplot2::geom_line() +
  ggplot2::facet_wrap(~ run, scales = "free_x") +
  ggplot2::scale_y_continuous(labels = scales::percent) +
  ggplot2::labs(
    x = "Step order within run",
    y = "Completion rate",
    title = "Completion rate across steps (by run)"
  )

ggplot2::ggsave("outputs/plots/completion_rate_by_step.png", p_comp, width = 12, height = 6)

cache("p_comp")


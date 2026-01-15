stopifnot(exists("funnel_step_all"))

p_completion_box <- ggplot2::ggplot(
  funnel_step_all,
  ggplot2::aes(x = factor(run), y = completion_rate)
) +
  ggplot2::geom_boxplot() +
  ggplot2::scale_y_continuous(labels = scales::percent) +
  ggplot2::labs(
    title = "Distribution of step completion rates by run",
    x = "Run",
    y = "Completion rate"
  )

ggplot2::ggsave("outputs/plots/completion_rate_boxplot.png", p_completion_box, width = 10, height = 6)

cache("p_completion_box")


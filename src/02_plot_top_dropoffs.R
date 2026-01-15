#############################################
# Plot 1: Top drop-offs by run              #
#############################################

stopifnot(exists("funnel_step_all"))

top_dropoffs <- funnel_step_all |>
  dplyr::filter(!is.na(drop_off_to_next)) |>
  dplyr::group_by(run) |>
  dplyr::slice_max(drop_off_to_next, n = 10, with_ties = FALSE) |>
  dplyr::ungroup() |>
  dplyr::arrange(run, dplyr::desc(drop_off_to_next)) |>
  dplyr::mutate(step_label = paste0(week_number, ".", step_number))

# Save CSV
readr::write_csv(top_dropoffs, "outputs/top_dropoffs.csv")

# Plot
p_drop <- ggplot2::ggplot(
  top_dropoffs,
  ggplot2::aes(x = reorder(step_label, drop_off_to_next), y = drop_off_to_next)
) +
  ggplot2::geom_col() +
  ggplot2::facet_wrap(~ run, scales = "free_y") +
  ggplot2::scale_y_continuous(labels = scales::percent) +
  ggplot2::labs(
    x = "Step (week.step)",
    y = "Drop-off to next step",
    title = "Largest step-to-step drop-offs (by run)"
  ) +
  ggplot2::coord_flip()

ggplot2::ggsave("outputs/plots/top_dropoffs.png", p_drop, width = 12, height = 7)

cache("top_dropoffs")
cache("p_drop")

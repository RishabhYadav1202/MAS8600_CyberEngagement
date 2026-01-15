learner_quiz_participation <- dplyr::bind_rows(lapply(1:7, function(r) {
  
  # Learner persistence
  lsumm <- get(paste0("learner_summary_run", r)) %>%
    dplyr::mutate(run = r)
  
  # Quiz participation (number of answered questions)
  qr <- get(paste0("clean_question_response_run", r)) %>%
    dplyr::filter(!is.na(correct)) %>%
    dplyr::group_by(learner_id) %>%
    dplyr::summarise(
      quiz_items_answered = dplyr::n(),
      .groups = "drop"
    )
  
  dplyr::left_join(lsumm, qr, by = "learner_id")
}))

# Plot
p_quiz_participation <- ggplot2::ggplot(
  learner_quiz_participation,
  ggplot2::aes(x = quiz_items_answered, y = completion_ratio)
) +
  ggplot2::geom_point(alpha = 0.3) +
  ggplot2::labs(
    title = "Quiz participation vs learner persistence",
    x = "Number of quiz questions attempted",
    y = "Course completion ratio"
  )

# Save image
ggplot2::ggsave(
  "outputs/plots/quiz_participation_vs_persistence.png",
  p_quiz_participation,
  width = 10,
  height = 6
)

# Cache objects
cache("learner_quiz_participation")
cache("p_quiz_participation")


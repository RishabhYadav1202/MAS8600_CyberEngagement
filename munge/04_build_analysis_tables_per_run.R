#######################################################
# Build analysis-ready objects per run (NO combining)  #
#######################################################

for (r in 1:7) {
  
  step_name <- paste0("clean_step_activity_run", r)
  qr_name   <- paste0("clean_question_response_run", r)
  
  stopifnot(exists(step_name), exists(qr_name))
  
  clean_step <- get(step_name)
  clean_qr   <- get(qr_name)
  
  # Base learner-step table
  learner_step <- clean_step %>%
    dplyr::select(learner_id, week_number, step_number, dplyr::everything())
  
  # Quiz summary per learner-step
  quiz_by_learner_step <- clean_qr %>%
    dplyr::group_by(learner_id, week_number, step_number) %>%
    dplyr::summarise(
      quiz_items = sum(!is.na(correct)),
      quiz_correct = sum(correct %in% TRUE, na.rm = TRUE),
      quiz_accuracy = dplyr::if_else(quiz_items > 0, quiz_correct / quiz_items, NA_real_),
      
      first_submit_at = {
        x <- submitted_at
        if (all(is.na(x))) as.POSIXct(NA, tz = "UTC") else min(x, na.rm = TRUE)
      },
      .groups = "drop"
    )
  
  # Join step activity + quiz
  learner_step_joined <- learner_step %>%
    dplyr::left_join(
      quiz_by_learner_step,
      by = c("learner_id", "week_number", "step_number")
    )
  
  # Funnel per step (distinct learners)
  funnel_step <- learner_step %>%
    dplyr::group_by(week_number, step_number) %>%
    dplyr::summarise(
      visited = dplyr::n_distinct(learner_id),
      completed = dplyr::n_distinct(learner_id[completed %in% TRUE]),
      completion_rate = dplyr::if_else(visited > 0, completed / visited, NA_real_),
      .groups = "drop"
    ) %>%
    dplyr::arrange(week_number, step_number) %>%
    dplyr::mutate(
      visited_next = dplyr::lead(visited),
      drop_off_to_next = dplyr::if_else(
        !is.na(visited_next) & visited > 0,
        1 - (visited_next / visited),
        NA_real_
      )
    )
  
  # Learner-level summary
  learner_summary <- learner_step %>%
    dplyr::group_by(learner_id) %>%
    dplyr::summarise(
      steps_visited = dplyr::n_distinct(paste(week_number, step_number, sep = "_")),
      steps_completed = sum(completed, na.rm = TRUE),
      completion_ratio = dplyr::if_else(steps_visited > 0, steps_completed / steps_visited, NA_real_),
      first_seen = safe_min_posix(first_visited_at),
      last_seen  = safe_max_posix(first_visited_at),
      .groups = "drop"
    )
  
  # Assign per-run objects
  assign(paste0("learner_step_run", r), learner_step, envir = .GlobalEnv)
  assign(paste0("quiz_by_learner_step_run", r), quiz_by_learner_step, envir = .GlobalEnv)
  assign(paste0("learner_step_joined_run", r), learner_step_joined, envir = .GlobalEnv)
  assign(paste0("funnel_step_run", r), funnel_step, envir = .GlobalEnv)
  assign(paste0("learner_summary_run", r), learner_summary, envir = .GlobalEnv)
  
  # Cache per-run objects
  cache(paste0("learner_step_run", r))
  cache(paste0("quiz_by_learner_step_run", r))
  cache(paste0("learner_step_joined_run", r))
  cache(paste0("funnel_step_run", r))
  cache(paste0("learner_summary_run", r))
}


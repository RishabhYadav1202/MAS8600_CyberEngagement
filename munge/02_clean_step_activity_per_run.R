for (r in 1:7) {
  
  obj <- paste0("cyber.security.", r, "_step.activity")
  stopifnot(exists(obj))
  
  step_df <- get(obj) |> standardise_keys()
  
  clean_step <- step_df |>
    dplyr::mutate(
      learner_id = as.character(learner_id),
      week_number = as.integer(week_number),
      step_number = as.integer(step_number),
      
      first_visited_at  = lubridate::ymd_hms(
        stringr::str_remove(first_visited_at, " UTC$"),
        tz = "UTC"
      ),
      last_completed_at = lubridate::ymd_hms(
        stringr::str_remove(last_completed_at, " UTC$"),
        tz = "UTC"
      ),
      
      completed = !is.na(last_completed_at),
      
      visit_to_complete_mins = dplyr::if_else(
        completed,
        as.numeric(difftime(last_completed_at, first_visited_at, units = "mins")),
        NA_real_
      ),
      
      visit_to_complete_mins = dplyr::if_else(
        visit_to_complete_mins < 0, NA_real_, visit_to_complete_mins
      )
    )
  
  assign(paste0("clean_step_activity_run", r), clean_step, envir = .GlobalEnv)
  cache(paste0("clean_step_activity_run", r))
}


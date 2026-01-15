for (r in 1:7) {
  
  obj <- paste0("cyber.security.", r, "_question.response")
  stopifnot(exists(obj))
  
  qr <- get(obj) |> standardise_keys()
  
  clean_qr <- qr |>
    dplyr::mutate(
      learner_id = as.character(learner_id),
      week_number = as.integer(week_number),
      step_number = as.integer(step_number),
      submitted_at = lubridate::ymd_hms(
        stringr::str_remove(submitted_at, " UTC$"),
        tz = "UTC"
      )
    )
  
  assign(paste0("clean_question_response_run", r), clean_qr, envir = .GlobalEnv)
  cache(paste0("clean_question_response_run", r))
}


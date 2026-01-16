
# Preparing combined funnel table 


# Combine per-run funnel objects (plotting table only)
funnel_step_all <- dplyr::bind_rows(lapply(1:7, function(r) {
  get(paste0("funnel_step_run", r)) %>%
    dplyr::mutate(run = r)
}))

# Output folders (safe)
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/plots", showWarnings = FALSE)

cache("funnel_step_all")


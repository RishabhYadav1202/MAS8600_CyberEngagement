#############################
# Helper functions (MOOC)   #
#############################

standardise_keys <- function(df) {
  df |>
    dplyr::rename_with(~ gsub("\\s+", "_", .x)) |>
    dplyr::rename_with(tolower)
}

safe_min_posix <- function(x) {
  if (all(is.na(x))) as.POSIXct(NA, tz = "UTC") else min(x, na.rm = TRUE)
}

safe_max_posix <- function(x) {
  if (all(is.na(x))) as.POSIXct(NA, tz = "UTC") else max(x, na.rm = TRUE)
}




simulate_dataframe <- function(input_df, num_obs = 1, columns_to_simulate = colnames(input_df)) {

  sim_df <- data.frame(matrix(NA, nrow = num_obs, ncol = length(columns_to_simulate)))
  colnames(sim_df) <- columns_to_simulate

  code <- "data.frame(\n"

  for (col in columns_to_simulate) {
    if (is.numeric(input_df[[col]])) {
      dist_fit <- fitdist(input_df[[col]], "norm")
      sim_df[[col]] <- rnorm(num_obs, mean = dist_fit$estimate[1], sd = dist_fit$estimate[2])
      code <- paste0(code, "  ", col, " = rnorm(", num_obs, ", mean = ", dist_fit$estimate[1], ", sd = ", dist_fit$estimate[2], "),\n")
    } else if (is.factor(input_df[[col]])) {
      sim_df[[col]] <- factor(sample(levels(input_df[[col]]), num_obs, replace = TRUE))
      code <- paste0(code, "  ", col, " = factor(sample(c(", paste(paste0("\"", levels(input_df[[col]]), "\""), collapse = ", "), "), ", num_obs, ", replace = TRUE)),\n")
    } else if (is.character(input_df[[col]])) {
      sim_df[[col]] <- replicate(num_obs, paste(sample(letters, 10, replace = TRUE), collapse = ""))
      code <- paste0(code, "  ", col, " = replicate(", num_obs, ", paste(sample(letters, 10, replace = TRUE), collapse = '')),\n")
    }
  }

  code <- substr(code, 1, nchar(code)-2)
  code <- paste0(code, "\n)\n")

  return(list(simulated_df = sim_df, code = code))
}

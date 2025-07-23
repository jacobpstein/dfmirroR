#' Simulate data that mirrors a data frame and output code to re-create the simulation
#'
#' @param input_df A data frame.
#' @param num_obs A numeric value specifying how many observations (i.e., rows) to simulate.
#' @param columns_to_simulate One or more columns from the `input_df` to simulate. The default is all columns.
#' @param hide_cols Select `TRUE` to replace column names with anonymized names that take the form of "v1," "v2," and so on for each column.
#' #' @param seed Optional random seed for reproducibility
#' @return A list with
#' * `simulated_df` a data frame object containing a simulated mirror of the input df where each specified column has the same mean and standard deviation as the input df
#' * `code` a string vector that can be run in conjunction with `cat()` to output easily shareable code to recreate `simulated_df`
#'
#'@importFrom fitdistrplus fitdist
#'@importFrom stats rnorm
#'@importFrom stats shapiro.test
#'@importFrom stats rgamma
#'@importFrom stats sd
#'@importFrom MASS fitdistr
#'@importFrom e1071 skewness

#' @export
#'
#' @examples
#'# # Run the function and create an object called `mirrored_df`
#' mirrored_df <- simulate_dataframe(mtcars, num_obs = 10, columns_to_simulate = c("mpg", "wt"))
#'
#' # Print the mirrored data frame
#'print(mirrored_df$simulated_df)
#'
#' # Output code to create the mirrored data frame for asking
#' # questions or supporting other reproducible tasks
#' cat(mirrored_df$code)


simulate_dataframe <- function(input_df, num_obs = 1, columns_to_simulate = colnames(input_df),
                               hide_cols = FALSE, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  simulate_skewed_gamma <- function(column_data, num_obs) {
    mean_val <- mean(column_data, na.rm = TRUE)
    sd_val <- sd(column_data, na.rm = TRUE)
    shape <- (mean_val / sd_val)^2
    rate <- mean_val / sd_val^2
    rgamma(num_obs, shape = shape, rate = rate)
  }

  simulated_df <- data.frame(matrix(NA, nrow = num_obs, ncol = length(columns_to_simulate)))
  colnames(simulated_df) <- if (hide_cols) paste0("v", seq_along(columns_to_simulate)) else columns_to_simulate

  code <- "simulated_df <- data.frame(\n"

  for (i in seq_along(columns_to_simulate)) {
    col <- columns_to_simulate[i]
    col_data <- input_df[[col]]
    var_name <- if (hide_cols) paste0("v", i) else col

    # Handle constant columns
    unique_vals <- unique(na.omit(col_data))
    if (length(unique_vals) == 1) {
      simulated_df[[i]] <- rep(unique_vals, num_obs)
      code <- paste0(code, "  ", var_name, " = rep(", dput(unique_vals), ", ", num_obs, "),\n")
      next
    }

    # Handle numeric
    if (is.numeric(col_data)) {
      col_data <- ifelse(is.na(col_data), mean(col_data, na.rm = TRUE), col_data)
      if (length(col_data) >= 3 && length(unique(col_data)) > 2) {
        shapiro_test <- tryCatch(shapiro.test(col_data), error = function(e) NULL)
        if (!is.null(shapiro_test) && shapiro_test$p.value > 0.05) {
          dist_fit <- fitdistrplus::fitdist(col_data, "norm")
          mu <- dist_fit$estimate["mean"]
          sigma <- dist_fit$estimate["sd"]
          simulated_df[[i]] <- rnorm(num_obs, mean = mu, sd = sigma)
          code <- paste0(code, "  ", var_name, " = rnorm(", num_obs,
                         ", mean = ", round(mu, 4), ", sd = ", round(sigma, 4), "),\n")
        } else {
          skew_value <- tryCatch(e1071::skewness(col_data), error = function(e) NA)
          if (is.na(skew_value) || abs(skew_value) > 1) {
            simulated_df[[i]] <- simulate_skewed_gamma(col_data, num_obs)
            code <- paste0(code, "  ", var_name, " = simulate_skewed_gamma(input_df[['", col, "']], ", num_obs, "),\n")
          } else {
            sampled_values <- unique(col_data)
            simulated_df[[i]] <- sample(sampled_values, num_obs, replace = TRUE)
            code <- paste0(code, "  ", var_name, " = sample(c(", paste0(round(sampled_values, 4), collapse = ", "),
                           "), ", num_obs, ", replace = TRUE),\n")
          }
        }
      } else {
        simulated_df[[i]] <- rep(mean(col_data, na.rm = TRUE), num_obs)
        code <- paste0(code, "  ", var_name, " = rep(", round(mean(col_data, na.rm = TRUE), 4), ", ", num_obs, "),\n")
      }

      # Handle factor
    } else if (is.factor(col_data)) {
      tab <- table(col_data)
      levels_vec <- names(tab)
      probs <- tab / sum(tab)
      simulated_df[[i]] <- factor(sample(levels_vec, num_obs, replace = TRUE, prob = probs), levels = levels(col_data))
      code <- paste0(code, "  ", var_name, " = factor(sample(c(",
                     paste0("'", levels_vec, "'", collapse = ", "), "), ",
                     num_obs, ", replace = TRUE, prob = c(", paste0(round(probs, 4), collapse = ", "), "))),\n")

      # Handle character
    } else if (is.character(col_data)) {
      simulated_df[[i]] <- replicate(num_obs, paste(sample(letters, 10, replace = TRUE), collapse = ""))
      code <- paste0(code, "  ", var_name, " = replicate(", num_obs,
                     ", paste(sample(letters, 10, replace = TRUE), collapse = '')),\n")

      # Handle logical
    } else if (is.logical(col_data)) {
      tab <- table(col_data)
      probs <- tab / sum(tab)
      vals <- as.logical(names(tab))
      simulated_df[[i]] <- sample(vals, num_obs, replace = TRUE, prob = probs)
      code <- paste0(code, "  ", var_name, " = sample(c(", paste(as.character(vals), collapse = ", "),
                     "), ", num_obs, ", replace = TRUE, prob = c(", paste0(round(probs, 4), collapse = ", "), ")),\n")

      # Handle Date
    } else if (inherits(col_data, "Date")) {
      date_range <- range(col_data, na.rm = TRUE)
      simulated_df[[i]] <- sample(seq(date_range[1], date_range[2], by = "day"), num_obs, replace = TRUE)
      code <- paste0(code, "  ", var_name, " = sample(seq(as.Date('", date_range[1],
                     "'), as.Date('", date_range[2], "'), by = 'day'), ", num_obs, ", replace = TRUE),\n")

      # Handle nested data.frames or lists of data.frames
    } else if (is.data.frame(col_data) || is.list(col_data)) {
      nested_result <- tryCatch(
        simulate_dataframe(as.data.frame(col_data), num_obs = num_obs, hide_cols = hide_cols, seed = seed),
        error = function(e) NULL
      )
      simulated_df[[i]] <- I(nested_result$simulated_df)
      code <- paste0(code, "  ", var_name, " = simulate_dataframe(input_df[['", col, "']], num_obs = ", num_obs, ")$simulated_df,\n")

      # Fallback for unsupported types
    } else {
      simulated_df[[i]] <- rep(NA, num_obs)
      code <- paste0(code, "  ", var_name, " = rep(NA, ", num_obs, "),\n")
    }
  }

  code <- substr(code, 1, nchar(code) - 2)  # remove trailing comma
  code <- paste0(code, "\n)\n")

  return(list(simulated_df = simulated_df, code = code))
}

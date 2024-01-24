#' Simulate data that mirrors a data frame and output code to re-create the simulation
#'
#' @param input_df A data frame.
#' @param num_obs A numeric value specifying how many observations (i.e., rows) to simulate.
#' @param columns_to_simulate One or more columns from the `input_df` to simulate. The default is all columns.
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



simulate_dataframe <- function(input_df, num_obs = 1, columns_to_simulate = colnames(input_df)) {


  simulate_skewed_gamma <- function(column_data, num_obs) {
    # Custom function to simulate skewed gamma distribution while maintaining mean and standard deviation
    mean_val <- mean(column_data)
    sd_val <- sd(column_data)
    shape <- (mean_val / sd_val)^2
    rate <- mean_val / sd_val^2
    simulated_data <- rgamma(num_obs, shape = shape, rate = rate)
    return(simulated_data)
  }

  simulated_df <- data.frame(matrix(NA, nrow = num_obs, ncol = length(columns_to_simulate)))
  colnames(simulated_df) <- columns_to_simulate

  code <- "simulated_df <- data.frame(\n"

  for (col in columns_to_simulate) {
    if (is.numeric(input_df[[col]])) {
      # Check for normality using the Shapiro-Wilk test
      shapiro_test <- shapiro.test(input_df[[col]])

      if (shapiro_test$p.value > 0.05 && length(unique(input_df[[col]])) > 1) {
        # If p-value > 0.05 and there is variation, assume normal distribution
        dist_fit <- fitdist(input_df[[col]], "norm")
        simulated_df[[col]] <- rnorm(num_obs, mean = dist_fit$estimate[1], sd = dist_fit$estimate[2])
        code <- paste0(code, "  ", col, " = rnorm(", num_obs, ", mean = ", dist_fit$estimate[1], ", sd = ", dist_fit$estimate[2], "),\n")
      } else {
        # If p-value <= 0.05 or lacks variation, assume non-normal distribution
        # Impute missing values before checking skewness
        input_df[[col]][is.na(input_df[[col]])] <- mean(input_df[[col]], na.rm = TRUE)
        skew_value <- skewness(input_df[[col]])

        if (!is.na(skew_value) && abs(skew_value) > 1) {
          # If skewness is greater than 1, simulate skewed data using custom function
          simulated_df[[col]] <- simulate_skewed_gamma(input_df[[col]], num_obs)
          code <- paste0(code, "  ", col, " = simulate_skewed_gamma(input_df[['", col, "']], ", num_obs, "),\n")
        } else {
          # If skewness is not significant or missing, simulate as before
          sampled_values <- unique(input_df[[col]])
          simulated_df[[col]] <- sample(sampled_values, num_obs, replace = TRUE)
          code <- paste0(code, "  ", col, " = sample(c(", paste(sampled_values, collapse = ", "), "), ", num_obs, ", replace = TRUE),\n")
        }
      }
    } else if (is.factor(input_df[[col]])) {
      simulated_df[[col]] <- factor(sample(levels(input_df[[col]]), num_obs, replace = TRUE))
      code <- paste0(code, "  ", col, " = factor(sample(c(", paste(levels(input_df[[col]]), collapse = ", "), "), ", num_obs, ", replace = TRUE)),\n")
    } else if (is.character(input_df[[col]])) {
      simulated_df[[col]] <- replicate(num_obs, paste(sample(letters, 10, replace = TRUE), collapse = ""))
      code <- paste0(code, "  ", col, " = replicate(", num_obs, ", paste(sample(letters, 10, replace = TRUE), collapse = '')),\n")
    }
  }

  code <- substr(code, 1, nchar(code)-2)  # Remove the trailing comma
  code <- paste0(code, "\n)\n")

  return(list(simulated_df = simulated_df, code = code))
}



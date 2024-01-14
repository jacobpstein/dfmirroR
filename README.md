
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dfmirroR

<!-- badges: start -->
<!-- badges: end -->

The goal of dfmirroR is to create mirrored version of data sets *and*
output a string with the code to reproduce that copy. Data scientists
often have questions about analyzing a specific data set, but in many
cases cannot share their data.

*dfmirrorR* creates a copy of the data based on the distribution of
specified columns. In recognition that we also often have questions we
want to post publicly, and the need to create producable examples, the
package also has functionality for outputting a simplified, pasteable
version of code for creating the mirrored data frame object.

One neat thing about dfmirrorR is that it tests whether or not columns
are normally distributed and mirrors the specified columns accordingly
so that your “fake” data resembles your original data.

## Installation

You can install the development version of dfmirroR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jacobpstein/dfmirroR")
```

## Example

This is a basic example which shows you how to solve a common problem.
Let’s say you are working with the `airquality` dataset. This contains a
`Temp` column that is approximately normal based on a basic Shapiro-Wilk
test and another column `Ozone`, which is non-normally distributed. You
want to simulate a data set to test a model and need to mirror
`airquality` but with more observations and then create a reproducible
example.

Here’s what the `Ozone` column looks like in the original data:

``` r
library(dfmirroR)
library(ggplot2)

data(airquality)

# take a look at the Ozone variable

ggplot(airquality) +
  geom_histogram(aes(Ozone), col = "white", fill = "#AFDFEF") +
  theme_minimal() +
  labs(title = "Distribution of 153 Ozone observations from the airquality dataset")
#> `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
#> Warning: Removed 37 rows containing non-finite values (`stat_bin()`).
```

<img src="man/figures/README-example1-1.png" width="100%" />

Now, let’s run `dfmirrorR` to create a similar column.

``` r

air_mirror <- simulate_dataframe(airquality, num_obs = 1000, columns_to_simulate = c("Ozone", "Temp"))
```

This creates a `list()` object that contains a new data frame with 1,000
observations based on the distributions of the `Ozone` and `Temp`
columns in the `input_df`.

Take a look at the mirrored colum for Ozone:

``` r

ggplot(air_mirror$simulated_df) +
  geom_histogram(aes(Ozone), col = "white", fill = "#AFDFEF") +
  theme_minimal() +
  labs(title = "Distribution of 1,000 Ozone observations from a mirrored dataset")
#> `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
#> Warning: Removed 255 rows containing non-finite values (`stat_bin()`).
```

<img src="man/figures/README-example3-1.png" width="100%" />

## Print code to share your simulated data

There are other packages that can mirror a dataframe. The excellent
[`faux`](https://debruine.github.io/faux/) comes to mind. However, one
addition of the `dfmirroR` package is that it prints code to add to a
reproducible example if you need to ask a question on Stackoverflow or
elsewhere.

For example, from our `air_mirror` list object above, we can extract the
`code` object, which is just a string containing the relevant code.
Combining this object with the `cat()` function provides clean, easily
shareable output.

``` r

cat(air_mirror$code)
#> simulated_df <- data.frame(
#>   Ozone = sample(41, 1000, replace = TRUE),
#>   Temp = sample(67, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(36, 1000, replace = TRUE),
#>   Temp = sample(72, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(12, 1000, replace = TRUE),
#>   Temp = sample(74, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(18, 1000, replace = TRUE),
#>   Temp = sample(62, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(56, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(28, 1000, replace = TRUE),
#>   Temp = sample(66, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(23, 1000, replace = TRUE),
#>   Temp = sample(65, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(19, 1000, replace = TRUE),
#>   Temp = sample(59, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(8, 1000, replace = TRUE),
#>   Temp = sample(61, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(69, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(7, 1000, replace = TRUE),
#>   Temp = sample(74, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(16, 1000, replace = TRUE),
#>   Temp = sample(69, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(11, 1000, replace = TRUE),
#>   Temp = sample(66, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(14, 1000, replace = TRUE),
#>   Temp = sample(68, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(18, 1000, replace = TRUE),
#>   Temp = sample(58, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(14, 1000, replace = TRUE),
#>   Temp = sample(64, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(34, 1000, replace = TRUE),
#>   Temp = sample(66, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(6, 1000, replace = TRUE),
#>   Temp = sample(57, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(30, 1000, replace = TRUE),
#>   Temp = sample(68, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(11, 1000, replace = TRUE),
#>   Temp = sample(62, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(1, 1000, replace = TRUE),
#>   Temp = sample(59, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(11, 1000, replace = TRUE),
#>   Temp = sample(73, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(4, 1000, replace = TRUE),
#>   Temp = sample(61, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(32, 1000, replace = TRUE),
#>   Temp = sample(61, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(57, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(58, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(57, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(23, 1000, replace = TRUE),
#>   Temp = sample(67, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(45, 1000, replace = TRUE),
#>   Temp = sample(81, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(115, 1000, replace = TRUE),
#>   Temp = sample(79, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(37, 1000, replace = TRUE),
#>   Temp = sample(76, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(78, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(74, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(67, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(84, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(85, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(79, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(29, 1000, replace = TRUE),
#>   Temp = sample(82, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(87, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(71, 1000, replace = TRUE),
#>   Temp = sample(90, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(39, 1000, replace = TRUE),
#>   Temp = sample(87, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(93, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(92, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(23, 1000, replace = TRUE),
#>   Temp = sample(82, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(80, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(79, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(21, 1000, replace = TRUE),
#>   Temp = sample(77, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(37, 1000, replace = TRUE),
#>   Temp = sample(72, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(20, 1000, replace = TRUE),
#>   Temp = sample(65, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(12, 1000, replace = TRUE),
#>   Temp = sample(73, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(13, 1000, replace = TRUE),
#>   Temp = sample(76, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(77, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(76, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(76, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(76, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(75, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(78, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(73, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(80, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(77, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(83, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(135, 1000, replace = TRUE),
#>   Temp = sample(84, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(49, 1000, replace = TRUE),
#>   Temp = sample(85, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(32, 1000, replace = TRUE),
#>   Temp = sample(81, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(84, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(64, 1000, replace = TRUE),
#>   Temp = sample(83, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(40, 1000, replace = TRUE),
#>   Temp = sample(83, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(77, 1000, replace = TRUE),
#>   Temp = sample(88, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(97, 1000, replace = TRUE),
#>   Temp = sample(92, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(97, 1000, replace = TRUE),
#>   Temp = sample(92, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(85, 1000, replace = TRUE),
#>   Temp = sample(89, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(82, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(10, 1000, replace = TRUE),
#>   Temp = sample(73, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(27, 1000, replace = TRUE),
#>   Temp = sample(81, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(91, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(7, 1000, replace = TRUE),
#>   Temp = sample(80, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(48, 1000, replace = TRUE),
#>   Temp = sample(81, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(35, 1000, replace = TRUE),
#>   Temp = sample(82, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(61, 1000, replace = TRUE),
#>   Temp = sample(84, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(79, 1000, replace = TRUE),
#>   Temp = sample(87, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(63, 1000, replace = TRUE),
#>   Temp = sample(85, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(16, 1000, replace = TRUE),
#>   Temp = sample(74, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(81, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(82, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(80, 1000, replace = TRUE),
#>   Temp = sample(86, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(108, 1000, replace = TRUE),
#>   Temp = sample(85, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(20, 1000, replace = TRUE),
#>   Temp = sample(82, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(52, 1000, replace = TRUE),
#>   Temp = sample(86, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(82, 1000, replace = TRUE),
#>   Temp = sample(88, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(50, 1000, replace = TRUE),
#>   Temp = sample(86, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(64, 1000, replace = TRUE),
#>   Temp = sample(83, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(59, 1000, replace = TRUE),
#>   Temp = sample(81, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(39, 1000, replace = TRUE),
#>   Temp = sample(81, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(9, 1000, replace = TRUE),
#>   Temp = sample(81, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(16, 1000, replace = TRUE),
#>   Temp = sample(82, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(78, 1000, replace = TRUE),
#>   Temp = sample(86, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(35, 1000, replace = TRUE),
#>   Temp = sample(85, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(66, 1000, replace = TRUE),
#>   Temp = sample(87, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(122, 1000, replace = TRUE),
#>   Temp = sample(89, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(89, 1000, replace = TRUE),
#>   Temp = sample(90, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(110, 1000, replace = TRUE),
#>   Temp = sample(90, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(92, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(86, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(44, 1000, replace = TRUE),
#>   Temp = sample(86, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(28, 1000, replace = TRUE),
#>   Temp = sample(82, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(65, 1000, replace = TRUE),
#>   Temp = sample(80, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(79, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(22, 1000, replace = TRUE),
#>   Temp = sample(77, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(59, 1000, replace = TRUE),
#>   Temp = sample(79, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(23, 1000, replace = TRUE),
#>   Temp = sample(76, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(31, 1000, replace = TRUE),
#>   Temp = sample(78, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(44, 1000, replace = TRUE),
#>   Temp = sample(78, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(21, 1000, replace = TRUE),
#>   Temp = sample(77, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(9, 1000, replace = TRUE),
#>   Temp = sample(72, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(75, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(45, 1000, replace = TRUE),
#>   Temp = sample(79, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(168, 1000, replace = TRUE),
#>   Temp = sample(81, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(73, 1000, replace = TRUE),
#>   Temp = sample(86, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(88, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(76, 1000, replace = TRUE),
#>   Temp = sample(97, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(118, 1000, replace = TRUE),
#>   Temp = sample(94, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(84, 1000, replace = TRUE),
#>   Temp = sample(96, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(85, 1000, replace = TRUE),
#>   Temp = sample(94, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(96, 1000, replace = TRUE),
#>   Temp = sample(91, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(78, 1000, replace = TRUE),
#>   Temp = sample(92, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(73, 1000, replace = TRUE),
#>   Temp = sample(93, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(91, 1000, replace = TRUE),
#>   Temp = sample(93, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(47, 1000, replace = TRUE),
#>   Temp = sample(87, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(32, 1000, replace = TRUE),
#>   Temp = sample(84, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(20, 1000, replace = TRUE),
#>   Temp = sample(80, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(23, 1000, replace = TRUE),
#>   Temp = sample(78, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(21, 1000, replace = TRUE),
#>   Temp = sample(75, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(24, 1000, replace = TRUE),
#>   Temp = sample(73, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(44, 1000, replace = TRUE),
#>   Temp = sample(81, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(21, 1000, replace = TRUE),
#>   Temp = sample(76, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(28, 1000, replace = TRUE),
#>   Temp = sample(77, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(9, 1000, replace = TRUE),
#>   Temp = sample(71, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(13, 1000, replace = TRUE),
#>   Temp = sample(71, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(46, 1000, replace = TRUE),
#>   Temp = sample(78, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(18, 1000, replace = TRUE),
#>   Temp = sample(67, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(13, 1000, replace = TRUE),
#>   Temp = sample(76, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(24, 1000, replace = TRUE),
#>   Temp = sample(68, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(16, 1000, replace = TRUE),
#>   Temp = sample(82, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(13, 1000, replace = TRUE),
#>   Temp = sample(64, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(23, 1000, replace = TRUE),
#>   Temp = sample(71, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(36, 1000, replace = TRUE),
#>   Temp = sample(81, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(7, 1000, replace = TRUE),
#>   Temp = sample(69, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(14, 1000, replace = TRUE),
#>   Temp = sample(63, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(30, 1000, replace = TRUE),
#>   Temp = sample(70, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(NA, 1000, replace = TRUE),
#>   Temp = sample(77, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(14, 1000, replace = TRUE),
#>   Temp = sample(75, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(18, 1000, replace = TRUE),
#>   Temp = sample(76, 1000, replace = TRUE)
#> )
#>  simulated_df <- data.frame(
#>   Ozone = sample(20, 1000, replace = TRUE),
#>   Temp = sample(68, 1000, replace = TRUE)
#> )
```

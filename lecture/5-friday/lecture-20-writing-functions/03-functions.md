03-functions.R
================
jenny
Fri Jun 16 09:29:57 2017

``` r




## Write your own R functions, part 3
library(gapminder)
library(tidyverse)
#> + ggplot2 2.2.1             Date: 2017-06-16
#> + tibble  1.3.3                R: 3.3.2
#> + tidyr   0.6.3               OS: OS X El Capitan 10.11.6
#> + readr   1.1.1              GUI: X11
#> + purrr   0.2.2.9000      Locale: en_CA.UTF-8
#> + dplyr   0.7.0               TZ: Europe/Rome
#> + stringr 1.2.0           
#> + forcats 0.2.0
#> Conflicts -----------------------------------------------------------------
#> * filter(),  from dplyr, masks stats::filter()
#> * lag(),     from dplyr, masks stats::lag()

qdiff4 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs)
  return(max(the_quantiles) - min(the_quantiles))
}


### Be proactive about `NA`s

z <- gapminder$lifeExp
z[3] <- NA
quantile(gapminder$lifeExp)
#>      0%     25%     50%     75%    100% 
#> 23.5990 48.1980 60.7125 70.8455 82.6030
quantile(z)
#> Error in quantile.default(z): missing values and NaN's not allowed if 'na.rm' is FALSE
quantile(z, na.rm = TRUE)
#>     0%    25%    50%    75%   100% 
#> 23.599 48.228 60.765 70.846 82.603


## hardwire the NA treatment
qdiff5 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs, na.rm = TRUE)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff5(gapminder$lifeExp)
#> [1] 59.004
qdiff5(z)
#> [1] 59.004



## allow your user to specify NA treatment
qdiff6 <- function(x, probs = c(0, 1), na.rm = TRUE) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs, na.rm = na.rm)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff6(gapminder$lifeExp)
#> [1] 59.004
qdiff6(z)
#> [1] 59.004
qdiff6(z, na.rm = FALSE)
#> Error in quantile.default(x, probs, na.rm = na.rm): missing values and NaN's not allowed if 'na.rm' is FALSE


### The useful but mysterious `...` argument

## give user control of quantile algorithm
qdiff7 <- function(x, probs = c(0, 1), na.rm = TRUE, ...) {
  the_quantiles <- quantile(x = x, probs = probs, na.rm = na.rm, ...)
  return(max(the_quantiles) - min(the_quantiles))
}

## caveat: practical significance of `type` argument is usually tiny
set.seed(1234)
z <- rnorm(10)
quantile(z, type = 1)
#>         0%        25%        50%        75%       100% 
#> -2.3456977 -0.8900378 -0.5644520  0.4291247  1.0844412
quantile(z, type = 4)
#>        0%       25%       50%       75%      100% 
#> -2.345698 -1.048552 -0.564452  0.353277  1.084441
all.equal(quantile(z, type = 1), quantile(z, type = 4))
#> [1] "Mean relative difference: 0.1776594"


qdiff7(z, probs = c(0.25, 0.75), type = 1)
#> [1] 1.319163
qdiff7(z, probs = c(0.25, 0.75), type = 4)
#> [1] 1.401829
## difference is subtle, but there!

## we just exposed functionality of quantile() w/o complicating our fxn much





### Use `testthat` for formal unit tests

library(testthat)
#> 
#> Attaching package: 'testthat'
#> The following object is masked from 'package:dplyr':
#> 
#>     matches
#> The following object is masked from 'package:purrr':
#> 
#>     is_null
test_that('invalid args are detected', {
  expect_error(qdiff7("eggplants are purple"))
  expect_error(qdiff7(iris))
  })
test_that('NA handling works', {
  expect_error(qdiff7(c(1:5, NA), na.rm = FALSE))
  expect_equal(qdiff7(c(1:5, NA)), 4)
})



qdiff_no_NA <- function(x, probs = c(0, 1)) {
  the_quantiles <- quantile(x = x, probs = probs)
  return(max(the_quantiles) - min(the_quantiles))
}
test_that('NA handling works', {
  expect_that(qdiff_no_NA(c(1:5, NA)), equals(4))
})
#> Error: Test failed: 'NA handling works'
#> * missing values and NaN's not allowed if 'na.rm' is FALSE
#> 1: expect_that(qdiff_no_NA(c(1:5, NA)), equals(4)) at <text>:92
#> 2: condition(object)
#> 3: expect_equal(x, expected, ..., expected.label = label)
#> 4: compare(object, expected, ...)
#> 5: qdiff_no_NA(c(1:5, NA))
#> 6: quantile(x = x, probs = probs) at <text>:88
#> 7: quantile.default(x = x, probs = probs)
#> 8: stop("missing values and NaN's not allowed if 'na.rm' is FALSE")
## this failure would alert you to your lack of NA handling
```

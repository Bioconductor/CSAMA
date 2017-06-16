#' ---
#' output: github_document
#' ---

#+ setup, include = FALSE, cache = FALSE
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", error = TRUE)
#+




## Write your own R functions, part 3
library(gapminder)
library(tidyverse)

qdiff4 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs)
  return(max(the_quantiles) - min(the_quantiles))
}


### Be proactive about `NA`s

z <- gapminder$lifeExp
z[3] <- NA
quantile(gapminder$lifeExp)
quantile(z)
quantile(z, na.rm = TRUE)


## hardwire the NA treatment
qdiff5 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs, na.rm = TRUE)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff5(gapminder$lifeExp)
qdiff5(z)



## allow your user to specify NA treatment
qdiff6 <- function(x, probs = c(0, 1), na.rm = TRUE) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs, na.rm = na.rm)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff6(gapminder$lifeExp)
qdiff6(z)
qdiff6(z, na.rm = FALSE)


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
quantile(z, type = 4)
all.equal(quantile(z, type = 1), quantile(z, type = 4))


qdiff7(z, probs = c(0.25, 0.75), type = 1)
qdiff7(z, probs = c(0.25, 0.75), type = 4)
## difference is subtle, but there!

## we just exposed functionality of quantile() w/o complicating our fxn much





### Use `testthat` for formal unit tests

library(testthat)
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
## this failure would alert you to your lack of NA handling


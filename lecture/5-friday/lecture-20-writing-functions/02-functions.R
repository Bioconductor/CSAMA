#' ---
#' output: github_document
#' ---

#+ setup, include = FALSE, cache = FALSE
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", error = TRUE)
#+




## Write your own R functions, part 2
library(gapminder)
library(tidyverse)

mmm <- function(x) {
  stopifnot(is.numeric(x))
  max(x) - min(x)
}


## Generalize to other quantiles
##
##  * median = 0.5 quantile
##  * 1st quartile = 0.25 quantile
##  * 3rd quartile = 0.75 quantile

## learn the landscape
quantile(gapminder$lifeExp)
quantile(gapminder$lifeExp, probs = 0.5)
median(gapminder$lifeExp)
quantile(gapminder$lifeExp, probs = c(0.25, 0.75))



## start to build Your Thing
## have success with top-level code
the_probs <- c(0.25, 0.75)
the_quantiles <- quantile(gapminder$lifeExp, probs = the_probs)
max(the_quantiles) - min(the_quantiles)
IQR(gapminder$lifeExp) # hey, we've reinvented IQR



## put WORKING code into body of function
qdiff1 <- function(x, probs) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x = x, probs = probs)
  max(the_quantiles) - min(the_quantiles)
}
qdiff1(gapminder$lifeExp, probs = c(0.25, 0.75))
qdiff1(gapminder$lifeExp, probs = c(0, 1))
mmm(gapminder$lifeExp)
## ^^ informal test with familiar example / previous MVP




## Argument names: freedom and conventions

qdiff2 <- function(zeus, hera) {
  stopifnot(is.numeric(zeus))
  the_quantiles <- quantile(x = zeus, probs = hera)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff2(zeus = gapminder$lifeExp, hera = 0:1)

## Just because you CAN, doesn't mean you SHOULD.
## Use meaningful names.




qdiff3 <- function(my_x, my_probs) {
 stopifnot(is.numeric(my_x))
  the_quantiles <- quantile(x = my_x, probs = my_probs)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff3(my_x = gapminder$lifeExp, my_probs = 0:1)


## When in Rome ... use same names as the functions/package you call!
qdiff1


### What a function returns

## why don't I need an explicit return?
#return(max(the_quantiles) - min(the_quantiles))

## pseudo-convention: explicit return() only for early return




### Default values: freedom to NOT specify the arguments

qdiff1(gapminder$lifeExp)


## be kind, be reasonable
qdiff4 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs)
  return(max(the_quantiles) - min(the_quantiles))
}

qdiff4(gapminder$lifeExp)
mmm(gapminder$lifeExp)
qdiff4(gapminder$lifeExp, c(0.1, 0.9))

## I would build more argument validity checks here

## GOOD STOPPING POINT

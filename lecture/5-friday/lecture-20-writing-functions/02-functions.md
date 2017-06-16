02-functions.R
================
jenny
Fri Jun 16 09:29:51 2017

``` r




## Write your own R functions, part 2
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
#>      0%     25%     50%     75%    100% 
#> 23.5990 48.1980 60.7125 70.8455 82.6030
quantile(gapminder$lifeExp, probs = 0.5)
#>     50% 
#> 60.7125
median(gapminder$lifeExp)
#> [1] 60.7125
quantile(gapminder$lifeExp, probs = c(0.25, 0.75))
#>     25%     75% 
#> 48.1980 70.8455



## start to build Your Thing
## have success with top-level code
the_probs <- c(0.25, 0.75)
the_quantiles <- quantile(gapminder$lifeExp, probs = the_probs)
max(the_quantiles) - min(the_quantiles)
#> [1] 22.6475
IQR(gapminder$lifeExp) # hey, we've reinvented IQR
#> [1] 22.6475



## put WORKING code into body of function
qdiff1 <- function(x, probs) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x = x, probs = probs)
  max(the_quantiles) - min(the_quantiles)
}
qdiff1(gapminder$lifeExp, probs = c(0.25, 0.75))
#> [1] 22.6475
qdiff1(gapminder$lifeExp, probs = c(0, 1))
#> [1] 59.004
mmm(gapminder$lifeExp)
#> [1] 59.004
## ^^ informal test with familiar example / previous MVP




## Argument names: freedom and conventions

qdiff2 <- function(zeus, hera) {
  stopifnot(is.numeric(zeus))
  the_quantiles <- quantile(x = zeus, probs = hera)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff2(zeus = gapminder$lifeExp, hera = 0:1)
#> [1] 59.004

## Just because you CAN, doesn't mean you SHOULD.
## Use meaningful names.




qdiff3 <- function(my_x, my_probs) {
 stopifnot(is.numeric(my_x))
  the_quantiles <- quantile(x = my_x, probs = my_probs)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff3(my_x = gapminder$lifeExp, my_probs = 0:1)
#> [1] 59.004


## When in Rome ... use same names as the functions/package you call!
qdiff1
#> function(x, probs) {
#>   stopifnot(is.numeric(x))
#>   the_quantiles <- quantile(x = x, probs = probs)
#>   max(the_quantiles) - min(the_quantiles)
#> }


### What a function returns

## why don't I need an explicit return?
#return(max(the_quantiles) - min(the_quantiles))

## pseudo-convention: explicit return() only for early return




### Default values: freedom to NOT specify the arguments

qdiff1(gapminder$lifeExp)
#> Error in quantile.default(x = x, probs = probs): argument "probs" is missing, with no default


## be kind, be reasonable
qdiff4 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs)
  return(max(the_quantiles) - min(the_quantiles))
}

qdiff4(gapminder$lifeExp)
#> [1] 59.004
mmm(gapminder$lifeExp)
#> [1] 59.004
qdiff4(gapminder$lifeExp, c(0.1, 0.9))
#> [1] 33.5862

## I would build more argument validity checks here

## GOOD STOPPING POINT
```

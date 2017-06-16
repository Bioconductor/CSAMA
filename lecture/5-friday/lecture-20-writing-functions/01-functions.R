#' ---
#' output: github_document
#' ---

#+ setup, include = FALSE, cache = FALSE
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", error = TRUE)
#+




## Write your own R functions, part 1
library(gapminder)
library(tidyverse)




## Hello Gapminder
str(gapminder)
ggplot(gapminder %>% filter(continent != "Oceania"),
       aes(x = year, y = lifeExp, group = country, color = country)) +
  geom_line(lwd = 1, show.legend = FALSE) + facet_wrap(~ continent) +
  scale_color_manual(values = country_colors) +
  theme_bw() + theme(strip.text = element_text(size = rel(1.1)))




## Max - min life expectancy, for each continent or, imagine 😱😱, country
## The Smelly Version
africa <- gapminder[gapminder$continent == "Africa", ]
africa_mm <- max(africa$lifeExp) - min(africa$lifeExp)
americas <- gapminder[gapminder$continent == "Americas", ]
americas_mm <- max(americas$lifeExp) - min(americas$lifeExp)
asia <- gapminder[gapminder$continent == "Asia", ]
asia_mm <- max(asia$lifeExp) - min(africa$lifeExp)
europe <- gapminder[gapminder$continent == "Europe", ]
europe_mm <- max(europe$lifeExp) - min(europe$lifeExp)
oceania <- gapminder[gapminder$continent == "Oceania", ]
oceania_mm <- max(oceania$lifeExp) - min(oceania$lifeExp)
(df <- tibble(
  continent = c("Africa", "Asias", "Americas", "Europe", "Oceania"),
  max_minus_min = c(africa_mm, americas_mm, asia_mm, europe_mm, oceania_mm)
))



## How to fix?
##
## Write a function!                         <-- OUR TOPIC
## Use with a high-level iteration approach


## Max - min
## Get something that works!!!



## learn the landscape
min(gapminder$lifeExp)
max(gapminder$lifeExp)
range(gapminder$lifeExp)

## some natural solutions
max(gapminder$lifeExp) - min(gapminder$lifeExp)
with(gapminder, max(lifeExp) - min(lifeExp))
range(gapminder$lifeExp)[2] - range(gapminder$lifeExp)[1]
with(gapminder, range(lifeExp)[2] - range(lifeExp)[1])
diff(range(gapminder$lifeExp))

## Internalize this "answer" for eye-ball-ometric testing

## Skateboard >> perfectly formed rear-view mirror
#' ![](spotify-howtobuildmvp.gif)




## Turn the working interactive code into a function
max_minus_min <- function(x) max(x) - min(x)
max_minus_min(gapminder$lifeExp)
## same answer? good!



## Test on new inputs

## artificial inputs where you know answer ... at least sort of
max_minus_min(1:10)
max_minus_min(runif(1000))




## Test on real data but *different* real data
max_minus_min(gapminder$gdpPercap)
max_minus_min(gapminder$pop)
## check by hand or sanity check





## Test on weird stuff you might to do late at night
max_minus_min(gapminder)
max_minus_min(gapminder$country)
max_minus_min("eggplants are purple")
## Do you want to read these error messages at 3a.m.?



## Scary things
max_minus_min(gapminder[c('lifeExp', 'gdpPercap', 'pop')])
max_minus_min(c(TRUE, TRUE, FALSE, TRUE, TRUE))
## Do you want your function to "work" on such input?






### Check the validity of arguments

## Rule of Repair: When you must fail, fail noisily and as soon as possible.

## stopifnot
mmm <- function(x) {
  stopifnot(is.numeric(x))
  max(x) - min(x)
}
mmm(gapminder)
mmm(gapminder$country)
mmm("eggplants are purple")
mmm(gapminder[c('lifeExp', 'gdpPercap', 'pop')])
mmm(c(TRUE, TRUE, FALSE, TRUE, TRUE))

## if then stop
## when you care enough to write an error message
mmm2 <- function(x) {
  if (!is.numeric(x)) {
    stop('I am so sorry, but this function only works for numeric input!\n',
         'You have provided an object of class: ', class(x)[1])
  }
  max(x) - min(x)
}
mmm2(gapminder)

## GOOD STOPPING POINT

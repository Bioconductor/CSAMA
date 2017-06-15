#' ---
#' title: "Learn to love the data frame"
#' author: "Jenny Bryan"
#' date: "`r format(Sys.Date())`"
#' output: github_document
#' ---

#+ setup, include = FALSE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  error = TRUE
)

#' Let's make a random dataset, in a repeatable way.
set.seed(432)

#' If
#' dataset = separate objects lying around the global environment.
#' then
#' dataset = just a state of mind
n <- 15
z <- rep(c("pirate", "ninja"), each = n)
x <- rep(runif(2 * n))
y <- ifelse(z == "pirate",
            0 + 10 * x + rnorm(n),
            2 + 1 * x + rnorm(n, sd = 0.3))
x
y
z

#' Talk me through this:
#'
#' scatterplot plot of x vs y,
#' with pirate points in blue, ninja in orange













plot(x, y, xlim = c(0, 1), ylim = c(0, 12), type = "n")
points(x[z == "pirate"], y[z == "pirate"], col = "blue", pch = 19)
points(x[z == "ninja"], y[z == "ninja"], col = "orange", pch = 19)
legend(x = 0.1, y = 10, c("pirate", "ninja"), col = c("blue", "orange"),
       pch = 19)

#' What if we want to fit a model to pirates and ninjas? And add fitted lines to
#' plot?

#' Talk me through this:
#'
#' fit a model to pirates
#' fit a model to ninjas
#' add a line for pirate fit
#' add a line for ninja fit










pirate_fit <- lm(y[z == "pirate"] ~ x[z == "pirate"])
ninja_fit <- lm(y[z == "ninja"] ~ x[z == "ninja"])
abline(pirate_fit, col = "blue", lwd = 2)
abline(ninja_fit, col = "orange", lwd = 2)

#' Talk me through this:
#'
#' sort x from smallest to largest
#' then re-use our plotting code
#x <- ???
#copy/paste the plotting code

#' What's gone wrong? How would I need to fix this?












x <- sort(x)

plot(x, y, xlim = c(0, 1), ylim = c(0, 12), type = "n")
points(x[z == "pirate"], y[z == "pirate"], col = "blue", pch = 19)
points(x[z == "ninja"], y[z == "ninja"], col = "orange", pch = 19)
legend(x = 0.1, y = 10, c("pirate", "ninja"), col = c("blue", "orange"),
       pch = 19)


#' BIG IDEA:
#' Keep x, y, z together in a data frame

#' Talk me through this:
#' Starting from scratch...
#' Get the same x, y, z into a data frame named df











set.seed(432)
n <- 15
df <- data.frame(
  z = rep(c("pirate", "ninja"), each = n),
  x = rep(runif(2 * n))
)
df$y <- ifelse(df$z == "pirate",
               0 + 10 * df$x + rnorm(n),
               2 + 1 * df$x + rnorm(n, sd = 0.3))
df
class(df)
summary(df)

#' Let's remake our plot to make sure data looks same.
#'
#' Let's take advantage of data = df.
plot(y ~ x, data = df, xlim = c(0, 1), ylim = c(0, 12), type = "n")
points(y ~ x, data = df, subset = z == "pirate", col = "blue", pch = 19)
points(y ~ x, data = df, subset = z == "ninja", col = "orange", pch = 19)
legend(x = 0.1, y = 10, c("pirate", "ninja"), col = c("blue", "orange"),
       pch = 19)
pirate_fit <- lm(y ~ x, data = df, subset = z == "pirate")
ninja_fit <- lm(y ~ x, data = df, subset = z == "ninja")
abline(pirate_fit, col = "blue", lwd = 2)
abline(ninja_fit, col = "orange", lwd = 2)



#' Let's revisit sorting by x.
df <- df[order(df$x), ]
plot(y ~ x, data = df, xlim = c(0, 1), ylim = c(0, 12), type = "n")
points(y ~ x, data = df, subset = z == "pirate", col = "blue", pch = 19)
points(y ~ x, data = df, subset = z == "ninja", col = "orange", pch = 19)
legend(x = 0.1, y = 10, c("pirate", "ninja"), col = c("blue", "orange"),
       pch = 19)
pirate_fit <- lm(y ~ x, data = df, subset = z == "pirate")
ninja_fit <- lm(y ~ x, data = df, subset = z == "ninja")
abline(pirate_fit, col = "blue", lwd = 2)
abline(ninja_fit, col = "orange", lwd = 2)
#' yes, looks the same! So we kept the variables "in sync".

#' Lessons so far:
#'
#'   * keeping vars in a data frame is **safer**
#'   * passing data frames to fxns let's you type less code
#'
#' Go back to the slides here






library(tidyverse)

set.seed(432)
n <- 15
df <- tibble(
  z = rep(c("pirate", "ninja"), each = n),
  x = rep(runif(2 * n)),
  y = ifelse(z == "pirate",
             0 + 10 * x + rnorm(n),
             2 + 1 * x + rnorm(n, sd = 0.3))
)
df
class(df)
summary(df)

pn_colors <- c(pirate = "blue", ninja = "orange")

ggplot(df, aes(x, y, colour = z)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  scale_color_manual(values = pn_colors) +
  theme(legend.justification = c(0,1), legend.position = c(0,1))

#' Let's revisit sorting by x.
df <- arrange(df, x)
head(df)
tail(df)
## resubmit the ggplot code as a visual check all is well

#' More lessons:
#'
#'   * tbl_df or "tibble" is a variant of the data frame
#'   * various annoying or arguably unsafe things about data frames have been
#'     eliminated
#'   * tidyverse packages
#'     - use tibbles
#'     - obey common conventions and principles about interface
#'
#' Go back to the slides here

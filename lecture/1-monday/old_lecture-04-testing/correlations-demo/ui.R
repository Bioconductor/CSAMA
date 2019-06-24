library("ggvis")

fluidPage(sidebarLayout(
  sidebarPanel(
    sliderInput("eps", 
        "Correlation strength", 
        min = 0, max = .8, value = 0),
    radioButtons("dist", "Distribution:",
      c("Normal" = "rnorm", "Uniform" = "runif",
        "Log-normal" = "rlnorm", "Exponential" = "rexp")),
    uiOutput("plot_ui")
  ),
  mainPanel(
    ggvisOutput("plot")
  )
))
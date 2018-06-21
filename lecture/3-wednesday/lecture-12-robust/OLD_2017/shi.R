
docook = function() {
# for CSAMA 2017
# illustrate Cook's distance
# 
library(shiny)
ui = fluidPage(
   sidebarLayout(
    sidebarPanel(
     fluidRow(
      helpText(a("Cook's Dist.", href="https://en.wikipedia.org/wiki/Cook%27s_distance"," for red", target="_blank")),
      textOutput("cook")
      ),
     fluidRow(
      helpText(a("leverage ", href="https://en.wikipedia.org/wiki/Leverage_(statistics)"," (self-influence) for red", target="_blank")),
      textOutput("lev")
      ),
     fluidRow(
      sliderInput("xput", "x", 3.5, 20.5, value=12, step=.5, animate=animationOptions(loop=TRUE))
      ),
     fluidRow(
      sliderInput("yput", "y", 3.5, 20.5, value=10.84, step=.5, animate=animationOptions(loop=TRUE))
      )
     ),
     mainPanel(
      h5(helpText("Anscombe's first pair: User sliders to modify location of red point and observe changes in values of Cook's distance and leverage")),
      plotOutput("cur")
     )
    )
   )
 
server = function(input, output, session) {
   output$cur = renderPlot({
    dat = data.frame(x=anscombe$x1, y=anscombe$y1)
    dat[9,1] = input$xput
    dat[9,2] = input$yput
    plot(y~x, data=dat, xlim=c(0,20.5), ylim=c(0,20.5), cex=1.5)
    points(dat[9,1], dat[9,2], pch=19, col="red")
    abline(lm(y~x, data=dat), lty=2, lwd=2, col="gray")
    })
   output$cook = renderText({
    dat = data.frame(x=anscombe$x1, y=anscombe$y1)
    dat[9,1] = input$xput
    dat[9,2] = input$yput
    cc = cooks.distance(lm(y~x, data=dat))
    as.character(round(cc[9],4))
    hh = hatvalues(lm(y~x, data=dat))
    as.character(round(cc[9],4))
    })
   output$lev = renderText({
    dat = data.frame(x=anscombe$x1, y=anscombe$y1)
    dat[9,1] = input$xput
    dat[9,2] = input$yput
    hh = hatvalues(lm(y~x, data=dat))
    as.character(round(hh[9], 4))
    })
}

shinyApp(ui=ui, server=server)
}


     


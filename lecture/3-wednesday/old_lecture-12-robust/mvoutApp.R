library(shiny)
library(parody)
library(beeswarm)
library(MASS)
library(maftools)

load("data/GBM.RData")

redNgray = c("#8B000033", "#D3D3D333")

genesets = ivygapSE::makeGeneSets()
if (!exists("gbmu133")) load("data/gbmu133.rda")
# you can use mv.calout.detect on subsets of data defined by gene sets

ui = fluidPage(
 sidebarLayout(
  sidebarPanel(
   helpText("CSAMA 2018 outlier exploration, using TCGA-GBM hu133 expression data and a potentially obsolete selection of cBioPortal gene sets"),
   selectInput("geneset", "geneset", names(genesets), names(genesets)[1]),
   uiOutput("picker"),
   numericInput("bp1", "bipl ax1", 1, min=1, max=10, step=1),
   numericInput("bp2", "bipl ax2", 2, min=2, max=10, step=1), width=3
   ),
  mainPanel(
   helpText("Tabs: beesOne for univariate, PCA for general princomp, biplot on PC selected as 'bipl ax', oncopl for maftools coOncoplot, which uses PoisonAlien TCGAMutations for GBM"),
   tabsetPanel(
    tabPanel("ParCo", plotOutput("curparco")),
    tabPanel("beesOne", plotOutput("beesOne")),
    tabPanel("PCA", plotOutput("prcomp")),
    tabPanel("biplot", plotOutput("bipl")),
    tabPanel("oncopl", plotOutput("oncop")),
    tabPanel("mutSumms", 
         textOutput("NumOLmsg"),
         plotOutput("oncopOL"), 
         textOutput("NumILmsg"),
         plotOutput("oncopIL"))
    )
  )
 )
)

server = function(input, output) {
  output$picker = renderUI(
     {
     curset = genesets[[input$geneset]]
     selectInput("curg", "gene", curset, curset[1])
     }
    )
  getCurrentOutliers = reactive({
     curgs = genesets[[input$geneset]]
     okg = intersect(rownames(gbmu133), curgs)
     texp = t(gbmu133[okg,])
     list(olinds = mv.calout.detect(texp), texp=texp)
    })
  output$curparco = renderPlot({
     olstuff = getCurrentOutliers()
     colsToUse = rep(redNgray[2], nrow(gbmu133))
     lwds = rep(1, nrow(gbmu133))
     if (sum(!is.na(curi <- olstuff$olinds$inds))>0)  {
        colsToUse[curi] = redNgray[1]
        lwds[curi] = 3
        }
     par(las=2)
     parcoord(olstuff$texp, col=colsToUse, lwd=lwds)
     })
   output$beesOne = renderPlot({
     olstuff = getCurrentOutliers()
     texp = olstuff$texp
     exps = texp[, input$curg]
     uniout = calout.detect(exps, method="GESD")
     mm = mean(exps)
     sd = sd(exps)
     dnlow = mm-2*sd
     dnhigh = mm+2*sd
     col2use = rep("gray", length(exps))
     col2usem = rep("gray", length(exps))
     col2useDN = rep("gray", length(exps))
     dnl = which(exps < dnlow)
     dnh = which(exps > dnhigh)
     if (length(dnl)>0) col2useDN[dnl] = "red"
     if (length(dnh)>0) col2useDN[dnh] = "red"
     if (!is.na(uniout$ind[1])) col2use[uniout$ind] = "red"
     if (!is.na(olstuff$olinds$ind[1])) col2usem[olstuff$olinds$ind] = "red"
     par(mfrow=c(1,3))
     beeswarm(exps, pwcol=col2useDN, pch=19, 
       main=paste0("DN 2SD rule: ", input$curg))
     beeswarm(exps, pwcol=col2use, pch=19, 
       main=paste0("univ GESD: ", input$curg))
     beeswarm(exps, pwcol=col2usem, pch=19, main=
      paste0("multivariate GESD:", input$curg))
     })
   output$prcomp = renderPlot({
     olstuff = getCurrentOutliers()
     texp = olstuff$texp
     pp = prcomp(texp)
     redNgray = c("#8B000054", "#D3D3D354")
     col2usem = rep(redNgray[2], nrow(texp))
     if (!is.na(olstuff$olinds$ind[1])) col2usem[olstuff$olinds$ind] = redNgray[1]
     pairs(pp$x[,1:4], pch=19, col=col2usem, cex=.9)
     })
   output$bipl = renderPlot({
     olstuff = getCurrentOutliers()
     texp = olstuff$texp
     pp = prcomp(texp)
     labs = rep(".", nrow(texp))
     if (!is.na(olstuff$olinds$ind[1])) labs[olstuff$olinds$ind] = "x"
     biplot(pp, xlabs=labs, choices=c(input$bp1, input$bp2))
     })
   prepMAF = reactive({
     olstuff = getCurrentOutliers()
     texp = olstuff$texp
     pp = prcomp(texp)
     labs = rep(".", nrow(texp))
     shn = substr(rownames(texp), 1, 12)
     if (!is.na(olstuff$olinds$ind[1])) {
       gr1 = shn[olstuff$olinds$ind] 
       mut1 = subsetMaf(tcga_gbm, gr1, mafObj=TRUE)
       gr2 = shn[-olstuff$olinds$ind] 
       mut2 = subsetMaf(tcga_gbm, gr2, mafObj=TRUE)
       }
     list(mutOL=mut1, mutIL=mut2) # outlier/inlier
   })
   output$oncop = renderPlot({
       mafstuff = prepMAF()
       coOncoplot(mafstuff$mutOL, mafstuff$mutIL) #, genes=input$geneset)
     })
   output$NumOLmsg = renderText({
       mafstuff = prepMAF()
       numOL = length(unique(mafstuff$mutOL@data$Tumor_Sample_Barcode))
       sprintf("MAF summary for %d outlying individuals with mutation info.", numOL)
       })
   output$NumILmsg = renderText({
       mafstuff = prepMAF()
       numIL = length(unique(mafstuff$mutIL@data$Tumor_Sample_Barcode))
       sprintf("MAF summary for %d inlying individuals with mutation info.", numIL)
       })
   output$oncopOL = renderPlot({
     mafstuff = prepMAF()
     plotmafSummary(mafstuff$mutOL)
     })
   output$oncopIL = renderPlot({
     mafstuff = prepMAF()
     plotmafSummary(mafstuff$mutIL)
     })
}

print(shinyApp(ui, server))

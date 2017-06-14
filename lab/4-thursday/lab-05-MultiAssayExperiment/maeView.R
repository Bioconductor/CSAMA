maeView = function(mae) {
#
# this function initiates a shiny app for viewing relationships
# among assays for selected genes.  MAE input must have experiments
# called "RNASeq2GeneNorm", "gistict", "miRNASeqGene"
#
library(shiny) # remove when packaged
library(DT)
library(limma)
ui = fluidPage(
  sidebarLayout(
   sidebarPanel(
    fluidRow(
    helpText("Select a gene to visualize association between GISTIC CN and expression, and tests of all miRNA seq results for association with selected gene's expression.")
    ),
    fluidRow(
     selectInput("gene", "gene", sort(rownames(mae)[[1]]))
    ),
    fluidRow(
     numericInput("mirind", "for plotting: miRNA from top", 1, min=1, max=20, step=1)
    )
   ),
   mainPanel(
    tabsetPanel(
     tabPanel("Expr vs CN", plotOutput("evg")),
     tabPanel("miRNA vs Expr (tab)", dataTableOutput("evmir")),
     tabPanel("miRNA vs Expr (viz)", plotOutput("evmir2"))
    )
   )
  )
 )

server = function(input, output, session) {
  output$evg = renderPlot({
     validate(need(all(c("RNASeq2GeneNorm",
            "gistict") %in% names(experiments(mae))),
            "expecting MAE with RNASeq2GeneNorm, gistict"))
     curMAE = intersectColumns(mae[,,c("RNASeq2GeneNorm", "gistict")])
     curMAE = curMAE[ input$gene,, ]
     LL = longFormat(curMAE)
     print(unique(LL$assay))
     ex = LL[LL$assay == "RNASeq2GeneNorm",]$value
     gi = LL[LL$assay == "gistict",]$value
     boxplot(split(log(ex+1),gi), ylab=paste0("log ",
         input$gene, "+1"))
     })
  output$evmir = renderDataTable({
     curMAE = intersectColumns(mae[,,c("RNASeq2GeneNorm", "miRNASeqGene")])
     mirex = experiments(curMAE)$miRNASeqGene  # need to do before selecting on gene
     curMAE = curMAE[ input$gene,, ]
     LL = longFormat(curMAE)
     ex = LL[LL$assay == "RNASeq2GeneNorm",]$value
     mirmat = log(exprs(mirex)+1)
     f1 = lmFit(mirmat, model.matrix(~ex))
     ef1 = eBayes(f1)
     tt = topTable(ef1, n=50)
     for (i in 1:ncol(tt)) if (is.numeric(tt[[i]]))
      tt[[i]] = round(tt[[i]],4)
     datatable(tt)
     })
  output$evmir2 = renderPlot({
     curMAE = intersectColumns(mae[,,c("RNASeq2GeneNorm", "miRNASeqGene")])
     mirex = experiments(curMAE)$miRNASeqGene  # need to do before selecting on gene
     curMAE = curMAE[ input$gene,, ]
     LL = longFormat(curMAE)
     ex = LL[LL$assay == "RNASeq2GeneNorm",]$value
     mirmat = log(exprs(mirex)+1)
     f1 = lmFit(mirmat, model.matrix(~ex))
     ef1 = eBayes(f1)
     tt = topTable(ef1, n=50)
     rr = rownames(tt)[input$mirind]
     plot(log(mirmat[rr,]+1), log(ex+1), xlab=paste0("log ", rr, " +1"), ylab=paste0("log ", input$gene, " +1") )
     })
}
shinyApp(ui=ui, server=server)
}

## LinkedCharts for airways example

library( DESeq2 )
library( airway )
library( rlc )

data( airway )
a <- AnnotationDbi::intraIDMapper( rownames(airway), species="HOMSA", 
    srcIDType="ENSEMBL", destIDType = "SYMBOL" )  
rownames(airway)[ match( names(a), rownames(airway) ) ] <- unlist(a)

dds <- DESeqDataSet( airway, ~ cell + dex )
dds <- DESeq( dds )
res <- results( dds )

openPage( useViewer=FALSE, layout="table2x2" )

gene <- 1

lc_scatter(
  dat(
    x = res$baseMean,
    y = res$log2FoldChange,
    colour = ifelse( !is.na(res$padj) & res$padj < .1, "red", "black" ),
    label = rownames(res),
    on_click = function(k) { gene <<- k; updateCharts("A2") }
  ),
  size = 2,
  logScaleX = 10,
  domainY = c( -5, 5 ),
  place = "A1"
)

lc_scatter(
  dat(
    x = colData(dds)$cell,
    y = 1+counts( dds, normalized=TRUE )[ gene, ],
    colourValue = colData(dds)$dex
  ),
  logScaleY = 10,
  place = "A2"
)

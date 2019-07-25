filter_genes <- function(x, num_reads = 5, num_samples = 5) {
    keep <- which(rowSums(x >= num_reads) >= num_samples)
    x[keep,]
}

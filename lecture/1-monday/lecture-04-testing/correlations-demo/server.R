library("ggvis")

sim = function(inp, n = 20, m = 10000) {

  x = matrix(
    do.call(inp$dist, list(n = n * m)), 
    ncol = n, nrow = m)
  colnames(x) = letters[1 + (seq_len(n)-1) %/% (n/2)]

  for (j in 2:ncol(x))
    x[, j] = x[, j-1] * inp$eps + x[, j] * (1 - inp$eps)
  x
}

function(input, output, session) {
  rt = reactive({
    xc = sim(input)
    genefilter::rowttests(xc, factor(colnames(xc)))
  })

  ggvis(rt, ~ p.value) %>% 
    layer_histograms(width = 0.02, boundary = 0) %>%
    bind_shiny("plot", "plot_ui")
}
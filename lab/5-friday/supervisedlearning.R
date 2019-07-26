## ----overfitting, fig.width = 3, fig.height = 3, echo = FALSE------------
set.seed(0xbedada)

library("ggplot2")
library("dplyr")
ov = tibble(
  x = seq(0, 30, by = 1),
  y = 2 + 0.01 * x^2 + 0.1 * x + 2 * rnorm(length(x)))
ggplot(ov, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(span = 0.2, col = "dodgerblue3", se = FALSE) +
  geom_smooth(span = 0.8, col = "darkorange1", se = FALSE)

## ----diabetes------------------------------------------------------------
library("readr")
library("magrittr")

diabetes = read_csv("diabetes.csv", col_names = TRUE)
diabetes
diabetes$group %<>% factor

## ----ldagroups, fig.width = 3.5, fig.height = 7.5------------------------
library("ggplot2")
library("reshape2")
ggplot(melt(diabetes, id.vars = c("id", "group")),
       aes(x = value, col = group)) +
 geom_density() + facet_wrap( ~variable, ncol = 1, scales = "free") +
 theme(legend.position = "bottom")


## ----scatterdiabetes, fig.width = 3.5, fig.height = 3--------------------
ggdb = ggplot(mapping = aes(x = insulin, y = glutest)) +
  geom_point(aes(colour = group), data = diabetes)
ggdb


## ----ldaresults----------------------------------------------------------
library("MASS")
diabetes_lda = lda(group ~ insulin + glutest, data = diabetes)
diabetes_lda
ghat = predict(diabetes_lda)$class
table(ghat, diabetes$group)
mean(ghat != diabetes$group)


## ----make1Dgrid----------------------------------------------------------
make1Dgrid = function(x) {
  rg = grDevices::extendrange(x)
  seq(from = rg[1], to = rg[2], length.out = 100)
}


## ----diabetes_grid_1-----------------------------------------------------
diabetes_grid = with(diabetes,
  expand.grid(insulin = make1Dgrid(insulin),
              glutest = make1Dgrid(glutest)))


## ----diabetes_grid_2-----------------------------------------------------
diabetes_grid$ghat =
  predict(diabetes_lda, newdata = diabetes_grid)$class


## ----centers-------------------------------------------------------------
centers = diabetes_lda$means


## ----unitcircle----------------------------------------------------------
unitcircle = exp(1i * seq(0, 2*pi, length.out = 90)) %>%
          {cbind(Re(.), Im(.))}
ellipse = unitcircle %*% solve(diabetes_lda$scaling)


## ----ellipses------------------------------------------------------------
ellipses = lapply(seq_len(nrow(centers)), function(i) {
  (ellipse +
   matrix(centers[i, ], byrow = TRUE,
          ncol = ncol(centers), nrow = nrow(ellipse))) %>%
     cbind(group = i)
}) %>% do.call(rbind, .) %>% data.frame
ellipses$group %<>% factor


## ----modeldiabetes, fig.width = 5, fig.height = 4------------------------
ggdb + geom_raster(aes(fill = ghat),
            data = diabetes_grid, alpha = 0.25, interpolate = TRUE) +
    geom_point(data = as_tibble(centers), pch = "+", size = 8) +
    geom_path(aes(colour = group), data = ellipses) +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0))


## ----diabetes_lda_uniform_prior, fig.width = 5, fig.height = 4-----------
diabetes_up = lda(group ~ insulin + glutest, data = diabetes,
  prior = with(diabetes, rep(1/nlevels(group), nlevels(group))))

diabetes_grid$ghat_up =
  predict(diabetes_up, newdata = diabetes_grid)$class

stopifnot(all.equal(diabetes_up$means, diabetes_lda$means))

ellipse_up  = unitcircle %*% solve(diabetes_up$scaling)
ellipses_up = lapply(seq_len(nrow(centers)), function(i) {
  (ellipse_up +
   matrix(centers[i, ], byrow = TRUE,
          ncol = ncol(centers), nrow = nrow(ellipse_up))) %>%
     cbind(group = i)
}) %>% do.call(rbind, .) %>% data.frame
ellipses_up$group %<>% factor

ggdb + geom_raster(aes(fill = ghat_up),
            data = diabetes_grid, alpha = 0.4, interpolate = TRUE) +
    geom_point(data = data.frame(centers), pch = "+", size = 8) +
    geom_path(aes(colour = group), data = ellipses_up) +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0))


## ----all5diab------------------------------------------------------------
diabetes_lda5 = lda(group ~ relwt + glufast + glutest +
           steady + insulin, data = diabetes)
diabetes_lda5
ghat5 = predict(diabetes_lda5)$class
table(ghat5, diabetes$group)
mean(ghat5 != diabetes$group)


## ----loadHiiragi2--------------------------------------------------------
library("Hiiragi2013")
library("dplyr")
data("x")
probes = c("1426642_at", "1418765_at", "1418864_at", "1416564_at")
embryoCells = t(Biobase::exprs(x)[probes, ]) %>% as_tibble %>%
  mutate(Embryonic.day = x$Embryonic.day) %>%
  dplyr::filter(x$genotype == "WT")


## ----annoHiiragi, warning = FALSE----------------------------------------
annotation(x)
library("mouse4302.db")
anno = AnnotationDbi::select(mouse4302.db, keys = probes,
         columns = c("SYMBOL", "GENENAME"))
anno
mt = match(anno$PROBEID, colnames(embryoCells))
colnames(embryoCells)[mt] = anno$SYMBOL

## ----assertprobeid, echo = FALSE-----------------------------------------
stopifnot(!any(is.na(mt)))


## ----HiiragiFourGenesPairs, fig.width = 6, fig.height = 6----------------
library("GGally")
ggpairs(embryoCells, mapping = aes(col = Embryonic.day),
  columns = anno$SYMBOL, upper = list(continuous = "points"))


## ----ldacells, fig.width=8, fig.height=4---------------------------------
ec_lda = lda(Embryonic.day ~ Fn1 + Timd2 + Gata4 + Sox7,
             data = embryoCells)
round(ec_lda$scaling, 1)


## ----edcontour, fig.width = 4.5, fig.height = 3.5------------------------
ec_rot = predict(ec_lda)$x %>% as_tibble %>%
           mutate(ed = embryoCells$Embryonic.day)
ec_lda2 = lda(ec_rot[, 1:2], predict(ec_lda)$class)
ec_grid = with(ec_rot, expand.grid(
  LD1 = make1Dgrid(LD1),
  LD2 = make1Dgrid(LD2)))
ec_grid$edhat = predict(ec_lda2, newdata = ec_grid)$class
ggplot() +
  geom_point(aes(x = LD1, y = LD2, colour = ed), data = ec_rot) +
  geom_raster(aes(x = LD1, y = LD2, fill = edhat),
            data = ec_grid, alpha = 0.4, interpolate = TRUE) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  coord_fixed()


## ----qdamouse, fig.width = 9, fig.height = 9-----------------------------
library("gridExtra")

ec_qda = qda(Embryonic.day ~ Fn1 + Timd2 + Gata4 + Sox7,
             data = embryoCells)

variables = colnames(ec_qda$means)
pairs = combn(variables, 2)
lapply(seq_len(ncol(pairs)), function(i) {
  grid = with(embryoCells,
    expand.grid(x = make1Dgrid(get(pairs[1, i])),
                y = make1Dgrid(get(pairs[2, i])))) %>%
    `colnames<-`(pairs[, i])

  for (v in setdiff(variables, pairs[, i]))
    grid[[v]] = median(embryoCells[[v]])

  grid$edhat = predict(ec_qda, newdata = grid)$class

  ggplot() + geom_point(
      aes_string(x = pairs[1, i], y = pairs[2, i],
      colour = "Embryonic.day"), data = embryoCells) +
    geom_raster(
      aes_string(x = pairs[1, i], y = pairs[2, i], fill = "edhat"),
      data = grid, alpha = 0.4, interpolate = TRUE) +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    coord_fixed() +
    if (i != ncol(pairs)) theme(legend.position = "none")
}) %>% grid.arrange(grobs = ., ncol = 2)


## ----ladallvariables, warning = TRUE, error = TRUE, results = "hide"-----

# these will cause warning, error:
# lda(t(Biobase::exprs(x))[, 1:1000], x$Embryonic.day)
# qda(t(Biobase::exprs(x))[, 1:1000], x$Embryonic.day)

## ----learnbyheart, warning = FALSE, fig.width = 3, fig.height = 3--------
library("dplyr")
p = 2:21
n = 20

mcl = lapply(p, function(pp) {
  replicate(100, {
    xmat = matrix(rnorm(n * pp), nrow = n)
    resp = sample(c("apple", "orange"), n, replace = TRUE)
    fit  = lda(xmat, resp)
    pred = predict(fit)$class
    mean(pred != resp)
  }) %>% mean %>% tibble(mcl = ., p = pp)
}) %>% bind_rows

ggplot(mcl, aes(x = p, y = mcl)) + geom_line() + geom_point() +
  ylab("Misclassification rate")


## ----mclcv, warning = FALSE----------------------------------------------
estimate_mcl_loocv = function(x, resp) {
  vapply(seq_len(nrow(x)), function(i) {
    fit  = lda(x[-i, ], resp[-i])
    ptrn = predict(fit, newdata = x[-i,, drop = FALSE])$class
    ptst = predict(fit, newdata = x[ i,, drop = FALSE])$class
    c(train = mean(ptrn != resp[-i]), test = (ptst != resp[i]))
  }, FUN.VALUE = numeric(2)) %>% rowMeans %>% t %>% as_tibble
}

xmat = matrix(rnorm(n * last(p)), nrow = n)
resp = sample(c("apple", "orange"), n, replace = TRUE)

mcl = lapply(p, function(k) {
  estimate_mcl_loocv(xmat[, 1:k], resp)
}) %>% bind_rows %>% data.frame(p) %>% melt(id.var = "p")

ggplot(mcl, aes(x = p, y = value, col = variable)) + geom_line() +
  geom_point() + ylab("Misclassification rate")


## ----curseofdim, warning = FALSE, fig.width = 3.5, fig.height = 3--------
p   = 2:20
mcl = replicate(100, {
  xmat = matrix(rnorm(n * last(p)), nrow = n)
  resp = sample(c("apple", "orange"), n, replace = TRUE)
  xmat[, 1:6] = xmat[, 1:6] + as.integer(factor(resp))

  lapply(p, function(k) {
    estimate_mcl_loocv(xmat[, 1:k], resp)
  }) %>% bind_rows %>% cbind(p = p) %>% melt(id.var = "p")
}, simplify = FALSE) %>% bind_rows

mcl =  group_by(mcl, p, variable) %>%
   summarise(value = mean(value))

ggplot(mcl, aes(x = p, y = value, col = variable)) + geom_line() +
   geom_point() + ylab("Misclassification rate")


## ----cursedimans1, fig.width = 3.5, fig.height = 2.5---------------------
sideLength = function(p, pointDensity = 1e6, pointsNeeded = 10)
   (pointsNeeded / pointDensity) ^ (1 / p)
ggplot(tibble(p = 1:400, sideLength = sideLength(p)),
       aes(x = p, y = sideLength)) + geom_line(col = "red") +
  geom_hline(aes(yintercept = 1), linetype = 2)


## ----cursedimans2, fig.width = 3.5, fig.height = 2.5---------------------
tibble(
  p = 1:400,
  volOuterCube = 1 ^ p,
  volInnerCube = 0.98 ^ p,  # 0.98 = 1 - 2 * 0.01
  `V(shell)` = volOuterCube - volInnerCube) %>%
ggplot(aes(x = p, y =`V(shell)`)) + geom_line(col = "blue")


## ----cursedimans3, fig.width = 3.5, fig.height = 2.5---------------------
n = 1000
df = tibble(
  p = round(10 ^ seq(0, 4, by = 0.25)),
  cv = vapply(p, function(k) {
    x1 = matrix(runif(k * n), nrow = n)
    x2 = matrix(runif(k * n), nrow = n)
    d = sqrt(rowSums((x1 - x2)^2))
    sd(d) / mean(d)
  }, FUN.VALUE = numeric(1)))
ggplot(df, aes(x = log10(p), y = cv)) + geom_line(col = "orange") +
  geom_point()


## ----confusiontable, eval=FALSE------------------------------------------
## table(truth, response)


## ----colon1, results = "hide"--------------------------------------------
library("ExperimentHub")
eh = ExperimentHub()
zeller = eh[["EH361"]]


## ----colon1b-------------------------------------------------------------
table(zeller$disease)


## ----colon2--------------------------------------------------------------
zellerNC = zeller[, zeller$disease %in% c("n", "cancer")]


## ----ehzellertest, echo = FALSE------------------------------------------
stopifnot(is.numeric(Biobase::exprs(zellerNC)), !any(is.na(Biobase::exprs(zellerNC))))


## ----zellerpData---------------------------------------------------------
pData(zellerNC)[ sample(ncol(zellerNC), 3), ]


## ----zellerrownames------------------------------------------------------
formatfn = function(x)
   gsub("|", "| ", x, fixed = TRUE) %>% lapply(strwrap)

rownames(zellerNC)[1:4]
rownames(zellerNC)[nrow(zellerNC) + (-2:0)] %>% formatfn


## ----zellerHist, fig.width = 3, fig.height = 4---------------------------
ggplot(melt(Biobase::exprs(zellerNC)[c(510, 527), ]), aes(x = value)) +
    geom_histogram(bins = 25) +
    facet_wrap( ~ Var1, ncol = 1, scales = "free")


## ----glmnet--------------------------------------------------------------
library("glmnet")
glmfit = glmnet(x = t(Biobase::exprs(zellerNC)),
                y = factor(zellerNC$disease),
                family = "binomial")


## ----colonPred-----------------------------------------------------------
predTrsf = predict(glmfit, newx = t(Biobase::exprs(zellerNC)),
                   type = "class", s = 0.04)
table(predTrsf, zellerNC$disease)


## ----plotglmfit, fig.width = 3.6, fig.height = 3.2, echo = -1------------
par(mai = c(0.5, 0.5, 0.575, 0.05))
plot(glmfit, col = brewer.pal(8, "Dark2"), lwd = sqrt(3), ylab = "")


## ----colonCV, fig.width = 4, fig.height = 4------------------------------
cvglmfit = cv.glmnet(x = t(Biobase::exprs(zellerNC)),
                     y = factor(zellerNC$disease),
                     family = "binomial")
plot(cvglmfit)


## ----lambda.min----------------------------------------------------------
cvglmfit$lambda.min


## ----lambda.1se----------------------------------------------------------
cvglmfit$lambda.1se


## ----predictwithlambda1se------------------------------------------------
s0 = cvglmfit$lambda.1se
predict(glmfit, newx = t(Biobase::exprs(zellerNC)),type = "class", s = s0) %>%
    table(zellerNC$disease)


## ----zellercoef----------------------------------------------------------
coefs = coef(glmfit)[, which.min(abs(glmfit$lambda - s0))]
topthree = order(abs(coefs), decreasing = TRUE)[1:3]
as.vector(coefs[topthree])
formatfn(names(coefs)[topthree])


## ----colonCVTrsf, fig.width = 4, fig.height = 4--------------------------
cv.glmnet(x = t(asinh(Biobase::exprs(zellerNC))),
          y = factor(zellerNC$disease),
          family = "binomial") %>% plot


## ----mousecvglmfit, fig.width = 4, fig.height = 4------------------------
sx = x[, x$Embryonic.day == "E3.25"]
embryoCellsClassifier = cv.glmnet(t(Biobase::exprs(sx)), sx$genotype,
                family = "binomial", type.measure = "class")
plot(embryoCellsClassifier)


## ----checkclaimMouseCellsClassifier, echo = FALSE------------------------
stopifnot(sum((diff(embryoCellsClassifier$cvm) * diff(embryoCellsClassifier$lambda)) < 0) <= 2)


## ----mousecellsrowttst, fig.width = 4, fig.height = 2.5------------------
mouse_de = rowttests(sx, "genotype")
ggplot(mouse_de, aes(x = p.value)) +
  geom_histogram(boundary = 0, breaks = seq(0, 1, by = 0.01))


## ----mousecellsnn1-------------------------------------------------------
dists = as.matrix(dist(scale(t(Biobase::exprs(x)))))
diag(dists) = +Inf


## ----mousecellsnn2-------------------------------------------------------
nn = sapply(seq_len(ncol(dists)), function(i) which.min(dists[, i]))
table(x$sampleGroup, x$sampleGroup[nn]) %>% `colnames<-`(NULL)


## ----caret1, message = FALSE---------------------------------------------
library("caret")
caretMethods = names(getModelInfo())
head(caretMethods, 8)
length(caretMethods)


## ----caret2--------------------------------------------------------------
getModelInfo("nnet", regex = FALSE)[[1]]$parameter


## ----caret3, results = "hide", message  = FALSE--------------------------
trnCtrl = trainControl(
  method = "repeatedcv",
  repeats = 3,
  classProbs = TRUE)
tuneGrid = expand.grid(
  size = c(2, 4, 8),
  decay = c(0, 1e-2, 1e-1))
nnfit = train(
  Embryonic.day ~ Fn1 + Timd2 + Gata4 + Sox7,
  data = embryoCells,
  method = "nnet",
  tuneGrid  = tuneGrid,
  trControl = trnCtrl,
  metric = "Accuracy")


## ----nnfit, fig.width = 3.75, fig.height = 4.25--------------------------
nnfit
plot(nnfit)
predict(nnfit) %>% head(10)


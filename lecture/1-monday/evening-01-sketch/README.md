## An evening session sketch

This file will contain suggestions on the evening team-building tasks.  The idea is to form
small groups to tackle a very basic problem in data analysis.  Before describing the specific
problem to be solved, I illustrate an approach to a related problem.  We use base R exclusively.

## Programming a tool to predict the species of iris flowers

The iris data are easy to look at after starting R.

```
?iris
head(iris)
table(iris$Species)
```

### Visualizing feature distributions

The distributions of sepal lengths can be compared across species.

```
boxplot(Sepal.Length~Species, data=iris, main="One feature", ylab="Sepal length (cm)")
```
![boxplot](sepal.png)

### A rule for assigning flowers to species based on sepal length, programmed in R

The plot suggests the following rule for classifying flowers into species.
If sepal length is less than 5.5cm, species is 'setosa'.  If sepal length
is greater than or equal to 5.5cm but less than 6.25, species is 'versicolor'.
If sepal length is greater than or equal to 6.25, species is 'virginica'.

We can program this rule in various ways.  Here is one that works for a single flower:
```
myspecies = NA
if (Sepal.Length < 5.5) myspecies = "setosa"
if (Sepal.Length >= 5.5 & Sepal.Length < 6.25) myspecies = "versicolor"
if (Sepal.Length >= 6.25) myspecies = "virginica"
```
This is valid R.  As long as there is a value for `Sepal.Length` in my session,
this code will result in a prediction of the species for the flower possessing
a sepal of length `Sepal.Length`.

### The rule as an R function

The expressions above can be wrapped in a bit of syntax to help us
process lots of flower data.
```
mypred = function(Sepal.Length) {
 myspecies = NA
 if (Sepal.Length < 5.5) myspecies = "setosa"
 if (Sepal.Length >= 5.5 & Sepal.Length < 6.25) myspecies = "versicolor"
 if (Sepal.Length >= 6.25) myspecies = "virginica"
 myspecies
 }
mypred(Sepal.Length=6.6) # one flower
allpred = rep(NA, nrow(iris))  # prepare to classify all
for (i in 1:nrow(iris)) 
   allpred[i] = mypred(iris[i, "Sepal.Length"])
table(true=iris$Species, predicted=allpred)
```
This is all valid.  Another approach that is more concise is
```
pred2 = sapply(iris$Sepal.Length, mypred)
table(true=iris$Species, predicted=pred2)
```
Yet another, more compelling approach is
```
pred3f = function(sl) ifelse(sl<5.5, "setosa", ifelse(sl<6.25, 
    "versicolor", "virginica"))
table(true=iris$Species, predicted=pred3f(iris$Sepal.Length))
```
`pred3f` is distinctive because it is "vectorized".  `mypred`
will misbehave if handed a vector of several sepal lengths, but
`pred3f` is ready for such a task.

### Appraisal

We have had a look at the iris data and created some functions to classify 
flowers using a single feature.  Our approach was based on human
interpretation of a collection of boxplots.  But:

- The predictions are not very good.
- There are more features to use.  Consider `pairs(iris[,1:4], col=iris$Species)`
- There is no way to assess how our procedure will perform on new iris measurements.

## The evening task

- Break into small groups, 4-5 at most
- Try to have one person experienced with R in each group
- Take one of the following projects
    - Create a report on improving iris classification relative to that of mypred
    - Create a report on classifying sex and or species from the crabs dataset

We can discuss the details in the session.
 




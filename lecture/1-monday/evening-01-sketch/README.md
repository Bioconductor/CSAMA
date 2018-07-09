This file will contain suggestions on the evening team-building tasks.  The idea is to form
small groups to tackle a very basic problem in data analysis.  Before describing the specific
problem to be solved, I illustrate an approach to a related problem.  We use base R exclusively.

The iris data are easy to look at after starting R.

```
head(iris)
table(iris$Species)
```

The distributions of sepal lengths can be compared across species.

```
boxplot(Sepal.Length~Species, data=iris)
```

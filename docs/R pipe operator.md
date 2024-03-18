The `|>` is a pipe argument.

>In brief, the pipe operator provides the result of the left hand side (LHS) of the operator as the _**first**_ argument of the right hand side (RHS).

```r
split(x = iris[-5], f = iris$Species) |>
  lapply(min) |>
  do.call(what = rbind) 
#           [,1]
#setosa      0.1
#versicolor  1.0
#virginica   1.4

#Compared to:
do.call(rbind,lapply(split(iris[-5],iris$Species),min))
```

// https://stackoverflow.com/questions/67744604/what-does-pipe-greater-than-mean-in-r

>The easiest way to pronounce the pipe is “then”.


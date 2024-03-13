From the [Tidyverse](Tidyverse.md) package.

>The `mapping` argument of the `[ggplot()](https://ggplot2.tidyverse.org/reference/ggplot.html)` function defines how variables in your dataset are mapped to visual properties (**aesthetics**) of your plot. The `mapping` argument is always defined in the `[aes()](https://ggplot2.tidyverse.org/reference/aes.html)` function, and the `x` and `y` arguments of `[aes()](https://ggplot2.tidyverse.org/reference/aes.html)` specify which variables to map to the x and y axes.

[aes()](https://ggplot2.tidyverse.org/reference/aes.html)

We need:
- dataset
- how to map properties to axis
- how to represent observations

Aestetics are hierarchical, they are inherited from the global level to each added layer (geom)

>To do so, we need to define a **geom**: the geometrical object that a plot uses to represent data. These geometric objects are made available in ggplot2 with functions that start with `geom_`. People often describe plots by the type of geom that the plot uses. For example, bar charts use bar geoms (`[geom_bar()](https://ggplot2.tidyverse.org/reference/geom_bar.html)`), line charts use line geoms (`[geom_line()](https://ggplot2.tidyverse.org/reference/geom_path.html)`), boxplots use boxplot geoms (`[geom_boxplot()](https://ggplot2.tidyverse.org/reference/geom_boxplot.html)`), scatterplots use point geoms (`[geom_point()](https://ggplot2.tidyverse.org/reference/geom_point.html)`), and so on.


>A variable is **categorical** if it can only take one of a small set of values. To examine the distribution of a categorical variable, you can use a bar chart.

Ordering bar geom: fct_infreq

>A variable is **numerical** (or quantitative) if it can take on a wide range of numerical values, and it is sensible to add, subtract, or take averages with those values. Numerical variables can be continuous or discrete.
>One commonly used visualization for distributions of continuous variables is a histogram.

>An alternative visualization for distributions of numerical variables is a density plot. A density plot is a smoothed-out version of a histogram and a practical alternative, particularly for continuous data that comes from an underlying smooth distribution.


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

>To visualize the relationship between a numerical and a categorical variable we can use side-by-side box plots. A **boxplot** is a type of visual shorthand for measures of position (percentiles) that describe a distribution. It is also useful for identifying potential outliers. As shown in [Figure 1.1](https://r4ds.hadley.nz/data-visualize#fig-eda-boxplot), each boxplot consists of:

- A box that indicates the range of the middle half of the data, a distance known as the interquartile range (IQR), stretching from the 25th percentile of the distribution to the 75th percentile. In the middle of the box is a line that displays the median, i.e. 50th percentile, of the distribution. These three lines give you a sense of the spread of the distribution and whether or not the distribution is symmetric about the median or skewed to one side.
    
- Visual points that display observations that fall more than 1.5 times the IQR from either edge of the box. These outlying points are unusual so are plotted individually.
    
- A line (or whisker) that extends from each end of the box and goes to the farthest non-outlier point in the distribution.

![](_attachments/Pasted%20image%2020240314222357.png)

>Note the terminology we have used here:
- We _map_ variables to aesthetics if we want the visual attribute represented by that aesthetic to vary based on the values of that variable.
- Otherwise, we _set_ the value of an aesthetic.

>We can use stacked bar plots to visualize the relationship between two categorical variables.

>A scatterplot is probably the most commonly used plot for visualizing the relationship between two numerical variables. - geom_point, x, y

> **facets**, subplots that each display one subset of the data.


Using [readr](readr.md) package from [Tidyverse](Tidyverse.md)

The most important one: `read_csv`

```r
students <- read_csv("src/playground/R-for-data-science/students.csv", na = c("N/A", ""))  
students  
  
students_remote <- read_csv("https://pos.it/r4ds-students-csv")  
students_remote

read_csv(  
  "a,b,c  
  1,2,3  4,5,6")
```

First read, then transform.

Common case is wrong names of columns (like with spaces). We could clean them by some heuristics:
```r
students |> janitor::clean_names()
```

Change column type (with `factor`) - [R data types](R%20data%20types.md)
```r
students |>
  janitor::clean_names() |>
  mutate(meal_plan = factor(meal_plan))
```

## other functions

```r
read_csv() # uses ,
read_csv2() # uses ;
read_tsv() # uses TAB
read_delim() # custom delimeter - will guess if not provided
read_fwf() # fixed-width-files by width or position
read_table() # fwf with columns separated with white space
read_log() # Apache style logs
```

# problems

When something wrong with data set lets try:
```r
df <- read_csv(  
  simple_csv,  
  col_types = list(x = col_double())  
)
problems(df)
```

# Multiple files

Sometimes data is spread through few files into single data frame
```r
sales_files <- c(  
  "https://pos.it/r4ds-01-sales",  
  "https://pos.it/r4ds-02-sales",  
  "https://pos.it/r4ds-03-sales"  
)  
read_csv(sales_files, id = "file")
```

# Writing

Using the `write_csv` (or `write_tsv`) we can output data to files.

Using those we loose data formats and on read we start the process again.

To keep data formats: [RDS binary format](RDS%20binary%20format.md) with `write_rds` and `read_rds`

```r
write_rds(students, "output_students.rds")
```

A faster format is [parquet binary format](parquet%20binary%20format.md)
```r
install.packages("arrow", repos='http://cran.us.r-project.org')  
library(arrow)  
write_parquet(students, "output_students.parquet")
```

The file sizes differ:
![](_attachments/Pasted%20image%2020240319215410.png)



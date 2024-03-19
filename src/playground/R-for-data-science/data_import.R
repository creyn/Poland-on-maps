# install.packages("janitor", repos='http://cran.us.r-project.org')
library(tidyverse)

students <- read_csv("src/playground/R-for-data-science/students.csv", na = c("N/A", ""))
students

# students_remote <- read_csv("https://pos.it/r4ds-students-csv")
# students_remote

students |>
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

students |> janitor::clean_names()

students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )


read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

read_csv(
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  skip = 2
)
read_csv(
  "# A comment I want to skip
  x,y,z
  1,2,3",
  comment = "#"
)
read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE
)
read_csv(
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z")
)

read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")

simple_csv <- "
  x
  10
  .
  20
  30"

df <- read_csv(
  simple_csv,
  col_types = list(x = col_double())
)
problems(df)

sales_files <- c(
  "https://pos.it/r4ds-01-sales",
  "https://pos.it/r4ds-02-sales",
  "https://pos.it/r4ds-03-sales"
)
read_csv(sales_files, id = "file")

write_csv(students, "output_students.csv")

write_rds(students, "output_students.rds")

install.packages("arrow", repos='http://cran.us.r-project.org')
library(arrow)
write_parquet(students, "output_students.parquet")
# install.packages("devtools", repos='http://cran.us.r-project.org')
# install.packages("roxygen2", repos='http://cran.us.r-project.org')

library(here)
setwd(here::here())

options(usethis.allow_nested_projects = TRUE)
devtools::create("polandon2maps")

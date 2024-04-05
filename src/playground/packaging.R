# install.packages("devtools", repos='http://cran.us.r-project.org')
# install.packages("roxygen2", repos='http://cran.us.r-project.org')

library(here)
setwd(here::here())

# this somehow doesn't work, I've created package from PyCharm new R package project
# options(usethis.allow_nested_projects = TRUE)
# devtools::create("polandon2maps")

# now load my package
install.packages("src/packages/POMUtils_1.0.tar.gz")
# library(POMUtils)

POMUtils::hello('test')
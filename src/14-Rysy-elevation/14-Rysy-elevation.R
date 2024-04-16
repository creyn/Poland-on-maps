print(">>>>> Map Rysy mountain elevation ...")

install.packages("src/packages/POMUtils_1.0.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/14-Rysy-elevation/",
  data_folder = "data/",
  packages = c("sf", "giscoR", "here", "tidyverse")
)


box <- st_linestring("POLYGON((20.054124 49.202095, 20.118108 49.202095, 20.118108 49.159603, 20.054124 49.159603, 20.054124 49.202095))")

box
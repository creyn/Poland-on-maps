install.packages("leaflet", repos='http://cran.us.r-project.org')

library(sf)
library(tidyverse)
library(leaflet)

setwd(here::here())
kml_path <- "data/Garmin/activity_run_20240324.kml"
layers <- st_layers(kml_path)
layers

kml <- st_read(kml_path, layer = "Warszawa Bieganie")
kml

map <- leaflet(kml) |>
  addProviderTiles(providers$CartoDB.Positron) |>
  addPolylines()

map

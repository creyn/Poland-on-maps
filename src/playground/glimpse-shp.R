# take a look at an SHP file
# show SHP on map

library(here)
library(sf)
library(tidyverse)
library(leaflet)

setwd(here::here())

shp_file_path <- "data/gminy/gminy.shp"
shp <- st_read(shp_file_path)

glimpse(shp)

# view(shp)
# shp

ggplot() +
  geom_sf(data = shp)

# shp_longlat <- st_transform(shp, "+proj=longlat +datum=WGS84")
# map <- leaflet(shp_longlat) |>
#   addProviderTiles(providers$CartoDB.PositronNoLabels) |>
#   # addPolylines()
#   addPolygons()
# map
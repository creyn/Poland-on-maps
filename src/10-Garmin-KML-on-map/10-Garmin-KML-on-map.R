# install.packages("leaflet", repos='http://cran.us.r-project.org')

library(sf)
library(tidyverse)
library(leaflet)

setwd(here::here())

# kml_1 <- "data/Garmin/my_activities_kml/14517375977.kml"
# kml_2 <- "data/Garmin/my_activities_kml/14657867151.kml"

data_path <- "data/Garmin/my_activities_kml/"
all_kml_files <- list.files(
    path = data_path,
    pattern = ".kml",
    full.names = T
)
# all_kml_files

# map <- leaflet() |>
#   addProviderTiles(providers$CartoDB.Positron)

all_tracks <- all_kml_files |>
  lapply(function(x) st_read(x, layer = last(st_layers(x)$name)))
  # apply(function(x) addPolylines(map, data = x))

print('all tracks')
utrack <- unlist(all_tracks)

# for (track in all_tracks) {
#   addPolylines(map, data = track)
#   break
# }

map <- leaflet() |>
  addProviderTiles(providers$CartoDB.Positron) |>
  addPolylines(data = utrack)

map

# addpol
#

#
# for (kml_file in all_kml_files) {
#   layers <- st_layers(kml_file)
#   track <- st_read(kml_file, layer = last(layers$name))
#   addPolylines(map, data = track)
#   # map |> addPolylines(data = track)
# }
# # kml_path <- "data/Garmin/activity_run_20240324.kml"
# # layers_kml_1 <- st_layers(kml_1)
# # layers_kml_2 <- st_layers(kml_2)
#
# # single_layer_name <- layers[layers$features == 1]
# # single_layer_name <- last(layers)
# # single_layer_name$layer_name
#
# # track_1 <- st_read(kml_1, layer = last(layers_kml_1$name))
# # track_2 <- st_read(kml_2, layer = last(layers_kml_2$name))
# #
# # track <- st_join(track_2, track_1, join = st_nearest_feature, left = T)
#
# map

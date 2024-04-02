# # install.packages("leaflet", repos='http://cran.us.r-project.org')
#
library(sf)
library(tidyverse)
library(leaflet)

setwd(here::here())

# test mapping 3 KMLs
# kml_1 <- "data/Garmin/my_activities_kml/14638534217.kml"
# kml_2 <- "data/Garmin/my_activities_kml/14517375977.kml"
# kml_3 <- "data/Garmin/my_activities_kml/14555388589.kml"
# track_1 <- st_read(kml_1, layer = last(st_layers(kml_1)$name))
# track_2 <- st_read(kml_2, layer = last(st_layers(kml_2)$name))
# track_3 <- st_read(kml_3, layer = last(st_layers(kml_3)$name))
# tracks <- c(track_1$geometry, track_2$geometry, track_3$geometry)
#
# map <- leaflet() |>
#   addProviderTiles(providers$CartoDB.Positron) |>
#   addPolylines(data = tracks)
# map

# map some KMLs
# data_path <- "data/Garmin/my_activities_kml/"
# all_kml_files <- list.files(
#     path = data_path,
#     pattern = ".kml",
#     full.names = T
# )
#
# # to get the proper type of tracks vector
# first_kml <- all_kml_files[[1]]
# first_track <- st_read(first_kml, layer = last(st_layers(first_kml)$name))
# tracks <- first_track$geometry
#
# for (kml_file in all_kml_files) {
#   track <- st_read(kml_file, layer = last(st_layers(kml_file)$name))
#   tracks <- c(tracks, track$geometry)
# }
#
# map <- leaflet(tracks) |>
#   addProviderTiles(providers$CartoDB.PositronNoLabels) |>
#   addPolylines()
#
# map

# map all KMLs
data_path <- "data/Garmin/my_all_activities_kml"
all_kml_files <- list.files(
    path = data_path,
    full.names = T
)

# to get the proper type of tracks vector
first_kml <- all_kml_files[[1]]
first_track <- st_read(first_kml, layer = last(st_layers(first_kml)$name))
tracks <- first_track$geometry

for (kml_file in all_kml_files) {
  track <- st_read(kml_file, layer = last(st_layers(kml_file)$name))
  if(st_geometry_type(track$geometry[[1]]) == "LINESTRING") {
    tracks <- c(tracks, track$geometry)
  }
}

map <- leaflet(tracks) |>
  addProviderTiles(providers$CartoDB.PositronNoLabels) |>
  addPolylines()

map

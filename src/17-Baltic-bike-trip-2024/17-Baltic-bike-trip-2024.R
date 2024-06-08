print("Create map of 2024 Baltic bike trip")

install.packages("src/packages/POMUtils_1.1.tar.gz")
folders <- POMUtils::setup(
    script_folder = "src/17-Baltic-bike-trip-2024/",
    data_folder = "data/",
    packages = c("sf", "here", "tidyverse", "leaflet", "ggspatial", "prettymapr")
)

print(">>>>> processing......")

# map all KMLs
data_path <- "data/Garmin/Baltic_bike_trip_2024_kml"
all_kml_files <- list.files(
    path = data_path,
    full.names = T
)

# to get the proper type of tracks vector
first_kml <- all_kml_files[[1]]
layer_names <- st_layers(first_kml)$name
not_laps_or_track_name <- layer_names[grep(pattern = "[^Laps][^Track Points]", layer_names)]
first_track <- st_read(first_kml, layer = not_laps_or_track_name, drivers = "KML")
tracks <- first_track$geometry

for (kml_file in all_kml_files) {
  layer_names <- st_layers(kml_file)$name
  not_laps_or_track_name <- layer_names[grep(pattern = "[^Laps][^Track Points]", layer_names)]
  track <- st_read(kml_file, layer = not_laps_or_track_name, drivers = "KML")
  if(st_geometry_type(track$geometry[[1]]) == "LINESTRING") {
    tracks <- c(tracks, track$geometry)
  }
}

bbox_string <- "POLYGON((18.0348 54.8795, 20.059 54.8795, 20.059 54.0637, 18.0348 54.0637, 18.0348 54.8795))"
bbox <- st_sf(st_as_sfc(bbox_string, crs = 4326))

tracks_bbox <- st_crop(tracks, bbox)

line_sopot_string <- "LINESTRING (18.5763252 54.4481236, 18.5760248 54.4489468, 18.5761321 54.4496827, 18.5767543 54.4505931, 18.7982340 54.5968582, 18.8000751 54.5987633, 18.8000321 54.5996704, 18.7996566 54.5998692)"
line_sopot <- st_sf(st_as_sfc(line_sopot_string, crs = 4326))

line_krynica_string <- "LINESTRING (19.4470561 54.3778209, 19.4657821 54.3684308, 19.5219154 54.3245754)"
line_krynica <- st_sf(st_as_sfc(line_krynica_string, crs = 4326))

cities <- data.frame(
    name = c("0. Sopot\n🚂🏠🚢", "1. Hel\n🚢", "2. Puck\n🏠", "3. Sobieszewo\n🏠", "4. Krynica Morska\n🏠🚢", "5. Tolkmicko\n🚢", "6. Elbląd\n🏠", "7. Gdańsk\n🏠🚂"),
    x = c(18.6309271, 18.8519898, 18.4490161, 18.8409534, 19.3890710, 19.5005579, 19.4672986, 18.7060461),
    y = c(54.4434964, 54.6056486, 54.7326795, 54.3603498, 54.4004984, 54.3021032, 54.1491351, 54.3835822)) |>
    st_as_sf(coords = c("x", "y"), crs = 4326) 

info <- data.frame(
    name = c("Bałtyk 2024\n280 km\n🚲🚲"),
    x = c(19.1354370),
    y = c(54.6453548)) |>
    st_as_sf(coords = c("x", "y"), crs = 4326) 

ggplot() +
    annotation_map_tile("osm", zoom = 11, forcedownload = FALSE) +
    geom_sf(data = tracks_bbox, color = "red", linewidth = 1) +
    geom_sf(data = line_sopot, color = "blue", linewidth = 0.5, linetype = "dashed") +
    geom_sf(data = line_krynica, color = "blue", linewidth = 0.5, linetype = "dashed") +
    geom_sf_text(data = cities, aes(label = name), size = 3) +
    geom_sf_text(data = info, aes(label = name), size = 5) +
    theme_void() +
    labs(title = "Trasa rowerowa Bałtyk 2024", caption = "Sopot - Hel - Puck - Sobieszewo - Krynica Morska - Tolkmicko - Elbląd - Gdańsk")

ggsave(paste(folders$final_map_folder, "17-Baltic-bike-trip-2024.png", sep = "/"))

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/17-Baltic-bike-trip-2024/17-Baltic-bike-trip-2024.R

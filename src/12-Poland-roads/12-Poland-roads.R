print("Create map of Poland's roads")

install.packages("src/packages/POMUtils_1.1.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/12-Poland-roads/",
  data_folder = "data/",
  packages = c("sf", "giscoR", "here", "tidyverse")
)

country_sf <- giscoR::gisco_get_countries(
    country = "PL",
    resolution = "1"
)

print(">>>>> fetching roads.....")
dataset <- POMUtils::fetch_zip_with_dataset(
  env_folders = folders,
  dataset_url = "http://envirosolutions.pl/dane/drogiPL.zip" # 370 MB
)
roads <- st_read(dataset$final_filename_shapes) # 580 MB

print(">>>>> processing.....")
glimpse(roads)
print(unique(roads$fclass))

# primary_roads <- roads |>
#   filter(fclass == "primary")

filtered_roads <- roads |>
  # filter(fclass == "motorway" | fclass == "motorway_link" | fclass == "tertiary" | fclass == "secondary" | fclass == "primary" | fclass == "secondary_link" | fclass == "tertiary_link" | fclass == "primary_link")
  # filter(fclass == "motorway" | fclass == "motorway_link" | fclass == "secondary" | fclass == "primary" | fclass == "secondary_link" | fclass == "primary_link")
  filter(fclass == "motorway" | fclass == "motorway_link" | fclass == "primary" | fclass == "primary_link")
  # filter(fclass == "motorway" | fclass == "motorway_link")

st_crs(filtered_roads) <- st_crs(country_sf)

filtered_roads <- st_intersection(filtered_roads, country_sf)

# print(">>>>> Mapping ...")
ggplot() +
  geom_sf(data = country_sf) +
  geom_sf(data = filtered_roads, aes(color = fclass)) +
  theme_classic() +
  labs(
    title = "Polskie drogi",
    shape = NULL,
    color = "Typ",
    caption = "dane: giscoR, envirosolutions"
  )

ggsave(paste(folders$final_map_folder, "12-Poland-roads.png", sep = "/"))
print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/12-Poland-roads/12-Poland-roads.R

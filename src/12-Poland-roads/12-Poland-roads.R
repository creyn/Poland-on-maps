print("Create map of Poland's roads")

install.packages("src/packages/POMUtils_1.0.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/12-Poland-roads/",
  data_folder = "data/",
  packages = c("sf", "giscoR", "here", "tidyverse")
)
dataset <- POMUtils::fetch_zip_with_shp(
  env_folders = folders,
  dataset_url = "http://envirosolutions.pl/dane/drogiPL.zip"
)

roads <- st_read(dataset$final_filename_shapes)
# print(unique(roads$fclass))
# glimpse(roads)
primary_roads <- roads |>
  filter(fclass == "primary")

print(">>>>> Mapping ...")
ggplot() +
  geom_sf(data = roads)

ggsave(paste(folders$final_map_folder, "12-Poland-roads.png", sep = "/"))
print(">>>>> Done.")

# map <- leaflet(shp) |>
#   addProviderTiles(providers$CartoDB.PositronNoLabels) |>
#   addPolylines()
# map
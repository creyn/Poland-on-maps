print("Create map of Poland regions")

install.packages("src/packages/POMUtils_1.0.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/03-Poland-regions/",
  data_folder = "data/",
  packages = c("sf", "here", "tidyverse")
)

dataset_regions <- POMUtils::fetch_zip_with_shp(
  env_folders = folders,
  dataset_url = "https://www.gis-support.pl/downloads/2022/wojewodztwa.zip"
)

provinces <- sf::st_read(dataset_regions)

print(">>>>> Draw map...")
ggplot(provinces['gml_id']) +
    geom_sf() +
    theme_void()
ggsave(paste(folders$final_map_folder, "03-Poland-regions.png", sep = "/"))

# to plot all attributes in that file
# png(paste(output_maps_folder, "03-Poland-regions-all.png", sep = "/"))
# plot(provinces, max.plot = 36)
# dev.off()

# to plot one attribute (borders)
# png(paste(output_maps_folder, "03-Poland-regions.png", sep = "/"))
# plot(provinces['gml_id'], col = "green", main = "Poland regions")
# dev.off()

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# then
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/03-Poland-regions/03-Poland-regions.R

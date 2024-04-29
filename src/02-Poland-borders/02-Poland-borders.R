print("Create map of Poland borders")

install.packages("src/packages/POMUtils_1.0.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/02-Poland-borders/",
  data_folder = "data/",
  packages = c("sf", "giscoR", "here", "tidyverse")
)

print(">>>>> Get PL from GISCO...")
country_sf <- giscoR::gisco_get_countries(
    country = "PL",
    resolution = "1"
)

print(">>>>> Draw map...")
ggplot(country_sf) +
    geom_sf() +
    theme_void()
ggsave(paste(folders$final_map_folder, "02-Poland-borders.png", sep = "/"))

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# then
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/02-Poland-borders/02-Poland-borders.R

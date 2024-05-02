print("Create map of Poland rivers")

install.packages("src/packages/POMUtils_1.1.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/04-Poland-rivers/",
  data_folder = "data/",
  packages = c("sf", "here", "tidyverse")
)

print(">>>>> downloading rivers.....")
dataset <- POMUtils::fetch_zip_with_dataset(
  env_folders = folders,
  dataset_url = "http://envirosolutions.pl/dane/rzekiPL.zip"
)
rivers <- sf::st_read(dataset)

print(">>>>> plotting rivers.....")
rivers_ordered <- rivers[order(rivers$DLUG, decreasing=TRUE),]
longest_river <- head(rivers_ordered, 1)
# vistula_river <- rivers[rivers$DLUG %in% c("1019.758"), ]
# longest_river_4326 <- sf::st_transform(longest_river, 4326)

country_sf <- giscoR::gisco_get_countries(
	country = "PL",
	resolution = "1"
)

ggplot() +
	geom_sf(data = country_sf) +
	geom_sf(data = longest_river, color = "blue", linewidth = 1) +
	theme_void() +
	labs(title = "Poland with the Vistula river")

ggsave(paste(folders$final_map_folder, "04-Poland-rivers.png", sep = "/"))
print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/04-Poland-rivers/04-Poland-rivers.R

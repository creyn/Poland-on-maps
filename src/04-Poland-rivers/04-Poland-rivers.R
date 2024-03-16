print("Create map of Poland rivers")

print(">>>>> Setup env...")
packages <- c("sf", "here", "tidyverse")
installed_packages <- packages %in% rownames(
    installed.packages()
)
if (any(installed_packages == F)) {
    install.packages(
        packages[!installed_packages], repos='http://cran.us.r-project.org'
    )
}
setwd(here::here())

print(">>>>> Setup folders...")
script_folder <- "src/04-Poland-rivers/"
data_folder <- paste(script_folder, "script-big-data", sep = "/")
env_data_folder <- Sys.getenv("POM_DATA_FOLDER")
if(env_data_folder != "") {
	data_folder <- env_data_folder
}
dir.create(data_folder)
print(paste(">>>>> Data folder setup to: ", data_folder))

output_maps_folder <- script_folder
env_maps_folder <- Sys.getenv("POM_OUTPUT_MAPS_FOLDER")
if(env_maps_folder != "") {
	output_maps_folder <- env_maps_folder
}
dir.create(output_maps_folder)
print(paste(">>>>> Output maps folder setup to: ", output_maps_folder))

print(">>>>> downloading rivers.....")
dataset_url <- "http://envirosolutions.pl/dane/rzekiPL.zip"
dataset_path <- paste(data_folder, basename(dataset_url), sep = "/")
dataset_folder <- sub(".zip", "", paste(data_folder, basename(dataset_url), sep = "/"))

if (! file.exists(dataset_path)) {
	download.file(
		url = dataset_url,
		destfile = dataset_path,
		mode = "wb"
	)

	unzip(
		paste(data_folder, basename(dataset_url), sep = "/"),
		exdir = dataset_folder
	)
}

filename <- list.files(
    path = dataset_folder,
    pattern = ".shp",
    full.names = T
)

print(">>>>> plotting rivers.....")
rivers <- sf::st_read(filename)
rivers_ordered <- rivers[order(rivers$DLUG, decreasing=TRUE),]
longest_river <- head(rivers_ordered, 1)
# vistula_river <- rivers[rivers$DLUG %in% c("1019.758"), ]
# longest_river_4326 <- sf::st_transform(longest_river, 4326)

library(tidyverse)

# display test
# plot(longest_river['DLUG'], main = "The Vistula river")
# ggplot() +
# 	geom_sf(data = longest_river)
# ggplot() +
# 	geom_sf(data = rivers)


country_sf <- giscoR::gisco_get_countries(
	country = "PL",
	resolution = "1"
)

ggplot() +
	geom_sf(data = country_sf) +
	geom_sf(data = longest_river, color = "blue", linewidth = 1) +
	theme_void() +
	labs(title = "Poland with the Vistula river")

ggsave(paste(output_maps_folder, "04-Poland-rivers.png", sep = "/"))

short_rivers <- rivers[rivers$DLUG > 1 & rivers$DLUG < 5, ]
ggplot() +
	geom_sf(data = short_rivers)

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/04-Poland-rivers/04-Poland-rivers.R
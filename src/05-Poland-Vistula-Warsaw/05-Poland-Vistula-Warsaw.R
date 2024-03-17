print("Create map of Poland with Vistula and Warsaw")

print(">>>>> Setup env...")
packages <- c("sf", "here", "tidyverse", "giscoR")
installed_packages <- packages %in% rownames(
    installed.packages()
)
if (any(installed_packages == F)) {
    install.packages(
        packages[!installed_packages], repos='http://cran.us.r-project.org'
    )
}
invisible(lapply(
    packages, library,
    character.only = T
))
setwd(here::here())

print(">>>>> Setup folders...")
script_folder <- "src/05-Poland-Vistula-Warsaw/"
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
dataset_url_rivers <- "http://envirosolutions.pl/dane/rzekiPL.zip"
dataset_path_rivers <- paste(data_folder, basename(dataset_url_rivers), sep = "/")
dataset_folder_rivers <- sub(".zip", "", paste(data_folder, basename(dataset_url_rivers), sep = "/"))

if (! file.exists(dataset_path_rivers)) {
	download.file(
		url = dataset_url_rivers,
		destfile = dataset_path_rivers,
		mode = "wb"
	)

	unzip(
		paste(data_folder, basename(dataset_url_rivers), sep = "/"),
		exdir = dataset_folder_rivers
	)
}

filename_rivers <- list.files(
    path = dataset_folder_rivers,
    pattern = ".shp",
    full.names = T
)

print(">>>>> downloading regions.....")
dataset_url_regions <- "https://www.gis-support.pl/downloads/2022/gminy.zip"
dataset_path_regions <- paste(data_folder, basename(dataset_url_regions), sep = "/")
dataset_folder_regions <- sub(".zip", "", paste(data_folder, basename(dataset_url_regions), sep = "/"))

if (! file.exists(dataset_path_regions)) {
	download.file(
		url = dataset_url_regions,
		destfile = dataset_path_regions,
		mode = "wb"
	)

	unzip(
		paste(data_folder, basename(dataset_url_regions), sep = "/"),
		exdir = dataset_folder_regions
	)
}

filename_regions <- list.files(
    path = dataset_folder_regions,
    pattern = ".shp",
    full.names = T
)

print(">>>>> plotting map.....")

rivers <- st_read(filename_rivers, options = "ENCODING=UTF8")
rivers_ordered <- rivers[order(rivers$DLUG, decreasing=TRUE),]
vistula <- head(rivers_ordered, 1)

poland <- gisco_get_countries(
	country = "PL",
	resolution = "1"
)

# Warsaw - latitude = 52.237049, longitude = 21.017532
points <- data.frame(lon = c(21.017532), lat = c(52.237049))
points$NAME <- c("Warsaw")
cities <- st_as_sf(x = points, coords = c("lon", "lat"), crs = 4326)

ggplot() +
	geom_sf(data = poland) +
	geom_sf(data = cities, aes(color = NAME), size = 5) +
	geom_sf(data = vistula, color = "blue", linewidth = 1) +
	theme_bw() +
	labs(title = "Poland with Vistula and Warsaw", x = "Longitude", y = "Latitude", color = "Poland")

ggsave(paste(output_maps_folder, "05-Poland-Vistula-Warsaw.png", sep = "/"))

regions <- st_read(filename_regions, options = "ENCODING=UTF8")
warsaw_region <- regions[regions$JPT_NAZWA_ == "Warszawa",]
warsaw_region$NAME <- "Warsaw"
warsaw_region <- st_transform(warsaw_region, st_crs(vistula))

ggplot() +
	geom_sf(data = poland) +
	geom_sf(data = warsaw_region, aes(fill = NAME)) +
	geom_sf(data = vistula,color = "blue", linewidth = .5) +
	theme_bw() +
	labs(title = "Poland with Vistula and Warsaw", x = "Longitude", y = "Latitude", fill = "Poland")

ggsave(paste(output_maps_folder, "05-Poland-Vistula-Warsaw-region.png", sep = "/"))

warsaw_box <- st_bbox(warsaw_region)
vistula_boxed <- st_crop(vistula, warsaw_box)

ggplot() +
	geom_sf(data = warsaw_region, aes(fill = NAME)) +
	geom_sf(data = vistula_boxed, color = "blue", linewidth = 1) +
	theme_bw() +
	labs(title = "Vistula and Warsaw", x = "Longitude", y = "Latitude", fill = "Poland")

ggsave(paste(output_maps_folder, "05-Vistula-Warsaw-region.png", sep = "/"))

krakow_region <- regions[startsWith(regions$JPT_NAZWA_, "Krak"),]
krakow_region$NAME <- "Krakow"
krakow_region <- st_transform(krakow_region, st_crs(vistula))
krakow_box <- st_bbox(krakow_region)
vistula_boxed <- st_crop(vistula, krakow_box)

ggplot() +
	geom_sf(data = krakow_region, aes(fill = NAME)) +
	geom_sf(data = vistula_boxed, color = "blue", linewidth = 1) +
	theme_bw() +
	labs(title = "Krakow and Warsaw", x = "Longitude", y = "Latitude", fill = "Poland")

ggsave(paste(output_maps_folder, "05-Vistula-Krakow-region.png", sep = "/"))

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/05-Poland-Vistula-Warsaw/05-Poland-Vistula-Warsaw.R

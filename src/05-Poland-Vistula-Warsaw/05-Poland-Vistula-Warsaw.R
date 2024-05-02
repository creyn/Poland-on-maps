print("Create map of Poland with Vistula and Warsaw")

install.packages("src/packages/POMUtils_1.1.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/05-Poland-Vistula-Warsaw/",
  data_folder = "data/",
  packages = c("sf", "here", "tidyverse", "giscoR")
)

print(">>>>> downloading rivers.....")
dataset_rivers <- POMUtils::fetch_zip_with_dataset(
  env_folders = folders,
  dataset_url = "http://envirosolutions.pl/dane/rzekiPL.zip"
)
rivers <- st_read(dataset_rivers, options = "ENCODING=UTF8")

print(">>>>> downloading regions.....")
dataset_regions <- POMUtils::fetch_zip_with_dataset(
  env_folders = folders,
  dataset_url = "https://www.gis-support.pl/downloads/2022/gminy.zip"
)
regions <- st_read(dataset_regions, options = "ENCODING=UTF8")

print(">>>>> plotting map.....")

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

ggsave(paste(folders$final_map_folder, "05-Poland-Vistula-Warsaw.png", sep = "/"))

warsaw_region <- regions[regions$JPT_NAZWA_ == "Warszawa",]
warsaw_region$NAME <- "Warsaw"
warsaw_region <- st_transform(warsaw_region, st_crs(vistula))

ggplot() +
	geom_sf(data = poland) +
	geom_sf(data = warsaw_region, aes(fill = NAME)) +
	geom_sf(data = vistula,color = "blue", linewidth = .5) +
	theme_bw() +
	labs(title = "Poland with Vistula and Warsaw", x = "Longitude", y = "Latitude", fill = "Poland")

ggsave(paste(folders$final_map_folder, "05-Poland-Vistula-Warsaw-region.png", sep = "/"))

warsaw_box <- st_bbox(warsaw_region)
vistula_boxed <- st_crop(vistula, warsaw_box)

ggplot() +
	geom_sf(data = warsaw_region, aes(fill = NAME)) +
	geom_sf(data = vistula_boxed, color = "blue", linewidth = 1) +
	theme_bw() +
	labs(title = "Vistula and Warsaw", x = "Longitude", y = "Latitude", fill = "Poland")

ggsave(paste(folders$final_map_folder, "05-Vistula-Warsaw-region.png", sep = "/"))

krakow_region <- regions[startsWith(regions$JPT_NAZWA_, "Krak"),]
krakow_region$NAME <- "Krakow"
krakow_region <- st_transform(krakow_region, st_crs(vistula))
krakow_box <- st_bbox(krakow_region)
vistula_boxed <- st_crop(vistula, krakow_box)

ggplot() +
	geom_sf(data = krakow_region, aes(fill = NAME)) +
	geom_sf(data = vistula_boxed, color = "blue", linewidth = 1) +
	theme_bw() +
	labs(title = "Vistula and Krakow", x = "Longitude", y = "Latitude", fill = "Poland")

ggsave(paste(folders$final_map_folder, "05-Vistula-Krakow-region.png", sep = "/"))

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/05-Poland-Vistula-Warsaw/05-Poland-Vistula-Warsaw.R

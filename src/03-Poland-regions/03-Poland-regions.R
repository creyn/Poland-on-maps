print("Create map of Poland regions")

print(">>>>> Setup env...")
packages <- c("sf", "here")
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
script_folder <- "src/03-Poland-regions/"
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

print(">>>>> downloading provinces.....")
dataset_url <- "https://www.gis-support.pl/downloads/2022/wojewodztwa.zip"
dataset_path <- paste(data_folder, basename(dataset_url), sep = "/")

if (! file.exists(dataset_path)) {
	download.file(
		url = dataset_url,
		destfile = dataset_path,
		mode = "wb"
	)

	unzip(
		paste(data_folder, basename(dataset_url), sep = "/"),
		exdir = data_folder
	)
}

filename <- list.files(
    path = data_folder,
    pattern = ".shp",
    full.names = T
)

print(">>>>> plotting provinces.....")
provinces <- sf::st_read(filename)
# print(provinces)

# to plot all attributes in that file
# png(paste(output_maps_folder, "03-Poland-regions-all.png", sep = "/"))
# plot(provinces, max.plot = 36)
# dev.off()

# to plot one attribute (borders)
png(paste(output_maps_folder, "03-Poland-regions.png", sep = "/"))
plot(provinces['gml_id'], col = "green", main = "Poland regions")
dev.off()

print(">>>>> Done.")
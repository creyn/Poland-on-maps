install.packages("here", repos='http://cran.us.r-project.org')

print(">>>>> preparing env.....")
setwd(here::here())
script_folder <- "src/03-Poland-regions/"
data_folder <- paste(script_folder, "script-big-data", sep = "/")
dir.create(data_folder)

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
# png(paste(script_folder, "03-Poland-regions-all.png", sep = "/"))
# plot(provinces, max.plot = 36)
# dev.off()

# to plot one attribute (borders)
png(paste(script_folder, "03-Poland-regions.png", sep = "/"))
plot(provinces['gml_id'], col = "red", main = "Poland regions")
dev.off()

print(">>>>> done.")
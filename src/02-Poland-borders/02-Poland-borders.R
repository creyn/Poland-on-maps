print("Create map of Poland borders")

print(">>>>> Setup env...")
packages <- c("sf", "giscoR", "here")
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
script_folder <- "src/02-Poland-borders/"
output_maps_folder <- script_folder
env_maps_folder <- Sys.getenv("POM_OUTPUT_MAPS_FOLDER")
if(env_maps_folder != "") {
	output_maps_folder <- env_maps_folder
}
dir.create(output_maps_folder)
print(paste(">>>>> Output maps folder setup to: ", output_maps_folder))

print(">>>>> Get PL from GISCO...")
country_sf <- giscoR::gisco_get_countries(
    country = "PL",
    resolution = "1"
)

print(">>>>> Draw map...")
png(paste(output_maps_folder, "02-Poland-borders.png", sep = "/"))
plot(sf::st_geometry(country_sf), col = "green", main = "Poland")
invisible(dev.off())

print(">>>>> Done.")

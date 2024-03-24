print("Create map of Poland presidential election 2020 results per province")

# configure script
script_folder <- "src/07-Poland-elections-result-per-provinces/"

# common
print(">>>>> Setup env...")
packages <- c("sf", "here", "tidyverse", "janitor")
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

# mapping

print(">>>>> downloading provinces.....")
dataset_url_shapes_provinces <- "https://www.gis-support.pl/downloads/2022/gminy.zip"
dataset_path_shapes_provinces <- paste(data_folder, basename(dataset_url_shapes_provinces), sep = "/")
dataset_folder_shapes_provinces <- sub(".zip", "", dataset_path_shapes_provinces)

if (! file.exists(dataset_path_shapes_provinces)) {
	download.file(
		url = dataset_url_shapes_provinces,
		destfile = dataset_path_shapes_provinces,
		mode = "wb"
	)

	unzip(
      dataset_path_shapes_provinces,
      exdir = dataset_folder_shapes_provinces
	)
}

filename_shapes_provinces <- list.files(
    path = dataset_folder_shapes_provinces,
    pattern = ".shp",
    full.names = T
)

provinces <- st_read(filename_shapes_provinces)
# ggplot() +
#   geom_sf(data = provinces)
# view(provinces)
provinces_with_teryt <- provinces |>
	mutate(
		kod_teryt = substring(JPT_KOD_JE, 1, 6)
	)

print(">>>>> downloading election results per provinces.....")
dataset_url_results_provinces <- "https://prezydent20200628.pkw.gov.pl/prezydent20200628/data/2/csv/wyniki_gl_na_kand_po_gminach_csv.zip"
dataset_path_results_provinces <- paste(data_folder, basename(dataset_url_results_provinces), sep = "/")
dataset_folder_results_provinces <- sub(".zip", "", dataset_path_results_provinces)

if (! file.exists(dataset_path_results_provinces)) {
	download.file(
		url = dataset_url_results_provinces,
		destfile = dataset_path_results_provinces,
		mode = "wb"
	)

	unzip(
		dataset_path_results_provinces,
		exdir = dataset_folder_results_provinces
	)
}

print(">>>>> processing results.....")
filename_results_provinces <- list.files(
    path = dataset_folder_results_provinces,
    pattern = ".csv",
    full.names = T
)

results_csv <- read_csv2(filename_results_provinces)
# View(results_csv)

results <- results_csv |> janitor::clean_names()
# view(results)

results_with_winner <- results |>
	mutate(
		winner = ifelse(andrzej_sebastian_duda > rafal_kazimierz_trzaskowski, "Andrzej Sebastian Duda", "Rafal Kazimierz Trzaskowski")
	)

merged <- merge(provinces_with_teryt, results_with_winner, "kod_teryt")
# view(merged)

ggplot() +
	geom_sf(data = merged, aes(fill = winner)) +
	theme_bw() +
	scale_fill_manual(
		values = c(
			"Andrzej Sebastian Duda" = "#0073e6",
			"Rafal Kazimierz Trzaskowski" = "#e6308a"
		),
		labels = c(
			"Andrzej Sebastian Duda",
			"Rafal Kazimierz Trzaskowski"
		)
	) +
	labs(caption = "Poland's 2020 presidential elections results per province")

ggsave(paste(output_maps_folder, "07-Poland-elections-result-per-provinces.png", sep = "/"))

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/07-Poland-elections-result-per-provinces/07-Poland-elections-result-per-provinces.R

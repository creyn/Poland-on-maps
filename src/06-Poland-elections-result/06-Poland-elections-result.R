print("Create map of Poland election results")

# configure script
script_folder <- "src/06-Poland-elections-result/"

# common
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
dataset_url_shapes_voivodeships <- "https://www.gis-support.pl/downloads/2022/wojewodztwa.zip"
dataset_path_shapes_voivodeships <- paste(data_folder, basename(dataset_url_shapes_voivodeships), sep = "/")
dataset_folder_shapes_voivodeships <- sub(".zip", "", dataset_path_shapes_voivodeships)

if (! file.exists(dataset_path_shapes_voivodeships)) {
	download.file(
		url = dataset_url_shapes_voivodeships,
		destfile = dataset_path_shapes_voivodeships,
		mode = "wb"
	)

	unzip(
		dataset_path_shapes_voivodeships,
		exdir = dataset_folder_shapes_voivodeships
	)
}

filename_shapes_voivodeship <- list.files(
    path = dataset_folder_shapes_voivodeships,
    pattern = ".shp",
    full.names = T
)

print(">>>>> downloading election results per voivodeship.....")
dataset_url_results_voivodeships <- "https://prezydent20200628.pkw.gov.pl/prezydent20200628/data/2/csv/wyniki_gl_na_kand_po_wojewodztwach_csv.zip"
dataset_path_results_voivodeships <- paste(data_folder, basename(dataset_url_results_voivodeships), sep = "/")
dataset_folder_results_voivodeships <- sub(".zip", "", dataset_path_results_voivodeships)

if (! file.exists(dataset_path_results_voivodeships)) {
	download.file(
		url = dataset_url_results_voivodeships,
		destfile = dataset_path_results_voivodeships,
		mode = "wb"
	)

	unzip(
		dataset_path_results_voivodeships,
		exdir = dataset_folder_results_voivodeships
	)
}

print(">>>>> processing results.....")
filename_results_voivodeship <- list.files(
    path = dataset_folder_results_voivodeships,
    pattern = ".csv",
    full.names = T
)

results_csv <- read_csv2(filename_results_voivodeship)

results <- results_csv |> janitor::clean_names() |>
	mutate(
		wojewodztwo = factor(wojewodztwo),
	) |>
	pivot_longer(
		cols = c(andrzej_sebastian_duda, rafal_kazimierz_trzaskowski),
		names_to = "candidate",
		values_to = "votes"
	) |>
	select("kod_teryt", "wojewodztwo", "candidate", "votes") |>
	group_by(candidate) |>
	summarise(
		votes = sum(votes)
	) |>
	mutate(
		percent = round(100 * votes / sum(votes), 2)
	)

ggplot(
	data = results,
	mapping = aes(x = 1, y = percent, fill = candidate)
) +
	geom_col(color = "black") + # make pie chart
	coord_polar(theta = "y") + # make pie chart
	geom_text(
		aes(label = paste(percent, "%")),
		position = position_stack(vjust = 0.5)
	) +
	theme_void(base_size = 15) +
	scale_fill_manual(
		values = c(
			"andrzej_sebastian_duda" = "#0073e6",
			"rafal_kazimierz_trzaskowski" = "#e6308a"
		),
		labels = c(
			"Andrzej Sebastian Duda",
			"Rafal Kazimierz Trzaskowski"
		)
	) +
	labs(caption = "Poland's presidential elections 2020 results")

results_voivodeships_with_winner <- results_csv |> janitor::clean_names() |>
	mutate(
		winner = ifelse(andrzej_sebastian_duda > rafal_kazimierz_trzaskowski, "Andrzej Sebastian Duda", "Rafal Kazimierz Trzaskowski")
	)

voivodeships <- st_read(filename_shapes_voivodeship, options = "ENCODING=UTF8")

voivodeships_with_teryt <- voivodeships |>
	mutate(
		kod_teryt = paste(JPT_KOD_JE, "0000", sep = "")
	)

merged <- merge(voivodeships_with_teryt, results_voivodeships_with_winner, "kod_teryt")
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
	labs(caption = "Poland's 2020 presidential elections results per voivodeship")

ggsave(paste(output_maps_folder, "06-Poland-elections-result-per-voivodeship.png", sep = "/"))

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/06-Poland-elections-result/06-Poland-elections-result.R

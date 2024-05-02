print("Create map of Poland presidential election 2020 results per province")

# run from 'Poland-on-maps' folder: Poland-on-maps> Rscript.exe .\src\07-Poland-elections-result-per-provinces\07-Poland-elections-result-per-provinces.R
install.packages("src/packages/POMUtils_1.1.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/07-Poland-elections-result-per-provinces/",
  data_folder = "data/",
  packages = c("sf", "here", "tidyverse", "janitor")
)

print(">>>>> downloading provinces.....")
dataset_provinces <- POMUtils::fetch_zip_with_dataset(
  env_folders = folders,
  dataset_url = "https://www.gis-support.pl/downloads/2022/gminy.zip"
)
provinces <- st_read(dataset_provinces, options = "ENCODING=UTF8")

print(">>>>> downloading election results per provinces.....")
dataset_voivodeships_results <- POMUtils::fetch_zip_with_dataset(
  env_folders = folders,
  dataset_url = "https://prezydent20200628.pkw.gov.pl/prezydent20200628/data/2/csv/wyniki_gl_na_kand_po_gminach_csv.zip",
  dataset_extension = ".csv"
)
results_csv <- read_csv2(dataset_voivodeships_results$final_filename_shapes)

print(">>>>> processing.....")

provinces_with_teryt <- provinces |>
	mutate(
		kod_teryt = substring(JPT_KOD_JE, 1, 6)
	)

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

ggsave(paste(folders$final_map_folder, "07-Poland-elections-result-per-provinces.png", sep = "/"))

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/07-Poland-elections-result-per-provinces/07-Poland-elections-result-per-provinces.R

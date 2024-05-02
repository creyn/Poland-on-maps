print("Create map of Poland election results")

# run from 'Poland-on-maps' folder: Poland-on-maps> Rscript.exe .\src\06-Poland-elections-result\06-Poland-elections-result.R
install.packages("src/packages/POMUtils_1.1.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/06-Poland-elections-result/",
  data_folder = "data/",
  packages = c("sf", "here", "tidyverse", "giscoR", "janitor")
)

print(">>>>> downloading provinces.....")
dataset_voivodeships <- POMUtils::fetch_zip_with_dataset(
  env_folders = folders,
  dataset_url = "https://www.gis-support.pl/downloads/2022/wojewodztwa.zip"
)
voivodeships <- st_read(dataset_voivodeships, options = "ENCODING=UTF8")

print(">>>>> downloading election results per voivodeship.....")
dataset_voivodeships_results <- POMUtils::fetch_zip_with_dataset(
  env_folders = folders,
  dataset_url = "https://prezydent20200628.pkw.gov.pl/prezydent20200628/data/2/csv/wyniki_gl_na_kand_po_wojewodztwach_csv.zip",
  dataset_extension = ".csv"
)
results_csv <- read_csv2(dataset_voivodeships_results$final_filename_shapes)

print(">>>>> processing data .....")
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

ggsave(paste(folders$final_map_folder, "06-Poland-elections-results.png", sep = "/"))

results_voivodeships_with_winner <- results_csv |> janitor::clean_names() |>
	mutate(
		winner = ifelse(andrzej_sebastian_duda > rafal_kazimierz_trzaskowski, "Andrzej Sebastian Duda", "Rafal Kazimierz Trzaskowski")
	)

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

ggsave(paste(folders$final_map_folder, "06-Poland-elections-result-per-voivodeship.png", sep = "/"))

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/06-Poland-elections-result/06-Poland-elections-result.R

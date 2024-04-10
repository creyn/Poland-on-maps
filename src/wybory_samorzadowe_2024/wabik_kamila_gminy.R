print(">>>>> Map results of 2024 elections for Kamila Wabik")

install.packages("src/packages/POMUtils_1.0.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/wybory_samorzadowe_2024/",
  data_folder = "data/",
  packages = c("sf", "giscoR", "here", "tidyverse")
)

filename <- "data/wybory_samorzadowe_2024/wabik_kamila_wyniki_gminy.csv"
wyniki <- read_csv2(filename) |> janitor::clean_names()

# print(wyniki)
# glimpse(wyniki)

teryts <- wyniki$kod_teryt_powiatu
# print(teryts)

# print(">>>>> All votes:")
# print(sum(wyniki$liczba_glosow_na_kandydata))

dataset_gminy <- POMUtils::fetch_zip_with_shp(
  env_folders = folders,
  dataset_url = "https://www.gis-support.pl/downloads/2022/gminy.zip"
)
dataset_wojewodztwa <- POMUtils::fetch_zip_with_shp(
  env_folders = folders,
  dataset_url = "https://www.gis-support.pl/downloads/2022/wojewodztwa.zip"
)
gminy <- st_read(dataset_gminy$final_filename_shapes)
wojewodztwa <- st_read(dataset_wojewodztwa$final_filename_shapes)

# only one needed
wojewodztwa <- wojewodztwa |> filter(
  JPT_NAZWA_ == "mazowieckie"
)
# print(wojewodztwa)

gminy <- gminy |> filter(
  substring(JPT_KOD_JE, 1, 4) %in% teryts
)

merged <- merge(gminy, wyniki, by.x = "JPT_NAZWA_", by.y = "gmina")
# print(merged)

poland <- gisco_get_countries(
    country = "PL",
    resolution = "1"
)
poland <- st_transform(poland, st_crs(gminy))

ggplot() +
  geom_sf(data = wojewodztwa) + 
    geom_sf(data = merged, aes(fill = liczba_glosow_na_kandydata)) +
    geom_sf(data = poland, fill = alpha("white", 0.2)) +
    theme_classic() +
    theme(
      axis.line = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank()
    ) +
    scale_fill_gradient2(low = "blue", mid = "orange", high = "red", midpoint = 90) +
    labs(
        title = "Kamila Wabik 968 głosów (0.33%)",
        subtitle = "Wyniki w okręgu wyborczym nr 5 w wyborach do Sejmiku Województwa Mazowieckiego",
        fill = "Liczba głosów"
        # caption = "Polska na mapach"
    )

ggsave(paste(folders$final_map_folder, "wybory_samorzadowe_2024_wabik_kamila_gminy.png", sep = "/"))

print(">>>>> done")
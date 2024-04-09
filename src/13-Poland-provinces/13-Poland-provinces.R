print(">>>>> Map Poland's provinces ...")

install.packages("src/packages/POMUtils_1.0.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/13-Poland-provinces/",
  data_folder = "data/",
  packages = c("sf", "giscoR", "here", "tidyverse")
)
dataset_provinces <- POMUtils::fetch_zip_with_shp(
  env_folders = folders,
  dataset_url = "https://www.gis-support.pl/downloads/2022/gminy.zip"
)
dataset_powiaty <- POMUtils::fetch_zip_with_shp(
  env_folders = folders,
  dataset_url = "https://www.gis-support.pl/downloads/2022/powiaty.zip"
)
dataset_regions <- POMUtils::fetch_zip_with_shp(
  env_folders = folders,
  dataset_url = "https://www.gis-support.pl/downloads/2022/wojewodztwa.zip"
)

provinces <- st_read(dataset_provinces$final_filename_shapes)
powiaty <- st_read(dataset_powiaty$final_filename_shapes)
regions <- st_read(dataset_regions$final_filename_shapes)

poland <- gisco_get_countries(
    country = "PL",
    resolution = "1"
)
poland <- st_transform(poland, st_crs(regions))

# map code to type
provinces <- provinces |>
    mutate(
        KOD_TYPE = case_when(
            endsWith(JPT_KOD_JE, "1") ~ "gmina miejska",
            endsWith(JPT_KOD_JE, "2") ~ "gmina wiejska",
            endsWith(JPT_KOD_JE, "3") ~ "gmina miejsko-wiejska",
            endsWith(JPT_KOD_JE, "4") ~ "miasto w gminie miejsko-wiejskiej",
            endsWith(JPT_KOD_JE, "5") ~ "obszar wiejski w gminie miejsko-wiejskiej",
            TRUE ~ "?"
        )
    )

# both datasets need clipping to fit borders !
regions <- st_intersection(regions, poland)
powiaty <- st_intersection(powiaty, poland)
provinces <- st_intersection(provinces, poland)

print(">>>>> Mapping ...")
ggplot() +
    geom_sf(data = provinces, aes(fill = KOD_TYPE)) + 
    geom_sf(data = powiaty, fill = alpha("white", 0.1), color = "black", size = 1) +
    geom_sf(data = regions, fill = alpha("white", 0.1), color = "black", size = 1) +
    geom_sf(data = poland, fill = alpha("white", 0.1)) +
    theme_bw() +
    labs(
        title = "Poland's provinces",
        fill = "Typ gminy",
        caption = "data: https://www.gis-support.pl"
    )

ggsave(paste(folders$final_map_folder, "13-Poland-provinces.png", sep = "/"))

print(">>>>> Done.")
print("Create map of Poland railroads")

install.packages("src/packages/POMUtils_1.1.tar.gz")
folders <- POMUtils::setup(
    script_folder = "src/16-Poland-railroads/",
    data_folder = "data/",
    packages = c("sf", "here", "tidyverse", "terra", "giscoR")
)

print(">>>>> downloading .....")
dataset <- POMUtils::fetch_zip_with_dataset(
    env_folders = folders,
    dataset_url = "http://envirosolutions.pl/dane/drogiKolejowePL.zip"
)
shape <- st_read(dataset, options = "ENCODING=UTF8")

country_sf <- giscoR::gisco_get_countries(
    country = "PL",
    resolution = "1"
)

glimpse(shape)
print(unique(shape$code))
print(unique(shape$fclass))
# print(unique(shape$name))

print(">>>>> processing......")
st_crs(shape) <- st_crs(country_sf)
shape <- shape |>
    mutate(
        typ = case_when(
            endsWith(fclass, "funicular") ~ "kolejka linowa",
            endsWith(fclass, "narrow_gauge") ~ "wąskotorowa",
            endsWith(fclass, "tram") ~ "tramwaj",
            endsWith(fclass, "miniature_railway") ~ "kolej miniaturowa",
            endsWith(fclass, "light_rail") ~ "lekka kolej",
            endsWith(fclass, "monorail") ~ "jednoszynowa",
            endsWith(fclass, "subway") ~ "metro",
            endsWith(fclass, "rail") ~ "kolej",
            TRUE ~ "?"
        )
    )

print(">>>>> plotting.....")

# ggplot() +
#     geom_sf(data = country_sf) +
#     geom_sf(data = shape, aes(color = fclass)) +
#     facet_wrap(~fclass) +
#     theme_void() +
#     labs(color = "Types")

# ggsave(paste(folders$final_map_folder, "16-Poland-railroads-fclass.png", sep = "/"))

ggplot() +
    geom_sf(data = country_sf) +
    geom_sf(data = shape, aes(color = typ)) +
    theme_void() +
    labs(title = "Kolej w Polsce", color = "Typ kolei", caption = "dane: giscoR, envirosolutions")
ggsave(paste(folders$final_map_folder, "16-Poland-railroads.png", sep = "/"))

subway <- shape |>
    filter(typ == "metro")

ggplot() +
    geom_sf(data = country_sf) +
    geom_sf(data = subway) +
    theme_void() +
    labs(title = "Metro w Polsce", caption = "dane: giscoR, envirosolutions")
ggsave(paste(folders$final_map_folder, "16-Poland-railroads-subway.png", sep = "/"))

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/16-Poland-railroads/16-Poland-railroads.R
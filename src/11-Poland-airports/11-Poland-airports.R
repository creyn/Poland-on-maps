print("Create map of Poland's airports")

install.packages("src/packages/POMUtils_1.1.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/11-Poland-airports/",
  data_folder = "data/",
  packages = c("sf", "giscoR", "here", "tidyverse")
)

print(">>>>> Get PL from GISCO...")
country_sf <- giscoR::gisco_get_countries(
    country = "PL",
    resolution = "1"
)
airports_sf <- giscoR::gisco_get_airports(
  country = "PL"
)

glimpse(airports_sf)

print(">>>>> Draw map...")
ggplot(country_sf) +
  geom_sf(fill = "grey80") +
  geom_sf(data = airports_sf, aes(size = AIRP_PASS, color = AIRP_OWNR)) +
  labs(
    title = "Airports of Poland",
    shape = NULL,
    size = "Przepustowość",
    color = "Własność",
    caption = giscoR::gisco_attributions()
  )

ggsave(paste(folders$final_map_folder, "11-Poland-airports.png", sep = "/"))

print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/11-Poland-airports/11-Poland-airports.R

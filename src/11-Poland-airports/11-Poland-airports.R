print("Create map of Poland's airports")

install.packages("src/packages/POMUtils_1.1.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/11-Poland-airports/",
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

print(">>>>> Draw map...")
ggplot(country_sf) +
  geom_sf(fill = "grey80") +
  geom_sf(data = airports_sf, color = "blue") +
  labs(
    title = "Airports of Poland",
    shape = NULL,
    color = NULL,
    caption = giscoR::gisco_attributions()
  )

ggsave(paste(folders$final_map_folder, "11-Poland-airports.png", sep = "/"))

print(">>>>> Done.")

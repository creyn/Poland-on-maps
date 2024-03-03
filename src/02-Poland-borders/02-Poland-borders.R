install.packages("here", repos='http://cran.us.r-project.org')
setwd(here::here())

country_sf <- giscoR::gisco_get_countries(
    country = "PL",
    resolution = "1"
)

png('src/02-Poland-borders/02-Poland-borders.png')
plot(sf::st_geometry(country_sf), col = "red")
dev.off()

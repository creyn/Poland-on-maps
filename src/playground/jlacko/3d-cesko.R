# install.packages("stars", repos='http://cran.us.r-project.org')
# install.packages("MetBrewer", repos='http://cran.us.r-project.org')

library(sf)
library(curl)
library(stars)
library(units)
library(ggplot2)
library(rayshader)
# library(rgl)

# země, která nás zajímá (Čechy Čechům!) - ale jiná by fungovala obdobně
# zipak <- "https://geodata-eu-central-1-kontur-public.s3.amazonaws.com/kontur_datasets/kontur_population_CZ_20220630.gpkg.gz"
zipak <- "https://geodata-eu-central-1-kontur-public.s3.amazonaws.com/kontur_datasets/kontur_population_PL_20231101.gpkg.gz"

if(!file.exists("target_PL.gz")) curl::curl_download(url = zipak, destfile = "target_PL.gz")

# ze zipáku vykuchat geopackage
R.utils::gunzip("target_PL.gz", destname = "target_PL.gpkg", overwrite = TRUE, remove = FALSE)

# načíst geopackage jako {sf} objekt
country <- sf::st_read("target_PL.gpkg") %>% 
  st_transform(3857) # web mercator, pro sichr

country

# z vektoru raster - menší stačí... pozor! formát 3:2 funguje pro Česko, není platný obecně
plot_src <- st_rasterize(country, 
                         nx = 900, 
                         ny = 900)

plot_src

# # z rasteru matici! velikost jako raster
matice <- matrix(plot_src$population, 
                 nrow = 900, 
                 ncol = 900)

# head(matice)

# # barvičky pro vykreslení / inspirováno https://www.metmuseum.org/art/collection/search/11145
barvicky <- grDevices::colorRampPalette(MetBrewer::met.brewer(name="Homer1"))(256)

barvicky

# # vykreslit obrázek
height_shade(matice,
             texture = barvicky) %>%
  plot_3d(heightmap = matice,
          # baseshape = "hex",
          zscale = 90,
          solid = FALSE,
          shadow = TRUE,
          shadowdepth = -1,
          shadow_darkness = 4/5,
          theta = -5,
          phi = 45,
          windowsize = c(2200, 1500),
          zoom = 0.5,
  ) 

render_snapshot("snapshot.png")

# # rgl.snapshot('3dplot.png', fmt = 'png')

# # dev.off()

# # rayshade! pozor, není rychlé (ani trochu)
# # render_highquality(
# #   "country_PL.png",
# #   parallel = TRUE, 
# #   samples = 500,
# #   light = TRUE, 
# #   lightdirection = 210,
# #   lightintensity = 750,
# #   interactive = FALSE,
# #   width = 300, 
# #   height = 200
# # )

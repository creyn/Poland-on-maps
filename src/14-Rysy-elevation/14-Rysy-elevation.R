print(">>>>> Map Rysy mountain elevation ...")

install.packages("src/packages/POMUtils_1.0.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/14-Rysy-elevation/",
  data_folder = "data/",
  packages = c("sf", "giscoR", "here", "tidyverse", "elevatr", "terra")
)

str <- "POLYGON((20.054124 49.202095, 20.118108 49.202095, 20.118108 49.159603, 20.054124 49.159603, 20.054124 49.202095))"
box0 <- st_as_sfc(str, crs = 4326)
box <- st_sf(box0)
# box

mdt <- get_elev_raster(box, z = 5)
# mdt
mdt_rast <- rast(mdt)
# mdt_rast

vect_bbox <- vect(box)
# vect_bbox

# masked <- mask(mdt_rast, vect_bbox)
mdt <- rast(mdt) |>
    mask(vect(box))

png(paste(folders$final_map_folder, "14-Rysy-elevation-z5-masked.png", sep = "/"))
plot(mdt)
invisible(dev.off())
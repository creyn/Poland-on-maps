print(">>>>> Map Rysy mountain elevation ...")

install.packages("src/packages/POMUtils_1.0.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/14-Rysy-elevation/",
  data_folder = "data/",
  packages = c("sf", "giscoR", "here", "tidyverse", "elevatr", "terra", "ggnewscale", "tidyterra")
)

str <- "POLYGON((20.054124 49.202095, 20.118108 49.202095, 20.118108 49.159603, 20.054124 49.159603, 20.054124 49.202095))"
box0 <- st_as_sfc(str, crs = 4326)
box <- st_sf(box0)
# box

mdt <- get_elev_raster(box, z = 14)
# mdt
# mdt_rast <- rast(mdt)
# mdt_rast

vect_bbox <- vect(box)
# vect_bbox

# masked <- mask(mdt_rast, vect_bbox)
mdt <- rast(mdt) |>
    mask(vect(box))

# convert the raster into a data.frame of xyz
mdtdf <- as.data.frame(mdt, xy = TRUE)
# glimpse(mdtdf)
names(mdtdf)[3] <- "alt"

sl <- terrain(mdt, "slope", unit = "radians")
asp <- terrain(mdt, "aspect", unit = "radians")

hill_single <- shade(sl, asp, 
      angle = 45, 
      direction = 0,
      normalize= TRUE)

hill_single_df <- as.data.frame(hill_single, xy = T)
glimpse(hill_single_df)

# png(paste(folders$final_map_folder, "14-Rysy-elevation-z12-hill.png", sep = "/"))
# plot(hill_single, col = grey(1:100/100))
# invisible(dev.off())

# hs <- hillShade(terrain(alt, opt = "slope"),
#                 terrain(alt, opt = "aspect"))

ggplot() +
    geom_raster(data = hill_single_df, aes(x = x, y = y, fill = hillshade), show.legend = FALSE) +
    scale_fill_distiller(palette = "Greys") +
    new_scale_fill() +
    geom_raster(data = mdtdf, aes(x = x, y = y, fill = alt), alpha = 0.7) +
    # scale_fill_hypso_tint_c(breaks = c(180, 250, 500, 1000,
    #                                  1500,  2000, 2500,
    #                                  3000, 3500, 4000)) +
    scale_fill_gradientn("alt", colors = terrain.colors(256), na.value = NA) +
    # guides(fill = guide_colorsteps(barwidth = 20,
    #                              barheight = .5,
    #                              title.position = "right")) +
    labs(fill = "m") +
    coord_sf() +
    theme_bw() +
    theme(legend.position = "bottom")

ggsave(paste(folders$final_map_folder, "14-Rysy-elevation.png", sep = "/"))
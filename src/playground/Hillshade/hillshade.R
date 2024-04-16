libs <- c("giscoR", "elevatr", "terra", "tidyverse", "sf", "tidyterra")

# install missing libraries
installed_libs <- libs %in% rownames(installed.packages())
if (any(installed_libs == F)) {
  install.packages(libs[!installed_libs], repos='http://cran.us.r-project.org')
}

# load libraries
invisible(lapply(libs, library, character.only = T))


suiz <- gisco_get_countries(country = "Poland", resolution = "03")


# suiz <- st_crop(suiz, bbox_wkt)

# get the DEM with
# z = 11 too much memory on my laptop
# mdt <- get_elev_raster(suiz, z = 5)
mdt <- get_elev_raster(bbox_wkt, z = 5)

# convert to terra and mask area of interest
mdt <- rast(mdt) %>% 
         mask(vect(suiz)) 

# have to use suiz_lakes for CRS
# import the lakes boundaries
# suiz_lakes <- st_read("22_DKM500_GEWAESSER_PLY.shp")

# reproject
# mdt <- project(mdt, crs(suiz_lakes))

# print(">>>>> CRS")
# st_crs(suiz_lakes)

# reproject vect
# suiz <- st_transform(suiz, st_crs(suiz_lakes))

# png("mdt.png")
# plot(mdt)
# invisible(dev.off())

# convert the raster into a data.frame of xyz
mdtdf <- as.data.frame(mdt, xy = TRUE)
names(mdtdf)[3] <- "alt"

# map
# ggplot() +
#   geom_raster(data = mdtdf,
#               aes(x, y, fill = alt)) +
#    geom_sf(data = suiz_lakes,
#           fill = "#c6dbef", 
#           colour = NA) +
#   scale_fill_hypso_tint_c(breaks = c(180, 250, 500, 1000,
#                                      1500,  2000, 2500,
#                                      3000, 3500, 4000)) +
#   guides(fill = guide_colorsteps(barwidth = 20,
#                                  barheight = .5,
#                                  title.position = "right")) +
#   labs(fill = "m") +
#   coord_sf() +
#   theme_void() +
#   theme(legend.position = "bottom")

# ggsave("all.png")

# estimate the slope
sl <- terrain(mdt, "slope", unit = "radians")
# png("terrain.png")
# plot(sl)
# invisible(dev.off())

# estimate the aspect or orientation
asp <- terrain(mdt, "aspect", unit = "radians")
# png("terrain_aspect.png")
# plot(asp)
# invisible(dev.off())

# calculate the hillshade effect with 45º of elevation
hill_single <- shade(sl, asp, 
      angle = 45, 
      direction = 300,
      normalize= TRUE)

# final hillshade 
png("bbox_hillshade_PL_z5.png")
plot(hill_single, col = grey(1:100/100))
invisible(dev.off())

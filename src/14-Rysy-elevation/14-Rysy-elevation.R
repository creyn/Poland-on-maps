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

print(">>>>> mdt")
glimpse(mdt)
print(">>>>>")
mdt

print(">>>>> rast")
mdt_rast <- rast(mdt)
glimpse(mdt_rast)
print(">>>>> ")
mdt_rast

print(">>>>> mask")
mdt_mask <- mask(mdt_rast, vect(box))
glimpse(mdt_mask)
print(">>>>>")
mdt_mask

print(">>>>> as dataframe")
mdtdf <- as.data.frame(mdt_rast, xy = TRUE)
names(mdtdf)[3] <- "alt"
glimpse(mdtdf)
print(">>>>>")
head(mdtdf)

# print(">>>>> max rast")
# print(max(mdt_rast$file3c58716168f6))
print(">>>>> max mask")
mask_df <- as.data.frame(mdt_mask, xy = TRUE)
names(mask_df)[3] <- "alt"
print(max(mask_df$alt))
# print(max(mdt_rast$file3c58716168f6))
print(">>>>> max df")
print(max(mdtdf$alt))

# vect_bbox <- vect(box)
# vect_bbox

# masked <- mask(mdt_rast, vect_bbox)
# mdt <- rast(mdt) |>
#     mask(vect(box))

# # convert the raster into a data.frame of xyz
# mdtdf <- as.data.frame(mdt, xy = TRUE)
# # glimpse(mdtdf)
# names(mdtdf)[3] <- "alt"

sl <- terrain(mdt_mask, "slope", unit = "radians")
print(">>>>> sl")
glimpse(sl)
print(">>>>>")
sl

asp <- terrain(mdt_mask, "aspect", unit = "radians")
print(">>>>> asp")
glimpse(asp)
print(">>>>>")
asp

hill_single <- shade(sl, asp, 
      angle = 45, 
      direction = 0,
      normalize= FALSE)
print(">>>>> shade")
glimpse(hill_single)
print(">>>>>")
hill_single

df_slope <- as.data.frame(sl, xy = T)
head(df_slope)
df_aspect <- as.data.frame(asp, xy = T)
head(df_aspect)
df_shade <- as.data.frame(hill_single, xy = T)
head(df_shade)

# print(">>>>> plots")
# png(paste(folders$final_map_folder, "plot-shade.png", sep = "/"))
# plot(df_shade)
# invisible(dev.off())

# png(paste(folders$final_map_folder, "plot-shade-interpolate.png", sep = "/"))
# plot(df_shade, interpolate = TRUE)
# invisible(dev.off())

# # print(">>>>> ggplots")
# ggplot() + geom_raster(data = df_slope, aes(x = x, y = y, fill = slope), show.legend = FALSE)
# ggsave(paste(folders$final_map_folder, "2slope.png", sep = "/"))
# ggplot() + geom_raster(data = df_aspect, aes(x = x, y = y, fill = aspect), show.legend = FALSE)
# ggsave(paste(folders$final_map_folder, "2aspect.png", sep = "/"))
# ggplot() + geom_raster(data = df_shade, aes(x = x, y = y, fill = hillshade), show.legend = FALSE)
# ggsave(paste(folders$final_map_folder, "2shade.png", sep = "/"))

print(">>>>> ggplots disaggregate")
ggplot() + geom_raster(data = df_shade, aes(x = x, y = y, fill = hillshade), show.legend = FALSE)
ggsave(paste(folders$final_map_folder, "3shade.png", sep = "/"))
hill_single_disaggregate <- disagg(hill_single, 300, method='bilinear')
df_shade_disaggregate <- as.data.frame(hill_single_disaggregate, xy = T)
ggplot() + geom_raster(data = df_shade_disaggregate, aes(x = x, y = y, fill = hillshade), show.legend = FALSE)
ggsave(paste(folders$final_map_folder, "3shade-disaggregate.png", sep = "/"))



# hill_single_df <- as.data.frame(hill_single, xy = T)
# glimpse(hill_single_df)

# # print(">>>>> smooth")
# # smooth <- disaggregate(hill_single_df, 3, method='bilinear')
# # glimpse(smooth)

# # png(paste(folders$final_map_folder, "14-Rysy-elevation-z12-hill.png", sep = "/"))
# # plot(hill_single, col = grey(1:100/100))
# # invisible(dev.off())

# # hs <- hillShade(terrain(alt, opt = "slope"),
# #                 terrain(alt, opt = "aspect"))

# ggplot() +
#     geom_raster(data = hill_single_df, aes(x = x, y = y, fill = hillshade), show.legend = FALSE) +
#     scale_fill_distiller(palette = "Greys") +
#     new_scale_fill() +
#     geom_raster(data = mdtdf, aes(x = x, y = y, fill = alt), alpha = 0.7) +
#     # scale_fill_hypso_tint_c(breaks = c(180, 250, 500, 1000,
#     #                                  1500,  2000, 2500,
#     #                                  3000, 3500, 4000)) +
#     scale_fill_gradientn(colors = terrain.colors(256), na.value = NA) +
#     # guides(fill = guide_colorsteps(barwidth = 20,
#     #                              barheight = .5,
#     #                              title.position = "right")) +
#     labs(fill = "m") +
#     coord_sf() +
#     theme_bw() +
#     theme(legend.position = "bottom")

# ggsave(paste(folders$final_map_folder, "14-Rysy-elevation.png", sep = "/"))
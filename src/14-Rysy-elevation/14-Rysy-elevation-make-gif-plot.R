print(">>>>> Map Rysy mountain elevation gif ...")

install.packages("src/packages/POMUtils_1.0.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/14-Rysy-elevation/",
  data_folder = "data/",
  packages = c("sf", "giscoR", "here", "tidyverse", "elevatr", "terra", "ggnewscale", "tidyterra")
)

bbox_string <- "POLYGON((20.054124 49.202095, 20.118108 49.202095, 20.118108 49.159603, 20.054124 49.159603, 20.054124 49.202095))"
st_bbox <- st_as_sfc(bbox_string, crs = 4326)
bbox <- st_sf(st_bbox)

area <- get_elev_raster(bbox, z = 14) |>
    rast() |>
    mask(vect(bbox))

area_df <- as.data.frame(area, xy = TRUE)
names(area_df)[3] <- "alt"

slope <- terrain(area, "slope", unit = "radians")
aspect <- terrain(area, "aspect", unit = "radians")

for(d in seq(0, 360, by = 10)) {

    print(paste(">>>>> plot direction: ", d))

    area_shade <- shade(
        slope, 
        aspect,
        angle = 45,
        direction = d,
        normalize= FALSE
    )

    area_shade_df <- as.data.frame(area_shade, xy = T)

    ggplot() +
        geom_raster(data = area_shade_df, aes(x = x, y = y, fill = hillshade), show.legend = FALSE) +
        scale_fill_distiller(palette = "Greys") +
        new_scale_fill() +
        geom_raster(data = area_df, aes(x = x, y = y, fill = alt), alpha = 0.7) +
        # scale_fill_hypso_tint_c(breaks = c(180, 250, 500, 1000,
        #                                  1500,  2000, 2500,
        #                                  3000, 3500, 4000)) +
        scale_fill_gradientn(colors = terrain.colors(256), na.value = NA) +
        # guides(fill = guide_colorsteps(barwidth = 20,
        #                              barheight = .5,
        #                              title.position = "right")) +
        # labs(fill = "m") +
        coord_sf()
        # theme_bw() +
        # theme(legend.position = "bottom")

    ggsave(paste(folders$final_map_folder, "directions", paste(d, ".png"), sep = "/"), create.dir = TRUE)

}

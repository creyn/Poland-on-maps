windowsFonts(georg = windowsFont('Georgia'))

# libraries we need
libs <- c("elevatr", "terra", "tidyverse", 
	"sf", "giscoR", "marmap")

# install missing libraries
installed_libs <- libs %in% rownames(installed.packages())
if (any(installed_libs == F)) {
  install.packages(libs[!installed_libs], repos='http://cran.us.r-project.org')
}

# load libraries
invisible(lapply(libs, library, character.only = T))

print(">>>>> 1. GET COUNTRY MAP")
#---------

crsLONGLAT <- "+proj=longlat +datum=WGS84 +no_defs"

get_sf <- function(country_sf, country_transformed) {
	
	# country_sf <- giscoR::gisco_get_countries(
    # 	year = "2016",
    # 	epsg = "4326",
    # 	resolution = "10",
    # 	country = "IT")

    country_sf <- giscoR::gisco_get_countries(
    	year = "2016",
    	epsg = "4326",
    	resolution = "10",
    	country = "PL")
	
	country_transformed <- st_transform(country_sf, crs = crsLONGLAT)

	return(country_transformed)
}

country_transformed <- get_sf()

print(">>>>> 2. GET ELEVATION DATA")
#---------

get_elevation_data <- function(country_elevation, country_elevation_df) {

	country_elevation <- get_elev_raster(
		locations = country_transformed, 
		z = 9, 
		clip = "locations") 

	country_elevation_df <- as.data.frame(country_elevation, xy = T) %>%
		na.omit()
	
	colnames(country_elevation_df)[3] <- "elevation"

	return(country_elevation_df)
}

country_elevation_df <- get_elevation_data()

head(country_elevation_df)

print(">>>>> 3. MAP")
#---------

# my colors - mostly gray 
etopo <- read.csv(textConnection(
"altitudes,colours
10000,#FBFBFB
4000,#864747
3900,#7E4B11
2000,#9B8411
1900,#DDDDDD
300,#DDDDDD
0,#DDDDDD
-1,#AFDCF4
-12000,#090B6A
"
), stringsAsFactors=FALSE)
etopo$altitudes01 <- scales::rescale(etopo$altitudes)

get_elevation_map <- function(country_map) {

	country_map <- ggplot() +
  		geom_tile(data = country_elevation_df, 
  			aes(x = x, y = y, fill = elevation)) +
  		# scale_fill_etopo() +
        # scale_fill_distiller(palette = "Greys") +
        scale_fill_gradientn(colours=etopo$colours, values=etopo$altitudes01, limits=range(etopo$altitudes)) +
  		coord_sf(crs = crsLONGLAT)+
  		theme_minimal() +
  		theme(text = element_text(family = "georg", color = "#22211d"),
    		axis.line = element_blank(),
    		axis.text.x = element_blank(),
    		axis.text.y = element_blank(),
    		axis.ticks = element_blank(),
    		axis.title.x = element_blank(),
    		axis.title.y = element_blank(),
    		legend.position = "none",
   		  	panel.grid.major = element_line(color = "white", size = 0.2),
    		panel.grid.minor = element_blank(),
    		plot.title = element_text(size=18, color="grey20", hjust=1, vjust=-5),
    		plot.caption = element_text(size=8, color="grey70", hjust=.15, vjust=20),
    		plot.margin = unit(c(t=0, r=0, b=0, l=0),"lines"), #added these narrower margins to enlarge maps
    		plot.background = element_rect(fill = "white", color = NA), 
    		panel.background = element_rect(fill = "white", color = NA),
    		panel.border = element_blank()) +
		labs(x = "", 
    		y = NULL, 
    		title = "Topographic map of POLAND", 
    		subtitle = "", 
    		# caption = "©2022 Milos Popovic (https://milospopovic.net)")
    		caption = "©2024 Creyn (https://github.com/creyn/Poland-on-maps)")

	return(country_map)
}

country_map <- get_elevation_map()

print(">>>>> saving")
# ggsave(filename="italy_topo_map.png", width=7, height=8.5, dpi = 600, device='png', country_map)
ggsave(filename="poland_topo_map_4.png", country_map)

print(">>>>> done.")

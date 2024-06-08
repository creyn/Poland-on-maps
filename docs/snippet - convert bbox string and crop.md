#snippet 

```R
bbox_string <- "POLYGON((18.0348 54.8795, 20.059 54.8795, 20.059 54.0637, 18.0348 54.0637, 18.0348 54.8795))"
bbox <- st_sf(st_as_sfc(bbox_string, crs = 4326))

country_bbox <- st_crop(country_sf, bbox)

ggplot() +
    geom_sf(data = country_bbox) +
    ...
```

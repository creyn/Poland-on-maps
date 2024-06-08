Nice tool online for creating bounding-box to limit area: https://boundingbox.klokantech.com/

Manually set the bounding box:

![](_attachments/Pasted%20image%2020240607191534.png)

On the bottom select proper format, like "OGC WKT" and copy it into R script.

![](_attachments/Pasted%20image%2020240607191633.png)

Now convert string to a bbox object:

```R
bbox_string <- "POLYGON((18.0348 54.8795, 20.059 54.8795, 20.059 54.0637, 18.0348 54.0637, 18.0348 54.8795))"
bbox <- st_sf(st_as_sfc(bbox_string, crs = 4326))
```

And crop SF objects:

```R
country_bbox <- st_crop(country_sf, bbox)
tracks_bbox <- st_crop(tracks, bbox)
```

And plot it using [ggplot2](ggplot2.md)

```R
ggplot() +
    geom_sf(data = country_bbox) +
    geom_sf(data = tracks_bbox) +
    ...
```


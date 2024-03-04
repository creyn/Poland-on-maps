https://cran.r-project.org/web/packages/sf/index.html

>Support for simple features, a standardized way to encode spatial vector data. Binds to 'GDAL' for reading and writing data, to 'GEOS' for geometrical operations, and to 'PROJ' for projection conversions and datum transformations. Uses by default the 's2' package for spherical geometry operations on ellipsoidal (long/lat) coordinates.

https://github.com/r-spatial/sf

https://r-spatial.github.io/sf/

>Package sf:
- represents simple features as records in a `data.frame` or `tibble` with a geometry list-column
- represents natively in R all 17 simple feature types for all dimensions (XY, XYZ, XYM, XYZM)
- interfaces to [GEOS](https://libgeos.org/) for geometrical operations on projected coordinates, and (through R package [s2](https://cran.r-project.org/package=s2)) to [s2geometry](http://s2geometry.io/) for geometrical operations on ellipsoidal coordinates
- interfaces to [GDAL](https://gdal.org/), supporting all driver options, `Date` and `POSIXct` and list-columns
- interfaces to [PRØJ](http://proj.org/) for coordinate reference system conversion and transformation
- uses [well-known-binary](https://en.wikipedia.org/wiki/Well-known_text#Well-known_binary) serialisations written in C++/Rcpp for fast I/O with GDAL and GEOS
- reads from and writes to spatial databases such as [PostGIS](http://postgis.net/) using [DBI](https://cran.r-project.org/package=DBI)
- is extended by
    - [lwgeom](https://github.com/r-spatial/lwgeom/) for selected liblwgeom/PostGIS functions
    - [stars](https://github.com/r-spatial/stars/) for raster data, and raster or vector data cubes (spatial time series)
    - [sfnetworks](https://luukvdmeer.github.io/sfnetworks/) for geospatial network data


SF Cheat sheet: https://github.com/rstudio/cheatsheets/blob/main/sf.pdf

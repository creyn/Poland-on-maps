#snippet

```r
dataset <- POMUtils::fetch_zip_with_shp(
  env_folders = folders,
  dataset_url = "http://envirosolutions.pl/dane/drogiPL.zip"
)
shape <- sf::st_read(dataset)
```


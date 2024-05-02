#snippet

```r
dataset <- POMUtils::fetch_zip_with_dataset(
  env_folders = folders,
  dataset_url = "http://envirosolutions.pl/dane/drogiPL.zip",
  dataset_extension = ".shp"
)
shape <- sf::st_read(dataset)
```

The `dataset_extension` is optional, default value = `.shp`.


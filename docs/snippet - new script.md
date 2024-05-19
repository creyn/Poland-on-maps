#snippet 

```r
print("Create map of ...")

install.packages("src/packages/POMUtils_1.1.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/.../",
  data_folder = "data/",
  packages = c("sf", "here", "tidyverse", "ggspatial", "prettymapr")
)

print(">>>>> downloading .....")
dataset <- POMUtils::fetch_zip_with_dataset(
  env_folders = folders,
  dataset_url = "http://envirosolutions.pl/dane/rzekiPL.zip"
)
shape <- st_read(dataset, options = "ENCODING=UTF8")

print(">>>>> processing ....")

print(">>>>> plotting.....")

ggplot() +
  geom_sf(data = shape, fill = alpha("#FFFFFF", 0), linewidth = 1) +
  theme_void()
ggsave(paste(folders$final_map_folder, "....png", sep = "/"))
print(">>>>> Done.")

# to run using Docker
# docker pull creyn/poland-on-maps:latest
# OR
# docker build -t poland-on-maps .
# docker run -it -v ${PWD}:/home/docker -w /home/docker -e POM_DATA_FOLDER=/home/docker/data -e POM_OUTPUT_MAPS_FOLDER=/home/docker/output poland-on-maps bash
# Rscript src/.../....R
```

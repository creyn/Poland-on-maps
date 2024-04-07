#snippet

```r
install.packages("src/packages/POMUtils_1.0.tar.gz")
folders <- POMUtils::setup(
  script_folder = "src/13-Poland-provinces/",
  data_folder = "data/",
  packages = c("sf", "giscoR", "here", "tidyverse")
)
```

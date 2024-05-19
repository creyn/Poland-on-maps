http://envirosolutions.pl/dane/drogiKolejowePL.zip

About dataset:

zip size: 11.4 MB
shp size: 17.2 MB

```r
Simple feature collection with 73681 features and 4 fields
Geometry type: LINESTRING
Dimension:     XY
Bounding box:  xmin: 14.17593 ymin: 48.98651 xmax: 24.15235 ymax: 54.79782
CRS:           NA
```

```r
gplimpse(roads)
[1] ">>>>> processing....."
Rows: 73,681
Columns: 5
$ osm_id   <chr> "8032853", "8032858", "8032859", "12184097", "12184098", "233…
$ code     <int> 6101, 6101, 6101, 6101, 6101, 6101, 6101, 6101, 6101, 6101, 6…
$ fclass   <chr> "rail", "rail", "rail", "rail", "rail", "rail", "rail", "rail…
$ name     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
$ geometry <LINESTRING> LINESTRING (22.39205 52.817..., LINESTRING (23.17039 5…
```

```r
print(unique(roads$fclass))
[1] "rail"              "narrow_gauge"      "tram"
[4] "funicular"         "miniature_railway" "light_rail"
[7] "monorail"          "subway"
```

```r
print(unique(shape$name))
  [1] NA
  [2] "Wigierska Kolej Wąskotorowa"
  [3] "Брузги-Гродно"
  [4] "Андреевичи-Качки"
  [5] "Гродно-Брузги"
  [6] "Most kolejowy w Tczewie"
  [7] "LK 281 kat B"
  [8] "Magistrala Węglowa"
  [9] "Most obrotowy Żuławskiej Kolei Wąskotorowej"
 [10] "Militärfeldbahn Hel"
 [11] "Kolejka na Kamienną Górę"
 ...
```


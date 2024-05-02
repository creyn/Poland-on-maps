http://envirosolutions.pl/dane/drogiPL.zip

About dataset:

zip size: 370 MB
shp size: 580 MB

```r
Simple feature collection with 3047538 features and 10 fields
Geometry type: LINESTRING
Dimension:     XY
Bounding box:  xmin: 14.07722 ymin: 48.98332 xmax: 24.1962 ymax: 54.83545
CRS:           NA
```

```r
gplimpse(roads)
[1] ">>>>> processing....."
Rows: 3,047,538
Columns: 11
$ osm_id   <chr> "4307220", "4307329", "4307330", "4308966", "4308967", "43089…
$ code     <int> 5122, 5115, 5115, 5115, 5115, 5122, 5122, 5122, 5122, 5122, 5…
$ fclass   <chr> "residential", "tertiary", "tertiary", "tertiary", "tertiary"…
$ name     <chr> "Powstańców Warszawy", "Rondo Feliksa Stamma", "Bokserska", "…
$ ref      <chr> NA, NA, NA, NA, "2862W", NA, NA, NA, NA, NA, NA, NA, NA, NA, …
$ oneway   <chr> "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "F", "…
$ maxspeed <int> 50, 0, 0, 50, 40, 0, 0, 0, 40, 0, 0, 0, 0, 0, 0, 0, 0, 50, 80…
$ layer    <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0…
$ bridge   <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "…
$ tunnel   <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "…
$ geometry <LINESTRING> LINESTRING (21.01688 52.074..., LINESTRING (20.99717 5…
```

```r
print(unique(roads$fclass))
 [1] "residential"    "tertiary"       "secondary"      "service"
 [5] "primary"        "living_street"  "unclassified"   "secondary_link"
 [9] "tertiary_link"  "trunk"          "primary_link"   "trunk_link"
[13] "path"           "pedestrian"     "cycleway"       "footway"
[17] "track"          "track_grade1"   "track_grade3"   "track_grade5"
[21] "track_grade4"   "track_grade2"   "steps"          "unknown"
[25] "bridleway"      "motorway_link"  "motorway"
```


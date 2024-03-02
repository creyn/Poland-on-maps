Link to code: https://github.com/milos-agathon/3d-river-basin-map

The code from this tutorial: [main.R](main.R)

To run the R script we can use the `RScript.exe` from the installation PATH.

```
Poland-on-maps\src\01-river-basins> Rscript.exe .\main.R
```

After fresh installation I had to install mentioned packages from the [CRAN - Comprehensive R Archive Network](CRAN%20-%20Comprehensive%20R%20Archive%20Network.md):

```r
if (any(installed_libs == F)) {
    install.packages(
        libs[!installed_libs], repos='http://cran.us.r-project.org'
    )
}
```

Plus I want to download data into specific folder (not in the execution folder that is under source control) and don't download if file already downloaded.

```r
url <- "https://data.hydrosheds.org/file/HydroRIVERS/HydroRIVERS_v10_eu_shp.zip"
url_destpath <- paste(data_folder, basename(url), sep = "/")

if (! file.exists(url_destpath)) {
	download.file(
		url = url,
		destfile = url_destpath,
		mode = "wb"
	)
	...
}
```

And ... I have too old laptop and not enough memory to finish rendering in high resolution running in Powershell 😊

```
... terminate called after throwing an instance of 'std::bad_alloc'
```

Running in [PyCharm IDE](PyCharm%20IDE) allowed to allocate more memory but it also took a lot of disk space (25 GB evaporated).

Rendering process took about 2 hours.

The intermediate rendering was also shown in the RGL device:
![](Pasted%20image%2020240302132728.png)

This is a screen crop from rendering shading. Looks quite nice but also has a lot of data to process:
![](Pasted%20image%2020240302114200.png)

And this is the final image (screen crop - because the real final image is a 17MB file).

![](Pasted%20image%2020240302132433.png)
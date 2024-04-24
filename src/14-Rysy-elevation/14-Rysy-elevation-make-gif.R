print(">>>>> Map Rysy mountain elevation gif ...")

# install.packages("magick", repos="http://cran.us.r-project.org")

print(">>>>> list file names and read in...")
imgs <- list.files("directions", full.names = TRUE)
# imgs
img_list <- lapply(imgs, magick::image_read)

print(">>>>> join the images together...")
img_joined <- magick::image_join(img_list)

print(">>>>> animate at 5 frames per second...")
img_animated <- magick::image_animate(img_joined, fps = 5)

## view animated image
# img_animated

print(">>>>> save to disk...")
magick::image_write(image = img_animated,
            path = "14-Rysy-elevation-change-directions.gif")

print(">>>>> done")

fetch_zip_with_shp <- function(env_folders, dataset_url) {

  print(paste(">>>>> fetching dataset", dataset_url, " into ", env_folders$final_data_folder))

  dataset_url_shapes <- dataset_url
  dataset_path_shapes <- paste(env_folders$final_data_folder, basename(dataset_url_shapes), sep = "/")
  dataset_folder_shapes <- sub(".zip", "", dataset_path_shapes)

  if (! file.exists(dataset_path_shapes)) {
    print(">>>>> downloading ...")
      download.file(
          url = dataset_url_shapes,
          destfile = dataset_path_shapes,
          mode = "wb"
      )
  }

  if (! dir.exists(dataset_folder_shapes)) {
    print(">>>>> unzipping ...")
    unzip(
        dataset_path_shapes,
        exdir = dataset_folder_shapes
      )
  }

  final_filename_shapes <- list.files(
      path = dataset_folder_shapes,
      pattern = ".shp",
      full.names = T
  )

  return(data.frame(final_filename_shapes))
}
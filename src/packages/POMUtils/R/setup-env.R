setup <- function(packages, script_folder, data_folder, load_libraries = TRUE) {

  print(">>>>> Setup env...")
  installed_packages <- packages %in% rownames(
      installed.packages()
  )
  if (any(installed_packages == F)) {
      install.packages(
          packages[!installed_packages], repos='http://cran.us.r-project.org'
      )
  }
  setwd(here::here())

  if(load_libraries == TRUE) {
    print(">>>>> Loading libs...")
    invisible(lapply(
      packages, library,
      character.only = T
    ))
  }

  print(">>>>> Setup folders...")
  final_data_folder <- paste(script_folder, "script-big-data", sep = "/")
  if(data_folder != "") {
    final_data_folder = data_folder
  }
  env_data_folder <- Sys.getenv("POM_DATA_FOLDER")
  if(env_data_folder != "") {
      final_data_folder <- env_data_folder
  }
  dir.create(final_data_folder)
  print(paste(">>>>> Data folder setup to: ", final_data_folder))

  final_map_folder <- script_folder
  env_maps_folder <- Sys.getenv("POM_OUTPUT_MAPS_FOLDER")
  if(env_maps_folder != "") {
      final_map_folder <- env_maps_folder
  }
  dir.create(final_map_folder)
  print(paste(">>>>> Output maps folder setup to: ", final_map_folder))

  return(data.frame(final_data_folder, final_map_folder))
}
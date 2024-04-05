setup <- function(script_folder, packages, load_libraries = TRUE) {

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
  output_maps_folder <- script_folder
  env_maps_folder <- Sys.getenv("POM_OUTPUT_MAPS_FOLDER")
  if(env_maps_folder != "") {
      output_maps_folder <- env_maps_folder
  }
  dir.create(output_maps_folder)
  print(paste(">>>>> Output maps folder setup to: ", output_maps_folder))

  return(output_maps_folder)
}
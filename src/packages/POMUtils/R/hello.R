hello <- function(name = "your name") {
    name <- stringr::str_to_title(name)
    print(paste("Hello,", name))
}

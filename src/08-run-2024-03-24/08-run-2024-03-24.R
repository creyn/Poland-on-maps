print("Statistics of a 2024-03-24 run")

# configure script
script_folder <- "src/08-run-2024-03-24/"
data_folder <- "data/run20240324"

# common
print(">>>>> Setup env...")
packages <- c("sf", "here", "tidyverse", "giscoR")
installed_packages <- packages %in% rownames(
  installed.packages()
)
if (any(installed_packages == F)) {
  install.packages(
      packages[!installed_packages], repos='http://cran.us.r-project.org'
    )
}
invisible(lapply(
  packages, library,
    character.only = T
))
setwd(here::here())

library(rvest)

# results <- read_html("https://live.sts-timing.pl/pw2024/index.php?dystans=2")
results <- read_html("https://live.sts-timing.pl/pw2024/wyniki.php?search=1&dystans=1&dystans=2&filter%5Bcountry%5D=&filter%5Bcity%5D=&filter%5Bteam%5D=&filter%5Bsex%5D=&filter%5Bcat%5D=&show%5B%5D=1&show%5B%5D=2&show%5B%5D=3&show%5B%5D=4&show%5B%5D=5&show%5B%5D=6&show%5B%5D=7&show%5B%5D=8&show%5B%5D=9&show%5B%5D=10&show%5B%5D=11&show%5B%5D=12&show%5B%5D=13&show%5B%5D=14&sort=") # 5 km
# results <- read_html("https://live.sts-timing.pl/pw2024/wyniki.php?search=1&dystans=1&dystans=1&filter%5Bcountry%5D=&filter%5Bcity%5D=&filter%5Bteam%5D=&filter%5Bsex%5D=&filter%5Bcat%5D=&show%5B%5D=1&show%5B%5D=2&show%5B%5D=3&show%5B%5D=4&show%5B%5D=5&show%5B%5D=6&show%5B%5D=7&show%5B%5D=8&show%5B%5D=9&show%5B%5D=10&show%5B%5D=11&show%5B%5D=12&show%5B%5D=13&show%5B%5D=14&sort=") # 21 km
# results <- read_html("https://live.sts-timing.pl/pw2024/wyniki.php?search=1&dystans=4&dystans=4&filter%5Bcountry%5D=&filter%5Bcity%5D=&filter%5Bteam%5D=&filter%5Bsex%5D=&filter%5Bcat%5D=&show%5B%5D=1&show%5B%5D=2&show%5B%5D=3&show%5B%5D=4&show%5B%5D=5&show%5B%5D=6&show%5B%5D=7&show%5B%5D=8&show%5B%5D=9&show%5B%5D=10&show%5B%5D=11&sort=") # 5 km wheelchairs
# results <- read_html("https://live.sts-timing.pl/pw2024/wyniki.php?search=1&dystans=3&dystans=3&filter%5Bcountry%5D=&filter%5Bcity%5D=&filter%5Bteam%5D=&filter%5Bsex%5D=&filter%5Bcat%5D=&show%5B%5D=1&show%5B%5D=2&show%5B%5D=3&show%5B%5D=4&show%5B%5D=5&show%5B%5D=6&show%5B%5D=7&show%5B%5D=8&show%5B%5D=9&show%5B%5D=10&show%5B%5D=11&show%5B%5D=12&show%5B%5D=13&show%5B%5D=14&sort=") # 21 km wheelchairs

table <- results |>
  html_element("table") |>
  html_table()

results <- table |> janitor::clean_names() |>
  mutate(
    sex = plec,
    time = as.difftime(czas_netto, units = "secs")
  )

results_35260 <- results |>
  filter(
    numer == 35260
  )

view(results_35260)
# glimpse(results)

ggplot(data = results, mapping = aes(x = time, fill = sex)) +
  geom_histogram(binwidth = 30) +
  geom_vline(xintercept = results_35260$time)
  # facet_wrap("sex")

# # results |>
# #   arrange(miejsce_plec)
#
# results_sex <- results |>
#   group_by(sex) |>
#   summarise(
#     runners = n()
#   )
#
# results_sex
#
# ggplot(
# 	data = results_sex,
# 	mapping = aes(x = 1, y = runners, fill = sex)
# ) +
# 	geom_col(color = "black") + # make pie chart
# 	coord_polar(theta = "y") + # make pie chart
# 	geom_text(
# 		aes(label = runners),
# 		position = position_stack(vjust = 0.5)
# 	) +
# 	theme_void(base_size = 15) +
# 	scale_fill_manual(
# 		values = c(
# 			"M" = "#0073e6",
# 			"K" = "#e6308a"
# 		),
# 		labels = c(
# 			"M" = "Male",
# 			"K" = "Female"
# 		)
# 	) +
# 	labs(caption = "Run 2024-03-24 - 21km - wheelchairs")
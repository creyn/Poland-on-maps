print(">>>>> Setup env...")
packages <- c("tidyverse", "palmerpenguins", "ggthemes", "here")
installed_packages <- packages %in% rownames(
    installed.packages()
)
if (any(installed_packages == F)) {
    install.packages(
        packages[!installed_packages], repos='http://cran.us.r-project.org'
    )
}
library(tidyverse)
setwd(here::here())

palmerpenguins::penguins

glimpse(palmerpenguins::penguins)

# ggplot(
#   data = palmerpenguins::penguins,
#   mapping = aes(x = flipper_length_mm, y = body_mass_g)
# ) +
#   geom_point(mapping = aes(color = species, shape = species)) +
#   geom_smooth(method = "lm") +
#   labs(
#     title = "Body mass and flipper length",
#     subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
#     x = "Flipper length (mm)", y = "Body mass (g)",
#     color = "Species", shape = "Species"
#   ) +
#   ggthemes::scale_color_colorblind()
#
#
# # exercises
#
# ggplot(
#   data = palmerpenguins::penguins,
#   mapping = aes(x = flipper_length_mm, y = body_mass_g)
# ) +
#   geom_point(mapping = aes(color = bill_depth_mm)) +
#   geom_smooth(method = "lm", na.rm = TRUE)
#
# ggplot(
#   data = palmerpenguins::penguins,
#   mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
# ) +
#   geom_point() +
#   geom_smooth(se = FALSE)
#
# ggplot(
#   data = palmerpenguins::penguins,
#   mapping = aes(x = flipper_length_mm, y = body_mass_g)
# ) +
#   geom_point() +
#   geom_smooth()
#
#
# ggplot() +
#   geom_point(
#     data = palmerpenguins::penguins,
#     mapping = aes(x = flipper_length_mm, y = body_mass_g)
#   ) +
#   geom_smooth(
#     data = palmerpenguins::penguins,
#     mapping = aes(x = flipper_length_mm, y = body_mass_g)
#   )
#
# ggplot(palmerpenguins::penguins, aes(x = species)) +
#   geom_bar()
#
# ggplot(palmerpenguins::penguins, aes(x = fct_infreq(species))) +
#   geom_bar()
#
# ggplot(palmerpenguins::penguins, aes(x = body_mass_g)) +
#   geom_histogram(binwidth = 200)


ggplot(palmerpenguins::penguins, aes(y = species)) +
  geom_bar()

ggplot(palmerpenguins::penguins, aes(x = species)) +
  geom_bar(color = "red")
ggplot(palmerpenguins::penguins, aes(x = species)) +
  geom_bar(fill = "red")

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.01)


ggplot(palmerpenguins::penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()

ggplot(palmerpenguins::penguins, aes(x = body_mass_g, color = species)) +
  geom_density(linewidth = 0.75)

ggplot(palmerpenguins::penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill")


ggplot(palmerpenguins::penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)

# exercises

mpg
glimpse(mpg)

ggplot(mpg, aes(x = displ, y = hwy, color = cty, size = cty, linewidth = cty)) +
  geom_point()

ggplot(palmerpenguins::penguins, aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point() +
  facet_wrap(~species)


ggplot(
  data = palmerpenguins::penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm,
    color = species, shape = species
  )
) +
  geom_point()

ggsave(filename = "src/playground/R-for-data-science/penguins.png")
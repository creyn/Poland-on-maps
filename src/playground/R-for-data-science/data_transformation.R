# install.packages("nycflights13", repos="http://cran.us.r-project.org")
library(nycflights13)
library(tidyverse)

glimpse(flights)

# View(flights)

flights |>
  filter(dest == "IAH") |>
  group_by(year, month, day) |>
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

flights |>
  filter(dep_delay > 120)

flights |>
  filter(month %in% c(1, 2))

flights |>
  arrange(desc(dep_delay))

flights |>
  distinct(origin, dest, .keep_all = TRUE)

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1,
    .keep = "used"
  )

flights |>
  select(!year:day)

flights |>
  select(where(is.character))

flights |>
  relocate(time_hour, air_time)

flights |>
  group_by(month) |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )

# df |> slice_head(n = 1) takes the first row from each group.
# df |> slice_tail(n = 1) takes the last row in each group.
# df |> slice_min(x, n = 1) takes the row with the smallest value of column x.
# df |> slice_max(x, n = 1) takes the row with the largest value of column x.
# df |> slice_sample(n = 1) takes one random row.

flights |>
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = c(origin, dest)
  )


flights |>
  group_by(dest) |>
  summarize(
    distance = mean(distance),
    speed = mean(distance / air_time, na.rm = TRUE)
  ) |>
  ggplot(aes(x = distance, y = speed)) +
  geom_smooth(
    method = "loess",
    span = 0.5,
    se = FALSE,
    color = "white",
    linewidth = 4
  ) +
  geom_point()




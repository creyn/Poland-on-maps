#snippet 
```r
provinces <- provinces |>
    mutate(
        KOD_TYPE = case_when(
            endsWith(JPT_KOD_JE, "1") ~ "gmina miejska",
            endsWith(JPT_KOD_JE, "2") ~ "gmina wiejska",
            endsWith(JPT_KOD_JE, "3") ~ "gmina miejsko-wiejska",
            endsWith(JPT_KOD_JE, "4") ~ "miasto w gminie miejsko-wiejskiej",
            endsWith(JPT_KOD_JE, "5") ~ "obszar wiejski w gminie miejsko-wiejskiej",
            TRUE ~ "?"
        )
    )
```

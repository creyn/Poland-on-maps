```r
# un-pivot ?  
billboard_longer <- billboard |>  
  pivot_longer(  
    cols = starts_with("wk"),  
    names_to = "week",  
    values_to = "rank",  
    values_drop_na = TRUE  
  ) |>  
  mutate(  
    week = parse_number(week) # parses first number, ignores all text  
  )
```

Select columns , names of those columns should go to column "week" and values to columns "rank". Then parse text to number for computations.

We can un-mix the column if it has values also using the `.value`:
```r
household |>  
  pivot_longer(  
    cols = !family,  
    names_to = c(".value", "child"),  
    names_sep = "_",  
    values_drop_na = TRUE  
  )
```

We also can do the opposite, make dataset wider (more columns, less rows):
```r
cms_patient_experience |>  
  pivot_wider(  
    id_cols = starts_with("org"),  
    names_from = measure_cd,  
    values_from = prf_rate  
  )
```


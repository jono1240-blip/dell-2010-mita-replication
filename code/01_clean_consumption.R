# 01_clean_consumption.R
# Rebuilds Dell's household dataset (first part of maketable2.do)

library(here)
library(haven)
library(tidyverse)

# Household roster: one row per person
roster <- read_dta(here("data/raw/enaho01_2001iv_200.dta")) |>
  select(conglome, vivienda, hogar, ubigeo, p203, p207, p208a, p208b) |>
  mutate(
    across(c(conglome, vivienda, hogar), str_trim),     # remove stray spaces
    ubigeo = str_pad(str_trim(ubigeo), 6, pad = "0")    # " 30101" -> "030101"
  ) |>
  filter(p203 != 0) |>                         # drop people no longer in household
  mutate(
    p208b = replace_na(p208b, 0),              # missing months = 0
    age   = p208a + p208b / 12,                # age in years
    hhead = as.integer(p203 == 1),             # 1 = household head
    male  = as.integer(p207 == 1),             # 1 = male
    ccdd  = as.numeric(substr(ubigeo, 1, 2))   # department code
  ) |>
  filter(ccdd %in% c(3, 4, 5, 8, 21))          # keep the 5 study departments

# Household size and equivalence scale
roster <- roster |>
  mutate(hid = paste0(conglome, vivienda, hogar)) |>   # household ID
  group_by(hid) |>
  mutate(
    hhmem   = n(),                  # number of people in household
    kids    = sum(age < 15),        # members aged 0–14
    k_hhmem = kids / hhmem,         # share of household who are kids
    weight  = case_when(
      age < 5  ~ 0.4,               # infants count as 0.4
      age < 15 ~ 0.5,               # children count as 0.5
      TRUE     ~ 1                  # adults count as 1
    ),
    ces = sum(weight)               # equivalent adults in household
  ) |>
  ungroup()
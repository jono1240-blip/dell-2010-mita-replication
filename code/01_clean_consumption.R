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

# Household consumption (sumaria file)
transfers <- c("ingtexhd", "ingtrahd", "gru13hd1", "gru13hd2", "gru13hd3",
               "gru23hd1", "gru23hd2", "gru33hd1", "gru33hd2",
               "gru43hd1", "gru43hd2", "gru53hd1", "gru53hd2",
               "gru63hd1", "gru63hd2", "gru73hd1", "gru73hd2",
               "gru83hd1", "gru83hd2")

sumaria <- read_dta(here("data/raw/sumaria_2001iv.dta")) |>
  select(conglome, vivienda, hogar, gashog2d, defesp, all_of(transfers)) |>
  mutate(
    across(c(conglome, vivienda, hogar), str_trim),       # same space problem
    across(all_of(transfers), ~ replace_na(.x, 0)),        # missing transfer = 0
    hconsump = gashog2d - rowSums(across(all_of(transfers)))  # spending minus transfers
  )

# Merge onto roster, deflate, keep one row per household
consumption <- roster |>
  left_join(sumaria, by = c("conglome", "vivienda", "hogar")) |>
  mutate(
    hconsumplm = hconsump / defesp,                              # convert to Lima prices
    hhequiv    = hconsumplm / ces,                               # consumption per equivalent adult
    lhhequiv   = log(if_else(hhequiv > 0, hhequiv, NA_real_)),   # log only if positive
    lhhequiv   = replace_na(lhhequiv, 0)                         # Dell: recode lhhequiv .=0
  ) |>
  filter(hhead == 1)  
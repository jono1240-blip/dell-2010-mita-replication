# 02_table2.R
# Replicates Table 2, Panel A, column 1 (Dell 2010)

library(here)
library(tidyverse)
library(fixest)

consumption <- read_rds(here("data/clean/consumption.rds"))

# Sample: within 100km of mita boundary, excluding Cusco
sample_100 <- consumption |>
  filter(cusco != 1, d_bnd < 100)

# Regression: cubic in lat/lon, household controls, geography, boundary FEs
m1 <- feols(
  lhhequiv ~ pothuan_mita +
    x + y + x2 + y2 + xy + x3 + y3 + x2y + xy2 +   # cubic polynomial in coordinates
    infants + children + adults +                  # household composition
    elv_sh + slope +                               # elevation and slope
    bfe4_1 + bfe4_2 + bfe4_3,                      # boundary segment fixed effects
  data    = sample_100,
  cluster = ~ubigeo                                # SEs clustered by district
)

summary(m1)
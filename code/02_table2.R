# 02_table2.R
# Replicates Table 2, Panel A, column 1 (Dell 2010)

library(here)
library(tidyverse)
library(fixest)

consumption <- read_rds(here("data/clean/consumption.rds"))

# Same regression at three distance cutoffs from the mita boundary
run_spec <- function(cutoff) {
  feols(
    lhhequiv ~ pothuan_mita +
      x + y + x2 + y2 + xy + x3 + y3 + x2y + xy2 +   # cubic polynomial in coordinates
      infants + children + adults +                  # household composition
      elv_sh + slope +                               # elevation and slope
      bfe4_1 + bfe4_2 + bfe4_3,                      # boundary segment fixed effects
    data    = consumption |> filter(cusco != 1, d_bnd < cutoff),
    cluster = ~ubigeo                                # SEs clustered by district
  )
}

m1 <- run_spec(100)
m2 <- run_spec(75)
m3 <- run_spec(50)

etable(m1, m2, m3, keep = "pothuan_mita")
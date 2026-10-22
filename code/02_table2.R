# 02_table2.R
# Replicates Table 2, Panel A (Dell 2010), plus a robustness check

library(here)
library(tidyverse)
library(fixest)

consumption <- read_rds(here("data/clean/consumption.rds"))

# Same regression at three distance cutoffs from the mita boundary
run_spec <- function(cutoff, data = consumption) {
  feols(
    lhhequiv ~ pothuan_mita +
      x + y + x2 + y2 + xy + x3 + y3 + x2y + xy2 +   # cubic polynomial in coordinates
      infants + children + adults +                  # household composition
      elv_sh + slope +                               # elevation and slope
      bfe4_1 + bfe4_2 + bfe4_3,                      # boundary segment fixed effects
    data    = data |> filter(cusco != 1, d_bnd < cutoff),
    cluster = ~ubigeo                                # SEs clustered by district
  )
}

m1 <- run_spec(100)
m2 <- run_spec(75)
m3 <- run_spec(50)

# Robustness: drop households with zero or negative consumption
consumption_pos <- consumption |> filter(hhequiv > 0)

r1 <- run_spec(100, data = consumption_pos)
r2 <- run_spec(75,  data = consumption_pos)
r3 <- run_spec(50,  data = consumption_pos)

etable(m1, m2, m3, r1, r2, r3, keep = "pothuan_mita")

# Save table
etable(m1, m2, m3,
       keep    = "pothuan_mita",
       headers = c("<100 km", "<75 km", "<50 km"),
       file    = here("output/tables/table2_panelA.tex"),
       replace = TRUE)

# Save robustness table
etable(m1, m2, m3, r1, r2, r3,
       keep    = "pothuan_mita",
       headers = list(
         "Sample:"   = list("Original" = 3, "Drop non-positive consumption" = 3),
         "Distance:" = rep(c("<100 km", "<75 km", "<50 km"), 2)
       ),
       file    = here("output/tables/table2_robustness.tex"),
       replace = TRUE)

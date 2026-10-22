# 03_figures.R
# Figure 1: maps of mita status and consumption
# Figure 2: regression discontinuity plot at the mita boundary

library(here)
library(tidyverse)
library(sf)

# Same sample as Table 2, column 1
rd_sample <- read_rds(here("data/clean/consumption.rds")) |>
  filter(cusco != 1, d_bnd < 100) |>
  mutate(
    dist = bnd_dist_neg,                              # km to boundary: + inside mita, - outside
    side = if_else(dist > 0, "Mita", "Non-mita")
  )

# Basic RD plot: every household, plus a fitted line on each side
ggplot(rd_sample, aes(dist, lhhequiv, colour = side)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm") +
  geom_vline(xintercept = 0, linetype = "dashed")

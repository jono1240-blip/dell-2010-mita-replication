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

# Colours used in both figures
col_mita    <- "#B5543C"   # terracotta
col_nonmita <- "#3E6A8A"   # slate blue


# ---- Figure 2: RD plot ------------------------------------------------------

# Average households into 10 km bins so the pattern is readable
bin_width <- 10
rd_bins <- rd_sample |>
  mutate(bin = floor(dist / bin_width) * bin_width + bin_width / 2) |>   # bin midpoint
  group_by(side, bin) |>
  summarise(mean_y = mean(lhhequiv), n = n(), .groups = "drop")

fig2 <- ggplot(rd_sample, aes(dist, lhhequiv, colour = side, fill = side)) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "grey40") +
  geom_smooth(method = "lm", formula = y ~ x, linewidth = 0.9, alpha = 0.15) +  # fit on all households
  geom_point(data = rd_bins, aes(bin, mean_y, size = n),                        # binned means
             shape = 21, colour = "white", stroke = 0.4) +
  scale_colour_manual(values = c("Mita" = col_mita, "Non-mita" = col_nonmita)) +
  scale_fill_manual(values = c("Mita" = col_mita, "Non-mita" = col_nonmita)) +
  scale_size_area(max_size = 6, guide = "none") +
  scale_x_continuous(breaks = seq(-100, 100, 25)) +
  annotate("text", x = -50, y = 6.75, label = "Outside the mita",
           colour = col_nonmita, fontface = "bold", size = 3.6) +
  annotate("text", x = 50, y = 6.75, label = "Inside the mita",
           colour = col_mita, fontface = "bold", size = 3.6) +
  coord_cartesian(ylim = c(5, 7)) +
  labs(
    title    = "Household consumption drops at the mita boundary",
    subtitle = "Mean log consumption per equivalent adult in 10 km bins (point size = households); linear fit with 95% CI on each side",
    x        = "Distance to the mita boundary (km)",
    y        = "Log consumption per equivalent adult",
    caption  = "Sample: households within 100 km of the boundary, excluding Cusco (N = 1,477)."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    legend.position  = "none",
    panel.grid.minor = element_blank(),
    plot.title       = element_text(face = "bold"),
    plot.subtitle    = element_text(colour = "grey35", size = 9.5),
    plot.caption     = element_text(colour = "grey40", size = 8)
  )

fig2

ggsave(here("output/figures/fig2_rd_plot.png"), fig2,
       width = 8, height = 5, dpi = 300, bg = "white")

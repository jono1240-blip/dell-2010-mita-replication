# 03_figures.R
# Figure 1: maps of mita status and district consumption around the boundary
# Figure 2: regression discontinuity plot at the mita boundary

library(here)
library(tidyverse)
library(sf)
library(patchwork)

sf_use_s2(FALSE)   # planar geometry: fine at this scale, avoids invalid-polygon errors

gis_dir <- here("data/raw/gis/rdfigs_datafiles/gis")

# Same sample as Table 2, column 1: within 100 km of the boundary, excluding Cusco
rd_sample <- read_rds(here("data/clean/consumption.rds")) |>
  filter(cusco != 1, d_bnd < 100)

# Shared colours and theme
col_mita    <- "#B5543C"   # terracotta
col_nonmita <- "#3E6A8A"   # slate blue
col_cusco   <- "#D9D4CC"   # light grey

theme_map <- theme_void(base_size = 11) +
  theme(
    plot.title      = element_text(face = "bold", size = 12),
    plot.subtitle   = element_text(colour = "grey35", size = 9.5),
    legend.position = "bottom",
    legend.title    = element_text(size = 9),
    legend.text     = element_text(size = 9)
  )


# ---- Spatial data -----------------------------------------------------------

districts <- st_read(file.path(gis_dir, "district_wgs.shp"), quiet = TRUE) |>
  st_make_valid()
boundary  <- st_read(file.path(gis_dir, "boundary_wgs.shp"), quiet = TRUE)

study <- districts |>
  filter(STUDY_REG == 1) |>
  mutate(status = case_when(
    CUSCO == 1   ~ "Cusco (excluded)",
    PH_MITA == 1 ~ "Mita",
    TRUE         ~ "Non-mita"
  ))

# Map window: study region plus a small margin; surrounding districts drawn as context
pad     <- 0.25
window  <- st_bbox(study) + c(-pad, -pad, pad, pad)   # xmin, ymin, xmax, ymax
xlim    <- unname(window[c("xmin", "xmax")])
ylim    <- unname(window[c("ymin", "ymax")])
context <- st_crop(districts, window)

# Department capitals for orientation (label at district centroid)
cities <- tibble(
  name    = c("Cusco", "Ayacucho", "Abancay", "Puno", "Arequipa"),
  ubigeo  = c(80101, 50101, 30101, 210101, 40101),
  nudge_x = c(0.35, 0, -0.45, 0, 0),       # move labels off the boundary line
  nudge_y = c(0.15, 0.15, -0.15, 0.17, 0.15)
) |>
  inner_join(districts, by = "ubigeo") |>
  st_as_sf() |>
  st_centroid() |>
  suppressWarnings()   # centroid of lon/lat polygons: fine for placing labels

# Mean log consumption by district (households in the RD sample)
district_means <- rd_sample |>
  group_by(ubigeo) |>
  summarise(mean_lhhequiv = mean(lhhequiv), n_households = n())

study_cons <- study |>
  left_join(district_means, by = "ubigeo")


# ---- Figure 1: maps ---------------------------------------------------------

city_xy <- cities |>
  mutate(x = st_coordinates(geometry)[, 1] + nudge_x,
         y = st_coordinates(geometry)[, 2] + nudge_y) |>
  st_drop_geometry()

base_layers <- list(
  geom_sf(data = context, fill = "grey96", colour = "grey85", linewidth = 0.1)
)

top_layers <- list(
  geom_sf(data = boundary, colour = "black", linewidth = 0.9),
  geom_sf(data = cities, shape = 21, fill = "white", colour = "black", size = 1.8),
  geom_label(data = city_xy, aes(x, y, label = name), size = 2.9,
             fontface = "bold", fill = alpha("white", 0.85),
             label.size = 0, label.padding = unit(0.12, "lines")),
  coord_sf(xlim = xlim, ylim = ylim, expand = FALSE, datum = NA)
)

map_status <- ggplot() +
  base_layers +
  geom_sf(data = study, aes(fill = status), colour = "white", linewidth = 0.15) +
  top_layers +
  scale_fill_manual(
    values = c("Mita" = col_mita, "Non-mita" = col_nonmita,
               "Cusco (excluded)" = col_cusco),
    name = NULL
  ) +
  labs(title = "A. Mita assignment",
       subtitle = "Districts in the study region; black line = mita boundary") +
  theme_map

map_cons <- ggplot() +
  base_layers +
  geom_sf(data = study_cons, aes(fill = mean_lhhequiv),
          colour = "white", linewidth = 0.15) +
  top_layers +
  scale_fill_viridis_c(
    option = "mako", direction = 1, na.value = "grey90",
    name = "Mean log consumption\nper equivalent adult (2001)",
    guide = guide_colourbar(barwidth = 10, barheight = 0.5, title.position = "top")
  ) +
  labs(title = "B. Household consumption",
       subtitle = "District means, households within 100 km of the boundary") +
  theme_map

fig1 <- map_status + map_cons +
  plot_annotation(
    caption = "Data: Dell (2010) replication files; ENAHO 2001. Grey districts have no sampled households.",
    theme   = theme(plot.caption = element_text(colour = "grey40", size = 8))
  )

ggsave(here("output/figures/fig1_mita_map.png"), fig1,
       width = 11, height = 6.2, dpi = 300, bg = "white")


# ---- Figure 2: RD plot ------------------------------------------------------

# Running variable: distance to the boundary in km, positive inside the mita
rd_sample <- rd_sample |>
  mutate(dist  = bnd_dist_neg,
         side  = if_else(dist > 0, "Mita", "Non-mita"))

bin_width <- 10
rd_bins <- rd_sample |>
  mutate(bin = floor(dist / bin_width) * bin_width + bin_width / 2) |>
  group_by(side, bin) |>
  summarise(mean_y = mean(lhhequiv), n = n(), .groups = "drop")

fig2 <- ggplot(rd_sample, aes(dist, lhhequiv, colour = side, fill = side)) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "grey40") +
  geom_smooth(method = "lm", formula = y ~ x, linewidth = 0.9, alpha = 0.15) +
  geom_point(data = rd_bins, aes(bin, mean_y, size = n),
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
    subtitle = paste0("Mean log consumption per equivalent adult in ", bin_width,
                      " km bins (point size = households); linear fit with 95% CI on each side"),
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

ggsave(here("output/figures/fig2_rd_plot.png"), fig2,
       width = 8, height = 5, dpi = 300, bg = "white")

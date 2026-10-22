
mita_colors <- function(z,
                        cmap = rev(tim.colors(n = 512)),
                        zrng = c(min(z), max(z)),
                        leg_inc = diff(zrng)/5
                        )
  {
    ## setup colors, setup figure parameters 

    ## Z Value colors for each region
    col_pos<- pmax(1,
                   floor((data_region.shp[[region_data]][include]- zrng[1]) /
                         diff(zrng) * length(cmap) + 1)
                   )
    
    col_pos[col_pos > length(cmap)] <- length(cmap)
    col_pos[col_pos < 1] <- 1
    col_code <- cmap[col_pos]

    ## Setup marker size
    if (!is.na(region_nobs))
      {
        nobs_rng <- c(min(data_region.shp[[region_nobs]][include]),
                      max(data_region.shp[[region_nobs]][include]))
        outer_dot_size <- (data_region.shp[[region_nobs]][include] - nobs_rng[1]) /
          diff(nobs_rng) * (max_dot_size - min_dot_size) + min_dot_size
        inner_dot_size <- outer_dot_size - 0.5
      } else {
        outer_dot_size <- as.vector(rep(max_dot_size / 2, length =
                                        sum(include)))
        inner_dot_size <- outer_dot_size - 0.5
      }

    ## Legend colors
    leg_lab <- sprintf('%.2f', seq(min(zrng), max(zrng),
                                   leg_inc))
    leg_lab[1] <- ifelse(min(zrng) == 0,
                         sprintf('%.2f', min(zrng)),
                         sprintf('<%.2f', min(zrng)))
    leg_lab[length(leg_lab)] <- sprintf('>%.2f', max(zrng))
    leg <- seq(zrng[1], zrng[2], leg_inc)
    leg_pos <- floor(( leg - zrng[1] ) / (zrng[2] - zrng[1]) *
                     length(cmap)) + 1
    leg_pos[leg_pos < 1] <- 1
    leg_pos[length(leg_pos)] <- length(cmap)
    leg_code <- cmap[leg_pos]

    return(list(zrng           = zrng,
                cmap           = cmap,
                col_code       = col_code,
                leg_code       = leg_code,
                leg_lab        = leg_lab,
                inner_dot_size = inner_dot_size,
                outer_dot_size = outer_dot_size))

  }

mita_draw_legend <- function(x, y, xw, yw)
  {
    ## Draw the legend
    
    num_markers <- 4
    nobs_rng <- c(min(data_region.shp[[region_nobs]][include]),
                  max(data_region.shp[[region_nobs]][include]))
    rect(x, y, x + xw, y + yw, col = 'white')
    margin <- 0.15
    top_margin <- margin * 0.38
    step <- (yw - margin)/ (num_markers - 1)
    for (marker in 0:(num_markers - 1))
      {
        outer_dot_size <- (diff(nobs_rng) * marker / num_markers) /
          diff(nobs_rng) * (max_dot_size - min_dot_size) + min_dot_size
        ##        inner_dot_size <- outer_dot_size * 0.7
        inner_dot_size <- outer_dot_size - 0.5
        points(x + xw/6, y + yw - top_margin - step * marker, pch = 19, col = 'black', cex = outer_dot_size)
        points(x + xw/6, y + yw - top_margin - step * marker, pch = 19, col = 'white', cex = inner_dot_size)
        text(x + xw*.25, y + yw - top_margin - step * marker,
             adj = c(0, 0.5),
             lab = sprintf(' %d Obs.',
               nobs_rng[1] + round(diff(nobs_rng) * marker)),
             cex = 0.8)
      }
    
  }

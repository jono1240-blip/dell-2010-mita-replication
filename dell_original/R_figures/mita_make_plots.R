mita_make_plots <- function(x, y, z,
                            cmap, zrng,
                            col_code, leg_code,
                            leg_lab, plot_type = 'both', main = '',
                            zlab = main, theta = 0) {
    ## Make a single plot

    if (plot_type != 'persp')
      {

        ## Draw  boundary to setup axes 
        plot(boundary.shp, lwd = boundary_lwd, col =
             boundary_col, main = main, lty = boundary_lty, xlim =
             range(x) + xbuffer, ylim = range(y) + ybuffer, axes =
             TRUE)

        if (plot_type == 'data_regions')
          {
            plot(data_region.shp, add = TRUE, lwd = 1)
            plot(data_region.shp[include, ], col = col_code, add = TRUE,
                 lwd = 1)
          }
        
        if (plot_type == 'reg' | plot_type == 'both' | plot_type ==
                            'nomap_both' | plot_type == 'nomap_reg')
          {
            z_trunc <- z
            z_trunc[z_trunc < zrng[1]] <- zrng[1]
            z_trunc[z_trunc > zrng[2]] <- zrng[2]
            image(x = x, y = y, z = z_trunc, col = cmap, xlim =
                  range(x), ylim = range(y), zlim = zrng, add = TRUE)
            if (regexpr('nomap*', plot_type) != 1)
              {
                plot(data_region.shp, lwd = 1, add = TRUE)
              }
          }
        
        if (plot_type == 'data_points' | plot_type == 'both' |
                            plot_type == 'nomap_both' | plot_type ==
                            'nomap_data_points')
          {
            if (regexpr('nomap*', plot_type) != 1)
              {
                plot(data_region.shp, lwd = 1, add = TRUE)
              }
            points(coordinates(data_region.shp[include, ]), pch = 19, col =
                   'black', cex = outer_dot_size)
            points(coordinates(data_region.shp[include, ]), pch = 19, col =
                   col_code, cex = inner_dot_size)
            if (!is.na(region_nobs))
              mita_draw_legend(x_legend - .805, y_legend + .927, 0.76,
                               0.775)
          }
        draw_boundary(main)
        legend(x = x_legend, y = y_legend + 1.7, bg = 'white', legend = leg_lab,
               fill = leg_code, cex=.8)
      }
    
    if (plot_type == 'persp')
      {
        persp(x=x, y=y, z=z, expand = 0.3,
              phi = 40, theta = theta, 
              shade = 1, col = 'white',
              ticktype = 'detailed', nticks = 4,
              ylab = 'Lat.', xlab = 'Long.', zlab = zlab,
              xlim = range(x),
              ylim = range(y),
              zlim = zrng,
              main = main)
      }
    
  }

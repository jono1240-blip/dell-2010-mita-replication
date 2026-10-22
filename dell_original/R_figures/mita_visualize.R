## Visualize output

## Define boundary drawing function
if (pdf_col)
  {
    draw_boundary <- function(main)
      {
        plot(boundary.shp, lwd = boundary_lwd, add = TRUE, col = boundary_col, main
             = main, lty = boundary_lty) ## color
        ## boundary
      }
  } else {
    draw_boundary <- function(main)
      {
        plot(boundary.shp, lwd = boundary_lwd, add = TRUE, col = 'black', main
             = main, lty = 1) # lty = line
        plot(boundary.shp, lwd = boundary_lwd, add = TRUE, col = 'white', main = main,
             lty = 3) # lty = dotted
      }
  }

## Make PDF file
pdf(sprintf('%s/%s',
            ifelse(pdf_col, 'col', 'bw'),
            pdf_file))

attach(mita_colors(z = z,
                   cmap = cmap,  zrng = zrng_func(z)
                   ), warn.conflicts = FALSE)

mita_make_plots(x, y, z,
                cmap, zrng,
                col_code, leg_code,
                leg_lab, plot_type = 'data_regions',
                main = main_string)

mita_make_plots(x_lowres, y_lowres, z_lowres,
                cmap, zrng = zrng,
                col_code, leg_code,
                leg_lab, plot_type = 'persp',
                main = main_string,
                theta = 0)

mita_make_plots(x_lowres, y_lowres, z_lowres,
                cmap, zrng = zrng,
                col_code, leg_code,
                leg_lab, plot_type = 'persp',
                main = main_string,
                theta = 270)

mita_make_plots(x, y, z,
                cmap, zrng,
                col_code, leg_code,
                leg_lab, plot_type = 'data_points',
                main = main_string)

mita_make_plots(x, y, z,
                cmap, zrng,
                col_code, leg_code,
                leg_lab, plot_type = 'reg',
                main = main_string)

mita_make_plots(x, y, z,
                cmap, zrng,
                col_code, leg_code,
                leg_lab, plot_type = 'both',
                main = main_string)

mita_make_plots(x, y, z,
                cmap, zrng,
                col_code, leg_code,
                leg_lab, plot_type = 'nomap_both',
                main = main_string)

mita_make_plots(x, y, z,
                cmap, zrng,
                col_code, leg_code,
                leg_lab, plot_type = 'nomap_data_points',
                main = main_string)

mita_make_plots(x, y, z,
                cmap, zrng,
                col_code, leg_code,
                leg_lab, plot_type = 'nomap_reg',
                main = main_string)

dev.off()

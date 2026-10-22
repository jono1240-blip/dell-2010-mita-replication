mita_compute_regression <- function(x_rel, y_rel, xbar, ybar, params)
  {
    ## Compute the regression function for all points on the map
    
    ## Recover true x/y values
    ## x and y must be increasing for image.plot to accept them
    x <- rev(-(x_rel + x_center))
    y <- rev(-(y_rel + y_center))

    ## Evaluate the regression
    f <- function(a, b) {
      ## De-mean and flip coordinates since the regression equation
      ## assumes 0-mean/positive coordinates. 
      a <- (-a - xbar) 
      b <- (-b - ybar)
      return(
             params['x'] * a + params['y'] * b +

             params['x2'] * a^2 + params['y2'] * b^2 +
             params['xy'] * a * b +
             
             params['x3'] * a^3 + params['y3'] * b^3 +
             params['x2y'] * a^2 * b + params['xy2'] * a * b^2 +

             params['x4'] * a^4 + params['y4'] * b^4 +
             params['x3y'] * a^3 * b + params['xy3'] * a * b^3 +
             params['x2y2'] * a^2 * b^2 +
             
             params['Constant'] + params['pothuan_mita']
             )
    }
    zpoly <- outer(X = x, Y = y, FUN = f)
    grd <- meshgrid(x, y)
    indexes <- meshgrid(1:length(x), 1:length(y))
    z_coord <- SpatialPoints(cbind(as.vector(grd$x), as.vector(grd$y)))
    z <- zpoly
    in_map <- matrix(data = FALSE, nrow = nrow(z), ncol = ncol(z))

    ## add mita effect to regression function
    for (index in 1:dim(assign)[1])
      {
        district <- which(data_region.shp@data[[region_ub]] ==
                          assign[[id_field]][index])
        if (length(district) > 0)
          {
            mask <- !is.na(overlay(x = z_coord, y = data_region.shp[district, ]))
            for (point in which(mask))
              {
                in_map[indexes$x[point], indexes$y[point]] <- TRUE
                if(!as.logical(assign$pothuan_mita[index]))
                  {
                    ## if not mita, subtract mita effect
                    z[indexes$x[point], indexes$y[point]] <-
                      z[indexes$x[point], indexes$y[point]] -
                        params['pothuan_mita']
                  }
              }
          }
      }
    z[!in_map] <- NA
    z[z<0] <- 0 
    return(list(x = x,
                y = y,
                z = z))
  }

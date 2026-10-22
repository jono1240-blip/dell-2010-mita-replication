mita_select_dataset <- function(dataset)
  {
    ## Assign figure parameters for each dataset
    param_rows      <- seq(2,32,2)
    id_field        <- 'ubigeo'
    zeros_na        <- FALSE
    zrng_func       <- function(data) {
      data          <- data[!is.na(as.vector(data))]
      c(min(data), mean(data) + 0.5 * sd(as.vector(data)))
    }
    ## Color maps/intensities based on ArcGIS "cyan-light to
    ## blue-dark" colormap.
    if(pdf_col) {
      cmap <-
        colorRampPalette(c('#202040', '#B4B4F6', '#D4D4FF', '#EAEAFF'),
                       space = 'Lab')(32)
    } else {
      cmap <-
        colorRampPalette(c('#202020', '#AAAAAA', '#D0D0D0', '#E0E0E0'))(32)
    }
    if (dataset == 'cons2001')
      {
        ## Consumption
        shp_file    <- 'cons2001_prj_Nobs_Project.shp'
        pdf_file    <- 'cons2001.pdf'
        main_string <- 'Consumption2001'
        param_col   <- 'lhhequiv'
        region_data <- 'cons2001_2'
        region_ub   <- 'cons2001_1'
        region_nobs <- 'consumpt_2'
        zeros_na    <- TRUE
        zrng_func   <- function(data) { c(5.5, 9) }
      }
    if (dataset == 'cons2001d')
      {
        ## Consumption - regression by district
        shp_file    <- 'cons2001_prj_Nobs_Project.shp'
        pdf_file    <- 'cons2001.pdf'
        main_string <- 'Consumption2001 (districts)'
        param_col   <- 'lhhequiv_district'
        region_data <- 'cons2001_2'
        region_ub   <- 'cons2001_1'
        region_nobs <- 'consumpt_2'
        zeros_na    <- TRUE
        zrng_func   <- function(data) { c(5.5, 9) }
      }
    if (dataset == 'educ1876')
      {
        ## Education 1876
        shp_file    <- 'educ1876_final.shp'
        pdf_file    <- 'educ1876.pdf'
        main_string <- 'Education1876'
        param_col   <- 'literate'
        region_data <- 'educ1876_1'
        region_ub   <- 'district_w'
        region_nobs <- NA
        zrng_func   <- function(data) { c(.01, 0.15) }
      }
    
    if (dataset == 'height2005')
      {
        ## Height 2005
        # note:
        # colormap is flipped for "favorable/unfavorable" consistency
        # with other datasets
        shp_file    <- 'height2005_w_Nobs.shp'
        pdf_file    <- 'height2005.pdf'
        main_string <- 'Height2005'
        param_col   <- 'desnu'
        region_data <- 'height2_14'
        region_ub   <- 'height2_13'
        region_nobs <- 'height_N_3'
        cmap        <- rev(cmap)
        zrng_func   <- function(data) { c(0.1, 0.5) }
      }
    if (dataset == 'mkt1994' |
        dataset == 'mkt1994poly0' |
        dataset == 'mkt1994poly1' |
        dataset == 'mkt1994poly2' |
        dataset == 'mkt1994poly3' |
        dataset == 'mkt1994poly4')
      {
        ## Market, with different order polynomials 
        shp_file    <- 'mkt1994_w_Nobs.shp'
        pdf_file    <- paste(dataset, '.pdf', sep ='')
        main_string <- 'Mkt1994'
        region_data <- 'mkt1994__3'
        region_ub   <- 'mkt1994_pr'
        region_nobs <- 'mkt_coll_3'
        zrng_func   <- function(data) { c(0, .5) }
      }
    if (dataset == 'mkt1994') {
      param_col <- 'd_venta'
    } 
    if (dataset == 'mkt1994poly0') {
      param_col <- 'd_venta0'
    } 
    if (dataset == 'mkt1994poly1') {
      param_col <- 'd_venta1'
    }
    if (dataset == 'mkt1994poly2') {
      param_col <- 'd_venta2'
    }
    if (dataset == 'mkt1994poly3') {
      param_col <- 'd_venta3'
    }
    if (dataset == 'mkt1994poly4') {
      param_col <- 'd_venta4'
    }
    if (dataset == 'hac1689')
      {
        ## Haciendas 1689
        shp_file    <- 'boundary1689.shp'        
        pdf_file    <- 'hac1689.pdf'
        main_string <- 'Haciendas 1689'
        param_col   <- 'num_hac'
        region_data <- 'hac1689__1'
        region_ub   <- 'hac1689_te'
        region_nobs <- NA
        zrng_func   <- function(data) { c(0, 25) }
      }
    if (dataset == 'hac1845')
      {
        ## Haciendas 1845
        shp_file    <- 'hacienda1845_prj.shp'
        pdf_file    <- 'hac1845.pdf'
        main_string <- 'Haciendas 1845'
        param_col   <- 'ptlf_hac'
        region_data <- 'hac1845__1'
        region_ub   <- 'hac1845__2'
        region_nobs <- NA
        zrng_func   <- function(data) { c(0, 1.3) }        
      }
    if (dataset == 'hac1940')
      {
        ## Haciendas 1940
        shp_file    <- 'hacienda1940_prj.shp'
        pdf_file    <- 'hac1940.pdf'
        main_string <- 'Haciendas 1940'
        param_col   <- 'hacienda_prlf'
        region_data <- 'hac1940__1'
        region_ub   <- 'hac1940__2'
        region_nobs <- NA
        zrng_func   <- function(data) { c(0, .9) }                
      }    
    if (dataset == 'roads2006')
      {
        ## Roads 2006
        shp_file    <- 'roads2006_prj.shp'
        pdf_file    <- 'roads2006.pdf'
        main_string <- 'Roads 2006'
        param_col   <- 'ddep_t'
        region_data <- 'roads_fi_1'
        region_ub   <- 'ubigeo'
        region_nobs <- NA
        zrng_func   <- function(data) { c(5, 70) }
      }
    return(list(shp_file    = shp_file,
                pdf_file    = pdf_file,
                main_string = main_string,
                param_rows  = param_rows,
                param_col   = param_col,
                region_data = region_data,
                region_ub   = region_ub,
                region_nobs = region_nobs,
                zrng_func   = zrng_func,
                id_field    = id_field,
                zeros_na    = zeros_na,
                cmap        = cmap
                ))
  }

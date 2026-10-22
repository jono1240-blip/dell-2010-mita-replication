## Main code file

rm(list = ls(all.names = TRUE)) # Clear variables
library(maptools)     # loads sp library too
library(RColorBrewer) # creates nice color schemes
library(classInt)     # finds class intervals for continuous vars
library(fields)       # Use image.plot
library(Cairo)        # PDF antialiasing

## Set up X/Y range, window arrangement, define helper functions
source("mita_setup.R")

## All datasets
datasets <- c('cons2001', 
              'cons2001d', 
              'educ1876', 
              'hac1689', 
              'hac1845', 
              'hac1940',
              'height2005',
              'mkt1994', 
              'mkt1994poly0', 
              'mkt1994poly1', 
              'mkt1994poly2', 
              'mkt1994poly3',  
              'mkt1994poly4',
              'roads2006') 

## Market regression with different order polynomials
poly_datasets <- c('mkt1994poly0',
                   'mkt1994poly1',
                   'mkt1994poly2',
                   'mkt1994poly3',
                   'mkt1994poly4')

for (pdf_col in c(FALSE, TRUE)) # loop through black/white and color figures
  {
    for (dataset in datasets) # loop through each dataset
      {
        ## dataset specific data
        attach(mita_select_dataset(dataset), warn.conflicts = FALSE)

        ## Load mita data 
        source("mita_load_data_general.R")

        ## Compute regression function, low resolution version (for
        ## surface plots)
        reg <- mita_compute_regression(x_rel_lowres, y_rel_lowres, xbar,
                                       ybar, params)
        x_lowres <- reg$x
        y_lowres <- reg$y
        z_lowres <- reg$z

        ## Compute regression function, high resolution version (for color
        ## images)
        reg <- mita_compute_regression(x_rel, y_rel, xbar, ybar, params) 
        x <- reg$x
        y <- reg$y
        z <- reg$z

        ## Visualize, produce PDFs
        source("mita_visualize.R")
      }
  }

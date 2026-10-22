## Set debug mode
debug_mode <- FALSE
if (debug_mode) {
  options(error = recover)
} else {
  options(error = NULL)
}

## Define helper functions
source("mita_select_dataset.R")
source("mita_compute_regression.R")
source("mita_colors.R")
source("mita_make_plots.R")
source("mita_draw_legend.R")
meshgrid <- function(a,b) {
  ## matlab-style meshgrid() function
  list(
       x=outer(b*0,a,FUN="+"),
       y=outer(b,a*0,FUN="+")
       )
} 

## Setup X/Y parameters, map margins, data dot size
xmin=-2.4
xmax= 2.4
ymin=-1.4
ymax=2.0

## Resolution settings for the regression function
## _rel_lowres parameters are used for the surface plot
## _rel parameters are used for the heat map
## Publication-quality resolution ----
x_rel_lowres <- seq(xmin, xmax, .04)
y_rel_lowres <- seq(ymin, ymax, .04)
x_rel <- seq(xmin, xmax, .01)
y_rel <- seq(ymin, ymax, .01)
## Debugging-quality resolution ----
## x_rel_lowres <- seq(xmin, xmax, .1)
## y_rel_lowres <- seq(ymin, ymax, .1)
## x_rel <- seq(xmin, xmax, .05)
## y_rel <- seq(ymin, ymax, .05)

## Misc figure parameters
x_legend <- -70.7
y_legend <- -14.25
xbuffer <- c(.5, -.5) 
ybuffer <- c(.1, -.1)
max_dot_size <- 3.5
min_dot_size <- 0.75
boundary_col <- 'green'
boundary_lty <- 1
boundary_lwd <- 3

## create output directories
dir.create('col')
dir.create('bw')

## Read map data
boundary.shp <- readShapeLines('datafiles/gis/boundary_wgs.shp',
                               proj4string=CRS("+proj=longlat"))
capitals.shp <- readShapePoints('datafiles/gis/capitals_wgs.shp',
                                proj4string=CRS("+proj=longlat"))

## assign mita/non-mita designation
assign <-
  read.csv("datafiles/other/mita_assign_list_modified.csv")

## load regression parameters
all_params <- read.csv("datafiles/other/param_figs_final.csv", header
                       = TRUE)

data_region.shp <- readShapePoly(sprintf('datafiles/gis/%s', shp_file),
                                 proj4string=CRS("+proj=longlat"))

## Data to include in the analysis (i.e. not NA)
if (zeros_na)
  {
    include <- !is.na(data_region.shp[[region_data]]) &
    (data_region.shp[[region_data]] != 0)
  } else {
    include <- !is.na(data_region.shp[[region_data]])
  }

## Read regression params
params <- all_params[param_rows, param_col]
params <- as.numeric(sub('[*]+', '', as.character(params))) ## remove asterisks
names(params) <- all_params[param_rows, 1]
params[is.na(params)] <- 0
mean_values <- read.table("datafiles/other/mean_values.txt",
                          row.names = 1)

## Mean values to use in computing the regression
xbar <- mean_values[dataset, 1]
ybar <- mean_values[dataset, 2]

## Coordinates to center the map on (use center of the haciendas1689
## dataset for all maps)
x_center <- mean_values['hac1689', 1]
y_center <- mean_values['hac1689', 2]

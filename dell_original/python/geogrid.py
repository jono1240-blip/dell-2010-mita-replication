# ---------------------------------------------------------------------------
#This file contains code for means comprison of elevation and slope  by grid cell across
#the mita boundary
# ---------------------------------------------------------------------------

# Import system modules
import sys, string, os, arcgisscripting
print "system modules imported"

# Create the Geoprocessor object
gp = arcgisscripting.create()
print "created geoprocessor object"

# Set the necessary product code
gp.SetProduct("ArcInfo")
print "set product code"

# Check out any necessary licenses
gp.CheckOutExtension("spatial")
gp.CheckOutExtension("3D")
print "checked extensions"

# Load required toolboxes...
gp.AddToolbox("C:/Program Files/ArcGIS/ArcToolbox/Toolboxes/Spatial Analyst Tools.tbx")
gp.AddToolbox("C:/Program Files/ArcGIS/ArcToolbox/Toolboxes/Data Management Tools.tbx")
gp.AddToolbox("C:/Program Files/ArcGIS/ArcToolbox/Toolboxes/3D Analyst Tools.tbx")
gp.AddToolbox("C:/Program Files/ArcGIS/ArcToolbox/Toolboxes/Analysis Tools.tbx")
print "loaded required toolboxes"

#Turn overwrite on
gp.overwriteoutput = 1
print "overwrite on"

# Set Extent
gp.Extent = "MAXOF"
        
#Set directory path
gp.workspace = "G:\\mita\\mita.gdb\\"
print "directroy set"

###--------------------------------------###
###---Mean Elevation by Grid Cell --###
###--------------------------------------###

###----Data files used
#-peru_nw
#-elev_prj
#-grid
#-StudyReg_prj
#-MitaBoundary_prj
#-in_prj
#-out_prj

###----Data files created as final product
#-e3.dbf
#-inmita.dbf
#-outmita.dbf
#-s3.dbf

# Process: Extract by Mask ...
peru_nw = "peru_nw"
elev_eq = "elev_prj"
el_pe = "el_pe"
gp.ExtractByMask_sa(elev_eq, peru_nw, el_pe)
print "selected elevation data without water bodies (necessary for calculating slope below)"

# Process: Zonal Statistics as Table...
grid = "grid"
elev = "ElevZone"
gp.ZonalStatisticsAsTable_sa(grid, "GRID_ID", el_pe, elev, "DATA")
print "calculated mean of elev in each grid cell"

# Process: Table Select...
elev_dbf = "G:\\mita\\output\\e3.dbf"
gp.TableSelect_analysis(elev, elev_dbf, "")
print "exported to .dbf file"

# Process: Feature To Point...
cent = "cent"
gp.FeatureToPoint_management(grid, cent, "INSIDE")
print "created grid centroids"

# Process: Clip...
streg_poly = "StudyReg_prj"
centeq_cl = "centeq_cl"
gp.Clip_analysis(cent, streg_poly, centeq_cl, "")
print "clipped centroids to study region extent"

# Process: Near ...
ph_bnd = "MitaBoundary"
gp.Near_analysis(centeq_cl, ph_bnd, "100000 Meters", "LOCATION", "NO_ANGLE")
print "calculated distance to mita boundary"

# Process: Intersect ...
inmita_poly = "in_prj"
inmita_centroids = "cent_inmita"
gp.Intersect_analysis("centeq_cl #;in_prj #", inmita_centroids, "ALL", "", "INPUT")
print "intersected centroids with mita extent data"

# Process: Table Select ...
inmita_dbf = "G:\\mita\\output\\inmita.dbf"
gp.TableSelect_analysis(inmita_centroids, inmita_dbf, "")
print "exported mita-centroid data"

# Process: Intersect ...
outmita_centroids = "cent_outmita"
outmita_poly = "out_prj"
gp.Intersect_analysis("centeq_cl #;out_prj #", outmita_centroids, "ALL", "", "INPUT")
print "intersected centroids with mita extent data"

# Process: Table Select ...
outmita_dbf = "G:\\mita\\output\\outmita.dbf"
gp.TableSelect_analysis(outmita_centroids, outmita_dbf, "")
print "exported mita-centroid data"

####--------Slope

# Process: Slope...
slope = "slope_nw"
gp.Slope_sa(el_pe, slope, "DEGREE", "1")
print "calculated slope"

# Process: Zonal Statistics as Table...
slope_grid = "slope_grid"
gp.ZonalStatisticsAsTable_sa(grid, "GRID_ID", slope, slope_grid, "DATA")
print "calculated mean slope by grid cell"

# Process: Table Select ...
slopegrid_dbf = "G:\\mita\\output\\s3.dbf"
gp.TableSelect_analysis(slope_grid, slopegrid_dbf, "")
print "exported slope (by grid) data to .dbf file"




print "calculations completed"


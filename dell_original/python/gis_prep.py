
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

#Set directory path
gp.workspace = "G:\\mita\\mita.gdb\\"
print "directroy set"


###-------------------------------------###
###---Calculate distance vars
###-------------------------------------###

#---Files used
#-d2_pot
#-Potosi
#-d2huan
#-Huancav
#-d2_bnd
#-MitaBoundary

# Process: Near ... (Calculate distance of district capitals to Potosi and mita boundary)
d2pot = "d2_pot"
Potosi = "Potosi"
gp.Near_analysis(d2pot, "Potosi", "5000 Kilometers", "NO_LOCATION", "NO_ANGLE")
d2huan = "d2_huan"
Huancav = "Huancav"
gp.Near_analysis(d2huan, "Huancav", "5000 Kilometers", "NO_LOCATION", "NO_ANGLE")
print "calculated distance to Potosi and Huancavelica"

d2bnd = "d2_bnd"
ph_bnd = "MitaBoundary"
gp.Near_analysis(d2bnd, ph_bnd, "100000 Meters", "LOCATION", "NO_ANGLE")
print "calculated distance to mita boundary"



###-------------------------------------###
###---Mean elevation  and slope by district
###-------------------------------------###


#---Files used
#-peru_nw
#-elev_prj
#-StudyDistricts

#---Data files created as final products
#-meanelev.dbf
#-sldist.dbf

#-------Mean district elevation-----#


# Process: Extract by Mask ...
peru_nw = "peru_nw"
elev_prj = "elev_prj"
el_pe = "el_pe"
gp.ExtractByMask_sa(elev_prj, peru_nw, el_pe)
print "selected elevation data without water bodies (necessary for calculating slope below)"

# Process: Zonal Statistics as Table...
StudyDistricts = "StudyDistricts"
elev = "ElevZone"
el_pe = "el_pe"
gp.ZonalStatisticsAsTable_sa(StudyDistricts, "CODIGO_DIS", el_pe, elev, "DATA")
print "calculated mean of elev in each dist"

# Process: Table Select...
meanelev_dbf = "G:\\mita\\output\\meanelev.dbf"
gp.TableSelect_analysis(elev, meanelev_dbf, "")
print "exported to .dbf file"


###------Slopes by District


# Process: Slope...
slope = "slope_nw"
gp.Slope_sa(el_pe, slope, "DEGREE", "1")
print "calculated slope"

# Process: Zonal Statistics as Table...
slope_dist = "slope_dist"
gp.ZonalStatisticsAsTable_sa(StudyDistricts, "CODIGO_DIS", slope, slope_dist, "DATA")
print "calculated mean slope by dist"

# Process: Table Select ...
slopedist_dbf = "G:\\mita\\output\\sldist.dbf"
gp.TableSelect_analysis(slope_dist, slopedist_dbf, "")
print "exported slope (by dist) data to .dbf file"

# ---------------------------------------------------------------------------
# Prepares data for road network analysis
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

#Set directory path
gp.workspace = "G:\\mita\\mita.gdb"
print "directroy set"



###------------------------------------###
###---Length of Roads by District---###
###------------------------------------###

###---------Data files used
#--roads_prj
#--StudyDistricts
#--elev_prj

###---------Data files created as final product
#--vecg`X'.shp (X=1-5, 9)
#--depg`X'.shp(X=1-5, 9)
#--nacg`X'.shp (X=1-5. 9)


#Superficie
#1 Asfaltado
#2 Afirmado
#3 Sin Afirmar
#4 Trocha Carrozable
#5 En Construccion
#9 En Proyecto

#-----Local Roads-----#

print "Calculate kilometers of different types of local roads"


# Process: Select...
roads_prj = "roads_prj"
Red0206Vecinal_shp = "Red0206Vecinal1"
#gp.Select_analysis(roads_prj, Red0206Vecinal_shp, "\"RUTA\" ='Vecinal' AND \"SUPERFICIE\"=1")
print "extracted local roads"

# Process: Intersect...
vec_intd_shp = "G:\\mita\\output\\vecd1.shp"
gp.Intersect_analysis("Red0206Vecinal1 #;StudyDistricts #", vec_intd_shp, "ALL", "", "INPUT")
print "intersected local roads and districts"

# Process: Surface Length...
elev_prj = "elev_prj"
gp.SurfaceLength_3d(elev_prj, vec_intd_shp, "SLength", "", "1")
print "calculated length of local roads"




# Process: Select...
roads_prj = "roads_prj"
Red0206Vecinal_shp = "Red0206Vecinal2"
gp.Select_analysis(roads_prj, Red0206Vecinal_shp, "\"RUTA\" ='Vecinal' AND \"SUPERFICIE\"=2")
print "extracted local roads"

# Process: Intersect...
vec_intd_shp = "G:\\mita\\output\\vecd2.shp"
gp.Intersect_analysis("Red0206Vecinal2 #;StudyDistricts #", vec_intd_shp, "ALL", "", "INPUT")
print "intersected local roads and districts"

# Process: Surface Length...
elev_prj = "elev_prj"
gp.SurfaceLength_3d(elev_prj, vec_intd_shp, "SLength", "", "1")
print "calculated length of local roads"




# Process: Select...
roads_prj = "roads_prj"
Red0206Vecinal_shp = "Red0206Vecinal3"
gp.Select_analysis(roads_prj, Red0206Vecinal_shp, "\"RUTA\" ='Vecinal' AND \"SUPERFICIE\"=3")
print "extracted local roads"

# Process: Intersect...
vec_intd_shp = "G:\\mita\\output\\vecd3.shp"
gp.Intersect_analysis("Red0206Vecinal3 #;StudyDistricts #", vec_intd_shp, "ALL", "", "INPUT")
print "intersected local roads and districts"

# Process: Surface Length...
elev_prj = "elev_prj"
gp.SurfaceLength_3d(elev_prj, vec_intd_shp, "SLength", "", "1")
print "calculated length of local roads"




# Process: Select...
roads_prj = "roads_prj"
Red0206Vecinal_shp = "Red0206Vecinal4"
gp.Select_analysis(roads_prj, Red0206Vecinal_shp, "\"RUTA\" ='Vecinal' AND \"SUPERFICIE\"=4")
print "extracted local roads"

# Process: Intersect...
vec_intd_shp = "G:\\mita\\output\\vecd4.shp"
gp.Intersect_analysis("Red0206Vecinal4 #;StudyDistricts #", vec_intd_shp, "ALL", "", "INPUT")
print "intersected local roads and districts"

# Process: Surface Length...
elev_prj = "elev_prj"
gp.SurfaceLength_3d(elev_prj, vec_intd_shp, "SLength", "", "1")
print "calculated length of local roads"




# Process: Select...
roads_prj = "roads_prj"
Red0206Vecinal_shp = "Red0206Vecinal5"
gp.Select_analysis(roads_prj, Red0206Vecinal_shp, "\"RUTA\" ='Vecinal' AND \"SUPERFICIE\"=5")
print "extracted local roads"

# Process: Intersect...
vec_intd_shp = "G:\\mita\\output\\vecd5.shp"
gp.Intersect_analysis("Red0206Vecinal5 #;StudyDistricts #", vec_intd_shp, "ALL", "", "INPUT")
print "intersected local roads and districts"

# Process: Surface Length...
elev_prj = "elev_prj"
gp.SurfaceLength_3d(elev_prj, vec_intd_shp, "SLength", "", "1")
print "calculated length of local roads"




# Process: Select...
roads_prj = "roads_prj"
Red0206Vecinal_shp = "Red0206Vecinal9"
gp.Select_analysis(roads_prj, Red0206Vecinal_shp, "\"RUTA\" ='Vecinal' AND \"SUPERFICIE\"=9")
print "extracted local roads"

# Process: Intersect...
vec_intd_shp = "G:\\mita\\output\\vecd9.shp"
gp.Intersect_analysis("Red0206Vecinal9 #;StudyDistricts #", vec_intd_shp, "ALL", "", "INPUT")
print "intersected local roads and districts"

# Process: Surface Length...
elev_prj = "elev_prj"
gp.SurfaceLength_3d(elev_prj, vec_intd_shp, "SLength", "", "1")
print "calculated length of local roads"




#-----Departamental Roads-----#

# Process: Select...
RedDep0206_shp = "Red0206dep1"
gp.Select_analysis(roads_prj, RedDep0206_shp, "\"RUTA\" ='Departamental' AND \"SUPERFICIE\"=1")
print "extracted departamental roads"

# Process: Intersect...
dep_intd_shp = "G:\\mita\\output\\depd1.shp"
gp.Intersect_analysis("Red0206dep1 #;StudyDistricts #", dep_intd_shp, "ALL", "", "INPUT")
print "intersected departamental roads and districts"

# Process: Surface Length...
gp.SurfaceLength_3d(elev_prj, dep_intd_shp, "SLength", "", "1")
print "calculated length of departamental roads"



# Process: Select...
RedDep0206_shp = "Red0206dep2"
gp.Select_analysis(roads_prj, RedDep0206_shp, "\"RUTA\" ='Departamental' AND \"SUPERFICIE\"=2")
print "extracted departamental roads"

# Process: Intersect...
dep_intd_shp = "G:\\mita\\output\\depd2.shp"
gp.Intersect_analysis("Red0206dep2 #;StudyDistricts #", dep_intd_shp, "ALL", "", "INPUT")
print "intersected departamental roads and districts"

# Process: Surface Length...
gp.SurfaceLength_3d(elev_prj, dep_intd_shp, "SLength", "", "1")
print "calculated length of departamental roads"



# Process: Select...
RedDep0206_shp = "Red0206dep3"
gp.Select_analysis(roads_prj, RedDep0206_shp, "\"RUTA\" ='Departamental' AND \"SUPERFICIE\"=3")
print "extracted departamental roads"

# Process: Intersect...
dep_intd_shp = "G:\\mita\\output\\depd3.shp"
gp.Intersect_analysis("Red0206dep3 #;StudyDistricts #", dep_intd_shp, "ALL", "", "INPUT")
print "intersected departamental roads and districts"

# Process: Surface Length...
gp.SurfaceLength_3d(elev_prj, dep_intd_shp, "SLength", "", "1")
print "calculated length of departamental roads"



# Process: Select...
RedDep0206_shp = "Red0206dep4"
gp.Select_analysis(roads_prj, RedDep0206_shp, "\"RUTA\" ='Departamental' AND \"SUPERFICIE\"=4")
print "extracted departamental roads"

# Process: Intersect...
dep_intd_shp = "G:\\mita\\output\\depd4.shp"
gp.Intersect_analysis("Red0206dep4 #;StudyDistricts #", dep_intd_shp, "ALL", "", "INPUT")
print "intersected departamental roads and districtsd"

# Process: Surface Length...
gp.SurfaceLength_3d(elev_prj, dep_intd_shp, "SLength", "", "4")
print "calculated length of departamental roads"




# Process: Select...
RedDep0206_shp = "Red0206dep5"
gp.Select_analysis(roads_prj, RedDep0206_shp, "\"RUTA\" ='Departamental' AND \"SUPERFICIE\"=5")
print "extracted departamental roads"

# Process: Intersect...
dep_intd_shp = "G:\\mita\\output\\depd5.shp"
gp.Intersect_analysis("Red0206dep5 #;StudyDistricts #", dep_intd_shp, "ALL", "", "INPUT")
print "intersected departamental roads and districts"

# Process: Surface Length...
gp.SurfaceLength_3d(elev_prj, dep_intd_shp, "SLength", "", "4")
print "calculated length of departamental roads"



# Process: Select...
RedDep0206_shp = "Red0206dep9"
gp.Select_analysis(roads_prj, RedDep0206_shp, "\"RUTA\" ='Departamental' AND \"SUPERFICIE\"=9")
print "extracted departamental roads"

# Process: Intersect...
dep_intd_shp = "G:\\mita\\output\\depd9.shp"
gp.Intersect_analysis("Red0206dep9 #;StudyDistricts #", dep_intd_shp, "ALL", "", "INPUT")
print "intersected departamental roads and districts"

# Process: Surface Length...
gp.SurfaceLength_3d(elev_prj, dep_intd_shp, "SLength", "", "1")
print "calculated length of departamental roads"


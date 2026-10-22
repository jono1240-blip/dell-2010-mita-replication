********************************************
*This file makes Table 8 (Roads)
********************************************
capture log close
clear
clear matrix
set mem 200000
cd G:\mita\data
log using maketable8, replace

/*Data Files Used
	gis_dist.dta
	vecd`X'.dbf
	depd`X'.dbf
	where `X'=1/5, 9
	distr.dbf
        
*Data files created as final products
	roads.dta
	
*Data Files Created as Intermediate Product
	temp.dta*/
	

/*NOTE: THE NUMBERS IN THE FILE NAMES REFER TO THE FOLLOWING CLASSIFICATION SCHEMA:
1 Asfaltado
2 Afirmado
3 Sin Afirmar
4 Trocha Carrozable
5 En Construcción
9 En Proyecto*/

cd G:\mita\output 

*Local roads
foreach X in 1 2 3 4 5 9 {
	clear
	odbc load CODIGO_DIS SLength, table("vecd`X'.dbf") dsn("dBASE Files") lowercase
	gen local_roads`X'=slength
	rename codigo_dis ubigeo
	collapse (sum) local_roads`X', by (ubigeo)
	sort ubigeo
	save vecd`X', replace 
}

*Regional roads
foreach X in 1 2 3 4 9 { /*note - no departmental roads currently being constructed (5)*/
	clear
	odbc load CODIGO_DIS SLength, table("depd`X'.dbf") dsn("dBASE Files") lowercase
	gen dep_roads`X'=slength
	rename codigo_dis ubigeo
	collapse (sum) dep_roads`X', by (ubigeo)
	sort ubigeo
	save depd`X', replace
}

use depd1, clear
sort ubigeo
merge ubigeo using depd2 depd3 depd4 depd9 vecd1 vecd2 vecd3 vecd4 vecd5 vecd9, unique
drop _merge*

foreach X in dep local {
	label var `X'_roads1 "length of `X' road (asphalt, m)"
	label var `X'_roads2 "length of `X' road (afirmado, m)"
	label var `X'_roads3 "length of `X' road (sin afirma, m)"
	label var `X'_roads4 "length of `X' road (trocha carrozable, m)"
	label var `X'_roads9 "length of `X' road (in planning, m)"
}
label var local_roads5 "length of local road (under construction, km)"

cd G:\mita\data

summ
save roads, replace

*---Get surface area data

clear
odbc load CODIGO_DIS sarea, table("distr.dbf") dsn("dBASE Files") lowercase
collapse (sum) sarea, by (codigo_dis) /*non-contiguous districts (i.e. include island*/
rename codigo_dis ubigeo
destring ubigeo, replace
sort ubigeo
save temp, replace

*---Merge surface area data
use roads
destring ubigeo, replace
sort ubigeo
merge ubigeo using temp, unique
tab _merge
drop _merge


*recode so that system missings (i.e. no roads) are 0's
foreach X in 1 2 3 4 9 {
	recode local_roads`X' .=0
	recode dep_roads`X' .=0
}

recode local_roads5 .=0

*generate some variables

*total length of local, departmental roads
gen local_t=local_roads1+local_roads2+local_roads3+local_roads4
gen dep_t=dep_roads1+dep_roads2+dep_roads3+dep_roads4

*Density of local and regional roads (all types)
gen	dlocal_t	=	local_t	/sarea
gen	ddep_t	=	dep_t	/sarea

*density of paved and gravel regional roads
gen	ddep_roads1	=	dep_roads1	/sarea
gen	ddep_roads2	=	dep_roads2	/sarea
gen ddep1_2= ddep_roads1+ddep_roads2

keep dlocal_t ddep_t ddep1_2 ubigeo
label var dlocal_t "density of (all) local roads"
label var ddep_t "density of (all) regional roads"
label var ddep_t "density of paved and gravel regional roads"

save roads, replace

/*GIS DATA AND TREATMENT DATA*/

use gis_dist, clear
sort ubigeo
save temp, replace

use roads, clear
sort ubigeo
merge ubigeo using temp, unique
drop if _merge==1 /*not in study region*/
tab _merge 
drop _merge

sum
save roads, replace

***-----Cubic polynomial in latitude and longitude


*Column 1: density of (all) local roads

summ dlocal_t  if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress dlocal_t pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_road, tex less(0) nocons replace bdec(3) adds("Clusters", e(N_clust), Mean Dep. Var., `mean')

*Column 2: density of (all) regional roads


summ ddep_t  if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress ddep_t pothuan_mita x y x2 y2 xy x3 y3 x2y xy2  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_road, tex less(0) nocons append bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')



*Column 3: density of paved and gravel regional roads

summ ddep1_2  if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress  ddep1_2 pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_road, tex less(0) nocons append bdec(3) adds("Clusters", e(N_clust), Mean Dep. Var., `mean')



***-----Single dimensional RD polynomials

*Column 1: density of (all) local roads

 regress dlocal_t pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_road, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

summ dlocal_t  if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress dlocal_t pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_road, tex less(0) nocons replace bdec(3) adds("Clusters", e(N_clust), Mean Dep. Var., `mean')

*Column 2: density of (all) regional roads

 regress ddep_t pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_road, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ ddep_t  if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress ddep_t pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_road, tex less(0) nocons append bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')

*Column 3: density of paved and gravel regional roads

 regress  ddep1_2 pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_road, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ ddep1_2  if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress  ddep1_2 pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_road, tex less(0) nocons append bdec(3) adds("Clusters", e(N_clust), Mean Dep. Var., `mean')






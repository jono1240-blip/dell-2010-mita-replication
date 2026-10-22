********************************************
*This file makes Table 7 (Education)
********************************************
capture log close
clear
clear matrix
set mem 200000
cd G:\mita\data
log using maketable7, replace

/*Data Files Used
	gis_dist.dta
	educ1876.csv
	educ1940.csv
	enaho01a_2001iv_300.dta
	
*Data Files Created as Final Product
	educ1876.dta
	educ1940.dta
	educ2001.dta
	
*Data Files Created as Intermediate Product
	temp.dta*/

*******************************
*----Education 1876
*******************************


insheet using educ1876.csv, clear

gen pop=read+write+neither 
label var pop "population"
gen illit=(neither)/(pop)
gen literate=1-illit
summarize literate
keep literate pop ccdd ccpp ccdi
sort ccdd ccpp ccdi
save educ1876, replace

/*GIS DATA AND TREATMENT DATA*/
use gis_dist, clear
sort ubigeo
save temp, replace

use educ1876, clear
gen ubigeo=ccdi+100*ccpp+10000*ccdd
sort ubigeo
merge ubigeo using temp, unique
tab _merge 
keep if _merge==3
drop _merge
sum
save educ1876, replace


***----Cubic polynomial in latitude and longitude


summ literate  if (d_bnd<50 & cusco!=1) [aweight=pop]
local mean = r(mean)

 regress literate pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_educ, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust), Mean Dep. Var., `mean')


***----Cubic polynomial in distance to Potosi

regress literate pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_educ, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

summ literate  if (d_bnd<50 & cusco!=1) [aweight=pop]
local mean = r(mean)

 regress literate pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_educ, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust), Mean Dep. Var., `mean')


***********************************
*-----Education 1940
***********************************


insheet using educ1940.csv, clear

/*label variables*/
label var educ0_mc "No Instruction Males 6-14"
label var educ0_fc "No Instruction - Females 6-14"	
label var educ0_ma "No Instruction - Males >15"	
label var educ0_fa "No Instruction - Females >15"
label var educ1_m "Basic Primary - males"	
label var educ1_f "Basic Primary - females"	
label var educ2_m "Primary to 2nd grade - males"
label var educ2_f "Primary to 2nd grade - females"
label var educ3_m "Secondary - Males"
label var educ3_f "Secondary - Females"
label var educ4_m "Comercial or Technical - males"	
label var educ4_f "Commercial or technical - females"	
label var educ5_m "Superior - males"
label var educ5_f "Superior - females"

/*create a single measure of education*/

gen educ0=educ0_mc+educ0_fc+educ0_ma+educ0_fa
drop educ0_mc educ0_fc educ0_ma educ0_fa
label var educ0 "# of people with no instrucion"

gen educ1=educ1_m+educ1_f
drop educ1_m educ1_f
label var educ1 "# of people with basic primary education"

gen educ2=educ2_m+educ2_f
drop educ2_m educ2_f
label var educ2 "# of people with advanced primary education"

gen educ3=educ3_m+educ3_f
drop educ3_m educ3_f
label var educ3 "# of people with secondary education"

gen educ4=educ4_m+educ4_f
drop educ4_m educ4_f
label var educ4 "# of people with commercial or technical education"

gen educ5=educ5_m+educ5_f
drop educ5_m educ5_f
label var educ5 "# of people with university education"

gen pop = educ0+educ1+educ2+educ3+educ4+educ5
label var pop "total population of district"

gen edyears=educ0*0+educ1*2+educ2*5+educ3*12+educ4*12+educ5*16
label var edyears "total years of education of district population"

gen mean_educ=edyears/pop
label var mean_educ "mean education of district population"

gen ubigeo=ccdi+100*ccpp+10000*ccdd
egen test=count(ubigeo), by (ubigeo)
tab test

sort ccdd ccpp ccdi
save educ1940, replace

/*GIS AND TREATMENT DATA*/
use gis_dist, clear
sort ubigeo
save temp, replace

use educ1940, clear
sort ubigeo
merge ubigeo using temp, unique
tab _merge 
keep if _merge==3
drop _merge
sum
save educ1940, replace


***----Cubic polynomial in latitude and longitude


 regress mean_educ pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_educ, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust), Mean Dep. Var., `mean')

***----Cubic polynomial in distance to Potosi

regress mean_educ pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_educ, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ mean_educ if (d_bnd<50 & cusco!=1) [aweight=pop]
local mean = r(mean)

 regress mean_educ pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_educ, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust), Mean Dep. Var., `mean')


***********************************
*-----Education 2001
***********************************

use enaho01a_2001iv_300, clear
 
/*fix the discrepancy between whether info recorded as ano (p301b) or grado (p301c)*/
replace p301b=p301c if p301b==0
replace p301b=0 if (p301b==. & p301c==.)
gen educ=.

/*recode for those with incomplete or complete primary*/
replace educ=p301b if (p301a==1)
replace educ=p301b if (p301a==2)
replace educ=p301b if (p301a==3)
replace educ=p301b if (p301a==4)

/*Appears that primary education used to be typically 5 years but within the 
past 30 or so years has become typically six years. Generate a var by district
that is mean # of years of primary education*/
egen mpeduc1=mean(p301b) if p301a==4, by (ubigeo)
tab mpeduc1
egen mpeduc=mean(mpeduc1), by (ubigeo)
replace mpeduc=5.5 if mpeduc==.
drop mpeduc1

/*recode for those with complete or incomplete secondary*/
replace educ=mpeduc+p301b if (p301a==5)
replace educ=mpeduc+p301b if (p301a==6)

/*recode for those with complete or incomplete postsecondary*/
replace educ=mpeduc+5+p301b if (p301a==7)
replace educ=mpeduc+5+p301b if (p301a==8)
replace educ=mpeduc+5+p301b if (p301a==9)
replace educ=mpeduc+5+p301b if (p301a==10)

/*recode educ for those with postgrado*/
replace educ=mpeduc+10+p301b if (p301a==11)

/*literacy system missing for a large portion of the sample*/

/*now keep only needed geographic units*/
gen ccdd=substr(ubigeo, 1, 2)
tab ccdd
gen ccpp=substr(ubigeo, 3, 2)
tab ccpp
gen ccdi=substr(ubigeo, 5, 2)
tab ccdi
destring ccdd, replace
destring ccpp, replace
destring ccdi, replace
keep if (ccdd==3 | ccdd==4 | ccdd==5 | ccdd==8 | ccdd==21)

keep ccdd ccpp ccdi ubigeo conglome vivienda hogar educ codperso 
sort conglome vivienda hogar codperso 
save educ2001, replace

/*GIS DATA AND TREATMENT DATA*/

use gis_dist, clear
sort ubigeo
save temp, replace

use educ2001, clear
destring ubigeo, replace
sort ubigeo
merge ubigeo using temp, uniqusing
tab _merge 
keep if _merge==3
drop _merge
sum
save educ2001, replace


***----Cubic polynomial in latitude and longitude


summ educ if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress educ pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) , /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_educ, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust), Mean Dep. Var., `mean')


***----Cubic polynomial in distance to Potosi

 regress educ pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) , /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_educ, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ educ if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress educ pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) , /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_educ, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust), Mean Dep. Var., `mean')


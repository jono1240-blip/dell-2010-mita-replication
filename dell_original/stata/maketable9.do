************************************************
*This file makes Table 9 (Consumption Channels)
************************************************
capture log close
clear
clear matrix
set mem 300000
cd G:\mita\data
log using maketable9, replace

/*Data Files Used
	gis_dist.dta
	occupation1993.csv
	apurimac-d2.dta
	arequipa-d2.dta
	ayacucho-d2.dta
	cusco-d2.dta
	puno-d2.dta
	apurimac-d4.dta
	arequipa-d4.dta
	ayacucho-d4.dta
	cusco-d4.dta
	puno-d4.dta
	
*Data files created as final products
	occupation1993.dta
	ag_mkts1994.dta
	ag_otherL94.dta
	
*Data Files Created as Intermediate Product
	temp.dta*/
	
*******************************************
**-----1993 Occupation Distribution	
*******************************************	

insheet using occupation1993.csv, clear
gen ag_pesc=.
replace ag_pesc=1 if (cat<599)  /*equal to 1 for ag */
recode ag_pesc (.=0)
replace ag_pesc=ag_pesc*cases


collapse (sum) ag_pesc cases, by(ubigeo)

gen pag_pesc =ag_pesc /cases
summ pag_pesc

label var pag_pesc "% of economically active labor force in agriculture"
sort ubigeo
save occupation1993, replace

/*GIS DATA AND TREATMENT DATA*/

use gis_dist, clear
sort ubigeo
save temp, replace

use occupation1993, clear
sort ubigeo
merge ubigeo using temp, unique
tab _merge 
keep if _merge==3
drop _merge
save occupation1993, replace


***----Cubic polynomial in latitude and longitude


summ pag_pesc  [aw=cases] if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress pag_pesc pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/   bfe4*  [aw=cases] if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_mkt, tex less(0) nocons replace bdec(3) adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


***----Cubic polynomial in distance to Potosi

regress pag_pesc pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4*  [aw=cases] if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_mkt, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

summ pag_pesc  [aw=cases] if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress pag_pesc pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/   bfe4*  [aw=cases] if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_mkt, tex less(0) nocons replace bdec(3) adds("Clusters", e(N_clust), Mean Dep. Var., `mean')
outreg2 pothuan_mita elv_sh slope  using dist3break_mkt8neg, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))


***********************************************
*--Agricultural Market Participation (1994)
***********************************************


use apurimac-d2, clear

*keep only needed vars
keep g01	g02	g03	g09	g10	nropar	b33d1	b33d2	b33d3	b33d4	b33d5 b33d6	b33d7	b33d8 b33d9	b33d10	b33d11	b33d12

*rename vars
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	nropar	num_parcel
rename	b33d1	destino1
rename	b33d2	destino2
rename	b33d3	destino3
rename	b33d4	destino4
rename	b33d5	destino5
rename	b33d6	destino6
rename	b33d7	destino7
rename	b33d8	destino8
rename	b33d9	destino9

foreach X of num 1/9 {
	destring destino`X', replace force
	recode destino`X' 0=.
}

/*gen destination dummies: 1 "venta en la U.A." 2 "consumo en la U.A." 
3 "venta en el mercado" 4 "venta para la semilla"*/

foreach X of num 1/4 {
	gen	d`X'=	.
}

/*note that all of this will be at the plot level - x% of campesinos dedicate
the production of a crop on at least one of their plots primarily to 1/2/3/4*/

foreach X of num 1/9 {
	replace	d1=	1 if destino`X'	==1
	recode d1 .=0 if destino`X'	==2
	recode d1 .=0 if destino`X'	==3
	recode d1 .=0 if destino`X'	==4
	replace	d2=	1 if destino`X'	==2
	recode d2 .=0 if destino`X'	==1
	recode d2 .=0 if destino`X'	==3
	recode d2 .=0 if destino`X'	==4
	replace	d3=	1 if destino`X'	==3
	recode d3 .=0 if destino`X'	==2
	recode d3 .=0 if destino`X'	==1
	recode d3 .=0 if destino`X'	==4
	replace	d4=	1 if destino`X'	==4
	recode d4 .=0 if destino`X'	==2
	recode d4 .=0 if destino`X'	==3
	recode d4 .=0 if destino`X'	==1
}

collapse (max) d1 d2 d3 d4, by (ccdd ccpp ccdi sea cedula)


rename d2 d_venta
label var d_venta "sold part of crop in market"
rename d3 d_consumo
label var d_consumo "consumed part of crop"
rename d4 d_semilla
label var d_semilla "used part of crop for seed"
tab d_venta
tab d_consumo
tab d_semilla

compress
save ag_mkts1994, replace	

use arequipa-d2, clear

*keep only needed vars
keep g01	g02	g03	g09	g10	nropar	b33d1	b33d2	b33d3	b33d4	b33d5 b33d6	b33d7	b33d8 b33d9	b33d10	b33d11	b33d12

*rename vars
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	nropar	num_parcel
rename	b33d1	destino1
rename	b33d2	destino2
rename	b33d3	destino3
rename	b33d4	destino4
rename	b33d5	destino5
rename	b33d6	destino6
rename	b33d7	destino7
rename	b33d8	destino8
rename	b33d9	destino9

foreach X of num 1/9 {
	destring destino`X', replace force
	recode destino`X' 0=.
}

/*gen destination dummies: 1 "venta en la U.A." 2 "consumo en la U.A." 
3 "venta en el mercado" 4 "venta para la semilla"*/

foreach X of num 1/4 {
	gen	d`X'=	.
}

/*note that all of this will be at the plot level - x% of campesinos dedicate
the production of a crop on at least one of their plots primarily to 1/2/3/4*/

foreach X of num 1/9 {
	replace	d1=	1 if destino`X'	==1
	recode d1 .=0 if destino`X'	==2
	recode d1 .=0 if destino`X'	==3
	recode d1 .=0 if destino`X'	==4
	replace	d2=	1 if destino`X'	==2
	recode d2 .=0 if destino`X'	==1
	recode d2 .=0 if destino`X'	==3
	recode d2 .=0 if destino`X'	==4
	replace	d3=	1 if destino`X'	==3
	recode d3 .=0 if destino`X'	==2
	recode d3 .=0 if destino`X'	==1
	recode d3 .=0 if destino`X'	==4
	replace	d4=	1 if destino`X'	==4
	recode d4 .=0 if destino`X'	==2
	recode d4 .=0 if destino`X'	==3
	recode d4 .=0 if destino`X'	==1
}

collapse (max) d1 d2 d3 d4, by (ccdd ccpp ccdi sea cedula)


rename d2 d_venta
label var d_venta "sold part of crop in market"
rename d3 d_consumo
label var d_consumo "consumed part of crop"
rename d4 d_semilla
label var d_semilla "used part of crop for seed"
tab d_venta
tab d_consumo
tab d_semilla

compress
save temp, replace

use ag_mkts1994, clear
append using temp
save ag_mkts1994, replace	

use ayacucho-d2, clear

*keep only needed vars
keep g01	g02	g03	g09	g10	nropar	b33d1	b33d2	b33d3	b33d4	b33d5 b33d6	b33d7	b33d8 b33d9	b33d10	b33d11	b33d12

*rename vars
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	nropar	num_parcel
rename	b33d1	destino1
rename	b33d2	destino2
rename	b33d3	destino3
rename	b33d4	destino4
rename	b33d5	destino5
rename	b33d6	destino6
rename	b33d7	destino7
rename	b33d8	destino8
rename	b33d9	destino9

foreach X of num 1/9 {
	destring destino`X', replace force
	recode destino`X' 0=.
}

/*gen destination dummies: 1 "venta en la U.A." 2 "consumo en la U.A." 
3 "venta en el mercado" 4 "venta para la semilla"*/

foreach X of num 1/4 {
	gen	d`X'=	.
}

/*note that all of this will be at the plot level - x% of campesinos dedicate
the production of a crop on at least one of their plots primarily to 1/2/3/4*/

foreach X of num 1/9 {
	replace	d1=	1 if destino`X'	==1
	recode d1 .=0 if destino`X'	==2
	recode d1 .=0 if destino`X'	==3
	recode d1 .=0 if destino`X'	==4
	replace	d2=	1 if destino`X'	==2
	recode d2 .=0 if destino`X'	==1
	recode d2 .=0 if destino`X'	==3
	recode d2 .=0 if destino`X'	==4
	replace	d3=	1 if destino`X'	==3
	recode d3 .=0 if destino`X'	==2
	recode d3 .=0 if destino`X'	==1
	recode d3 .=0 if destino`X'	==4
	replace	d4=	1 if destino`X'	==4
	recode d4 .=0 if destino`X'	==2
	recode d4 .=0 if destino`X'	==3
	recode d4 .=0 if destino`X'	==1
}

collapse (max) d1 d2 d3 d4, by (ccdd ccpp ccdi sea cedula)


rename d2 d_venta
label var d_venta "sold part of crop in market"
rename d3 d_consumo
label var d_consumo "consumed part of crop"
rename d4 d_semilla
label var d_semilla "used part of crop for seed"
tab d_venta
tab d_consumo
tab d_semilla

compress
save temp, replace

use ag_mkts1994, clear
append using temp
save ag_mkts1994, replace	

use cusco-d2, clear


*keep only needed vars
keep g01	g02	g03	g09	g10	nropar	b33d1	b33d2	b33d3	b33d4	b33d5 b33d6	b33d7	b33d8 b33d9	b33d10	b33d11	b33d12

*rename vars
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	nropar	num_parcel
rename	b33d1	destino1
rename	b33d2	destino2
rename	b33d3	destino3
rename	b33d4	destino4
rename	b33d5	destino5
rename	b33d6	destino6
rename	b33d7	destino7
rename	b33d8	destino8
rename	b33d9	destino9

foreach X of num 1/9 {
	destring destino`X', replace force
	recode destino`X' 0=.
}

/*gen destination dummies: 1 "venta en la U.A." 2 "consumo en la U.A." 
3 "venta en el mercado" 4 "venta para la semilla"*/

foreach X of num 1/4 {
	gen	d`X'=	.
}

/*note that all of this will be at the plot level - x% of campesinos dedicate
the production of a crop on at least one of their plots primarily to 1/2/3/4*/

foreach X of num 1/9 {
	replace	d1=	1 if destino`X'	==1
	recode d1 .=0 if destino`X'	==2
	recode d1 .=0 if destino`X'	==3
	recode d1 .=0 if destino`X'	==4
	replace	d2=	1 if destino`X'	==2
	recode d2 .=0 if destino`X'	==1
	recode d2 .=0 if destino`X'	==3
	recode d2 .=0 if destino`X'	==4
	replace	d3=	1 if destino`X'	==3
	recode d3 .=0 if destino`X'	==2
	recode d3 .=0 if destino`X'	==1
	recode d3 .=0 if destino`X'	==4
	replace	d4=	1 if destino`X'	==4
	recode d4 .=0 if destino`X'	==2
	recode d4 .=0 if destino`X'	==3
	recode d4 .=0 if destino`X'	==1
}

collapse (max) d1 d2 d3 d4, by (ccdd ccpp ccdi sea cedula)


rename d2 d_venta
label var d_venta "sold part of crop in market"
rename d3 d_consumo
label var d_consumo "consumed part of crop"
rename d4 d_semilla
label var d_semilla "used part of crop for seed"
tab d_venta
tab d_consumo
tab d_semilla

compress
save temp, replace

use ag_mkts1994, clear
append using temp
save ag_mkts1994, replace	

use puno-d2, clear


*keep only needed vars
keep g01	g02	g03	g09	g10	nropar	b33d1	b33d2	b33d3	b33d4	b33d5 b33d6	b33d7	b33d8 b33d9	b33d10	b33d11	b33d12

*rename vars
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	nropar	num_parcel
rename	b33d1	destino1
rename	b33d2	destino2
rename	b33d3	destino3
rename	b33d4	destino4
rename	b33d5	destino5
rename	b33d6	destino6
rename	b33d7	destino7
rename	b33d8	destino8
rename	b33d9	destino9

foreach X of num 1/9 {
	destring destino`X', replace force
	recode destino`X' 0=.
}

/*gen destination dummies: 1 "venta en la U.A." 2 "consumo en la U.A." 
3 "venta en el mercado" 4 "venta para la semilla"*/

foreach X of num 1/4 {
	gen	d`X'=	.
}

/*note that all of this will be at the plot level - x% of campesinos dedicate
the production of a crop on at least one of their plots primarily to 1/2/3/4*/

foreach X of num 1/9 {
	replace	d1=	1 if destino`X'	==1
	recode d1 .=0 if destino`X'	==2
	recode d1 .=0 if destino`X'	==3
	recode d1 .=0 if destino`X'	==4
	replace	d2=	1 if destino`X'	==2
	recode d2 .=0 if destino`X'	==1
	recode d2 .=0 if destino`X'	==3
	recode d2 .=0 if destino`X'	==4
	replace	d3=	1 if destino`X'	==3
	recode d3 .=0 if destino`X'	==2
	recode d3 .=0 if destino`X'	==1
	recode d3 .=0 if destino`X'	==4
	replace	d4=	1 if destino`X'	==4
	recode d4 .=0 if destino`X'	==2
	recode d4 .=0 if destino`X'	==3
	recode d4 .=0 if destino`X'	==1
}

collapse (max) d1 d2 d3 d4, by (ccdd ccpp ccdi sea cedula)


rename d2 d_venta
label var d_venta "sold part of crop in market"
rename d3 d_consumo
label var d_consumo "consumed part of crop"
rename d4 d_semilla
label var d_semilla "used part of crop for seed"
tab d_venta
tab d_consumo
tab d_semilla

compress
save temp, replace

use ag_mkts1994, clear
append using temp
save ag_mkts1994, replace	


/*GIS DATA AND TREATMENT DATA*/

use gis_dist, clear
sort ubigeo
save temp, replace

use ag_mkts1994, clear
gen ubigeo=ccdi+100*ccpp+10000*ccdd
sort ubigeo
merge ubigeo using temp, uniqusing
tab _merge 
keep if _merge==3
drop _merge
sum
save ag_mkts1994, replace


use ag_mkts1994, clear


summ d_venta if (d_bnd<50 & cusco!=1)
local mean = r(mean)


***---Cubic polynomila in latitude and longitude

 regress d_venta pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/   bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_mkt, tex less(0) nocons append bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


*---Cubic polynomial in distance to Potosi

 regress d_venta pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_mkt, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Cubic polynomial in distance to the boundary

summ d_venta if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress d_venta pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/   bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_mkt, tex less(0) nocons append bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


**********************************************
*----Household Employment Outside Agricultural Unit
**********************************************

use apurimac-d4A, clear

*keep only needed obs.
keep g01 g02	g03	g09	g10	c110

*rename
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	c110	dejar_trab

*label
label var	dejar_trab	"do you leave your U.A. to work in other activities at any point during the year"

recode dejar_trab 2=0 99=0 .=0
label values dejar_trab noyes
tab dejar_trab

compress
describe
save ag_otherL94, replace	

use arequipa-d4A, clear

*keep only needed obs.
keep g01 g02	g03	g09	g10	c110

*rename
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	c110	dejar_trab

*label
label var	dejar_trab	"do you leave your U.A. to work in other activities at any point during the year"

recode dejar_trab 2=0 99=0 .=0
label values dejar_trab noyes
tab dejar_trab

compress
save temp, replace

use ag_otherL94, clear
append using temp
save ag_otherL94, replace

use ayacucho-d4A, clear

*keep only needed obs.
keep g01 g02	g03	g09	g10	c110

*rename
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	c110	dejar_trab

*label
label var	dejar_trab	"do you leave your U.A. to work in other activities at any point during the year"

recode dejar_trab 2=0 99=0 .=0
label values dejar_trab noyes
tab dejar_trab

compress
save temp, replace

use ag_otherL94, clear
append using temp
save ag_otherL94, replace

use cusco-d4A, clear

*keep only needed obs.
keep g01 g02	g03	g09	g10	c110

*rename
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	c110	dejar_trab

*label
label var	dejar_trab	"do you leave your U.A. to work in other activities at any point during the year"

recode dejar_trab 2=0 99=0 .=0
label values dejar_trab noyes
tab dejar_trab

compress
save temp, replace

use ag_otherL94, clear
append using temp
save ag_otherL94, replace

use puno-d4A.dta, clear

*keep only needed obs.
keep g01 g02	g03	g09	g10	c110

*rename
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	c110	dejar_trab

*label
label var	dejar_trab	"do you leave your U.A. to work in other activities at any point during the year"

recode dejar_trab 2=0 99=0 .=0
label values dejar_trab noyes
tab dejar_trab

compress
save temp, replace

use ag_otherL94, clear
append using temp
save ag_otherL94, replace

/*GIS DATA AND TREATMENT DATA*/

use gis_dist, clear
sort ubigeo
save temp, replace

use ag_otherL94, clear
gen ubigeo=ccdi+100*ccpp+10000*ccdd
sort ubigeo
merge ubigeo using temp, uniqusing
tab _merge 
keep if _merge==3
drop _merge
sum
save ag_otherL94, replace


use ag_otherL94, clear

***---Cubic polynomial in latitude and longitude

summ dejar_trab if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress dejar_trab pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope  /*
*/   bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_mkt, tex less(0) nocons append bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')

***---Cubic polynomial in distance to Potosi

 regress dejar_trab pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_mkt, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Cubic polynomial in distance to the boundary

summ dejar_trab  if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress dejar_trab pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/   bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_mkt, tex less(0) nocons append bdec(3) adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


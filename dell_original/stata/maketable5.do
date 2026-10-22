***********************************************************
*Prepares 1572-1573 Toledo tribute data for analysis
*Creates Table 5 
***********************************************************
clear
capture log close
cd G:\mita\data
log using maketable5, replace

/*Data Files Used
	tribute1572.dta
	gis_dist.dta
	1572budget.csv
	1572demographic.csv
	
*Data Files Created as Final Product
	spec_check1572.dta
	budget1572.dta
	dem1572.dta

*Data Files Created as Intermediate Product
	temp*/
	

*************************************
**----Mean Per Capita Tribute
*************************************

insheet using tribute1572.csv, clear

*label variables
label var	poblado	"centro poblado"
label var eid "encomienda id"
label var	ccdd	"department"
label var	ccpp	"province"
label var	ccdi	"district"
label var	trib_pop	"Tributary Pop."
label var	oro	"Oro"
label var	plata	"Plata"
label var	ropa_abasca	"ropa de abasca"
label var	carnero	"Carneros de la tierra"
label var	ropa_algadon	"ropa de algadon"
label var	chuno	"chuno"
label var	maiz	"maiz"
label var	hechura	"hechura"
label var	aves	"aves"
label var	pescado	"pescado seco"
label var	costales	"costales"
label var	papas	"papas"
label var	pacos	"pacos"
label var	trigo	"trigo"
label var	ropa_cumbi	"ropa de cumbi"
label var	puercos	"puercos"
label var	alpargatas	"alpargatas"
label var	cebada	"cebada"
label var	sal	"sal"
label var yana "yanacona"

/*convert all numerical vars to byte*/
destring ccdd, replace
destring ccpp, replace
destring ccdi, replace

/*recode tribute type vars so that system missing is changed to zero*/
recode	oro	.=0
recode	plata	.=0
recode	ropa_abasca	.=0
recode	carnero	.=0
recode	ropa_algadon .=0
recode	chuno .=0
recode	maiz	.=0
recode	hechura	.=0
recode	aves	.=0
recode	pescado	.=0
recode	costales .=0
recode	papas .=0
recode	pacos .=0
recode	trigo .=0
recode	ropa_cumbi .=0
recode	puercos .=0
recode	alpargatas .=0
recode	cebada .=0
recode	sal .=0

gen trib_tot= oro+plata+ropa_abasca	+carnero+ropa_algadon+chuno+maiz+hechura+aves/*
*/+pescado+costales+papas+pacos+trigo+ropa_cumbi+puercos+alpargatas+cebada+sal

/*drop yanaconas (special religious servant tribute category)*/
drop if yana==1

gen num=1

/*aggregate encomiendas by district*/
collapse (sum) trib_pop	num oro	plata	ropa_abasca	carnero	ropa_algadon chuno /*
*/maiz	hechura	aves	pescado	costales	papas	pacos	trigo	ropa_cumbi	/*
*/puercos	alpargatas	cebada	sal	trib_tot match_pcap, by (ccdd ccpp ccdi)

gen trib_rate=trib_tot/trib_pop

/*take log of the tribute rate*/

gen ltrib_rate=ln(trib_rate)

sort ccdd ccpp ccdi
save spec_check1572, replace

*MERGE WITH GIS AND TREATMENT DATA

use gis_dist, clear
sort ubigeo
save temp, replace

use spec_check1572, clear
gen ubigeo=ccdi+100*ccpp+10000*ccdd
sort ubigeo
merge ubigeo using temp, unique
tab _merge 
keep if _merge==3
drop _merge
sum
save spec_check1572, replace


use spec_check1572, clear

***---Cubic polynomial in latitude and longitude

 regress ltrib_rate pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_trib, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

***---Cubic polynomial in distance to Potosi
 regress ltrib_rate pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_trib, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

***---Cubic polynomial in distance to the mita boundary

summ ltrib_rate if (d_bnd<50 & cusco!=1)  [aw=trib_pop]
local mean = r(mean)


 regress ltrib_rate pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50)  [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_trib, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust),Mean Dep. Var., `mean')

*****************************
**----Budget
*****************************

insheet using 1572budget.csv, clear

destring  construct_church, replace
collapse (sum) priest justice cacique construct hospital, by(ccdd ccpp ccdi)
egen admin=rowtotal( priest justice cacique construct hospital)
sort ccdd ccpp ccdi
save temp, replace

use spec_check1572, clear
keep if d_bnd<100
sort ccdd ccpp ccdi 
mmerge ccdd ccpp ccdi using temp, type(1:1)
keep if _merge==3
drop _merge
keep if admin<.
gen extraction=trib_tot-admin
summ extraction
label var extraction "pesos extracted by encomenderos"

gen sh_priest=priest/trib_tot
gen sh_justice=justice/trib_tot
gen sh_cacique=cacique/trib_tot
gen sh_extract=extraction/trib_tot

summ sh_priest sh_justice sh_cacique sh_extract, detail
sort ccdd ccpp ccdi
save budget1572, replace


use budget1572, clear

***----Cubic polynomial in latitude and longitude


 regress sh_extract pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


 regress sh_priest pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


 regress sh_justice pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


 regress sh_cacique pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Single dimensional RD polynomials

 regress sh_extract pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ sh_extract if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress sh_extract pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust),Mean Dep. Var., `mean')

 regress sh_priest pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ sh_priest if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress sh_priest pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust),Mean Dep. Var., `mean')

 regress sh_justice pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ sh_justice if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress sh_justice pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust),Mean Dep. Var., `mean')

 regress sh_cacique pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ sh_cacique if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress sh_cacique pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust),Mean Dep. Var., `mean')



**************************************
**----Demographics
**************************************

insheet using 1572demographic.csv, clear

collapse (sum) trib_pop old_men boys women tot_other, by(ccdd ccpp ccdi)

egen total_pop=rowtotal( trib_pop old_men boys women) 
egen temp=rowtotal(trib_pop tot_other)
replace total_pop=temp if total_pop==.
drop temp

gen sh_trib=trib_pop/total_pop
gen sh_oldmen=old_men/total_pop
gen sh_boys=boys/total_pop
gen sh_women=women/total_pop
sort ccdd ccpp ccdi
save temp, replace


use spec_check1572, clear
keep if d_bnd<100
keep pothuan_mita elv_sh slope dpot dpot2 dbnd_sh dbnd_sh2 /*
*/ bfe4* cusco ubigeo d_bnd ccdd ccpp ccdi x* y*
sort ccdd ccpp ccdi 
mmerge ccdd ccpp ccdi using temp, type(1:1)
keep if _merge==3
drop _merge
keep if sh_trib<.
save dem1572, replace


use dem1572, clear

***----RD polynomials in latitude and longitude


 regress sh_trib pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/   bfe4* if (cusco!=1 & d_bnd<50) [aw=total_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


 regress sh_boys pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=total_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


 regress sh_women pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=total_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***----Single dimensional RD polynomials

g dpot3=dpot^3

g dbnd_sh3=dbnd_sh^3

 regress sh_trib pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/   bfe4* if (cusco!=1 & d_bnd<50) [aw=total_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


summ sh_trib if (d_bnd<50 & cusco!=1) [aw=total_pop]
local mean = r(mean)

 regress sh_trib pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=total_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust),Mean Dep. Var., `mean')

 regress sh_boys pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=total_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ sh_boys if (d_bnd<50 & cusco!=1) [aw=total_pop]
local mean = r(mean)

 regress sh_boys pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=total_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust),Mean Dep. Var., `mean')

 regress sh_women pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=total_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ sh_women if (d_bnd<50 & cusco!=1) [aw=total_pop]
local mean = r(mean)

 regress sh_women pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=total_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_trib, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust),Mean Dep. Var., `mean')



log close

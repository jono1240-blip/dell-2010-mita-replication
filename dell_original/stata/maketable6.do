********************************************
*This file makes Table 6 (Haciendas)
********************************************
capture log close
clear
clear matrix
set mem 200000
cd G:\mita\data
log using maketable6, replace

/*Data Files Used
	hacienda1689.csv
	hacienda1845.csv
	hacienda1940.csv
	apurimac-d2.dta
	arequipa-d2.dta
	ayacucho-d2.dta
	cusco-d2.dta
	puno-d2.dta
	
*Data Files Created as Final Product
	hacienda1689.dta
	hacienda1845.dta
	hacienda1940.dta
	land_dist94.dta
	
*Data Files Created as Intermediate Product
	temp.dta*/


*************************
*HACIENDAS 1689
*************************

insheet using hacienda1689.csv, clear
/*add up parishes by district - num_hac gives the # of haciendas per parish, the hacienda*
	variables give the number of peasants attached to each hacienda in the parish, when this
	information is available*/
collapse (sum) num_hac hacienda* pop, by (ccdd ccpp ccdi)
foreach X of num 1/20 {
	tab hacienda`X'
}

reshape long hacienda, i(ccdd ccpp ccdi) j(hac_code) 

rename hacienda mean_hlf
recode num_hac .=0

collapse (mean) num_hac pop mean_hlf, by (ccdd ccpp ccdi)

gen hac_pc=num_hac/(pop/1000)
label var hac_pc "haciendas per 1000 inhabitants"
summarize hac_pc

label var ccdd "department code"
label var ccpp "province code"
label var ccdi "district code"
label var num_hac "# of haciendas in parish"
label var mean_hlf "mean Indians per hacienda in parish"

sort ccdd ccpp ccdi
save hacienda1689, replace

/*GIS DATA AND TREATMENT DATA*/

use gis_dist, clear
sort ubigeo
save temp, replace

use hacienda1689, clear
gen ubigeo=ccdi+100*ccpp+10000*ccdd
sort ubigeo
merge ubigeo using temp, unique
tab _merge 
keep if _merge==3
drop _merge
sum
save hacienda1689, replace


***---Cubic polynomial in latitude and longitude

 regress num_hac pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		

summ num_hac if (d_bnd<50 & cusco!=1)
local mean = r(mean)

outreg2 pothuan_mita elv_sh slope  using latlon3_hac, tex less(0) nocons replace bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')
	
 regress hac_pc pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		

summ hac_pc if (d_bnd<50 & cusco!=1)
local mean = r(mean)

outreg2 pothuan_mita elv_sh slope  using latlon3_hac, tex less(0) nocons append bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


***---Single dimensional RD polynomials

use hacienda1689, clear

 regress num_hac pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_hac, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

summ num_hac if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress num_hac pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_hac, tex less(0) nocons replace bdec(3) adds("Clusters", e(N_clust), Mean Dep. Var., `mean')

	
 regress hac_pc pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_hac, tex less(0) nocons append bdec(3) adds("Clusters", e(N_clust), Mean Dep. Var., `mean')

summ hac_pc if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress hac_pc pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_hac, tex less(0) nocons append bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


*************************
*HACIENDAS 1845
*************************

insheet using hacienda1845.csv, clear

/* Dates
	Abancay - 1845
	Paucartambo - 1850
	Aymaraes - 1845
	Urubamba - 1845
	Calca y Lares - 1845
	Anta - 1845
	Quispicanchis - 1845
	Paruro - 1850
	Cotabambas - 1845
	Canas y Canchis - 1845
	Chumbivilcas - 1846
	*/
	drop repartimiento
reshape wide hac_fl comm_fl, i(rep_id) j(year) 

gen hac_fl=	hac_fl1845
gen comm_fl=	comm_fl1845

replace hac_fl=	hac_fl1850	if hac_fl1845==.
replace comm_fl=	comm_fl1850	if comm_fl1845==.

replace hac_fl=	hac_fl1846	if (hac_fl1845==.	& hac_fl1850==.)
replace comm_fl=	comm_fl1846	if (comm_fl1845==.	& comm_fl1850==.)


gen lf_pop=hac_fl+comm_fl

collapse (sum) hac_fl	comm_fl lf_pop, by (ccdd ccpp ccdi)

/*generate % vars for haciendas*/
gen ptlf_hac=(hac_fl)/(hac_fl+ comm_fl)
tab ptlf_hac

*label vars
label var	ccdd	"department code"
label var	ccpp	"province code"
label var	ccdi	"district code"
label var	hac_fl	"labor force in hacienas - later"
label var	comm_fl	"labor force in communities - later"
label var ptlf_hac "% of tributary labor force in haciendas"
label var lf_pop "labor force population"

describe
keep ptlf_hac lf_pop ccdd ccpp ccdi
sort ccdd ccpp ccdi
save hacienda1845, replace


/*GIS DATA AND TREATMENT DATA*/

use gis_dist, clear
sort ubigeo
save temp, replace

use hacienda1845, clear
gen ubigeo=ccdi+100*ccpp+10000*ccdd
sort ubigeo
merge ubigeo using temp, unique
tab _merge 
keep if _merge==3
drop _merge
sum
save hacienda1845, replace


use hacienda1845, clear


***----Cubic polynomial in latitude and longitude

summ ptlf_hac if (d_bnd<50 & cusco!=1) [aw= lf_pop]
local mean = r(mean)

 regress ptlf_hac pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_hac, tex less(0) nocons append bdec(3) adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


***----Single dimensional RD polynomials

 regress ptlf_hac pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4*  if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_hac, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ ptlf_hac if (d_bnd<50 & cusco!=1) [aw= lf_pop]
local mean = r(mean)

 regress ptlf_hac pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_hac, tex less(0) nocons append bdec(3) adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


*****************************
*---Haciendas 1940
*****************************

insheet using hacienda1940.csv, clear

/*PREPARE FOR ANALYSIS*/
gen hacienda=.
gen estancia=.
gen comm_parc=.
gen pueblo=.
gen otro=.

replace hacienda=1 if (categoria=="hacienda" | categoria=="anexo")
recode hacienda .=0
tab hacienda

replace estancia=1 if (categoria=="estancia" | categoria=="finca" | categoria=="fundo")
recode estancia .=0
tab estancia

replace comm_parc=1 if (categoria=="communidad" | categoria=="ayllo" | categoria=="parcialidad")
recode comm_parc .=0
tab comm_parc

replace pueblo=1 if (categoria=="barrio" | categoria=="pueblo" | categoria=="villa" | categoria=="ciudad" | categoria=="aldea")
recode pueblo .=0
tab pueblo

replace otro=1 if (categoria=="campamento" | categoria=="caserio" | categoria=="lavadero"	| categoria=="mina"	| categoria=="otra"	| categoria=="pago"	| categoria=="puesto"	|categoria=="salinera"	| categoria=="tambo")
recode otro .=0
tab otro

gen hacienda_lf=.
gen estancia_lf=.
gen comm_parc_lf=.
gen pueblo_lf=.
gen otro_lf=.

replace hacienda_lf=population if hacienda==1
replace estancia_lf=population if estancia==1
replace comm_parc_lf=population if comm_parc==1
replace pueblo_lf=population if pueblo==1
replace otro_lf=population if otro==1

collapse (sum) hacienda_lf estancia_lf comm_parc_lf pueblo_lf otro_lf population, by (ccdd ccpp ccdi)

gen hacienda_prlf=hacienda_lf/(population-pueblo_lf) /*the missing obs. is an entirely 
	urban district - i.e. there is no rural labor force so the denominator is zero*/

gen rural_lf=hacienda_lf + estancia_lf + comm_parc_lf

label var hacienda_prlf "% of r.l.f. in district in haciendas"
sort ccdd ccpp ccdi
save hacienda1940, replace

/*GIS DATA AND TREATMENT DATA*/

use gis_dist, clear
sort ubigeo
save temp, replace

use hacienda1940, clear
gen ubigeo=ccdi+100*ccpp+10000*ccdd
sort ubigeo
merge ubigeo using temp, unique
tab _merge 
keep if _merge==3
drop _merge
sum
save hacienda1940, replace



***---Cubic polynomial in latitude and longitude


summ hacienda_prlf if (d_bnd<50 & cusco!=1) [aw=rural_lf]
local mean = r(mean)

 regress hacienda_prlf pothuan_mita x y x2 y2 xy x3 y3 x2y xy2  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_hac, tex less(0) nocons append bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


***---Single dimensional RD polynomials

use hacienda1940, clear

 regress hacienda_prlf pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_hac, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ hacienda_prlf if (d_bnd<50 & cusco!=1) [aw=rural_lf]
local mean = r(mean)

 regress hacienda_prlf pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_hac, tex less(0) nocons append bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


*************************************
*---Land Gini, 1994
*************************************
clear
clear matrix
set mem 300000
use apurimac-d2, clear

*keep only needed vars
keep g01	g02	g03	g09	g10	w33b1	w33b2	w33b3	w33b4	w33b5	w33b6	w33b7	w33b8	w33b9	w34a	w35a	w36a	w37a	w37b	w38	w39	numua

*rename vars
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	w33b1	plot_size1
rename	w33b2	plot_size2
rename	w33b3	plot_size3
rename	w33b4	plot_size4
rename	w33b5	plot_size5
rename	w33b6	plot_size6
rename	w33b7	plot_size7
rename	w33b8	plot_size8
rename	w33b9	plot_size9
rename	w34a	sc_sembra /*not under cultivation - going to be harvested*/
rename	w35a	sc_nosembra /*not under cultivation - not going to be harvested*/
rename	w36a	descanso /*fallowing*/
rename	w37a	pastos_m /*maintained pastures*/
rename	w37b	pastos_no_m /*natural pastures*/

foreach X in sc_sembra sc_nosembra descanso pastos_m pastos_no_m {
	destring `X', replace force
	recode `X' .=0
}

foreach X of num 1/9 {
	destring plot_size`X', replace force
}

/*total land currently devoted to cultivation*/
quietly gen sembra=plot_size1 + plot_size2 + plot_size3 + plot_size4 + plot_size5 + plot_size6 + plot_size7 + plot_size8 + plot_size9

/*total land area - don't count woods and wild pasture*/
quietly gen sup_pnm= sembra+ sc_sembra+ sc_nosembra+ descanso+ pastos_m

collapse (sum) sup_pnm, by (ccdd ccpp ccdi sea cedula)


/*label vars*/
label var	ccdd	"department"
label var	ccpp 	"province"
label var	ccdi	"district"
label var	sea	"S.E.A."
label var	cedula	"cedula"
label var	sup_pnm	"total land area of the unidad agropecuario, less woods and wild pasture"

compress
save land_dist94, replace

use arequipa-d2, clear



*keep only needed vars
keep g01	g02	g03	g09	g10	w33b1	w33b2	w33b3	w33b4	w33b5	w33b6	w33b7	w33b8	w33b9	w34a	w35a	w36a	w37a	w37b	w38	w39	numua

*rename vars
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	w33b1	plot_size1
rename	w33b2	plot_size2
rename	w33b3	plot_size3
rename	w33b4	plot_size4
rename	w33b5	plot_size5
rename	w33b6	plot_size6
rename	w33b7	plot_size7
rename	w33b8	plot_size8
rename	w33b9	plot_size9
rename	w34a	sc_sembra /*not under cultivation - going to be harvested*/
rename	w35a	sc_nosembra /*not under cultivation - not going to be harvested*/
rename	w36a	descanso /*fallowing*/
rename	w37a	pastos_m /*maintained pastures*/
rename	w37b	pastos_no_m /*natural pastures*/

foreach X in sc_sembra sc_nosembra descanso pastos_m pastos_no_m {
	destring `X', replace force
	recode `X' .=0
}

foreach X of num 1/9 {
	destring plot_size`X', replace force
}


/*total land currently devoted to cultivation*/
quietly gen sembra=plot_size1 + plot_size2 + plot_size3 + plot_size4 + plot_size5 + plot_size6 + plot_size7 + plot_size8 + plot_size9

/*total land area - don't count woods and wild pasture*/
quietly gen sup_pnm= sembra+ sc_sembra+ sc_nosembra+ descanso+ pastos_m

collapse (sum) sup_pnm, by (ccdd ccpp ccdi sea cedula)


/*label vars*/
label var	ccdd	"department"
label var	ccpp 	"province"
label var	ccdi	"district"
label var	sea	"S.E.A."
label var	cedula	"cedula"
label var	sup_pnm	"total land area of the unidad agropecuario, less woods and wild pasture"

compress
save temp, replace

use land_dist94, clear
append using temp
save land_dist94, replace

use cusco-d2, clear



*keep only needed vars
keep g01	g02	g03	g09	g10	w33b1	w33b2	w33b3	w33b4	w33b5	w33b6	w33b7	w33b8	w33b9	w34a	w35a	w36a	w37a	w37b	w38	w39	numua

*rename vars
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	w33b1	plot_size1
rename	w33b2	plot_size2
rename	w33b3	plot_size3
rename	w33b4	plot_size4
rename	w33b5	plot_size5
rename	w33b6	plot_size6
rename	w33b7	plot_size7
rename	w33b8	plot_size8
rename	w33b9	plot_size9
rename	w34a	sc_sembra /*not under cultivation - going to be harvested*/
rename	w35a	sc_nosembra /*not under cultivation - not going to be harvested*/
rename	w36a	descanso /*fallowing*/
rename	w37a	pastos_m /*maintained pastures*/
rename	w37b	pastos_no_m /*natural pastures*/

foreach X in sc_sembra sc_nosembra descanso pastos_m pastos_no_m {
	destring `X', replace force
	recode `X' .=0
}

foreach X of num 1/9 {
	destring plot_size`X', replace force
}


/*total land currently devoted to cultivation*/
quietly gen sembra=plot_size1 + plot_size2 + plot_size3 + plot_size4 + plot_size5 + plot_size6 + plot_size7 + plot_size8 + plot_size9

/*total land area - don't count woods and wild pasture*/
quietly gen sup_pnm= sembra+ sc_sembra+ sc_nosembra+ descanso+ pastos_m

collapse (sum) sup_pnm, by (ccdd ccpp ccdi sea cedula)


/*label vars*/
label var	ccdd	"department"
label var	ccpp 	"province"
label var	ccdi	"district"
label var	sea	"S.E.A."
label var	cedula	"cedula"
label var	sup_pnm	"total land area of the unidad agropecuario, less woods and wild pasture"

compress
save temp, replace

use land_dist94, clear
append using temp
save land_dist94, replace

use puno-d2, clear


*keep only needed vars
keep g01	g02	g03	g09	g10	w33b1	w33b2	w33b3	w33b4	w33b5	w33b6	w33b7	w33b8	w33b9	w34a	w35a	w36a	w37a	w37b	w38	w39	numua

*rename vars
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	w33b1	plot_size1
rename	w33b2	plot_size2
rename	w33b3	plot_size3
rename	w33b4	plot_size4
rename	w33b5	plot_size5
rename	w33b6	plot_size6
rename	w33b7	plot_size7
rename	w33b8	plot_size8
rename	w33b9	plot_size9
rename	w34a	sc_sembra /*not under cultivation - going to be harvested*/
rename	w35a	sc_nosembra /*not under cultivation - not going to be harvested*/
rename	w36a	descanso /*fallowing*/
rename	w37a	pastos_m /*maintained pastures*/
rename	w37b	pastos_no_m /*natural pastures*/

foreach X in sc_sembra sc_nosembra descanso pastos_m pastos_no_m {
	destring `X', replace force
	recode `X' .=0
}

foreach X of num 1/9 {
	destring plot_size`X', replace force
}


/*total land currently devoted to cultivation*/
quietly gen sembra=plot_size1 + plot_size2 + plot_size3 + plot_size4 + plot_size5 + plot_size6 + plot_size7 + plot_size8 + plot_size9

/*total land area - don't count woods and wild pasture*/
quietly gen sup_pnm= sembra+ sc_sembra+ sc_nosembra+ descanso+ pastos_m

collapse (sum) sup_pnm, by (ccdd ccpp ccdi sea cedula)


/*label vars*/
label var	ccdd	"department"
label var	ccpp 	"province"
label var	ccdi	"district"
label var	sea	"S.E.A."
label var	cedula	"cedula"
label var	sup_pnm	"total land area of the unidad agropecuario, less woods and wild pasture"

compress
save temp, replace

use land_dist94, clear
append using temp
save land_dist94, replace

use ayacucho-d2, clear



*keep only needed vars
keep g01	g02	g03	g09	g10	w33b1	w33b2	w33b3	w33b4	w33b5	w33b6	w33b7	w33b8	w33b9	w34a	w35a	w36a	w37a	w37b	w38	w39	numua

*rename vars
rename	g01	ccdd
rename	g02	ccpp 
rename	g03	ccdi
rename	g09	sea
rename	g10	cedula
rename	w33b1	plot_size1
rename	w33b2	plot_size2
rename	w33b3	plot_size3
rename	w33b4	plot_size4
rename	w33b5	plot_size5
rename	w33b6	plot_size6
rename	w33b7	plot_size7
rename	w33b8	plot_size8
rename	w33b9	plot_size9
rename	w34a	sc_sembra /*not under cultivation - going to be harvested*/
rename	w35a	sc_nosembra /*not under cultivation - not going to be harvested*/
rename	w36a	descanso /*fallowing*/
rename	w37a	pastos_m /*maintained pastures*/
rename	w37b	pastos_no_m /*natural pastures*/

foreach X in sc_sembra sc_nosembra descanso pastos_m pastos_no_m {
	destring `X', replace force
	recode `X' .=0
}

foreach X of num 1/9 {
	destring plot_size`X', replace force
}


/*total land currently devoted to cultivation*/
quietly gen sembra=plot_size1 + plot_size2 + plot_size3 + plot_size4 + plot_size5 + plot_size6 + plot_size7 + plot_size8 + plot_size9

/*total land area - don't count woods and wild pasture*/
quietly gen sup_pnm= sembra+ sc_sembra+ sc_nosembra+ descanso+ pastos_m

collapse (sum) sup_pnm, by (ccdd ccpp ccdi sea cedula)


/*label vars*/
label var	ccdd	"department"
label var	ccpp 	"province"
label var	ccdi	"district"
label var	sea	"S.E.A."
label var	cedula	"cedula"
label var	sup_pnm	"total land area of the unidad agropecuario, less woods and wild pasture"

compress
save temp, replace

use land_dist94, clear
append using temp

/*CONSTRUCT LAND GINIS BY DISTRICT*/

quietly gen ubigeo=ccdi+100*ccpp+10000*ccdd
quietly ineqdeco sup_pnm, bygroup(ubigeo) summarize
quietly gen tl_gini=.
foreach X in 30101	30102	30103	30104	30105	30106	30107	30108	30109	30201	30202	30203	30204	30205	30206	30207	30208	30209	30210	30211	30212	30213	30214	30215	30216	30217	30218	30301	30302	30303	30304	30305	30306	30307	30401	30402	30403	30404	30405	30406	30407	30408	30409	30410	30411	30412	30413	30414	30415	30416	30417	30501	30502	30503	30504	30505	30601	30602	30603	30604	30605	30606	30607	30608	30701	30702	30703	30704	30705	30706	30707	30708	30709	30710	30711	30712	30713	30714	/*															
	*/ 40306	40402	40403	40404	40405	40406	40408	40409	40410	40411	40412	40414	40501	40502	40503	40504	40505	40506	40507	40508	40509	40510	40511	40512	40513	40514	40515	40516	40517	40518	40519	40601	40602	40603	40604	40605	40607	40608	40801	40802	40803	40804	40805	40806	40807	40808	40809	40810	40811 /*																																													
	*/ 50101	50102	50103	50104	50105	50106	50107	50108	50109	50110	50111	50112	50113	50114	50201	50202	50203	50204	50205	50206	50301	50302	50303	50304	50601	50602	50603	50604	50605	50606	50607	50608	50609	50610	50611	50612	50613	50614	50615	50616	50617	50618	50619	50620	50621	50701	50702	50703	50704	50705	50706	50707	50708	50801	50802	50803	50804	50805	50806	50807	50808	50809	50810	50901	50902	50903	50904	50905	50906	50907	50908	50909	50910	50911	51001	51002	51003	51004	51005	51006	51007	51008	51009	51010	51011	51012	51101	51102	51103	51104	51105	51106	51107	51108 /*
	*/ 80101	80102	80103	80104	80105	80106	80107	80201	80202	80203	80204	80205	80206	80207	80301	80302	80303	80304	80305	80306	80307	80308	80309	80401	80402	80403	80404	80405	80406	80407	80501	80502	80503	80504	80505	80506	80507	80508	80601	80602	80603	80604	80605	80606	80607	80608	80701	80702	80703	80704	80705	80706	80707	80708	80801	80802	80803	80804	80805	80806	80807	81001	81002	81003	81004	81005	81006	81007	81008	81009	81102	81103	81104	81105	81201	81202	81204	81205	81206	81207	81208	81209	81210	81211	81212	81301	81302	81303	81304	81305	81306	81307 /*		
	*/ 210101	210102	210103	210104	210105	210106	210107	210108	210109	210110	210111	210112	210113	210114	210115	210201	210202	210203	210204	210205	210206	210207	210208	210209	210210	210211	210212	210213	210214	210215	210301	210302	210303	210304	210305	210306	210307	210308	210310	210401	210402	210403	210404	210405	210406	210407	210501	210502	210503	210504	210505	210601	210602	210603	210604	210605	210606	210607	210608	210701	210702	210703	210704	210705	210706	210707	210708	210709	210710	210801	210802	210803	210804	210805	210806	210807	210808	210809	210901	210902	210903	210904	211001	211002	211003	211004	211005	211101	211102	211103	211104	211201	{	    
	quietly replace tl_gini=r(gini_`X') if ubigeo==`X'
}

collapse (mean) tl_gini, by (ubigeo)
save land_dist94, replace

/*GIS DATA AND TREATMENT DATA*/

use gis_dist, clear
sort ubigeo
save temp, replace

use land_dist94, clear
sort ubigeo
merge ubigeo using temp, unique
tab _merge 
keep if _merge==3
drop _merge
sum
save land_dist94, replace



***----Cubic polynomial in latitude and longitude


summ tl_gini if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress tl_gini pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_hac, tex less(0) nocons append bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


***----Single dimensional RD polynomials

use land_dist94, clear

 regress tl_gini pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dpot_hac, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

summ tl_gini if (d_bnd<50 & cusco!=1)
local mean = r(mean)

 regress tl_gini pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd_hac, tex less(0) nocons append bdec(3)  adds("Clusters", e(N_clust), Mean Dep. Var., `mean')


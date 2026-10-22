***************************
*This file makes Table 2
***************************
capture log close
clear
set mem 200000
cd G:\mita\data
log using maketable2, replace

/*Data Files Used
	enaho01_2001iv_200.dta
	sumaria_2001iv.dta
	enaho01b_2001iv.dta
	gis_dist.dta
	ctalla.dta
		
*Data Files Created as Final Product
	consumption.dta
	height.dta
	
*Data Files Created as Intermediate Product
	temp.dta
*/

***********************************
**---Household Consumption
***********************************

*HOUSEHOLD IDS

/*first get household and identifier codes and data on age and sex of members*/

use enaho01_2001iv_200, clear
keep conglome	vivienda	hogar	ubigeo p203	p207	p208a	p208b

drop if p203==0 /*people who were in the panel before but not in household anymore*/

recode p208b .=0
gen age= p208a + (p208b/12)
drop p208a p208b
tab age

rename 	p203	hhead
rename 	p207	male
recode hhead 2/10=0
egen test=sum(hhead), by (conglome vivienda hogar)
tab test
drop test
recode male 2=0

label var	conglome	"conglomerado"
label var	vivienda	"vivienda"
label var	hogar	"hogar"
label var	ubigeo	"ubicacion geografica"
label var	hhead	"household head"
label var	male	"male"

label define noyes 0 no 1 yes
label values hhead noyes

label define gender 0 female 1 male
label values male gender

/*delete departments not in sample*/
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

save consumption, replace


*HOUSEHOLD CONSUMPTION NET TRANSFERS PER EQUIVALENT MEMBER

*generate a unique household identifier
gen hid = conglome + vivienda + hogar
label var hid "household identifier"

*create a variable which contains the number of members per household
gen var1=1
egen hhmem=sum (var1), by (hid)
tab hhmem
label var hhmem "number of household members"
drop var1
gen lhhmem=ln(hhmem)
label var lhhmem "log number of household members"

*create an age category var
gen age_cat=age
recode age_cat 0/14=1
recode age_cat 15/9999=2
tab age_cat, gen(ac)
egen kids=sum(ac1), by (hid)
drop ac*
tab kids
label var kids "# hh members aged 0 through 14"
gen k_hhmem=kids/hhmem
label var k_hhmem "kids/household members"
drop age_cat

/*(Deaton values)*/
gen age_cat=age
recode age_cat 0/4=1
recode age_cat 5/14=2
recode age_cat 15/9999=3
tab age_cat
label var age_cat "age category"
tab age_cat, gen(ac)
egen infants=sum(ac1), by (hid)
egen children=sum(ac2), by (hid)
egen adults=sum(ac3), by (hid)

*babies count as .4, children as .5, and adults as 1
recode age_cat 1=.4 2=.5 3=1
tab age_cat
egen ces = sum(age_cat), by(hid)
summarize ces
drop age_cat
drop ac*

save consumption, replace

/*HOUSEHOLD CONSUMPTION*/

use sumaria_2001iv, clear

keep conglome	vivienda	hogar	ubigeo	factorto gashog2d /*
*/defesp ingtexhd ingtrahd gru13hd1 gru13hd2 gru13hd3 /*
*/gru23hd1 gru23hd2 gru33hd1 gru33hd2 gru43hd1 gru43hd2 gru53hd1 gru53hd2 /*
*/gru63hd1  gru63hd2 gru73hd1 gru73hd2 gru83hd1 gru83hd2

*Definition of aggregate household consumption
/*GASHOG2D = G05HD + IG06HD + G07HD + IG08HD + SG23 + SIG24 +
GRU11HD + GRU12HD1 + GRU12HD2 + GRU13HD1 +
GRU13HD2 + GRU13HD3 + GRU21HD + GRU22HD1 +
GRU22HD2 + GRU23HD1 + GRU23HD2 + GRU23HD3 +
GRU24HD + GRU31HD + GRU32HD1 + GRU32HD2 +
GRU33HD1 + GRU33HD2 + GRU33HD3 + GRU34HD +
GRU41HD + GRU42HD1 + GRU42HD2 + GRU43HD1 +
GRU43HD2 + GRU43HD3 + GRU44HD + GRU51HD +
GRU52HD1 + GRU52HD2 + GRU53HD1 + GRU53HD2 +
GRU53HD3 + GRU54HD + GRU61HD + GRU62HD1 +
GRU62HD2 + GRU63HD1 + GRU63HD2 + GRU63HD3 +
GRU64HD + GRU71HD + GRU72HD1 + GRU72HD2 +
GRU73HD1 + GRU73HD2 + GRU73HD3 + GRU74HD +
GRU81HD + GRU82HD1 + GRU82HD2 + GRU83HD1 +
GRU83HD2 + GRU83HD3 + GRU84HD*/

/*transfers that I subtract from household consumption
INGTEXHD - Ingreso por transferencias corrientes del extranjero
INGTRAHD - Ingreso por transferencias corrientes monetarias del pa’s
GRU13HD1 - Alimentos - Donaci—n Pœblico
GRU13HD2 - Alimentos - Donaci—n Privada
GRU13HD3 - alimentos donado, regelado, etc
GRU23HD1 - vestido y calzado, donacion publica
GRU23HD2 - vestido y calzado, donacion privada
GRU33HD1 - Alquiler de Vivienda, Combustible, Electricidad y Conservaci—n de la
Vivienda - Donaci—n Pœblica
GRU33HD2 - Alquiler de Vivienda, Combustible, Electricidad y Conservaci—n de la
Vivienda - Donaci—n Privada
GRU43HD1 - Muebles y Enseres, y Mantenimiento de la Vivienda - Donaci—n
Pœblica
GRU43HD2 - Muebles y Enseres, y Mantenimiento de la Vivienda - Donaci—n
Privada
GRU53HD1 - Cuidado, Conservaci—n de la Salud y Servicios MŽdicos - Donaci—n
Pœblica
GRU53HD2 - Cuidado, Conservaci—n de la Salud y Servicios MŽdicos - Donaci—n
Privada
GRU63HD1 - Transportes y Comunicaciones - Donaci—n Pœblica
GRU63HD2 - Transportes y Comunicaciones - Donaci—n Privada
GRU73HD1 - Esparcimiento, Diversi—n, Servicios Culturales y de Ense–anza -
Donado Pœblico
GRU73HD2 - Esparcimiento, Diversi—n, Servicios Culturales y de Ense–anza -
Donado Privado
GRU83HD1 - Otros Bienes y Servicios - Donaci—n Pœblica
GRU83HD2 - Otros Bienes y Servicios - Donaci—n Privada
gashog2d	gasto total trimestral
defesp	    deflactor espacial de precios base a lima metropolitana*/

/*recode system missings to 0*/
recode ingtexhd .=0
recode ingtrahd .=0
recode gru13hd1 .=0
recode gru13hd2 .=0
recode gru13hd3 .=0
recode gru23hd1 .=0
recode gru23hd2 .=0
recode gru33hd1 .=0
recode gru33hd2 .=0
recode gru43hd1 .=0
recode gru43hd2 .=0
recode gru53hd1 .=0
recode gru53hd2 .=0
recode gru63hd1 .=0
recode gru63hd2 .=0
recode gru73hd1 .=0
recode gru73hd2 .=0
recode gru83hd1 .=0
recode gru83hd2 .=0

/*delete departments not in sample*/
gen ccdd=substr(ubigeo, 1, 2)
tab ccdd
gen ccpp=substr(ubigeo, 3, 2)
tab ccpp
gen ccdi=substr(ubigeo, 5, 2)
tab ccdi
gen depprov=substr(ubigeo, 1, 4)
destring depprov, replace
tab depprov
destring ccdd, replace
destring ccpp, replace
destring ccdi, replace
keep if (ccdd==3 | ccdd==4 | ccdd==5 | ccdd==8 | ccdd==21)

sort conglome vivienda hogar
save temp, replace

use consumption, clear
sort conglome vivienda hogar
merge conglome vivienda hogar using temp, uniqusing
tab _merge
drop _merge
save  consumption, replace

/*generated household consumption in normal prices*/
gen hconsump = gashog2d - ingtexhd -ingtrahd -gru13hd1 -gru13hd2 -gru13hd3 -/*
*/gru23hd1 -gru23hd2 -gru33hd1 -gru33hd2 -gru43hd1 -gru43hd2 -gru53hd1 -gru53hd2 -/*
*/gru63hd1 -gru63hd2 -gru73hd1 -gru73hd2 -gru83hd1 -gru83hd2 
drop gru*   factorto ingtrahd ingtexhd gashog2d  

label variable hconsump "household consumption minus transfers"

/*gen hh consumption in lima metropolitan prices*/

gen hconsumplm = (hconsump)/(defesp)
label variable hconsumplm "household consumption minus transfers (Lima prices)"
drop  defesp

/*for Deaton values*/
gen hhequiv= ((hconsumplm/ces))
gen lhhequiv=ln(hhequiv)
recode lhhequiv .=0

/*log household consumption*/
gen lhhconsplm=ln(hconsumplm)
recode lhhconsplm .=0

count

/*keep only household head*/
keep if hhead==1
count
drop hhead

save consumption, replace



*LANGUAGE AND ETHNICITY

use enaho01b_2001iv, clear
keep conglome	vivienda	hogar	ubigeo q21 q24 q25 q231 q232 q233 q28 q301 /*
*/q302 q303 q31 q32 q26a1 q33a1 q26a2 q33a2 q26a3 q33a3 q26a4 q33a4 q26a5 q33a5
/*delete departments not in sample*/
gen ccdd=substr(ubigeo, 1, 2)
tab ccdd
gen ccpp=substr(ubigeo, 3, 2)
tab ccpp
gen ccdi=substr(ubigeo, 5, 2)
tab ccdi
gen depprov=substr(ubigeo, 1, 4)
destring depprov, replace
tab depprov
destring ccdd, replace
destring ccpp, replace
destring ccdi, replace
keep if (ccdd==3 | ccdd==4 | ccdd==5 | ccdd==8 | ccdd==21)

/*Which language do you speak most frequently?*/
rename q231 CAST
replace CAST=1 if q21==1
replace CAST=0 if (q24!=. & q24!=1)
tab CAST

rename q232 QUE
recode QUE 2=1
replace QUE=1 if q21==2
replace QUE=0 if (q24!=. & q24!=2)
tab QUE

rename q233 AYM
recode AYM 3=1
replace AYM=1 if q21==3
replace AYM=0 if (q24!=. & q24!=3)
tab AYM

gen test=CAST+QUE+AYM
tab test
drop test

replace q301=1 if q28==1
replace q301=0 if (q31!=. & q31!=1)
tab q301

recode q302 2=1
replace q302=1 if q28==2
replace q302=0 if (q31!=. & q31!=2)
tab q302

recode q303 3=1
replace q303=1 if q28==3
replace q303=0 if (q31!=. & q31!=3)
tab q303

replace CAST=q301 if CAST==.
replace QUE=q302 if QUE==.
replace AYM=q303 if AYM==.

recode QUE .=0
recode CAST .=0
recode AYM .=0

tab CAST
tab QUE
tab AYM
drop q*
count

sort conglome vivienda hogar
save temp, replace

use consumption, clear
sort conglome vivienda hogar
merge conglome vivienda hogar using temp, unique
tab _merge
drop _merge 
save consumption, replace


*GIS VARS

use gis_dist, clear
sort ubigeo
save temp, replace

use consumption, clear
destring ubigeo, replace
sort ubigeo
merge ubigeo using temp, uniqusing
tab _merge
keep if _merge==3 /*keep only those observations in the study region for which we have consumption data*/
drop _merge
summ
save consumption, replace


**--Cubic polynomial in latitude and longitude

use consumption, clear

 regress lhhequiv pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/infants children adults elv_sh slope  /*
*/ bfe4* if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita  using table2a, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita  using table2a, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita  using table2a, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))
				

**--cubc polynomial in distance to Potosi

use consumption, clear

 regress lhhequiv pothuan_mita dpot dpot2 dpot3 /*
*/infants children adults elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita  using table2b, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita dpot dpot2 dpot3 /*
*/infants children adults elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita  using table2b, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita dpot dpot2 dpot3 /*
*/infants children adults elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita  using table2b, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


**--Cubc polynomial in distance to the mita boundary

use consumption, clear

regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using table2c, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using table2c, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using table2c, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


******************************
**---Childhood Stunting
******************************

clear
set mem 8000000
global thebulkdir = "/homes/nber/dellm/"
global thedir = "/homes/nber/dellm/"
cd $thebulkdir

use ctalla, clear

keep if situacion==""

gen desnu=.
replace desnu=1 if (cnive=="3" | cnive=="4" | cnive=="5")
recode desnu (.=0)

gen desnu_sev=.
replace desnu_sev=1 if (cnive=="4" | cnive=="5")
recode desnu_sev (.=0)

destring canios, replace
destring cmeses, replace
replace canios=canios*12
gen age_mo=canios+cmeses
replace age_mo=age_mo/3
replace age_mo=floor(age_mo)
tab age, g(yr)
rename sexo male
destring male, replace
recode male (2=0)

foreach X of num 1/16 {
	gen age_sex`X'=male*yr`X'
}

keep cod_mod codgeo desnu* z_score talla_cm age_sex* male yr*

rename codgeo ubigeo
destring ubigeo, replace force
sort ubigeo
save height, replace


/*GIS DATA AND TREATMENT DATA*/

use gis_dist, clear
sort ubigeo
save temp, replace

use height, clear
sort ubigeo
merge ubigeo using temp, uniqusing
tab _merge 
keep if _merge==3
drop _merge
sum
saveold height, replace


use height, clear

**-----Cubic polynomial longitude and latitude


 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita  using table2a, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita  using table2a, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita  using table2a, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))
				
 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope  /*stype2 stype3 stype5*/  /*
*/  bfe4*  if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita  using table2a, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


**----cubc polynomial in distance to Potosi
 regress desnu pothuan_mita dpot dpot2 dpot3 /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
	outreg2 pothuan_mita  using table2b, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust)) 

 regress desnu pothuan_mita dpot dpot2 dpot3 /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
	outreg2 pothuan_mita  using table2b, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust)) 

 regress desnu pothuan_mita dpot dpot2 dpot3 /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
	outreg2 pothuan_mita  using table2b, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust)) 

regress desnu pothuan_mita dpot dpot2 dpot3 /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
	outreg2 pothuan_mita  using table2b, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust)) 


use height, clear


*---Cubic polyonomial in distance to the mita boundary


regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using table2c, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using table2c, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using table2c, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using table2c, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

log close

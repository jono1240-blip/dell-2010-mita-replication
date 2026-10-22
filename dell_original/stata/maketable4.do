********************************
*This file makes Table 4
********************************
capture log close
clear
set mem 200000
cd G:\mita\data
log using maketable4, replace

/*Data Files Used
	consumption.dta
	height.dta
	nriver.csv
	
*Data Files Created as Final Product
	none
	
*Data Files Created as Intermediate Product
	none
*/

**********************
*-----Consumption
**********************

***---Cubic polynomial in latitude and longitude


*--Baseline

use consumption, clear


 regress lhhequiv infants children adults pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
	outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust)) 



*--Control for ethnicity

 regress lhhequiv pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 QUE /*
*/infants children adults elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Includes Cusco

 regress lhhequiv pothuan_mita x y x2 y2 xy x3 y3 x2y xy2  /*
*/infants children adults elv_sh slope    /*
*/  bfe4*  if (d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Excludes districts with Inca estates

		/*drop Inca estate districts*/
drop if (ccdd==8	& ccpp==1	& ccdi==4)
drop if (ccdd== 8 & ccpp== 3	& ccdi== 4)
drop if (ccdd== 8	& ccpp== 3	& ccdi== 6)
drop if (ccdd== 8	& ccpp== 3	& ccdi== 9)
drop if (ccdd== 8	& ccpp== 4	& ccdi== 1)
drop if (ccdd== 8	& ccpp== 4	& ccdi== 3)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 1)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 2)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 3)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 4)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 5)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 6)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 7)

 regress lhhequiv pothuan_mita x y x2 y2 xy x3 y3 x2y xy2  /*
*/infants children adults elv_sh slope    /*
*/  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*--Excludes portions of the boundary formed by rivers

insheet using nrivers.csv, clear
sort ubigeo
merge ubigeo using consumption, uniqmaster
keep if _merge==3 /*keep only places along portions of boundary not formed by rivers*/
drop _merge


 regress lhhequiv pothuan_mita x y x2 y2 xy x3 y3 x2y xy2  /*
*/infants children adults elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Flexible household equivalence scale

use consumption, clear


 regress lhhconsplm pothuan_mita x y x2 y2 xy x3 y3 x2y xy2  /*
*/lhhmem k_hhmem elv_sh slope    /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))



*--Migration

use consumption, clear
drop if cusco==1
drop if d_bnd>50
egen rank=rank(hhequiv), by (pothuan_mita) track 
egen count=count(hhequiv), by (pothuan_mita)
gen ptile=rank/count
drop rank count
drop if (pothuan_mita==0 & ptile>(1-.048))


 regress lhhequiv pothuan_mita x y x2 y2 xy x3 y3 x2y xy2  /*
*/infants children adults elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))



***---One dimensional specifications

*--Baseline

use consumption, clear

 regress lhhequiv infants children adults pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
	outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust)) 

 regress lhhequiv infants children adults pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope  /*
*/ bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
	outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust)) 


*--Control for ethnicity

 regress lhhequiv pothuan_mita dpot dpot2 dpot3 QUE /*
*/infants children adults elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 QUE /*
*/infants children adults elv_sh slope    /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Includes Cusco

 regress lhhequiv pothuan_mita dpot dpot2 dpot3 /*
*/infants children adults elv_sh slope    /*
*/  bfe4*  if (d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3  /*
*/infants children adults elv_sh slope    /*
*/  bfe4* if (d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Excludes districts with Inca estates

		/*drop Inca estate districts*/
drop if (ccdd==8	& ccpp==1	& ccdi==4)
drop if (ccdd== 8 & ccpp== 3	& ccdi== 4)
drop if (ccdd== 8	& ccpp== 3	& ccdi== 6)
drop if (ccdd== 8	& ccpp== 3	& ccdi== 9)
drop if (ccdd== 8	& ccpp== 4	& ccdi== 1)
drop if (ccdd== 8	& ccpp== 4	& ccdi== 3)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 1)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 2)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 3)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 4)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 5)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 6)
drop if (ccdd== 8	& ccpp== 13	& ccdi== 7)

 regress lhhequiv pothuan_mita dpot dpot2 dpot3 /*
*/infants children adults elv_sh slope bfe4*  /*
*/  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3  /*
*/ infants children adults elv_sh slope    /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*--Excludes portions of the boundary formed by rivers

insheet using nrivers.csv, clear
sort ubigeo
merge ubigeo using consumption, uniqmaster
keep if _merge==3 /*keep only places along portions of boundary not formed by rivers*/
drop _merge


 regress lhhequiv pothuan_mita dpot dpot2 dpot3 /*
*/infants children adults elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3  /*
*/infants children adults elv_sh slope    /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Flexible household equivalence scale

use consumption, clear


 regress lhhconsplm pothuan_mita dpot dpot2 dpot3 /*
*/lhhmem k_hhmem elv_sh slope    /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress lhhconsplm pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3  /*
*/lhhmem k_hhmem elv_sh slope    /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*--Migration

use consumption, clear
drop if cusco==1
drop if d_bnd>50
egen rank=rank(hhequiv), by (pothuan_mita) track 
egen count=count(hhequiv), by (pothuan_mita)
gen ptile=rank/count
drop rank count
drop if (pothuan_mita==0 & ptile>(1-.048))


 regress lhhequiv pothuan_mita dpot dpot2 dpot3 /*
*/infants children adults elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3  /*
*/infants children adults elv_sh slope    /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*****************************
*-------Stunting
*****************************

***----Polynomial in latitude and longitude


*---Baseline

use height, clear

 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 /*
*/ elv_sh slope   /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
	outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust)) 


*---Includes Cusco

 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2  /*
*/ elv_sh slope    /*
*/  bfe4*  if (d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Exclude districts with Inca estates

/*drop Inca estate districts*/
drop if (ubigeo==80104)
drop if (ubigeo== 80304)
drop if (ubigeo== 80306)
drop if (ubigeo== 80309)
drop if (ubigeo== 80401)
drop if (ubigeo== 80403)
drop if (ubigeo== 801301)
drop if (ubigeo== 801302)
drop if (ubigeo== 801303)
drop if (ubigeo== 801304)
drop if (ubigeo== 801305)
drop if (ubigeo== 801306)
drop if (ubigeo== 801307)

 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2  /*
*/ elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Excludes portions of the boundary formed by rivers

use height, clear
sort ubigeo
save height, replace

insheet using nrivers.csv, clear
sort ubigeo
merge ubigeo using height, uniqmaster
keep if _merge==3 /*keep only places along portions of boundary not formed by rivers*/
drop _merge

 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2  /*
*/ elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Migration

use height, clear

drop if cusco==1
drop if d_bnd>50
egen rank=rank(desnu), by (pothuan_mita) unique 
egen count=count(desnu), by (pothuan_mita)
gen ptile=rank/count
drop rank count
drop if (pothuan_mita==0 & ptile<(.048))

 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2  /*
*/ elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon3_altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 


***----One dimensional polynomials

*---Baseline

use height, clear

 regress desnu pothuan_mita dpot dpot2 dpot3  /*
*/ elv_sh slope   /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
	outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust)) 

 regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 /*
*/ elv_sh slope  /*
*/ bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
	outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust)) 


*---Includes Cusco

 regress desnu pothuan_mita dpot dpot2 dpot3 /*
*/ elv_sh slope    /*
*/  bfe4*  if (d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3  /*
*/ elv_sh slope    /*
*/  bfe4* if (d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Exclude districts with Inca estates

/*drop Inca estate districts*/
drop if (ubigeo==80104)
drop if (ubigeo== 80304)
drop if (ubigeo== 80306)
drop if (ubigeo== 80309)
drop if (ubigeo== 80401)
drop if (ubigeo== 80403)
drop if (ubigeo== 801301)
drop if (ubigeo== 801302)
drop if (ubigeo== 801303)
drop if (ubigeo== 801304)
drop if (ubigeo== 801305)
drop if (ubigeo== 801306)
drop if (ubigeo== 801307)

 regress desnu pothuan_mita dpot dpot2 dpot3 /*
*/ elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3  /*
*/ elv_sh slope    /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

*---Excludes portions of the boundary formed by rivers

use height, clear
sort ubigeo
save height, replace

insheet using nrivers.csv, clear
sort ubigeo
merge ubigeo using height, uniqmaster
keep if _merge==3 /*keep only places along portions of boundary not formed by rivers*/
drop _merge

 regress desnu pothuan_mita dpot dpot2 dpot3 /*
*/ elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3  /*
*/ elv_sh slope    /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Migration

use height, clear

drop if cusco==1
drop if d_bnd>50
egen rank=rank(desnu), by (pothuan_mita) unique 
egen count=count(desnu), by (pothuan_mita)
gen ptile=rank/count
drop rank count
drop if (pothuan_mita==0 & ptile<(.048))

 regress desnu pothuan_mita dpot dpot2 dpot3 /*
*/ elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using pot2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3  /*
*/ elv_sh slope    /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using dbnd2altspec, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))





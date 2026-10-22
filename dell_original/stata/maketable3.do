********************************
*This file makes Table 3
********************************
capture log close
clear
set mem 200000
cd G:\mita\data
log using maketable3, replace

/**Data Files Used
	consumption.dta
	height.dta
		
*Data Files Created as Final Product
	none
	
*Data Files Created as Intermediate Product
	none
*/


******************************************
***----------Consumption Regressions
******************************************


**---linear in distance to Potosi

use consumption, clear

regress lhhequiv pothuan_mita dpot /*
*/infants children adults elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1robust, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dpot /*
*/infants children adults elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dpot /*
*/infants children adults elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


**---quadratic in distance to Potosi

use consumption, clear

regress lhhequiv pothuan_mita dpot dpot2 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2robust, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dpot dpot2 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dpot dpot2 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


**---quartic in distance to Potosi

use consumption, clear

regress lhhequiv pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4robust, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


**---interacted linear polynomial in distance to Potosi

use consumption, clear
drop if d_bnd>100
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress lhhequiv pothuan_mita elv_sh slope dpot mitaXdpot /*
*/infants children adults  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


use consumption, clear
drop if d_bnd>75
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress lhhequiv pothuan_mita elv_sh slope dpot mitaXdpot /*
*/infants children adults  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


use consumption, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress lhhequiv pothuan_mita elv_sh slope dpot mitaXdpot /*
*/infants children adults  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 
 


**---interacted quadratic polynomial in distance to Potosi

use consumption, clear
drop if d_bnd>100
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress lhhequiv pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/infants children adults  bfe4* , robust cluster(ubigeo)
outreg2 elv_sh slope  using pot2interact_T3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


use consumption, clear
drop if d_bnd>75
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress lhhequiv pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/infants children adults  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


use consumption, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress lhhequiv pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/infants children adults  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


*---Interacted linear polyonomial in distance to the mita boundary

use consumption, clear
gen mxbnd=pothuan_mita* dbnd_sh 

regress lhhequiv pothuan_mita dbnd_sh mxbnd /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1robust, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh mxbnd /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh mxbnd /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Interacted quadratic polyonomial in distance to the mita boundary

use consumption, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2 

regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2robust, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Linear polyonomial in distance to the mita boundary

use consumption, clear

regress lhhequiv pothuan_mita dbnd_sh /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1robust, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

*---Quadratic polyonomial in distance to the mita boundary

use consumption, clear
regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2robust, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Quartic polyonomial in distance to the mita boundary

use consumption, clear

regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4robust, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

*---Oridnary least squares

use consumption, clear

regress lhhequiv pothuan_mita infants children adults elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using olsrobust, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita infants children adults elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using olsrobust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress lhhequiv pothuan_mita infants children adults elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using olsrobust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))
drop bfe4_1

***-----------Linear polynomial in latitude and longitude

use consumption, clear

 regress lhhequiv pothuan_mita x y /*
*/infants children adults elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita x y /*
*/infants children adults elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita x y /*
*/infants children adults elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))



***-----------Quadratic polynomial in latitude and longitude

use consumption, clear

 regress lhhequiv pothuan_mita x y x2 y2 xy /*
*/infants children adults elv_sh slope /*
*/ bfe4* if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita x y x2 y2 xy /*
*/infants children adults elv_sh slope   /*
*/ bfe4*  if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita x y x2 y2 xy /*
*/infants children adults elv_sh slope   /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))
				

***-----------Quartic polynomial in latitude and longitude

use consumption, clear

 regress lhhequiv pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress lhhequiv pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3 /*
*/infants children adults elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))
				

******************************************
***----------Height Regressions
******************************************

**---linear in distance to Potosi

use height, clear

regress desnu pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))



**---quadratic in distance to Potosi

use height, clear

regress desnu pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


**---quartic in distance to Potosi

use height, clear

regress desnu pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


**---interacted linear polynomial in distance to Potosi

use height, clear
drop if d_bnd>100
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress desnu pothuan_mita elv_sh slope dpot mitaXdpot /*
*/  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


use height, clear
drop if d_bnd>75
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress desnu pothuan_mita elv_sh slope dpot mitaXdpot /*
*/  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


use height, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress desnu pothuan_mita elv_sh slope dpot mitaXdpot /*
*/  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


use height, clear
drop if border!=1
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress desnu pothuan_mita elv_sh slope dpot mitaXdpot /*
*/  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


**---interacted quadratic polynomial in distance to Potosi

use height, clear
drop if d_bnd>100
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress desnu pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


use height, clear
drop if d_bnd>75
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress desnu pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


use height, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress desnu pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


use height, clear
drop if border!=1
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress desnu pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/  bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


*---Interacted linear polyonomial in distance to the mita boundary

use height, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2

regress desnu pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))



*---Interacted quadratic polyonomial in distance to the mita boundary

use height, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2

regress desnu pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Linear polyonomial in distance to the mita boundary

use height, clear


regress desnu pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Quadratic polyonomial in distance to the mita boundary

use height, clear
regress desnu pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Quartic polyonomial in distance to the mita boundary

use height, clear

regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4robust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


*---Oridnary least squares

use height, clear

regress desnu pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using olsrobust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using olsrobust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using olsrobust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

regress desnu pothuan_mita elv_sh slope  /*
*/  bfe4* if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using olsrobust, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***-----------Linear polynomial in latitude and longitude

use height, clear

 regress desnu pothuan_mita x y /*
*/ elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita x y /*
*/ elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita x y /*
*/ elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))
				
 regress desnu pothuan_mita x y /*
*/ elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***-----------Quadratic polynomial in latitude and longitude

use height, clear

 regress desnu pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))
				
 regress desnu pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***-----------Quartic polynomial in latitude and longitude
use height, clear

 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3 /*
*/ elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<100), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3 /*
*/ elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<75), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3 /*
*/ elv_sh slope  /*
*/  bfe4*  if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))
				
 regress desnu pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3 /*
*/ elv_sh slope    /*
*/  bfe4*  if (cusco!=1 & border==1), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


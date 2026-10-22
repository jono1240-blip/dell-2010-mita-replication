******************************************************
*This file makes Table 9 (Consumption Channels)
******************************************************
capture log close
clear
set mem 300000
cd G:\mita\data
log using maketableA3, replace

/*Data Files Used
	hacienda1689.dta
	hacienda1845.dta
	hacienda1940.dta
	educ1876.dta
	educ1940.dta
	educ2001.dta
	roads.dta
	ag_mkts1994.dta
	
*Data files created as final products
	none
	
*Data Files Created as Intermediate Product
	none*/



*********************
***---Tribute 1572
*********************

use spec_check1572, clear

***---Linear polynomial in latitude and longitude

 regress ltrib_rate pothuan_mita x y elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in latitude and longitude

 regress ltrib_rate pothuan_mita x y x2 y2 xy elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))


***---Quartic polynomial in latitude and longitude

 regress ltrib_rate pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3  elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))


***---Linear polynomial in distance to Potosi

regress ltrib_rate pothuan_mita dpot elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to Potosi

regress ltrib_rate pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to Potosi

regress ltrib_rate pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to Potosi

drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress ltrib_rate pothuan_mita elv_sh slope dpot mitaXdpot /*
*/ bfe4*  [aw=trib_pop], robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


***---Quadratic interacted polynomial in distance to Potosi


use spec_check1572, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress ltrib_rate pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/ bfe4*  [aw=trib_pop], robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


***---Linear polynomial in distance to the mita boundary

use spec_check1572, clear

regress ltrib_rate pothuan_mita dbnd_sh elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to the mita boundary

regress ltrib_rate pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to the mita boundary

regress ltrib_rate pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to the mita boundary

use spec_check1572, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2

regress ltrib_rate pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))


***---Quadratic interacted polynomial in distance to the mita boundary


regress ltrib_rate pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))


***---Ordinary least squares

regress ltrib_rate pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=trib_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using ols_A3, tex less(0) nocons replace bdec(3) adds(Clusters, e(N_clust))



*********************
***---Hacienda 1689
*********************

use hacienda1689, clear

***---Linear polynomial in latitude and longitude

 regress num_hac pothuan_mita x y /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in latitude and longitude

 regress num_hac pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quartic polynomial in latitude and longitude

 regress num_hac pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3  /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Linear polynomial in distance to Potosi

regress num_hac pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to Potosi

regress num_hac pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to Potosi

regress num_hac pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to Potosi

drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress num_hac pothuan_mita elv_sh slope dpot mitaXdpot /*
*/ bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


***---Quadratic interacted polynomial in distance to Potosi


use hacienda1689, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress num_hac pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/ bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


***---Linear polynomial in distance to the mita boundary

use hacienda1689, clear

regress num_hac pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to the mita boundary

regress num_hac pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to the mita boundary


regress num_hac pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to the mita boundary

use hacienda1689, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2

regress num_hac pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quadratic interacted polynomial in distance to the mita boundary


regress num_hac pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Ordinary least squares

regress num_hac pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using ols_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))




*********************
***---Hacienda 1845
*********************

use hacienda1845, clear

***---Linear polynomial in latitude and longitude

 regress ptlf_hac pothuan_mita x y /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in latitude and longitude

 regress ptlf_hac pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50)  [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quartic polynomial in latitude and longitude

 regress ptlf_hac pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3  /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Linear polynomial in distance to Potosi

regress ptlf_hac pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to Potosi

regress ptlf_hac pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to Potosi

regress ptlf_hac pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to Potosi

drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress ptlf_hac pothuan_mita elv_sh slope dpot mitaXdpot /*
*/ bfe4* [aw= lf_pop], robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


***---Quadratic interacted polynomial in distance to Potosi


use hacienda1845, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress ptlf_hac pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/ bfe4* [aw= lf_pop], robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


***---Linear polynomial in distance to the mita boundary

use hacienda1845, clear

regress ptlf_hac pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to the mita boundary

regress ptlf_hac pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to the mita boundary


regress ptlf_hac pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to the mita boundary

use hacienda1845, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2

regress ptlf_hac pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quadratic interacted polynomial in distance to the mita boundary


regress ptlf_hac pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Ordinary least squares

regress ptlf_hac pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw= lf_pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using ols_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))




*********************
***---Hacienda 1940
*********************

use hacienda1940, clear

***---Linear polynomial in latitude and longitude

 regress hacienda_prlf pothuan_mita x y /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in latitude and longitude

 regress hacienda_prlf pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quartic polynomial in latitude and longitude

 regress hacienda_prlf pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3  /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Linear polynomial in distance to Potosi

regress hacienda_prlf pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to Potosi

regress hacienda_prlf pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to Potosi

regress hacienda_prlf pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to Potosi

drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress hacienda_prlf pothuan_mita elv_sh slope dpot mitaXdpot /*
*/ bfe4*  [aw=rural_lf], robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


***---Quadratic interacted polynomial in distance to Potosi


use hacienda1940, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress hacienda_prlf pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/ bfe4* [aw=rural_lf], robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


***---Linear polynomial in distance to the mita boundary

use hacienda1940, clear

regress hacienda_prlf pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to the mita boundary

regress hacienda_prlf pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to the mita boundary


regress hacienda_prlf pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to the mita boundary

use hacienda1940, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2

regress hacienda_prlf pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quadratic interacted polynomial in distance to the mita boundary


regress hacienda_prlf pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Ordinary least squares

regress hacienda_prlf pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aw=rural_lf], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using ols_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))




*********************
***---Education 1876
*********************

use educ1876.dta, clear

***---Linear polynomial in latitude and longitude

 regress literate pothuan_mita x y /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in latitude and longitude

 regress literate pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quartic polynomial in latitude and longitude

 regress literate pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3  /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Linear polynomial in distance to Potosi

regress literate pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to Potosi

regress literate pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to Potosi

regress literate pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to Potosi

drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress literate pothuan_mita elv_sh slope dpot mitaXdpot /*
*/ bfe4* [aweight=pop], robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


***---Quadratic interacted polynomial in distance to Potosi


use educ1876.dta, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress literate pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/ bfe4* [aweight=pop], robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


***---Linear polynomial in distance to the mita boundary

use educ1876.dta, clear

regress literate pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to the mita boundary

regress literate pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to the mita boundary


regress literate pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to the mita boundary

use educ1876.dta, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2

regress literate pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quadratic interacted polynomial in distance to the mita boundary


regress literate pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Ordinary least squares

regress literate pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using ols_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))




*********************
***---Education 1940
*********************

use educ1940.dta, clear

***---Linear polynomial in latitude and longitude

 regress mean_educ pothuan_mita x y /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in latitude and longitude

 regress mean_educ pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quartic polynomial in latitude and longitude

 regress mean_educ pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3  /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Linear polynomial in distance to Potosi

regress mean_educ pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to Potosi

regress mean_educ pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to Potosi

regress mean_educ pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to Potosi

drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress mean_educ pothuan_mita elv_sh slope dpot mitaXdpot /*
*/ bfe4* [aweight=pop], robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


***---Quadratic interacted polynomial in distance to Potosi


use educ1940.dta, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress mean_educ pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/ bfe4* [aweight=pop], robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


***---Linear polynomial in distance to the mita boundary

use educ1940.dta, clear

regress mean_educ pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to the mita boundary

regress mean_educ pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to the mita boundary


regress mean_educ pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to the mita boundary

use educ1940.dta, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2

regress mean_educ pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quadratic interacted polynomial in distance to the mita boundary


regress mean_educ pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Ordinary least squares

regress mean_educ pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50) [aweight=pop], /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using ols_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))




*********************
***---Education 2001
*********************

use educ2001.dta, clear

***---Linear polynomial in latitude and longitude

 regress educ pothuan_mita x y /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in latitude and longitude

 regress educ pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quartic polynomial in latitude and longitude

 regress educ pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3  /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Linear polynomial in distance to Potosi

regress educ pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to Potosi

regress educ pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to Potosi

regress educ pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to Potosi

drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress educ pothuan_mita elv_sh slope dpot mitaXdpot /*
*/ bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


***---Quadratic interacted polynomial in distance to Potosi


use educ2001.dta, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress educ pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/ bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


***---Linear polynomial in distance to the mita boundary

use educ2001.dta, clear

regress educ pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to the mita boundary

regress educ pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to the mita boundary


regress educ pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to the mita boundary

use educ2001.dta, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2

regress educ pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quadratic interacted polynomial in distance to the mita boundary


regress educ pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Ordinary least squares

regress educ pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using ols_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))




*********************
***---Roads 2006
*********************

use roads.dta, clear

***---Linear polynomial in latitude and longitude

 regress ddep_t pothuan_mita x y /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in latitude and longitude

 regress ddep_t pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quartic polynomial in latitude and longitude

 regress ddep_t pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3  /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Linear polynomial in distance to Potosi

regress ddep_t pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to Potosi

regress ddep_t pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to Potosi

regress ddep_t pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to Potosi

drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress ddep_t pothuan_mita elv_sh slope dpot mitaXdpot /*
*/ bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


***---Quadratic interacted polynomial in distance to Potosi


use roads.dta, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress ddep_t pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/ bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


***---Linear polynomial in distance to the mita boundary

use roads.dta, clear

regress ddep_t pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to the mita boundary

regress ddep_t pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to the mita boundary


regress ddep_t pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to the mita boundary

use roads.dta, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2

regress ddep_t pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quadratic interacted polynomial in distance to the mita boundary


regress ddep_t pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Ordinary least squares

regress ddep_t pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using ols_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))




*********************
***---Markets 1994
*********************

use ag_mkts1994.dta, clear

***---Linear polynomial in latitude and longitude

 regress d_venta pothuan_mita x y /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in latitude and longitude

 regress d_venta pothuan_mita x y x2 y2 xy /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quartic polynomial in latitude and longitude

 regress d_venta pothuan_mita x y x2 y2 xy x3 y3 x2y xy2 x4 y4 x3y x2y2 xy3  /*
*/ elv_sh slope /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita elv_sh slope  using latlon4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Linear polynomial in distance to Potosi

regress d_venta pothuan_mita dpot /*
*/ elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to Potosi

regress d_venta pothuan_mita dpot dpot2 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to Potosi

regress d_venta pothuan_mita dpot dpot2 dpot3 dpot4 /*
*/ elv_sh slope  /*
*/  bfe4*    if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using pot4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to Potosi

drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot

regress d_venta pothuan_mita elv_sh slope dpot mitaXdpot /*
*/ bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean' 


***---Quadratic interacted polynomial in distance to Potosi


use ag_mkts1994.dta, clear
drop if d_bnd>50
drop if cusco==1

gen mitaXdpot=pothuan_mita*dpot
gen mitaXdpot2=pothuan_mita*(dpot)^2

regress d_venta pothuan_mita elv_sh slope dpot dpot2 mitaXdpot mitaXdpot2 /*
*/ bfe4* , robust cluster(ubigeo)

qui summ dpot if d_bnd<10, detail
local mean =r(mean)
nlcom _b[pothuan_mita] + _b[mitaXdpot]*`mean'+ _b[mitaXdpot2]*(`mean')^2 


***---Linear polynomial in distance to the mita boundary

use ag_mkts1994.dta, clear

regress d_venta pothuan_mita dbnd_sh /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quadratic polynomial in distance to the mita boundary

regress d_venta pothuan_mita dbnd_sh dbnd_sh2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Quartic polynomial in distance to the mita boundary


regress d_venta pothuan_mita dbnd_sh dbnd_sh2 dbnd_sh3 dbnd_sh4 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbnd4_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))

***---Linear interacted polynomial in distance to the mita boundary

use ag_mkts1994.dta, clear
gen mxbnd=pothuan_mita* dbnd_sh 
gen mxbnd2=pothuan_mita* dbnd_sh2

regress d_venta pothuan_mita dbnd_sh mxbnd /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter1_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Quadratic interacted polynomial in distance to the mita boundary


regress d_venta pothuan_mita dbnd_sh dbnd_sh2 mxbnd mxbnd2 /*
*/ elv_sh slope  /*
*/  bfe4*   if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using dbndinter2_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))


***---Ordinary least squares

regress d_venta pothuan_mita  elv_sh slope  /*
*/  bfe4* if (cusco!=1 & d_bnd<50), /*
*/robust cluster (ubigeo)		
outreg2 pothuan_mita using ols_A3, tex less(0) nocons append bdec(3) adds(Clusters, e(N_clust))



***********************************************************************
*This file contains code for generating a comparison of means table
*for various characteristics (Table 1) 
***********************************************************************
capture log close
clear
clear matrix
set mem 400000
cd G:\mita\data
log using maketable1, replace


***--------------------------------------------------------------------------------------------------------***
***----------------------------------------GIS (Panel A)---------------------------------------------------***
***--------------------------------------------------------------------------------------------------------***

***--------Elevation all areas of study region (no Cusco)------***
use gis_grid, clear
foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'
	bys pothuan_mita: sum elev
	regress elev pothuan_mita, robust 
}

***--------Slope--------***

clear
use gis_grid, clear
foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'
	bys pothuan_mita: summ slope
	regress slope pothuan_mita, robust 
}


***--------------------------------------------------------------------------------------------------------***
***---------------------------------------QUECHUA SPEAKERS-------------------------------------------------***
***--------------------------------------------------------------------------------------------------------***

use consumption, clear

foreach Y of num 100 75 50 25 {
	bys pothuan_mita: summarize QUE if (d_bnd<`Y' & cusco!=1)
	regress QUE pothuan_mita if (d_bnd<`Y' & cusco!=1), robust cluster (ubigeo)
}

***--------------------------------------------------------------------------------------------------------***
***--------------------------------------1572 Tribute*-----------------------------------------------------***
***--------------------------------------------------------------------------------------------------------***

use spec_check1572, clear

foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'
	bys pothuan_mita: sum  ltrib_rate if cusco!=1 [aweight=trib_pop] 
	regress ltrib_rate pothuan_mita [aweight=trib_pop] if cusco!=1, robust
}



***--------------------------------------------------------------------------------------------------------***
***--------------------------------------1572 Budget-----------------------------------------------------***
***--------------------------------------------------------------------------------------------------------***

use budget1572, clear

foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'
	bys pothuan_mita: sum  sh_priest if cusco!=1
	regress sh_priest pothuan_mita if cusco!=1 , robust
}

use budget1572, clear

foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'
	bys pothuan_mita: sum  sh_justice if cusco!=1
	regress sh_justice pothuan_mita if cusco!=1 , robust
}

use budget1572, clear

foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'
	bys pothuan_mita: sum  sh_cacique if cusco!=1
	regress sh_cacique pothuan_mita if cusco!=1, robust
}

use budget1572, clear

foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'
	bys pothuan_mita: sum  sh_extract if cusco!=1
	regress sh_extract pothuan_mita if cusco!=1, robust
}




*****************************
*Conley Standard Errors
*****************************
***--------------------------------------------------------------------------------------------------------***
***----------------------------------------GIS (Panel A)---------------------------------------------------***
***--------------------------------------------------------------------------------------------------------***

***--------Elevation all areas of study region (no Cusco)------***
use gis_grid, clear
keep if elv<.
gen xcut1=1
gen ycut1=1
gen const=1
foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'
	x_ols xcord ycord xcut1 ycut1 elev const pothuan_mita, xreg(2) coord(2)
	drop  window epsilon dis1 dis2
}


***--------Slope--------***

use gis_grid, clear
drop if slope==.
gen xcut1=1
gen ycut1=1
gen const=1

foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'
	x_ols xcord ycord xcut1 ycut1 slope const pothuan_mita, xreg(2) coord(2)
	drop  window epsilon dis1 dis2
}

***--------QUECHUA SPEAKERS--------***


***--------------------------------------------------------------------------------------------------------***
***---------------------------------------QUECHUA SPEAKERS-------------------------------------------------***
***--------------------------------------------------------------------------------------------------------***

use consumption, clear
drop if QUE==.
drop if cusco==1
gen xcut1=1
gen ycut1=1
gen const=1

foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'	
	x_ols x y xcut1 ycut1 QUE const pothuan_mita, xreg(2) coord(2)
	drop  window epsilon dis1 dis2
}


***--------------------------------------------------------------------------------------------------------***
***--------------------------------------1572 Tribute*-----------------------------------------------------***
***--------------------------------------------------------------------------------------------------------***

use spec_check1572, clear
    
drop if cusco==1
keep if ltrib_rate<.
gen xcut1=1
gen ycut1=1
gen const=1
foreach X in ltrib_rate const pothuan_mita {
	replace `X'=`X'*sqrt(trib_pop)
}

foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'
	x_ols x y xcut1 ycut1 ltrib_rate const pothuan_mita, xreg(2) coord(2)
	drop  window epsilon dis1 dis2
}


***--------------------------------------------------------------------------------------------------------***
***--------------------------------------1572 Budget-----------------------------------------------------***
***--------------------------------------------------------------------------------------------------------***
use budget1572, clear
		
drop if cusco==1
keep if sh_extract<.   
gen xcut1=1
gen ycut1=1
gen const=1

foreach Y of num 100 75 50 25 {
	drop if d_bnd>`Y'
	x_ols x y xcut1 ycut1 sh_extract const pothuan_mita, xreg(2) coord(2)
		drop  window epsilon dis1 dis2
	x_ols x y xcut1 ycut1 sh_priest const pothuan_mita, xreg(2) coord(2)
		drop  window epsilon dis1 dis2
	x_ols x y xcut1 ycut1 sh_justice const pothuan_mita, xreg(2) coord(2)
		drop  window epsilon dis1 dis2
	x_ols x y xcut1 ycut1 sh_cacique const pothuan_mita, xreg(2) coord(2)
	drop  window epsilon dis1 dis2
}


log close

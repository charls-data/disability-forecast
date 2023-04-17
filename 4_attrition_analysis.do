** ================================================================================================
** Aim:             Attrition analysis (Table A5 and Table_A1, attrition table)
** Author:          CHARLS team
** Created:         2020/20/14
** Modified:        2023/3/27
** Data input:      Weights （2011）
**                  Sample_Infor （2013，2015 and 2018）
**                  demo_info (2011，not in public data)
**                  Post_WeightS (2011，not in public data)
**                  Var_Health_Status_2011 (2011，not in public data)
** =================================================================================================

//2013 respondent death or visited
use $CHARLS_2013r\Weights,clear

keep if  !mi(INDV_weight_ad2) | (!mi(INDV_L_weight) & INDV_L_Died != 1)
//surveyed in 2013
keep ID
gen surveyed2013 = 1
drop if mi(ID)
save $working_data/surveyed2013, replace

use  $CHARLS_2013r\Weights,clear
keep if INDV_L_Died == 1
//death
keep ID
gen death2013 = 1
drop if mi(ID)

save $working_data/death2013, replace

//2015 respondent death or visited
use  $CHARLS_2015r\Sample_Infor,clear
keep if died != 1
//surveyed in 2015
keep ID
gen surveyed2015 = 1
save $working_data/surveyed2015, replace

use  $CHARLS_2015r\Sample_Infor,clear
keep if died == 1
//death
keep ID 
gen death2015 = 1
save $working_data/death2015, replace

//2018 respondent death or visited
use $CHARLS_2018r\Sample_Infor,clear
keep if died != 1
//surveyed in 2018
keep ID 
gen surveyed2018 = 1
save $working_data/surveyed2018, replace

use $CHARLS_2018r\Sample_Infor,clear
keep if died == 1
//death
keep ID 
gen death2018 = 1
save $working_data/death2018, replace

//2020 respondent death or visited
use $CHARLS_2020r\Sample_Infor,clear
keep if died != 1
//surveyed in 2020
keep ID 
gen surveyed2020 = 1
save $working_data/surveyed2020, replace

use $CHARLS_2020r\Sample_Infor,clear
keep if died == 1
//death
keep ID 
gen death2020 = 1
save $working_data/death2020, replace


//2011 basic information
use $CHARLS_2011r\demo_info,clear
merge 1:1 ID using $CHARLS_2011r\Post_WeightS
gen demo_weight = _merge

drop _merge
merge 1:1 ID using  $charls_variable_set\Health_Status\Var_Health_Status_2011.dta
drop if _merge==2
drop _merge
drop Wave
gen Wave=2011

keep ID householdID Gender Age Age_Group Hukou Edu Edu_Group Marry_Status INDV_weight_post2  Wave ADL* IADL*

replace householdID = householdID + "0"
replace ID = householdID + substr(ID,-2,2) 

save $working_data/attrition_2011,replace

**----------------------------------------------------------
**----------------------------------------------------------
use $working_data/attrition_2011,clear

count 
local num_obs_2011 = `r(N)'

//2013
merge 1:1 ID using $working_data/surveyed2013

keep if _merge == 1 |  _merge == 3
drop _merge

merge 1:1 ID using $working_data/death2013

keep if _merge == 1 |  _merge == 3
drop _merge

//2015
merge 1:1 ID using $working_data/surveyed2015

keep if _merge == 1 |  _merge == 3
drop _merge

merge 1:1 ID using $working_data/death2015

keep if _merge == 1 |  _merge == 3
drop _merge

//2018
merge 1:1 ID using $working_data/surveyed2018

keep if _merge == 1 |  _merge == 3
drop _merge

merge 1:1 ID using $working_data/death2018

keep if _merge == 1 |  _merge == 3
drop _merge

//2020
merge 1:1 ID using $working_data/surveyed2020

keep if _merge == 1 |  _merge == 3
drop _merge

merge 1:1 ID using $working_data/death2020

keep if _merge == 1 |  _merge == 3
drop _merge
count if mi(ID)

replace Hukou=. if Hukou==3
replace Hukou=. if Hukou==4

** =============================================================================
** construct disability variables
** =============================================================================
//ADL_needhelp_any including cooking only
gen ADL_needhelp_any_cooking=1 if ADL_needhelp_any==1|IADL_needhelp_cooking==1
replace ADL_needhelp_any_cooking=0 if ADL_needhelp_any==0 & IADL_needhelp_cooking==0
label var ADL_needhelp_any_cooking "ADL_needhelp_any including cooking"

//ADL_needhelp_any including shopping only
gen ADL_needhelp_any_shopping=1 if ADL_needhelp_any==1|IADL_needhelp_shopping==1
replace ADL_needhelp_any_shopping=0 if ADL_needhelp_any==0 & IADL_needhelp_shopping==0
label var ADL_needhelp_any_shopping "ADL_needhelp_any including shopping"

//ADL_needhelp_any including cooking and shopping
gen ADL_cooking_shopping=1 if  ADL_needhelp_eating==1 | ADL_needhelp_bathing==1| ADL_needhelp_bed==1| ADL_needhelp_dressing==1| ADL_needhelp_toileting==1| ADL_needhelp_urinecontrol==1 | IADL_needhelp_cooking==1 |IADL_needhelp_shopping==1
replace  ADL_cooking_shopping=0 if ADL_needhelp_eating==0 &  ADL_needhelp_bathing==0 & ADL_needhelp_bed==0 & ADL_needhelp_dressing==0 & ADL_needhelp_toileting==0 & ADL_needhelp_urinecontrol==0 & IADL_needhelp_cooking==0  & IADL_needhelp_shopping==0
label var ADL_cooking_shopping "ADL+cooking+shopping"

//ADL_needhelp_any including cooking and shopping and medicine
gen ADL_cs_medicine=1 if  ADL_cooking_shopping==1| IADL_needhelp_medicine==1
replace ADL_cs_medicine=0 if ADL_cooking_shopping==0 &  IADL_needhelp_medicine==0
label var ADL_cs_medicine "ADL+cooking+shopping+medicine"

//ADL_needhelp_any including cooking and shopping and medicine & money
gen ADL_csm_money=1 if  ADL_cs_medicine==1| IADL_needhelp_money==1
replace ADL_csm_money=0 if ADL_cs_medicine==0 &  IADL_needhelp_money==0
label var ADL_csm_money "ADL+cooking+shopping+medicine+money"

gen ADL_IADL_any=1 if ADL_csm_money==1 | IADL_needhelp_housework==1
replace ADL_IADL_any=0 if ADL_csm_money==0 & IADL_needhelp_housework==0

label var ADL_needhelp_any "Level 1 dependency"
label var ADL_cs_medicine "Level 2 dependency"
label var ADL_IADL_any "Level 3 dependency"

reshape long surveyed  death , i(ID) j(wave)

sort ID wave
order ID wave surveyed  death
bys ID: gen num_death = sum(death)
order ID wave surveyed  death num_death
//if died at time t, num_death = 1 in the future 

bys ID: gen death_addup = sum(num_death)
order ID wave surveyed  death num_death death_addup
//if died at time t, death_addup = 1 at time t and >=2 in the future 

egen sureyed_deaht_sum = rowtotal(surveyed num_death )
//visited or death

gen surveyed_death = 0 if sureyed_deaht_sum == 0
replace surveyed_death = 1 if sureyed_deaht_sum == 1 & death_addup == 0
//visited
replace surveyed_death = 1 if sureyed_deaht_sum == 1 & death_addup == 1
//death at time t
label var surveyed_death "visited or death at wave t"

tab Age_Group,gen(Agegroup)

cap drop Female

gen Female = 1 if Gender == 2
replace Female = 0 if Gender == 1

gen Hukou_agricultural = 1 if Hukou == 1
replace Hukou_agricultural = 0 if Hukou == 2

replace surveyed = 0 if mi(surveyed)
**-------------------------------------------------------------------
**----------Table A5, attrition_analysis
**-------------------------------------------------------------------
reg  surveyed_death ADL_IADL_any  i.Age_Group i.Edu_Group Female Hukou_agricultural i.wave,cluster(ID)
gen in_sample = e(sample)

outreg2 using $tables/Table_A5.xls, replace r2 bdec(3) sdec(3) ctitle(ADL/IADL)  label sideway stats(coef ci  pval) paren(ci) noaster pdec(5)

reg surveyed_death ADL_cs_medicine  i.Age_Group i.Edu_Group Female Hukou_agricultural i.wave,cluster(ID)
outreg2 using $tables/Table_A5.xls, append r2 bdec(3) sdec(3) ctitle(ADL Plus)  label sideway stats(coef ci  pval) paren(ci) noaster pdec(5)

reg surveyed_death ADL_needhelp_any  i.Age_Group i.Edu_Group Female Hukou_agricultural i.wave,cluster(ID)
outreg2 using $tables/Table_A5.xls, append r2 bdec(3) sdec(3) ctitle(ADL)  label sideway stats(coef ci  pval) paren(ci) noaster pdec(5)

*-------------------------------------------------------------------
**--------- Table_A1, attrition table
**-------------------------------------------------------------------

putexcel set $tables/Lancet_public_health.xlsx, sheet(Table_A1_attrition, replace) modify

putexcel A2 = "Sample attrition"

putexcel A3 = "Baseline sample"
putexcel A4 = "Revisit"
putexcel A5 = "Death"
putexcel A6 = "Non-revist"
putexcel A7 = "Percentage of revisit plus death"

putexcel A8 = "New sample in wave 2013"
putexcel A9 = "Revisit"
putexcel A10 = "Death"
putexcel A11 = "Non-revist"
putexcel A12 = "Percentage of revisit plus death"

putexcel A13 = "New sample in wave 2015"
putexcel A14 = "Revisit"
putexcel A15 = "Death"
putexcel A16 = "Non-revist"
putexcel A17 = "Percentage of revisit plus death"

putexcel A18 = "New sample in wave 2018"
putexcel A19 = "Revisit"
putexcel A20 = "Death"
putexcel A21 = "Non-revist"
putexcel A22 = "Percentage of revisit plus death"


putexcel B2 = "Wave 2011"
putexcel C2 = "Wave 2013"
putexcel D2 = "Wave 2015"
putexcel E2 = "Wave 2018"
putexcel F2 = "Wave 2020"



**--------- base sample in 2011
putexcel B3 = `num_obs_2011'


**2013
ta surveyed num_death if wave == 2013 ,m

count if surveyed== 1 & num_death ==0 & wave == 2013

putexcel C4 = `r(N)'

count if surveyed== 0 & num_death ==1 & wave == 2013

putexcel C5 = `r(N)'

count if surveyed== 0 & num_death ==0 & wave == 2013

putexcel C6 = `r(N)'

putexcel C7 = formula(1-C6/B3)

**2015
ta surveyed num_death if wave == 2015 ,m

count if surveyed== 1 & num_death ==0 & wave == 2015

putexcel D4 = `r(N)'

count if surveyed== 0 & num_death ==1 & wave == 2015

putexcel D5 = `r(N)'

count if surveyed== 0 & num_death ==0 & wave == 2015

putexcel D6 = `r(N)'

putexcel D7 = formula(1-D6/B3)


**2018
ta surveyed num_death if wave == 2018 ,m

count if surveyed== 1 & num_death ==0 & wave == 2018

putexcel E4 = `r(N)'

count if surveyed== 0 & num_death ==1 & wave == 2018

putexcel E5 = `r(N)'

count if surveyed== 0 & num_death ==0 & wave == 2018

putexcel E6 = `r(N)'

putexcel E7 = formula(1-E6/B3)


**2020
ta surveyed num_death if wave == 2020 ,m

count if surveyed== 1 & num_death ==0 & wave == 2020

putexcel F4 = `r(N)'

count if surveyed== 0 & num_death ==1 & wave == 2020

putexcel F5 = `r(N)'

count if surveyed== 0 & num_death ==0 & wave == 2020

putexcel F6 = `r(N)'

putexcel F7 = formula(1-F6/B3)


**---------------------------------------
**--------- new sample in 2013
**---------------------------------------

use $CHARLS_2013r\Weights, clear

drop if mi(ID)

keep ID crosssection longitudinal INDV_L_Died
save $working_data/samplewhole2013, replace

****
use $working_data/attrition_2011,clear

//2013
merge 1:1 ID using $working_data/samplewhole2013
ta _merge  crosssection,m

keep if _merge == 2

drop _merge

drop if INDV_L_Died == 1

keep ID crosssection longitudinal
save $working_data/newsample_2013, replace
//new sample in 2013

**
use $working_data/newsample_2013, clear

count 

local newsample_2013 = `r(N)'

//2015
merge 1:1 ID using $working_data/surveyed2015

keep if _merge == 1 |  _merge == 3
drop _merge

merge 1:1 ID using $working_data/death2015

keep if _merge == 1 |  _merge == 3
drop _merge

//2018
merge 1:1 ID using $working_data/surveyed2018

keep if _merge == 1 |  _merge == 3
drop _merge

merge 1:1 ID using $working_data/death2018

keep if _merge == 1 |  _merge == 3
drop _merge

//2020
merge 1:1 ID using $working_data/surveyed2020

keep if _merge == 1 |  _merge == 3
drop _merge

merge 1:1 ID using $working_data/death2020

keep if _merge == 1 |  _merge == 3
drop _merge


reshape long surveyed  death , i(ID) j(wave)

sort ID wave
order ID wave surveyed  death
bys ID: gen num_death = sum(death)
order ID wave surveyed  death num_death

putexcel C8 = `newsample_2013'

replace surveyed = 0 if mi(surveyed)

**2015
ta surveyed num_death if wave == 2015 ,m

count if surveyed== 1 & num_death ==0 & wave == 2015

putexcel D9 = `r(N)'

count if surveyed== 0 & num_death ==1 & wave == 2015

putexcel D10 = `r(N)'

count if surveyed== 0 & num_death ==0 & wave == 2015

putexcel D11 = `r(N)'

putexcel D12 = formula(1-D11/C8)

**2018
ta surveyed num_death if wave == 2018 ,m

count if surveyed== 1 & num_death ==0 & wave == 2018

putexcel E9 = `r(N)'

count if surveyed== 0 & num_death ==1 & wave == 2018

putexcel E10 = `r(N)'

count if surveyed== 0 & num_death ==0 & wave == 2018

putexcel E11 = `r(N)'

putexcel E12 = formula(1-E11/C8)

**2020
ta surveyed num_death if wave == 2020 ,m

count if surveyed== 1 & num_death ==0 & wave == 2020

putexcel F9 = `r(N)'

count if surveyed== 0 & num_death ==1 & wave == 2020

putexcel F10 = `r(N)'

count if surveyed== 0 & num_death ==0 & wave == 2020

putexcel F11 = `r(N)'

putexcel F12 = formula(1-F11/C8)



**---------------------------------------
**--------- new sample in 2015
**---------------------------------------
use $CHARLS_2015r\Sample_Infor, clear

drop if mi(ID)

keep ID crosssection  died
save $working_data/samplewhole2015, replace

****
use $working_data/attrition_2011,clear

//2013
merge 1:1 ID using $working_data/samplewhole2013
rename crosssection crosssection2013
rename longitudinal longitudinal2013
keep ID crosssection2013 longitudinal2013

merge 1:1 ID using $working_data/samplewhole2015
 
keep if _merge ==2 
drop _merge

drop if died == 1
//do not consider people who were death when they entered as new respondents
save $working_data/newsample_2015, replace
//new sample in 2015

count 

local newsample_2015 = `r(N)'

//2018
merge 1:1 ID using $working_data/surveyed2018

keep if _merge == 1 |  _merge == 3
drop _merge

merge 1:1 ID using $working_data/death2018

keep if _merge == 1 |  _merge == 3
drop _merge

//2020
merge 1:1 ID using $working_data/surveyed2020

keep if _merge == 1 |  _merge == 3
drop _merge

merge 1:1 ID using $working_data/death2020

keep if _merge == 1 |  _merge == 3
drop _merge


reshape long surveyed  death , i(ID) j(wave)

sort ID wave
order ID wave surveyed  death
bys ID: gen num_death = sum(death)
order ID wave surveyed  death num_death


putexcel D13 = `newsample_2015'

replace surveyed = 0 if mi(surveyed)


**2018
ta surveyed num_death if wave == 2018 ,m

count if surveyed== 1 & num_death ==0 & wave == 2018

putexcel E14 = `r(N)'

count if surveyed== 0 & num_death ==1 & wave == 2018

putexcel E15 = `r(N)'

count if surveyed== 0 & num_death ==0 & wave == 2018

putexcel E16 = `r(N)'

putexcel E17 = formula(1-E16/D13)

**2020
ta surveyed num_death if wave == 2020 ,m

count if surveyed== 1 & num_death ==0 & wave == 2020

putexcel F14 = `r(N)'

count if surveyed== 0 & num_death ==1 & wave == 2020

putexcel F15 = `r(N)'

count if surveyed== 0 & num_death ==0 & wave == 2020

putexcel F16 = `r(N)'

putexcel F17 = formula(1-F16/D13)


**---------------------------------------
**--------- new sample in 2018
**---------------------------------------
use $CHARLS_2018r\Sample_Infor,clear
keep ID crosssection died
save $working_data/samplewhole2018, replace


****
use $working_data/attrition_2011,clear

//2013
merge 1:1 ID using $working_data/samplewhole2013
rename crosssection crosssection2013
rename longitudinal longitudinal2013
keep ID crosssection2013 longitudinal2013

merge 1:1 ID using $working_data/samplewhole2015
rename crosssection  crosssection2015
rename died died2015
drop _merge

merge 1:1 ID using $working_data/samplewhole2018

keep if _merge ==2 
drop _merge

drop if died == 1
//do not consider people who were death when they entered as new respondents
save $working_data/newsample_2018, replace
// new sample in 2018

count 

local newsample_2018 = `r(N)'

//2020
merge 1:1 ID using $working_data/surveyed2020

keep if _merge == 1 |  _merge == 3
drop _merge

merge 1:1 ID using $working_data/death2020

keep if _merge == 1 |  _merge == 3
drop _merge


reshape long surveyed  death , i(ID) j(wave)

ta surveyed  death,m

ta surveyed  death if wave == 2020,m

sort ID wave
order ID wave surveyed  death
bys ID: gen num_death = sum(death)
order ID wave surveyed  death num_death

putexcel E18 = `newsample_2018'

replace surveyed = 0 if mi(surveyed)

**2020
ta surveyed num_death if wave == 2020 ,m

count if surveyed== 1 & num_death ==0 & wave == 2020

putexcel F19 = `r(N)'

count if surveyed== 0 & num_death ==1 & wave == 2020

putexcel F20 = `r(N)'

count if surveyed== 0 & num_death ==0 & wave == 2020

putexcel F21 = `r(N)'

putexcel F22 = formula(1-F21/E18)

putexcel save


erase $working_data/surveyed2013.dta
erase $working_data/surveyed2015.dta
erase $working_data/surveyed2018.dta
erase $working_data/surveyed2020.dta

erase $working_data/death2013.dta
erase $working_data/death2015.dta
erase $working_data/death2018.dta
erase $working_data/death2020.dta

erase $working_data/newsample_2013.dta
erase $working_data/newsample_2015.dta
erase $working_data/newsample_2018.dta

erase $working_data/samplewhole2013.dta
erase $working_data/samplewhole2015.dta
erase $working_data/samplewhole2018.dta

erase $working_data/attrition_2011.dta





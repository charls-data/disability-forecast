** ================================================================================================
** Aim:             disability rate and population, decomposition of disability rate (2011-2020)
** Author:          CHARLS team
** Created:         2020/20/14
** Modified:        2023/3/27
** Data input:      demo_info (not in public data)
**                  Post_Weights (not in public data)
**                  Var_Health_Status_20xx (not in public data)
**                  housing_characteristics (2011-2018)
**                  Household_Income (2020, including housing characteristics)
**                  psu (2011)
**                  pop_50_60 (number of people aged 50+ and aged 60+ from 2011 to 2020, from NBS) 
**                  hosptail_all_im (distance to the most visited hospital from 2011 to 2018, collected from community questionnaire, not in public data)
** Data output:     $working_data/disability_3index_bywave_1120
**                  $working_data/collapse_X_Y.dta
**                  $working_data/adl_iadl_coeff_weight
**                  $working_data/adl_plus_coeff_weight
**                  $working_data/adl_coeff_weight
** ==============================================================================================

//2011
use $CHARLS_2011r\demo_info,clear
merge 1:1 ID using $CHARLS_2011r\Post_Weights
keep if _merge==3 
drop _merge

merge 1:1 ID using  $charls_variable_set\Health_Status\Var_Health_Status_2011.dta
drop if _merge==2
drop _merge

merge m:1 householdID using $CHARLS_2011r\housing_characteristics.dta, keepusing(i012_3 i014s1 i014s2 i017)
drop if _merge==2
drop _merge

gen toilet=(i012_3>0 ) if !missing(i012_3)
label  var  toilet "Toilet or not "

gen toilet_sit=0 if !missing(i014s1) | !missing(i014s2)
replace toilet_sit=1 if i014s2==2

gen toilet_sit_inhouse = 0 if toilet == 0
replace toilet_sit_inhouse = 0 if toilet == 1 & toilet_sit == 0
replace toilet_sit_inhouse = 1 if toilet == 1 & toilet_sit == 1

gen toilet_unsit_inhouse = 0 if toilet == 0
replace  toilet_unsit_inhouse = 0 if toilet == 1  & toilet_sit == 1
replace toilet_unsit_inhouse = 1 if toilet == 1 & toilet_sit == 0

gen water = 1 if i017 == 1
replace water = 0 if i017 ==2

drop Wave
gen Wave=2011

order ADL* IADL*

keep ID householdID Gender Age Age_Group Hukou Edu Edu_Group Marry_Status INDV_weight_post2  Wave ADL* IADL*  toilet toilet_sit toilet_sit_inhouse toilet_unsit_inhouse water

save $working_data/ADL_2011,replace

//2013
use  $CHARLS_2013r\demo_info,clear
merge 1:1 ID using $CHARLS_2013r\Post_WeightS

keep if _merge==3 
drop _merge
merge 1:1 ID using  $charls_variable_set\Health_Status\Var_Health_Status_2013.dta
drop if _merge==2  //430
drop _merge


merge m:1 householdID using $CHARLS_2013r\housing_characteristics.dta, keepusing(i012_3 i014s1 i014s2 i017)
drop if _merge==2
drop _merge

gen toilet=(i012_3>0 ) if !missing(i012_3)
label  var  toilet "Toilet or not "

gen toilet_sit=0 if !missing(i014s1) | !missing(i014s2)
replace toilet_sit=1 if i014s2==2

gen toilet_sit_inhouse = 0 if toilet == 0
replace toilet_sit_inhouse = 0 if toilet == 1 & toilet_sit == 0
replace toilet_sit_inhouse = 1 if toilet == 1 & toilet_sit == 1

gen toilet_unsit_inhouse = 0 if toilet == 0
replace  toilet_unsit_inhouse = 0 if toilet == 1  & toilet_sit == 1
replace toilet_unsit_inhouse = 1 if toilet == 1 & toilet_sit == 0

gen water = 1 if i017 == 1
replace water = 0 if i017 ==2

gen Wave=2013
order ADL* IADL*

keep ID householdID Gender Age Age_Group Hukou Edu Edu_Group Marry_Status INDV_weight_post2  Wave ADL* IADL*  toilet toilet_sit toilet_sit_inhouse toilet_unsit_inhouse water
save $working_data/ADL_2013,replace

//2015
use D:\CHARLS_Data\CHARLS_Public\CHARLS2015r\demo_info,clear
merge 1:1 ID using D:\CHARLS_Data\CHARLS_Public\CHARLS2015r\Post_Weights
keep if _merge==3 //729
drop _merge
merge 1:1 ID using  $charls_variable_set\Health_Status\Var_Health_Status_2015.dta
drop if _merge==2  //1526
drop _merge

merge m:1 householdID using $CHARLS_2015r\housing_characteristics.dta, keepusing(i012_3 i014s1 i014s2 i017)
drop if _merge==2
drop _merge

gen toilet=(i012_3>0 ) if !missing(i012_3)
label  var  toilet "Toilet or not "

gen toilet_sit=0 if !missing(i014s1) | !missing(i014s2)
replace toilet_sit=1 if i014s2==2

gen toilet_sit_inhouse = 0 if toilet == 0
replace toilet_sit_inhouse = 0 if toilet == 1 & toilet_sit == 0
replace toilet_sit_inhouse = 1 if toilet == 1 & toilet_sit == 1

gen toilet_unsit_inhouse = 0 if toilet == 0
replace  toilet_unsit_inhouse = 0 if toilet == 1  & toilet_sit == 1
replace toilet_unsit_inhouse = 1 if toilet == 1 & toilet_sit == 0

gen water = 1 if i017 == 1
replace water = 0 if i017 ==2
gen Wave=2015

keep ID householdID Gender Age Age_Group Hukou Edu Edu_Group Marry_Status INDV_weight_post2  Wave ADL* IADL*  toilet toilet_sit toilet_sit_inhouse toilet_unsit_inhouse water
save $working_data/ADL_2015,replace

//2018
use D:\CHARLS_Data\CHARLS_Public\CHARLS2018r\demo_info,clear
merge 1:1 ID using D:\CHARLS_Data\CHARLS_Public\CHARLS2018r\Post_Weights
keep if _merge==3
drop _merge 

merge 1:1 ID using  $charls_variable_set\Health_Status\Var_Health_Status_2018r.dta
drop if _merge==2 
drop _merge

merge m:1 householdID using $CHARLS_2018r\Housing.dta, keepusing(i012_3 i014 i017)
drop if _merge==2
drop _merge

gen toilet=(i012_3>0 ) if !missing(i012_3)
label  var  toilet "Toilet or not "

gen toilet_sit=0 if !missing(i014)
replace toilet_sit=1 if i014==2

gen toilet_sit_inhouse = 0 if toilet == 0
replace toilet_sit_inhouse = 0 if toilet == 1 & toilet_sit == 0
replace toilet_sit_inhouse = 1 if toilet == 1 & toilet_sit == 1

gen toilet_unsit_inhouse = 0 if toilet == 0
replace  toilet_unsit_inhouse = 0 if toilet == 1  & toilet_sit == 1
replace toilet_unsit_inhouse = 1 if toilet == 1 & toilet_sit == 0

gen water = 1 if i017 == 1
replace water = 0 if i017 ==2

drop Wave
gen Wave=2018

order ADL* IADL*

keep ID householdID Gender Age Age_Group Hukou Edu Edu_Group Married INDV_weight_post2  Wave ADL* IADL* toilet toilet_sit toilet_sit_inhouse toilet_unsit_inhouse water
save $working_data/ADL_2018,replace

//2020
use $CHARLS_2020r\demo_info,clear
merge 1:1 ID using $CHARLS_2020r\Post_Weights
keep if _merge==3
drop _merge   

merge 1:1 ID using  $charls_variable_set\Health_Status\Var_Health_Status_2020r.dta
drop if _merge==2
recode Female(0=1)(1=2)(.=.),gen(Gender)
drop _merge

merge m:1 householdID using $CHARLS_2020r\Household_Income.dta, keepusing(i011_3 i013 i016)
drop if _merge==2
drop _merge

gen toilet=(i011_3>0 ) if !missing(i011_3)
label  var  toilet "Toilet or not "

gen toilet_sit=0 if !missing(i013) 
replace toilet_sit=1 if i013==2

gen toilet_sit_inhouse = 0 if toilet == 0
replace toilet_sit_inhouse = 0 if toilet == 1 & toilet_sit == 0
replace toilet_sit_inhouse = 1 if toilet == 1 & toilet_sit == 1

gen toilet_unsit_inhouse = 0 if toilet == 0
replace  toilet_unsit_inhouse = 0 if toilet == 1  & toilet_sit == 1
replace toilet_unsit_inhouse = 1 if toilet == 1 & toilet_sit == 0

gen water = 1 if i016 == 1
replace water = 0 if i016 ==2

gen Wave=2020
order ADL* IADL*
keep ID householdID Female Gender Age Age_Group Hukou Edu Edu_Group Married  INDV_weight_post2 ADL* IADL*  Wave  toilet toilet_sit toilet_sit_inhouse toilet_unsit_inhouse water

save $working_data/ADL_2020,replace

//merge
use $working_data/ADL_2011,clear
append using $working_data/ADL_2013
append using $working_data/ADL_2015
append using $working_data/ADL_2018
append using $working_data/ADL_2020

gen communityID = substr(ID,1,7)

merge m:1 communityID using $CHARLS_2011r\psu

drop _merge

count if mi(province)

gen region0=inlist(province,"江苏省","上海市")  //too long, seperate to two
gen region1=inlist(province,"北京", "天津", "河北省", "辽宁省","浙江省","福建省","山东省","广东省","海南省")
gen region2=inlist(province,"山西省" ,"吉林省","黑龙江省","安徽省","江西省","河南省","湖北省","湖南省")
gen region3=inlist(province,"四川省" ,"重庆市" ,"云南省","陕西省","甘肃省")
gen region4=inlist(province,"青海省","新疆维吾尔自治区","广西省","内蒙古自治区","贵州省") //too long, seperate to two

gen region=1 if region1==1|region0==1
replace region=2 if region2==1
replace region=3 if region3==1|region4==1
drop region1-region4

ta region,m

replace Hukou=. if Hukou==3 /*Unified Residence Hukou */
replace Hukou=. if Hukou==4 /*No Hukou*/

replace Edu_Group=6 if missing(Edu_Group)

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

ta ADL_IADL_any ADL_IADL_needhelp,m

**-------------------------------------------------------
**------rate to 100--------------------------------------
**-------------------------------------------------------

save $working_data/disability_3index_bywave_1120,replace

foreach var in ADL_needhelp_dressing ADL_needhelp_bathing  ADL_needhelp_eating ADL_needhelp_bed  ADL_needhelp_urinecontrol ADL_needhelp_toileting ADL_needhelp_any  ADL_cooking_shopping ADL_cs_medicine ADL_csm_money ADL_IADL_any IADL_needhelp_cooking IADL_needhelp_shopping IADL_needhelp_medicine IADL_needhelp_money IADL_needhelp_housework  {
	replace `var'=`var'*100
}

label var ADL_needhelp_any "Level 1 dependency"
label var ADL_cs_medicine "Level 2 dependency"
label var ADL_IADL_any "Level 3 dependency"

** ============================================================================
**      Figure 2: 2011-2020 disability rate: total
** ============================================================================

preserve
keep if Age>=60

svyset [pw=INDV_weight_post2]
svy: mean ADL_needhelp_any,over(Wave)

mat a = r(table)
mat num_adl = e(_N)


mat ADL_needhelp_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_needhelp_any
mat ADL_needhelp_any = [ADL_needhelp_any,(2011,2013,2015,2018,2020)',(1,1,1,1,1)']
mat list ADL_needhelp_any

mat drop a

svy: mean ADL_cs_medicine,over(Wave)

mat a = r(table)
mat num_adl_plus = e(_N)

mat ADL_cs_medicine = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat ADL_cs_medicine = [ADL_cs_medicine,(2011,2013,2015,2018,2020)',(2,2,2,2,2)']
mat list ADL_cs_medicine

mat drop a

svy: mean ADL_IADL_any,over(Wave)

mat a = r(table)
mat num_adl_iadl = e(_N)

mat ADL_IADL_any = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat ADL_IADL_any = [ADL_IADL_any,(2011,2013,2015,2018,2020)',(3,3,3,3,3)']
mat list ADL_IADL_any
mat drop a


mat adl_all = (ADL_needhelp_any \  ADL_cs_medicine \ ADL_IADL_any)

mat list adl_all

clear

svmat adl_all,name(col)

rename c4 Wave

gen c5_wave = c5 if Wave == 2011
replace c5_wave = c5 + 4 if Wave == 2013
replace c5_wave = c5 + 8 if Wave == 2015
replace c5_wave = c5 + 12 if Wave == 2018
replace c5_wave = c5 + 16 if Wave == 2020

twoway (bar b c5_wave if c5 == 1 ) ///
(bar b c5_wave if c5 == 2 ) ///
(bar b c5_wave if c5 == 3 ) ///
(rcap ul ll c5_wave, lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
 ytitle("%")  ylabel(0(5)25) ///
xlabel(2 "2011" 6 "2013" 10 "2015"  14 "2018"  18 "2020") xtitle("")

gr export $figures/Figure2.emf,replace
charls_figure2excel   $figures/Figure2.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure2) ///
    cell(1 8)  title("3 Index among Wave") note("Based on CHARLS2011-2020")

restore

putexcel set $tables/Lancet_public_health.xlsx, sheet(Table_A2_a, replace) modify

putexcel A3  = "Dependency rate in level 1"
putexcel A4  = "95% confidence interval"
putexcel A5  = "No. of observations"

putexcel A7  = "Dependency rate in level 2"
putexcel A8  = "95% confidence interval"
putexcel A9  = "No. of observations"

putexcel A11  = "Dependency rate in level 3"
putexcel A12  = "95% confidence interval"
putexcel A13  = "No. of observations"

putexcel B1  = "Wave"
putexcel B1:F1, merge
putexcel B2  = "2011"
putexcel C2  = "2013"
putexcel D2  = "2015"
putexcel E2  = "2018"
putexcel F2  = "2020"

putexcel B3  =  matrix(ADL_needhelp_any[1..5,1]'/100), nformat( 0.000)
putexcel B7  =  matrix(ADL_cs_medicine[1..5,1]'/100), nformat( 0.000)
putexcel B11  =  matrix(ADL_IADL_any[1..5,1]'/100), nformat( 0.000)

putexcel B5  =  matrix(num_adl), nformat( 0)
putexcel B9  =  matrix(num_adl_plus), nformat( 0)
putexcel B13  =  matrix(num_adl_iadl), nformat( 0)

preserve

clear

mat adl_all_outsheet = (ADL_needhelp_any ,  ADL_cs_medicine , ADL_IADL_any)

mat list adl_all_outsheet
mat adl_all_outsheet3 =adl_all_outsheet[1...,1]

mat adl_all_outsheet2 =[adl_all_outsheet[1..., 2],adl_all_outsheet[1..., 3],adl_all_outsheet[1..., 7],adl_all_outsheet[1..., 8],adl_all_outsheet[1..., 12],adl_all_outsheet[1..., 13]]


mat list adl_all_outsheet2  

svmat adl_all_outsheet2 

rename adl_all_outsheet21 adl_ll
rename adl_all_outsheet22 adl_ul
rename adl_all_outsheet23 adl_plus_ll
rename adl_all_outsheet24 adl_plus_ul
rename adl_all_outsheet25 adl_iadl_ll
rename adl_all_outsheet26 adl_iadl_ul

foreach x of varlist adl_ll adl_ul adl_plus_ll adl_plus_ul adl_iadl_ll adl_iadl_ul {
    replace `x' = `x'/100
}

tostring *, force replace format( %8.3f)

gen adl_iadl_ci = "("+adl_iadl_ll+"-"+adl_iadl_ul+")"
gen adl_ci = "("+adl_ll+"-"+adl_ul+")"
gen adl_plus_ci = "("+adl_plus_ll+"-"+adl_plus_ul+")"

putexcel B4 = adl_ci[1]
putexcel C4 = adl_ci[2]
putexcel D4 = adl_ci[3]
putexcel E4 = adl_ci[4]
putexcel F4 = adl_ci[5]

putexcel B8 = adl_plus_ci[1]
putexcel C8 = adl_plus_ci[2]
putexcel D8 = adl_plus_ci[3]
putexcel E8 = adl_plus_ci[4]
putexcel F8 = adl_plus_ci[5]

putexcel B12 = adl_iadl_ci[1]
putexcel C12 = adl_iadl_ci[2]
putexcel D12 = adl_iadl_ci[3]
putexcel E12 = adl_iadl_ci[4]
putexcel F12 = adl_iadl_ci[5]

restore

** ============================================================================
**     Figure A1(b) 2011-2020 disability rate by age group
** ============================================================================
 

preserve

gen Age_Group10 = 1 if Age_Group == 4 |  Age_Group == 5
replace Age_Group10 = 2 if Age_Group == 6 |  Age_Group == 7 | Age_Group == 8
label def Age_Group10 1 "60-69" 2 "70+"  
label val Age_Group10 Age_Group10

keep if Age>=60

svyset [pw=INDV_weight_post2]
svy: mean ADL_needhelp_any,over(Wave Age_Group10)


mat a = r(table)

mat list a

mat ADL_needhelp_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_needhelp_any
mat ADL_needhelp_any = [ADL_needhelp_any,(2011,2011,2013,2013,2015,2015,2018,2018,2020,2020)',(1,1,1,1,1,1,1,1,1,1)',(1,2,1,2,1,2,1,2,1,2)']
mat list ADL_needhelp_any

mat drop a

svy: mean ADL_cs_medicine,over(Wave Age_Group10)

mat a = r(table)

mat list a

mat ADL_cs_medicine = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_cs_medicine
mat ADL_cs_medicine = [ADL_cs_medicine,(2011,2011,2013,2013,2015,2015,2018,2018,2020,2020)',(2,2,2,2,2,2,2,2,2,2)',(1,2,1,2,1,2,1,2,1,2)']
mat list ADL_needhelp_any

mat drop a

svy: mean ADL_IADL_any,over(Wave Age_Group10)

mat a = r(table)

mat list a

mat ADL_IADL_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_IADL_any
mat ADL_IADL_any = [ADL_IADL_any,(2011,2011,2013,2013,2015,2015,2018,2018,2020,2020)',(3,3,3,3,3,3,3,3,3,3)',(1,2,1,2,1,2,1,2,1,2)']
mat list ADL_IADL_any

mat drop a


mat adl_all = (ADL_needhelp_any \  ADL_cs_medicine \ ADL_IADL_any)

mat list adl_all

clear

svmat adl_all,name(col)

cap drop Wave
rename c4 Wave

cap drop Age_Group10
rename c6 Age_Group10 


gen c5_wave = c5 if Wave == 2011
replace c5_wave = c5 + 4 if Wave == 2013
replace c5_wave = c5 + 8 if Wave == 2015
replace c5_wave = c5 + 12 if Wave == 2018
replace c5_wave = c5 + 16 if Wave == 2020

gen c5_wave_Age_Group10 =  c5_wave if  Age_Group10 == 1
replace c5_wave_Age_Group10 =  c5_wave + 21 if  Age_Group10 == 2


label def Age_Group10 1 "Age 60-69" 2 "Age 70+"
label value Age_Group10 Age_Group10


twoway (bar b c5_wave_Age_Group10 if c5 == 1   ) ///
(bar b c5_wave_Age_Group10 if c5 == 2  ) ///
(bar b c5_wave_Age_Group10 if c5 == 3  ) ///
(rcap ul ll c5_wave_Age_Group10  , lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave_Age_Group10   , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ylabel(0(5)30) ///
xlabel(2 "2011" 6 "2013" 10 `""2015" "Age 60-69" "'  14 "2018"  18 "2020" 23 "2011" 27 "2013" 31 `""2015" "Age 70+""'  35 "2018"  39 "2020")  ytitle("%")  ///
xtitle("")
gr export $figures/Figure_A1_b.emf,replace
charls_figure2excel   $figures/Figure_A1_b.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A1_b) ///
    cell(1 8)  title("3 Index among Wave by Age") note("Based on CHARLS2011-2020")


restore

** ============================================================================
**      Figure A2 (a): 2011-2020 disability rate by hukou
** ============================================================================

preserve
keep if Age>=60


svyset [pw=INDV_weight_post2]
svy: mean ADL_needhelp_any,over(Wave Hukou)

mat a = r(table)

mat list a

mat ADL_needhelp_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_needhelp_any
mat ADL_needhelp_any = [ADL_needhelp_any,(2011,2011,2013,2013,2015,2015,2018,2018,2020,2020)',(1,1,1,1,1,1,1,1,1,1)',(1,2,1,2,1,2,1,2,1,2)']
mat list ADL_needhelp_any

mat drop a

svy: mean ADL_cs_medicine,over(Wave Hukou)

mat a = r(table)

mat list a

mat ADL_cs_medicine = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_cs_medicine
mat ADL_cs_medicine = [ADL_cs_medicine,(2011,2011,2013,2013,2015,2015,2018,2018,2020,2020)',(2,2,2,2,2,2,2,2,2,2)',(1,2,1,2,1,2,1,2,1,2)']
mat list ADL_needhelp_any

mat drop a

svy: mean ADL_IADL_any,over(Wave Hukou)

mat a = r(table)

mat list a

mat ADL_IADL_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_IADL_any
mat ADL_IADL_any = [ADL_IADL_any,(2011,2011,2013,2013,2015,2015,2018,2018,2020,2020)',(3,3,3,3,3,3,3,3,3,3)',(1,2,1,2,1,2,1,2,1,2)']
mat list ADL_IADL_any

mat drop a


mat adl_all = (ADL_needhelp_any \  ADL_cs_medicine \ ADL_IADL_any)

mat list adl_all

clear

svmat adl_all,name(col)

cap drop Wave
rename c4 Wave

cap drop Hukou
rename c6 Hukou 


gen c5_wave = c5 if Wave == 2011
replace c5_wave = c5 + 4 if Wave == 2013
replace c5_wave = c5 + 8 if Wave == 2015
replace c5_wave = c5 + 12 if Wave == 2018
replace c5_wave = c5 + 16 if Wave == 2020

gen c5_wave_hukou =  c5_wave if  Hukou == 1
replace c5_wave_hukou =  c5_wave + 21 if  Hukou == 2

label def Hukou 1 "Rural Hukou" 2 "Urban Hukou"
label value Hukou Hukou

twoway (bar b c5_wave_hukou if c5 == 1   ) ///
(bar b c5_wave_hukou if c5 == 2  ) ///
(bar b c5_wave_hukou if c5 == 3  ) ///
(rcap ul ll c5_wave_hukou  , lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave_hukou   , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ylabel(0(5)30) ///
xlabel(2 "2011" 6 "2013" 10 `""2015" "Rural Hukou" "'  14 "2018"  18 "2020" 23 "2011" 27 "2013" 31 `""2015" "Urban Hukou""'  35 "2018"  39 "2020")   ytitle("%")  ///
xtitle("")
gr export $figures/Figure_A2_a.emf,replace
charls_figure2excel   $figures/Figure_A2_a.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A2_a) ///
    cell(1 8)  title("3 Index among Wave by Hukou") note("Based on CHARLS2011-2020")

restore

** ============================================================================
**      Figure A2 (b):2011-2020 disability rate by hukou by age group
** ============================================================================

preserve
gen Age_Group10 = 1 if Age_Group == 4 |  Age_Group == 5
replace Age_Group10 = 2 if Age_Group == 6 |  Age_Group == 7 |  Age_Group == 8
label def Age_Group10 1 "60-69" 2 "70+"
label val Age_Group10 Age_Group10

collapse(mean)  ADL_needhelp_any  ADL_cs_medicine ADL_IADL_any [pw=INDV_weight_post2]  if Age>=60,by(Wave Hukou Age_Group10)
sort  Hukou Age_Group10  Wave 

format ADL_needhelp_any ADL_cs_medicine ADL_IADL_any   %8.1f
order Hukou Age_Group10 Wave  ADL_needhelp_any ADL_cs_medicine ADL_IADL_any
restore

preserve
keep if Age>=60

gen Age_Group10 = 1 if Age_Group == 4 |  Age_Group == 5
replace Age_Group10 = 2 if Age_Group == 6 |  Age_Group == 7 |  Age_Group == 8
label def Age_Group10 1 "60-69" 2 "70+"
label val Age_Group10 Age_Group10

svyset [pw=INDV_weight_post2]
svy: mean ADL_needhelp_any  ,over(Wave Hukou Age_Group10)

mat a = r(table)

mat list a

mat ADL_needhelp_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_needhelp_any
mat ADL_needhelp_any = [(2011,2011,2011,2011,2013,2013,2013,2013,2015,2015,2015,2015,2018,2018,2018,2018,2020,2020,2020,2020)',(1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2)',(1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)',(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)',ADL_needhelp_any]
mat list ADL_needhelp_any

mat drop a

svy: mean ADL_cs_medicine,over(Wave Hukou Age_Group10)

mat a = r(table)

mat list a

mat ADL_cs_medicine = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_cs_medicine
mat ADL_cs_medicine = [(2011,2011,2011,2011,2013,2013,2013,2013,2015,2015,2015,2015,2018,2018,2018,2018,2020,2020,2020,2020)',(1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2)',(1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)',(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)',ADL_cs_medicine]
mat list ADL_cs_medicine

mat drop a

svy: mean ADL_IADL_any,over(Wave Hukou Age_Group10)

mat a = r(table)

mat list a

mat ADL_IADL_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_IADL_any
mat ADL_IADL_any = [(2011,2011,2011,2011,2013,2013,2013,2013,2015,2015,2015,2015,2018,2018,2018,2018,2020,2020,2020,2020)',(1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2)',(1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)',(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)',ADL_IADL_any]
mat list ADL_IADL_any

mat drop a


mat adl_all = (ADL_needhelp_any \ ADL_cs_medicine \ ADL_IADL_any)

mat list adl_all

mat colnames adl_all =  Wave Hukou Age_Group10 disability disability_ll disability_ul 

mat list adl_all

clear

svmat adl_all

rename adl_all1 Wave
rename adl_all2 Hukou
rename adl_all3 Age_Group10

rename adl_all4 c5

rename adl_all5 b
rename adl_all6 ll
rename adl_all7 ul

sort Hukou Age_Group10 Wave
order Hukou Age_Group10 Wave

label def Age_Group10 1 "60-69" 2 "70+" 
label val Age_Group10 Age_Group10

label def Hukou 1 "Agricultural Hukou" 2 "Non-Agricultural Hukou"
label value Hukou Hukou

format b ul ll  %8.1f

gen c5_wave = c5 if Wave == 2011
replace c5_wave = c5 + 4 if Wave == 2013
replace c5_wave = c5 + 8 if Wave == 2015
replace c5_wave = c5 + 12 if Wave == 2018
replace c5_wave = c5 + 16 if Wave == 2020


gen c5_wave_Age_Group10 =  c5_wave if  Age_Group10 == 1
replace c5_wave_Age_Group10 =  c5_wave + 21 if  Age_Group10 == 2


twoway (bar b c5_wave_Age_Group10 if c5 == 1 & Hukou == 1  ) ///
(bar b c5_wave_Age_Group10 if c5 == 2 & Hukou == 1  ) ///
(bar b c5_wave_Age_Group10 if c5 == 3  & Hukou == 1  ) ///
(rcap ul ll c5_wave_Age_Group10 if   Hukou == 1  , lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave_Age_Group10 if   Hukou == 1  , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
xlabel(2 "2011" 6 "2013" 10 `""2015" "Age 60-69" "'  14 "2018"  18 "2020" 23 "2011" 27 "2013" 31 `""2015" "Age 70+""'  35 "2018"  39 "2020")  title("Rural Hukou") ytitle("%")  ///
xtitle("")
gr export $figures/Figure_A2_b_rural.emf,replace
charls_figure2excel   $figures/Figure_A2_b_rural.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A2_b) ///
    cell(1 8)  title("3 Index among Wave by age group in rural") note("Based on CHARLS2011-2020")

 twoway (bar b c5_wave_Age_Group10 if c5 == 1 & Hukou == 2  ) ///
(bar b c5_wave_Age_Group10 if c5 == 2 & Hukou == 2) ///
(bar b c5_wave_Age_Group10 if c5 == 3  & Hukou == 2  ) ///
(rcap ul ll c5_wave_Age_Group10 if   Hukou == 2  , lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave_Age_Group10 if   Hukou == 2  , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
xlabel(2 "2011" 6 "2013" 10 `""2015" "Age 60-69" "'  14 "2018"  18 "2020" 23 "2011" 27 "2013" 31 `""2015" "Age 70+""'  35 "2018"  39 "2020")  title("Urban Hukou") ytitle("%")  ///
xtitle("")
gr export $figures/Figure_A2_b_urban.emf,replace
charls_figure2excel   $figures/Figure_A2_b_urban.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A2_b) ///
    cell(30 8)  title("3 Index among Wave by age group in urban") note("Based on CHARLS2011-2020")   

restore


 
** ============================================================================
**     Figure A1 (a): 2011-2020 disability rate by gender
** ============================================================================
preserve
keep if Age>=60

svyset [pw=INDV_weight_post2]
svy: mean ADL_needhelp_any,over(Wave Gender)

mat a = r(table)

mat list a

mat ADL_needhelp_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_needhelp_any
mat ADL_needhelp_any = [ADL_needhelp_any,(2011,2011,2013,2013,2015,2015,2018,2018,2020,2020)',(1,1,1,1,1,1,1,1,1,1)',(1,2,1,2,1,2,1,2,1,2)']
mat list ADL_needhelp_any

mat drop a

svy: mean ADL_cs_medicine,over(Wave Gender)

mat a = r(table)

mat list a

mat ADL_cs_medicine = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_cs_medicine
mat ADL_cs_medicine = [ADL_cs_medicine,(2011,2011,2013,2013,2015,2015,2018,2018,2020,2020)',(2,2,2,2,2,2,2,2,2,2)',(1,2,1,2,1,2,1,2,1,2)']
mat list ADL_needhelp_any

mat drop a

svy: mean ADL_IADL_any,over(Wave Gender)

mat a = r(table)

mat list a

mat ADL_IADL_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_IADL_any
mat ADL_IADL_any = [ADL_IADL_any,(2011,2011,2013,2013,2015,2015,2018,2018,2020,2020)',(3,3,3,3,3,3,3,3,3,3)',(1,2,1,2,1,2,1,2,1,2)']
mat list ADL_IADL_any

mat drop a


mat adl_all = (ADL_needhelp_any \  ADL_cs_medicine \ ADL_IADL_any)

mat list adl_all

clear

svmat adl_all,name(col)

cap drop Wave
rename c4 Wave

cap drop Gender
rename c6 Gender 


gen c5_wave = c5 if Wave == 2011
replace c5_wave = c5 + 4 if Wave == 2013
replace c5_wave = c5 + 8 if Wave == 2015
replace c5_wave = c5 + 12 if Wave == 2018
replace c5_wave = c5 + 16 if Wave == 2020


gen c5_wave_Gender =  c5_wave if  Gender == 1
replace c5_wave_Gender =  c5_wave + 21 if  Gender == 2



twoway (bar b c5_wave_Gender if c5 == 1   ) ///
(bar b c5_wave_Gender if c5 == 2  ) ///
(bar b c5_wave_Gender if c5 == 3  ) ///
(rcap ul ll c5_wave_Gender  , lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave_Gender   , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
xlabel(2 "2011" 6 "2013" 10 `""2015" "Male" "'  14 "2018"  18 "2020" 23 "2011" 27 "2013" 31 `""2015" "Female""'  35 "2018"  39 "2020")    ytitle("%") ylabel(0(5)30)  ///
xtitle("")

gr export $figures/Figure_A1_a.emf,replace

charls_figure2excel   $figures/Figure_A1_a.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A1_a) ///
    cell(1 8)  title("3 Index among Wave by Gender") note("Based on CHARLS2011-2020")

restore

** ============================================================================
**    Figure A1 (c): 2011-2020 disability rate by gender by age group
** ============================================================================

preserve
gen Age_Group10 = 1 if Age_Group == 4 |  Age_Group == 5
replace Age_Group10 = 2 if Age_Group == 6 |  Age_Group == 7
replace Age_Group10 = 3 if Age_Group == 8
label def Age_Group10 1 "60-69" 2 "70-79" 3 "80+"
label val Age_Group10 Age_Group10

collapse(mean)  ADL_needhelp_any  ADL_cs_medicine ADL_IADL_any [pw=INDV_weight_post2]  if Age>=60,by(Wave Gender Age_Group10)
sort  Gender Age_Group10  Wave 

format ADL_needhelp_any ADL_cs_medicine ADL_IADL_any   %8.1f
order Gender Age_Group10 Wave  ADL_needhelp_any ADL_cs_medicine ADL_IADL_any
restore

preserve
keep if Age>=60

gen Age_Group10 = 1 if Age_Group == 4 |  Age_Group == 5
replace Age_Group10 = 2 if Age_Group == 6 |  Age_Group == 7 |  Age_Group == 8
label def Age_Group10 1 "60-69" 2 "70+"
label val Age_Group10 Age_Group10

svyset [pw=INDV_weight_post2]
svy: mean ADL_needhelp_any  ,over(Wave Gender Age_Group10)

mat a = r(table)

mat list a

mat ADL_needhelp_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_needhelp_any
mat ADL_needhelp_any = [(2011,2011,2011,2011,2013,2013,2013,2013,2015,2015,2015,2015,2018,2018,2018,2018,2020,2020,2020,2020)',(1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2)',(1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)',(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)',ADL_needhelp_any]
mat list ADL_needhelp_any

mat drop a

svy: mean ADL_cs_medicine,over(Wave Gender Age_Group10)

mat a = r(table)

mat list a

mat ADL_cs_medicine = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_cs_medicine
mat ADL_cs_medicine = [(2011,2011,2011,2011,2013,2013,2013,2013,2015,2015,2015,2015,2018,2018,2018,2018,2020,2020,2020,2020)',(1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2)',(1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)',(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)',ADL_cs_medicine]
mat list ADL_cs_medicine

mat drop a

svy: mean ADL_IADL_any,over(Wave Gender Age_Group10)

mat a = r(table)

mat list a

mat ADL_IADL_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_IADL_any
mat ADL_IADL_any = [(2011,2011,2011,2011,2013,2013,2013,2013,2015,2015,2015,2015,2018,2018,2018,2018,2020,2020,2020,2020)',(1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2)',(1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)',(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)',ADL_IADL_any]
mat list ADL_IADL_any

mat drop a


mat adl_all = (ADL_needhelp_any \ ADL_cs_medicine \ ADL_IADL_any)

mat list adl_all

mat colnames adl_all =  Wave Gender Age_Group10 disability disability_ll disability_ul 

mat list adl_all

clear

svmat adl_all

rename adl_all1 Wave
rename adl_all2 Gender
rename adl_all3 Age_Group10

rename adl_all4 c5

rename adl_all5 b
rename adl_all6 ll
rename adl_all7 ul


label def Age_Group10 1 "60-69" 2 "70+" 
label val Age_Group10 Age_Group10

label def Gender 1 "Male" 2 "Female"
label value Gender Gender

format b ul ll  %8.1f

gen c5_wave = c5 if Wave == 2011
replace c5_wave = c5 + 4 if Wave == 2013
replace c5_wave = c5 + 8 if Wave == 2015
replace c5_wave = c5 + 12 if Wave == 2018
replace c5_wave = c5 + 16 if Wave == 2020


gen c5_wave_Age_Group10 =  c5_wave if  Age_Group10 == 1
replace c5_wave_Age_Group10 =  c5_wave + 21 if  Age_Group10 == 2


twoway (bar b c5_wave_Age_Group10 if c5 == 1 & Gender == 1  ) ///
(bar b c5_wave_Age_Group10 if c5 == 2 & Gender == 1  ) ///
(bar b c5_wave_Age_Group10 if c5 == 3  & Gender == 1  ) ///
(rcap ul ll c5_wave_Age_Group10 if   Gender == 1  , lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave_Age_Group10 if   Gender == 1  , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
xlabel(2 "2011" 6 "2013" 10 `""2015" "Age 60-69" "'  14 "2018"  18 "2020" 23 "2011" 27 "2013" 31 `""2015" "Age 70+""'  35 "2018"  39 "2020")  title("Male") ytitle("%")  ///
xtitle("")
gr export $figures/Figure_A1_c_male.emf,replace
charls_figure2excel   $figures/Figure_A1_c_male.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A1_c) ///
    cell(1 8)  title("3 Index among Wave by age group for male") note("Based on CHARLS2011-2020")

 twoway (bar b c5_wave_Age_Group10 if c5 == 1 & Gender == 2  ) ///
(bar b c5_wave_Age_Group10 if c5 == 2 & Gender == 2) ///
(bar b c5_wave_Age_Group10 if c5 == 3  & Gender == 2  ) ///
(rcap ul ll c5_wave_Age_Group10 if   Gender == 2  , lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave_Age_Group10 if   Gender == 2  , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
xlabel(2 "2011" 6 "2013" 10 `""2015" "Age 60-69" "'  14 "2018"  18 "2020" 23 "2011" 27 "2013" 31 `""2015" "Age 70+""'  35 "2018"  39 "2020")  title("Female") ytitle("%")  ///
xtitle("")
gr export $figures/Figure_A1_c_female.emf,replace
charls_figure2excel   $figures/Figure_A1_c_female.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A1_c) ///
    cell(30 8)  title("3 Index among Wave by age group for female") note("Based on CHARLS2011-2020")   

restore


** ============================================================================
**    Figure A3 (a): 2011-2020 disability rate by region
** ============================================================================

preserve
keep if Age>=60

svyset [pw=INDV_weight_post2]
svy: mean ADL_needhelp_any,over(Wave region)

mat a = r(table)

mat list a

mat ADL_needhelp_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_needhelp_any
mat ADL_needhelp_any = [ADL_needhelp_any,(2011,2011,2011,2013,2013,2013,2015,2015,2015,2018,2018,2018,2020,2020,2020)',(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)',(1,2,3,1,2,3,1,2,3,1,2,3,1,2,3)']
mat list ADL_needhelp_any


mat drop a

svy: mean ADL_cs_medicine,over(Wave region)

mat a = r(table)

mat list a

mat ADL_cs_medicine = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_cs_medicine
mat ADL_cs_medicine = [ADL_cs_medicine,(2011,2011,2011,2013,2013,2013,2015,2015,2015,2018,2018,2018,2020,2020,2020)',(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)',(1,2,3,1,2,3,1,2,3,1,2,3,1,2,3)']
mat list ADL_needhelp_any

mat drop a

svy: mean ADL_IADL_any,over(Wave region)

mat a = r(table)

mat list a

mat ADL_IADL_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_IADL_any
mat ADL_IADL_any = [ADL_IADL_any,(2011,2011,2011,2013,2013,2013,2015,2015,2015,2018,2018,2018,2020,2020,2020)',(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)',(1,2,3,1,2,3,1,2,3,1,2,3,1,2,3)']
mat list ADL_IADL_any

mat drop a


mat adl_all = (ADL_needhelp_any \  ADL_cs_medicine \ ADL_IADL_any)

mat list adl_all

clear

svmat adl_all,name(col)

cap drop Wave
rename c4 Wave

cap drop region
rename c6 region 


gen c5_wave = c5 if Wave == 2011
replace c5_wave = c5 + 4 if Wave == 2013
replace c5_wave = c5 + 8 if Wave == 2015
replace c5_wave = c5 + 12 if Wave == 2018
replace c5_wave = c5 + 16 if Wave == 2020

**region==1东部
twoway (bar b c5_wave if c5 == 1 & region == 1 ) ///
(bar b c5_wave if c5 == 2 & region == 1) ///
(bar b c5_wave if c5 == 3 & region == 1) ///
(rcap ul ll c5_wave if region == 1, lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave if region == 1 , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
title("East") ytitle("%") ylabel(0(5)25)  ///
xlabel(2 "2011" 6 "2013" 10 "2015"  14 "2018"  18 "2020") xtitle("")
 gr export $figures/Figure_A3_a_East.emf,replace
charls_figure2excel   $figures/Figure_A3_a_East.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A3_a) ///
    cell(20 8)  title("East: 3 Index among Wave") note("Based on CHARLS2011-2020")

twoway (bar b c5_wave if c5 == 1 & region == 2 ) ///
(bar b c5_wave if c5 == 2 & region == 2) ///
(bar b c5_wave if c5 == 3 & region == 2) ///
(rcap ul ll c5_wave if region == 2, lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave if region == 2 , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
title("Middle") ytitle("%") ylabel(0(5)30)  ///
xlabel(2 "2011" 6 "2013" 10 "2015"  14 "2018"  18 "2020") xtitle("")
gr export $figures/Figure_A3_a_Middle.emf,replace
charls_figure2excel   $figures/Figure_A3_a_Middle.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A3_a) ///
    cell(50 8)  title("Middle: 3 Index among Wave") note("Based on CHARLS2011-2020")

 twoway (bar b c5_wave if c5 == 1 & region == 3 ) ///
(bar b c5_wave if c5 == 2 & region == 3) ///
(bar b c5_wave if c5 == 3 & region == 3) ///
(rcap ul ll c5_wave if region == 3, lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave if region == 3 , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
title("West") ytitle("%") ylabel(0(5)30)  ///
xlabel(2 "2011" 6 "2013" 10 "2015"  14 "2018"  18 "2020") xtitle("")
gr export $figures/Figure_A3_a_West.emf,replace
charls_figure2excel   $figures/Figure_A3_a_West.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A3_a) ///
    cell(80 8)  title("West: 3 Index among Wave") note("Based on CHARLS2011-2020")
 
restore


** ============================================================================
**     Figure A3 (b): 2011-2020 disability rate by region by age group
** ============================================================================

preserve
keep if Age>=60

gen Age_Group10 = 1 if Age_Group == 4 |  Age_Group == 5
replace Age_Group10 = 2 if Age_Group == 6 |  Age_Group == 7 |  Age_Group == 8
label def Age_Group10 1 "60-69" 2 "70+"
label val Age_Group10 Age_Group10

svyset [pw=INDV_weight_post2]
svy: mean ADL_needhelp_any  ,over(Wave region Age_Group10)

mat a = r(table)

mat list a

mat ADL_needhelp_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_needhelp_any
mat ADL_needhelp_any = [(2011,2011,2011,2011,2011,2011,2013,2013,2013,2013,2013,2013,2015,2015,2015,2015,2015,2015,2018,2018,2018,2018,2018,2018,2020,2020,2020,2020,2020,2020)',(1,1,2,2,3,3,1,1,2,2,3,3,1,1,2,2,3,3,1,1,2,2,3,3,1,1,2,2,3,3)',(1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)',(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)',ADL_needhelp_any]
mat list ADL_needhelp_any

mat drop a

svy: mean ADL_cs_medicine,over(Wave region Age_Group10)

mat a = r(table)

mat list a

mat ADL_cs_medicine = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_cs_medicine
mat ADL_cs_medicine = [(2011,2011,2011,2011,2011,2011,2013,2013,2013,2013,2013,2013,2015,2015,2015,2015,2015,2015,2018,2018,2018,2018,2018,2018,2020,2020,2020,2020,2020,2020)',(1,1,2,2,3,3,1,1,2,2,3,3,1,1,2,2,3,3,1,1,2,2,3,3,1,1,2,2,3,3)',(1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)',(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)',ADL_cs_medicine]
mat list ADL_cs_medicine

mat drop a

svy: mean ADL_IADL_any,over(Wave region Age_Group10)

mat a = r(table)

mat list a

mat ADL_IADL_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_IADL_any
mat ADL_IADL_any = [(2011,2011,2011,2011,2011,2011,2013,2013,2013,2013,2013,2013,2015,2015,2015,2015,2015,2015,2018,2018,2018,2018,2018,2018,2020,2020,2020,2020,2020,2020)',(1,1,2,2,3,3,1,1,2,2,3,3,1,1,2,2,3,3,1,1,2,2,3,3,1,1,2,2,3,3)',(1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)',(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3)',ADL_IADL_any]
mat list ADL_IADL_any

mat drop a


mat adl_all = (ADL_needhelp_any \ ADL_cs_medicine \ ADL_IADL_any)

mat list adl_all

mat colnames adl_all =  Wave region Age_Group10 disability disability_ll disability_ul 

mat list adl_all

clear

svmat adl_all

rename adl_all1 Wave
rename adl_all2 region
rename adl_all3 Age_Group10

rename adl_all4 c5

rename adl_all5 b
rename adl_all6 ll
rename adl_all7 ul


label def Age_Group10 1 "60-69" 2 "70+" 
label val Age_Group10 Age_Group10

label def region 1 "East" 2 "Middle" 3 "West"
label value region region

format b ul ll  %8.1f

gen c5_wave = c5 if Wave == 2011
replace c5_wave = c5 + 4 if Wave == 2013
replace c5_wave = c5 + 8 if Wave == 2015
replace c5_wave = c5 + 12 if Wave == 2018
replace c5_wave = c5 + 16 if Wave == 2020


gen c5_wave_Age_Group10 =  c5_wave if  Age_Group10 == 1
replace c5_wave_Age_Group10 =  c5_wave + 21 if  Age_Group10 == 2


twoway (bar b c5_wave_Age_Group10 if c5 == 1 & region == 1  ) ///
(bar b c5_wave_Age_Group10 if c5 == 2 & region == 1  ) ///
(bar b c5_wave_Age_Group10 if c5 == 3  & region == 1  ) ///
(rcap ul ll c5_wave_Age_Group10 if   region == 1  , lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave_Age_Group10 if   region == 1  , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
xlabel(2 "2011" 6 "2013" 10 `""2015" "Age 60-69" "'  14 "2018"  18 "2020" 23 "2011" 27 "2013" 31 `""2015" "Age 70+""'  35 "2018"  39 "2020")  title("East") ytitle("%")  ///
xtitle("")
gr export $figures/Figure_A3_b_east.emf,replace
charls_figure2excel   $figures/Figure_A3_b_east.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A3_b) ///
    cell(1 8)  title("3 Index among Wave by age group in east") note("Based on CHARLS2011-2020")

 twoway (bar b c5_wave_Age_Group10 if c5 == 1 & region == 2  ) ///
(bar b c5_wave_Age_Group10 if c5 == 2 & region == 2) ///
(bar b c5_wave_Age_Group10 if c5 == 3  & region == 2  ) ///
(rcap ul ll c5_wave_Age_Group10 if   region == 2  , lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave_Age_Group10 if   region == 2  , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
xlabel(2 "2011" 6 "2013" 10 `""2015" "Age 60-69" "'  14 "2018"  18 "2020" 23 "2011" 27 "2013" 31 `""2015" "Age 70+""'  35 "2018"  39 "2020")  title("Middle") ytitle("%")  ///
xtitle("")
gr export $figures/Figure_A3_b_middle.emf,replace
charls_figure2excel   $figures/Figure_A3_b_middle.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A3_b) ///
    cell(30 8)  title("3 Index among Wave by age group in middle") note("Based on CHARLS2011-2020")   


 twoway (bar b c5_wave_Age_Group10 if c5 == 1 & region == 3  ) ///
(bar b c5_wave_Age_Group10 if c5 == 2 & region == 3) ///
(bar b c5_wave_Age_Group10 if c5 == 3  & region == 3  ) ///
(rcap ul ll c5_wave_Age_Group10 if   region == 3  , lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave_Age_Group10 if   region == 3  , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
xlabel(2 "2011" 6 "2013" 10 `""2015" "Age 60-69" "'  14 "2018"  18 "2020" 23 "2011" 27 "2013" 31 `""2015" "Age 70+""'  35 "2018"  39 "2020")  title("West") ytitle("%")  ///
xtitle("")
gr export $figures/Figure_A3_b_west.emf,replace
charls_figure2excel   $figures/Figure_A3_b_west.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A3_b) ///
    cell(60 8)  title("3 Index among Wave by age group in west") note("Based on CHARLS2011-2020")   
restore

** ============================================================================
**    Figure A4 (a), Figure A4 (b):  2011-2020 ADL and IADL items disability rate 
** ============================================================================
//ADL items
preserve
keep if Age>=60

svyset [pw=INDV_weight_post2]
svy: mean ADL_needhelp_bathing,over(Wave )

mat a = r(table)

mat ADL_needhelp_bathing = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_needhelp_bathing
mat ADL_needhelp_bathing = [ADL_needhelp_bathing,(2011,2013,2015,2018,2020)',(1,1,1,1,1)']
mat list ADL_needhelp_bathing

mat drop a

svy: mean ADL_needhelp_bed,over(Wave)

mat a = r(table)

mat ADL_needhelp_bed = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat ADL_needhelp_bed = [ADL_needhelp_bed,(2011,2013,2015,2018,2020)',(2,2,2,2,2)']
mat list ADL_needhelp_bed

mat drop a

svy: mean ADL_needhelp_dressing,over(Wave)

mat a = r(table)

mat ADL_needhelp_dressing = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat ADL_needhelp_dressing = [ADL_needhelp_dressing,(2011,2013,2015,2018,2020)',(3,3,3,3,3)']
mat list ADL_needhelp_dressing
mat drop a


svy: mean ADL_needhelp_eating,over(Wave)

mat a = r(table)

mat ADL_needhelp_eating = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat ADL_needhelp_eating = [ADL_needhelp_eating,(2011,2013,2015,2018,2020)',(4,4,4,4,4)']
mat list ADL_needhelp_eating
mat drop a


svy: mean ADL_needhelp_toileting,over(Wave)

mat a = r(table)

mat ADL_needhelp_toileting = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat ADL_needhelp_toileting = [ADL_needhelp_toileting,(2011,2013,2015,2018,2020)',(5,5,5,5,5)']
mat list ADL_needhelp_toileting
mat drop a

svy: mean ADL_needhelp_urinecontrol,over(Wave)

mat a = r(table)

mat ADL_needhelp_urinecontrol = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat ADL_needhelp_urinecontrol = [ADL_needhelp_urinecontrol,(2011,2013,2015,2018,2020)',(6,6,6,6,6)']
mat list ADL_needhelp_urinecontrol
mat drop a


mat adl_all = (ADL_needhelp_bathing \ ADL_needhelp_bed  \ ADL_needhelp_dressing  \ ADL_needhelp_eating \  ADL_needhelp_toileting \ ADL_needhelp_urinecontrol)

mat list adl_all

clear

svmat adl_all,name(col)

cap drop Wave
rename c4 Wave

sort c5 Wave
bys c5: gen order_wave = sum(1)

gen c5_wave = order_wave  if c5 == 1
replace c5_wave = order_wave + 6 if c5 == 2
replace c5_wave = order_wave + 12 if c5 == 3
replace c5_wave = order_wave + 18 if c5 == 4
replace c5_wave = order_wave + 24 if c5 == 5
replace c5_wave = order_wave + 30 if c5 == 6

twoway (bar b c5_wave if Wave == 2011 ) ///
(bar b c5_wave if Wave == 2013  ) ///
(bar b c5_wave if Wave == 2015  ) ///
(bar b c5_wave if Wave == 2018  ) ///
(bar b c5_wave if Wave == 2020  ) ///
(rcap ul ll c5_wave, lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave , msymbol(none) mlabel(b ) mlabposition(24) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(order(1 "2011" 2 "2013" 3 "2015"  4 "2018"  5 "2020" 6 "Confidence interval") row(1) ring(1))  ///
title("ADL Items") ytitle("%") ylabel(0(5)10)  ///
xlabel(3 "Bathing" 9 "Transferring" 15 "Dressing" 21 "Eating" 27 "Toileting" 33 "Continence") xtitle("")
gr export $figures/Figure_A4_a.emf,replace  
charls_figure2excel   $figures/Figure_A4_a.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A4_a) ///
    cell(1 8)  title("ADL Items among Wave") note("Based on CHARLS2011-2020")
restore

//IADL items
preserve
keep if Age>=60

svyset [pw=INDV_weight_post2]
svy: mean IADL_needhelp_cooking,over(Wave )

mat a = r(table)

mat IADL_needhelp_cooking = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list IADL_needhelp_cooking
mat IADL_needhelp_cooking = [IADL_needhelp_cooking,(2011,2013,2015,2018,2020)',(1,1,1,1,1)']
mat list IADL_needhelp_cooking

mat drop a



svy: mean IADL_needhelp_housework,over(Wave)

mat a = r(table)

mat IADL_needhelp_housework = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat IADL_needhelp_housework = [IADL_needhelp_housework,(2011,2013,2015,2018,2020)',(2,2,2,2,2)']
mat list IADL_needhelp_housework
mat drop a


svy: mean IADL_needhelp_medicine,over(Wave)

mat a = r(table)

mat IADL_needhelp_medicine = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat IADL_needhelp_medicine = [IADL_needhelp_medicine,(2011,2013,2015,2018,2020)',(3,3,3,3,3)']
mat list IADL_needhelp_medicine
mat drop a


svy: mean IADL_needhelp_money,over(Wave)

mat a = r(table)

mat IADL_needhelp_money = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat IADL_needhelp_money = [IADL_needhelp_money,(2011,2013,2015,2018,2020)',(4,4,4,4,4)']
mat list IADL_needhelp_money
mat drop a


svy: mean IADL_needhelp_shopping,over(Wave)

mat a = r(table)

mat IADL_needhelp_shopping = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat IADL_needhelp_shopping = [IADL_needhelp_shopping,(2011,2013,2015,2018,2020)',(5,5,5,5,5)']
mat list IADL_needhelp_shopping

mat drop a


mat adl_all = (IADL_needhelp_cooking \ IADL_needhelp_housework \ IADL_needhelp_medicine \ IADL_needhelp_money \ IADL_needhelp_shopping )

mat list adl_all

clear

svmat adl_all,name(col)

cap drop Wave
rename c4 Wave

sort c5 Wave
bys c5: gen order_wave = sum(1)

gen c5_wave = order_wave  if c5 == 1
replace c5_wave = order_wave + 6 if c5 == 2
replace c5_wave = order_wave + 12 if c5 == 3
replace c5_wave = order_wave + 18 if c5 == 4
replace c5_wave = order_wave + 24 if c5 == 5

twoway (bar b c5_wave if Wave == 2011 ) ///
(bar b c5_wave if Wave == 2013  ) ///
(bar b c5_wave if Wave == 2015  ) ///
(bar b c5_wave if Wave == 2018  ) ///
(bar b c5_wave if Wave == 2020  ) ///
(rcap ul ll c5_wave, lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave , msymbol(none) mlabel(b ) mlabposition(24) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(order(1 "2011" 2 "2013" 3 "2015"  4 "2018"  5 "2020" 6 "Confidence interval") row(1) ring(1))  ///
title("IADL Items") ytitle("%")  ylabel(0(5)15) ///
xlabel(3 "Cooking" 9 "Housework" 15 "Taking medicine" 21 "Money management" 27 "Shopping" ) xtitle("")
gr export $figures/Figure_A4_b.emf,replace 
	
charls_figure2excel   $figures/Figure_A4_b.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A4_b) ///
    cell(1 8)  title("IADL Items among Wave") note("Based on CHARLS2011-2020")

restore


** ============================================================================
**      get disability rate data, prepare to get number of disability pop
** ============================================================================

preserve
keep if Age>=60 & !mi(Age)

svyset [pw=INDV_weight_post2]
svy: mean ADL_needhelp_any,over(Wave)

mat a = r(table)

mat list a

mat ADL_needhelp_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_needhelp_any

mat drop a

svy: mean ADL_cs_medicine,over(Wave)

mat a = r(table)

mat ADL_cs_medicine = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat list ADL_cs_medicine

mat drop a

svy: mean ADL_IADL_any,over(Wave)

mat a = r(table)

mat ADL_IADL_any = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat list ADL_IADL_any
mat drop a


mat adl_all = (ADL_needhelp_any ,  ADL_cs_medicine , ADL_IADL_any,(2011,2013,2015,2018,2020)')

mat list adl_all

mat colnames adl_all = adl adl_ll adl_ul adl_plus adl_plus_ll adl_plus_ul adl_iadl adl_iadl_ll ///
adl_iadl_ul Wave

mat list adl_all


clear

svmat adl_all,name(col)

gen Agetype = 60

save $working_data/ADL_3index_bywave_60.dta,replace


restore


preserve
keep if Age>=50 & !mi(Age)



svyset [pw=INDV_weight_post2]
svy: mean ADL_needhelp_any,over(Wave)

mat a = r(table)

mat list a

mat ADL_needhelp_any = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list ADL_needhelp_any

mat drop a

svy: mean ADL_cs_medicine,over(Wave)

mat a = r(table)

mat ADL_cs_medicine = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat list ADL_cs_medicine

mat drop a

svy: mean ADL_IADL_any,over(Wave)

mat a = r(table)

mat ADL_IADL_any = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat list ADL_IADL_any
mat drop a


mat adl_all = (ADL_needhelp_any ,  ADL_cs_medicine , ADL_IADL_any,(2011,2013,2015,2018,2020)')

mat list adl_all

mat colnames adl_all = adl adl_ll adl_ul adl_plus adl_plus_ll adl_plus_ul adl_iadl adl_iadl_ll ///
adl_iadl_ul Wave

mat list adl_all


clear

svmat adl_all,name(col)

gen Agetype = 50
save $working_data/ADL_3index_bywave_50.dta,replace
restore

use $working_data/ADL_3index_bywave_50.dta,clear
append using $working_data/ADL_3index_bywave_60.dta
format adl* %8.1f
save $working_data/ADL_3index_bywave_50_60.dta,replace

** ============================================================================
**     insheet num of pop 50+ and 60+, and mutiply disability rate to get num of disability
** ============================================================================

use $raw_data/pop_50_60,clear
merge 1:1 Wave Agetype using  $working_data/ADL_3index_bywave_50_60.dta
drop _merge
rename INDV_weight_post2 pop
//unit of pop is 100 million
foreach var in adl adl_ll adl_ul adl_plus adl_plus_ll adl_plus_ul adl_iadl adl_iadl_ll adl_iadl_ul  {
	gen pop`var'=`var'*pop/100
}
format pop* %8.1f

sort Agetype Wave

order Agetype Wave pop adl popadl adl_ll popadl_ll adl_ul popadl_ul adl_plus popadl_plus adl_plus_ll popadl_plus_ll adl_plus_ul popadl_plus_ul adl_iadl popadl_iadl adl_iadl_ll popadl_iadl_ll adl_iadl_ul  popadl_iadl_ul
foreach var in pop popadl popadl_ll popadl_ul popadl_plus popadl_plus_ll popadl_plus_ul popadl_iadl popadl_iadl_ll popadl_iadl_ul {
	replace `var'=`var'/100
}
// change unit of pop to 1 million

save $working_data/pop_disability_3index_wave, replace


** ============================================================================
**    Figure 3: num of disability pop ( 3 index), graph
** ============================================================================

use $working_data/pop_disability_3index_wave ,clear

rename popadl dis_pop1
rename popadl_ll dis_pop_ll1
rename popadl_ul dis_pop_ul1

rename popadl_plus dis_pop2
rename popadl_plus_ll dis_pop_ll2
rename popadl_plus_ul dis_pop_ul2

rename popadl_iadl dis_pop3
rename popadl_iadl_ll dis_pop_ll3
rename popadl_iadl_ul dis_pop_ul3

keep if Agetype == 60
keep Wave dis_pop* Agetype
reshape long dis_pop dis_pop_ll dis_pop_ul,i(Wave) j(Type)

gen type_wave = Type if Wave == 2011
replace type_wave = Type + 4 if Wave == 2013
replace type_wave = Type + 8 if Wave == 2015
replace type_wave = Type + 12 if Wave == 2018
replace type_wave = Type + 16 if Wave == 2020

twoway (bar dis_pop type_wave if Type == 1 ) ///
(bar dis_pop type_wave if Type == 2 ) ///
(bar dis_pop type_wave if Type == 3 ) ///
(rcap dis_pop_ul dis_pop_ll type_wave, lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter dis_pop type_wave , msymbol(none) mlabel(dis_pop ) mlabposition(11) mlabformat(%9.2f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Level-1 Dependency) label(2 Level-2 Dependency)  label(3 Level-3 Dependency) label(4 Confidence Interval) label(5 ) pos(1) ring(1) row(3))  ///
 ytitle("Million")   ///
xlabel(2 "2011" 6 "2013" 10 "2015"  14 "2018"  18 "2020") xtitle("") ///
ylabel(0(20)60)
graph export $figures/Figure3.emf,replace
charls_figure2excel  $figures/Figure3.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure3) ///
    cell(1 8)  title("60+: Pop of Disability (ADL 3index) among Wave") note("Based on CHARLS2011-2020")


** ============================================================================
**   Figure 4, A6 (a), A6 (b):  num of disbility pop， decomposition
** ============================================================================
use $working_data/pop_disability_3index_wave ,clear

drop *_ll *_ul
rename popadl popADL_needhelp_any
rename popadl_plus popADL_cs_medicine
rename popadl_iadl popADL_IADL_any
rename adl ADL_needhelp_any
rename adl_plus ADL_cs_medicine
rename adl_iadl ADL_IADL_any

reshape wide ADL* pop*,i(Agetype) j(Wave)
**to get average of disability rate and num of pop
foreach var in ADL_needhelp_any ADL_cs_medicine  ADL_IADL_any pop {
	gen a`var'1311=(`var'2011+`var'2013)/2
	gen a`var'1511=(`var'2011+`var'2015)/2
	gen a`var'1811=(`var'2011+`var'2018)/2
	gen a`var'2011=(`var'2011+`var'2020)/2
}

format aADL* %8.1f
format apop* %8.0f
*to get difference of disability rate and num of pop
foreach var in  ADL_needhelp_any ADL_cs_medicine ADL_IADL_any pop popADL_needhelp_any popADL_cs_medicine  popADL_IADL_any {
	gen d`var'1311=`var'2013-`var'2011
	gen d`var'1511=`var'2015-`var'2011
	gen d`var'1811=`var'2018-`var'2011
	gen d`var'2011=`var'2020-`var'2011
}
format dADL* %8.1f
format dpop* %8.0f

//decomposition
foreach var in ADL_needhelp_any ADL_cs_medicine  ADL_IADL_any{
	foreach j in 1311 1511 1811 2011{
		gen conpop`var'`j'=dpop`j'*a`var'`j'/100
		gen crate`var'`j'=d`var'`j'*apop`j'/100
}
}

collapse conpop* crate* dpop* ,by(Age)
format conpop* crate* dpop* %8.2f
order Agetype  dpop*  conpop* crate*
drop dpop1811 dpop2011 dpop1311 dpop1511
reshape long dpopADL_needhelp_any conpopADL_needhelp_any  crateADL_needhelp_any  dpopADL_cs_medicine  conpopADL_cs_medicine crateADL_cs_medicine   dpopADL_IADL_any    conpopADL_IADL_any crateADL_IADL_any ,i(Agetype)
rename _j period




graph bar dpopADL_needhelp_any conpopADL_needhelp_any crateADL_needhelp_any if Agetype == 60, ///
over(period,relabel(1 "2013" 2 "2015" 3 "2018" 4 "2020")) ///
ytitle("Million")  title ("Level-1 Dependency")  ///
    legend(label(1 "Total Effect")  label(2 "Population Effect")  label(3 "Disability Effect") pos(1) row(1)  ) ///
bargap(10) blabel(bar, pos(outside)  size(vsmall) format(%9.2f))
graph export $figures/Figure4.emf,replace
charls_figure2excel  $figures/Figure4.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure4) ///
    cell(1 8)  title("Pop of Disability (level 1) decomposition") note("Based on CHARLS2011-2020")


graph bar dpopADL_cs_medicine conpopADL_cs_medicine  crateADL_cs_medicine if Agetype == 60, ///
over(period,relabel(1 "2013" 2 "2015" 3 "2018" 4 "2020")) ///
ytitle("Million")  title ("Level-2 Dependency")  ///
    legend(label(1 "Total Effect")  label(2 "Population Effect")  label(3 "Disability Effect") pos(1) row(1)  ) ///
bargap(10) blabel(bar, pos(outside)  size(vsmall) format(%9.2f))  ///
ylabel(-20(10)20)
graph export $figures/Figure_A6_a.emf,replace
charls_figure2excel  $figures/Figure_A6_a.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A6_a) ///
    cell(1 8)  title("Pop of Disability (level 2) decomposition") note("Based on CHARLS2011-2020")



graph bar dpopADL_IADL_any conpopADL_IADL_any  crateADL_IADL_any if Agetype == 60, ///
over(period,relabel(1 "2013" 2 "2015" 3 "2018" 4 "2020")) ///
ytitle("Million")  title ("Level-3 Dependency")  ///
    legend(label(1 "Total Effect")  label(2 "Population Effect")  label(3 "Disability Effect") pos(1) row(1)  ) ///
bargap(10) blabel(bar, pos(outside)  size(vsmall) format(%9.2f))
graph export $figures/Figure_A6_b.emf,replace
charls_figure2excel  $figures/Figure_A6_b.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A6_b) ///
    cell(1 8)  title("Pop of Disability (level 3) decomposition") note("Based on CHARLS2011-2020")

** ============================================================================
**    contribution of different factors
** ============================================================================

**-------------------------------------------------------------
**    disability rate change from 2011 to 2020
**-------------------------------------------------------------

use  $working_data/disability_3index_bywave_1120,clear

replace householdID = householdID + "0" if Wave == 2011
replace ID = householdID + substr(ID,-2,2) if Wave == 2011

merge m:1 communityID using $raw_data/hosptail_all_im, keepusing(jf006_9_2011 jf006_9_2013 jf006_9_2015 jf006_9_2018 im_jf006_9_2011 im_jf006_9_2013 im_jf006_9_2015 im_jf006_9_2018)

drop  if _merge == 2
drop _merge

gen distance_hosptial = .
foreach x of numlist 2011 2013 2015 2018 {
    replace  distance_hosptial = im_jf006_9_`x' if `x' == Wave 
}

count if mi(distance_hosptial)
ta Wave  if mi(distance_hosptial)

tab Age_Group,gen(Agegroup)

drop Female

ta Gender,m
//no missing in age and gender   

ta Hukou,m
ta Edu_Group,m
// missing in hukou and education  

count if mi(toilet_sit_inhouse)
count if mi(toilet_unsit_inhouse)
count if mi(water)
count if mi(distance_hosptial) & Wave != 2020
//missing in toilet_sit_inhouse, toilet_unsit_inhouse, water and distance_hosptial

ta toilet_unsit_inhouse  toilet_sit_inhouse,m
//same obs have missing value, just need to define one missing variable

gen Female = 1 if Gender == 2
replace Female = 0 if Gender == 1

gen Hukou_agricultural = 1 if Hukou == 1
replace Hukou_agricultural = 0 if Hukou == 2
replace Hukou_agricultural = 0 if mi(Hukou)

gen Hukou_agricultural_m = 1 if  mi(Hukou)
replace Hukou_agricultural_m = 0 if !mi(Hukou)

gen toilet_sit_inhouse_m = 1 if mi(toilet_sit_inhouse)
replace  toilet_sit_inhouse_m = 0 if !mi(toilet_sit_inhouse)

replace toilet_sit_inhouse = 0 if mi(toilet_sit_inhouse)
replace toilet_unsit_inhouse = 0 if mi(toilet_unsit_inhouse)

gen water_m = 1 if mi(water)
replace  water_m = 0 if !mi(water)
replace water = 0 if mi(water)

gen distance_hosptial_m = 1 if mi(distance_hosptial)
replace  distance_hosptial_m = 0 if !mi(distance_hosptial)
replace distance_hosptial = 0  if mi(distance_hosptial)

foreach x of numlist 1/5 {
gen Edugroup`x' = 0
replace  Edugroup`x' = 1 if  Edu_Group == `x'
}

replace Edu_Group = . if Edu_Group ==6 

gen Edugroup_m = 1 if mi(Edu_Group)
replace  Edugroup_m = 0 if !mi(Edu_Group)

keep if Age>= 60 &!mi(Age)

**-------------------------------------------------------------
** Table_A2 summary statistics, simple mean in X，no missing in ADL/IADL (level 3)
**-------------------------------------------------------------
preserve
drop if ADL_IADL_any == .

drop if mi(INDV_weight_post2)

collapse (count) Age Agegroup3 Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5 Edugroup_m Female Hukou_agricultural Hukou_agricultural_m toilet_sit_inhouse  toilet_unsit_inhouse  toilet_sit_inhouse_m water water_m distance_hosptial  distance_hosptial_m,by(Wave)
xpose, clear varname
gen rank_var = _n
gen id = 2
save $working_data/stats1.dta, replace

restore

foreach x of numlist 2011 2013 2015 2018 2020 {

preserve
drop if ADL_IADL_any == .
drop if mi(INDV_weight_post2)

mean Age Agegroup3 Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5 Edugroup_m Female Hukou_agricultural Hukou_agricultural_m toilet_sit_inhouse  toilet_unsit_inhouse  toilet_sit_inhouse_m water water_m distance_hosptial  distance_hosptial_m if Wave == `x'

estat sd

mat a = r(sd) 
clear
svmat a, names(matcol)
rename a* *
xpose, clear varname

gen rank_var = _n + 1
gen id = 3
if `x' == 2013 {
rename v1 v2 
}
if `x' == 2015 {
rename v1 v3 
}
if `x' == 2018 {
rename v1 v4 
}
if `x' == 2020 {
rename v1 v5 
}
save $working_data/adl_iadl_sd`x'.dta, replace

restore
}

preserve 
use $working_data/adl_iadl_sd2011 ,clear
merge 1:1 rank_var using $working_data/adl_iadl_sd2013
drop _merge
merge 1:1 rank_var using $working_data/adl_iadl_sd2015
drop _merge
merge 1:1 rank_var using  $working_data/adl_iadl_sd2018
drop _merge
merge 1:1 rank_var using $working_data/adl_iadl_sd2020
drop _merge
save $working_data/sd_adl_iadl, replace
restore



preserve
drop if ADL_IADL_any == .

collapse Age Agegroup3 Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5 Edugroup_m Female Hukou_agricultural Hukou_agricultural_m toilet_sit_inhouse  toilet_unsit_inhouse  toilet_sit_inhouse_m water water_m distance_hosptial  distance_hosptial_m ,by(Wave)
xpose, clear varname
gen rank_var = _n
gen id = 1
append using $working_data/sd_adl_iadl.dta

sort rank_var id
export excel using "$tables\Table_A2.xlsx", firstrow(variables) sheet(level_3, modify)

restore

**-------------------------------------------------------------
** Table_A2 summary statistics, simple mean in X，no missing in ADL+ (level 2)
**-------------------------------------------------------------
preserve
drop if ADL_cs_medicine == .
 
drop if mi(INDV_weight_post2)

collapse (count) Age Agegroup3 Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5 Edugroup_m Female Hukou_agricultural Hukou_agricultural_m toilet_sit_inhouse  toilet_unsit_inhouse  toilet_sit_inhouse_m water water_m distance_hosptial  distance_hosptial_m  ,by(Wave)
xpose, clear varname
gen rank_var = _n
gen id = 2
save $working_data/stats2.dta, replace

restore

foreach x of numlist 2011 2013 2015 2018 2020 {

preserve
drop if ADL_cs_medicine == .
drop if mi(INDV_weight_post2)

mean Age Agegroup3 Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5 Edugroup_m Female Hukou_agricultural Hukou_agricultural_m toilet_sit_inhouse  toilet_unsit_inhouse  toilet_sit_inhouse_m water water_m distance_hosptial  distance_hosptial_m if Wave == `x'

estat sd

mat a = r(sd) 
clear
svmat a, names(matcol)
rename a* *
xpose, clear varname

gen rank_var = _n + 1
gen id = 3
if `x' == 2013 {
rename v1 v2 
}
if `x' == 2015 {
rename v1 v3 
}
if `x' == 2018 {
rename v1 v4 
}
if `x' == 2020 {
rename v1 v5 
}
save $working_data/adl_plus_sd`x'.dta, replace

restore
}

preserve 
use $working_data/adl_plus_sd2011 ,clear
merge 1:1 rank_var using $working_data/adl_plus_sd2013
drop _merge
merge 1:1 rank_var using $working_data/adl_plus_sd2015
drop _merge
merge 1:1 rank_var using  $working_data/adl_plus_sd2018
drop _merge
merge 1:1 rank_var using $working_data/adl_plus_sd2020
drop _merge
save $working_data/sd_adl_plus, replace
restore

preserve
drop if ADL_cs_medicine == .

collapse Age  Agegroup3 Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5 Edugroup_m Female Hukou_agricultural Hukou_agricultural_m toilet_sit_inhouse  toilet_unsit_inhouse  toilet_sit_inhouse_m water water_m distance_hosptial  distance_hosptial_m  ,by(Wave)
xpose, clear varname
gen rank_var = _n
gen id = 1
append using $working_data/sd_adl_plus.dta

sort rank_var id
export excel using "$tables\Table_A2.xlsx", firstrow(variables) sheet(level_2, modify)

restore

**-------------------------------------------------------------
** Table_A2 summary statistics, simple mean in X，no missing in ADL (level 1)
**-------------------------------------------------------------
preserve
drop if ADL_needhelp_any == .
drop if mi(INDV_weight_post2)

collapse (count) Age Agegroup3 Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5 Edugroup_m Female Hukou_agricultural Hukou_agricultural_m toilet_sit_inhouse  toilet_unsit_inhouse  toilet_sit_inhouse_m water water_m distance_hosptial  distance_hosptial_m   ,by(Wave)
xpose, clear varname
gen rank_var = _n
gen id = 2
save $working_data/stats3.dta, replace

restore

foreach x of numlist 2011 2013 2015 2018 2020 {

preserve
drop if ADL_needhelp_any == .
drop if mi(INDV_weight_post2)

mean Age Agegroup3 Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5 Edugroup_m Female Hukou_agricultural Hukou_agricultural_m toilet_sit_inhouse  toilet_unsit_inhouse  toilet_sit_inhouse_m water water_m distance_hosptial  distance_hosptial_m if Wave == `x'

estat sd

mat a = r(sd) 
clear
svmat a, names(matcol)
rename a* *
xpose, clear varname

gen rank_var = _n + 1
gen id = 3
if `x' == 2013 {
rename v1 v2 
}
if `x' == 2015 {
rename v1 v3 
}
if `x' == 2018 {
rename v1 v4 
}
if `x' == 2020 {
rename v1 v5 
}
save $working_data/adl_sd`x'.dta, replace

restore
}

preserve 
use $working_data/adl_sd2011 ,clear
merge 1:1 rank_var using $working_data/adl_sd2013
drop _merge
merge 1:1 rank_var using $working_data/adl_sd2015
drop _merge
merge 1:1 rank_var using  $working_data/adl_sd2018
drop _merge
merge 1:1 rank_var using $working_data/adl_sd2020
drop _merge
save $working_data/sd_adl, replace
restore

preserve
drop if ADL_needhelp_any == .

collapse Age  Agegroup3 Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5 Edugroup_m Female Hukou_agricultural Hukou_agricultural_m toilet_sit_inhouse  toilet_unsit_inhouse  toilet_sit_inhouse_m water water_m distance_hosptial  distance_hosptial_m   ,by(Wave)
xpose, clear varname
gen rank_var = _n
gen id = 1
append using $working_data/sd_adl.dta

sort rank_var id
export excel using "$tables\Table_A2.xlsx", firstrow(variables) sheet(level_1, modify)

restore


**-------------------------------------------------------------
** regression coefficients，outcome variable is ADL/IADL (level 3)
**-------------------------------------------------------------

reg ADL_IADL_any   Agegroup5 Agegroup6 Agegroup7  Agegroup8 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5  Female Hukou_agricultural  toilet_sit_inhouse  toilet_unsit_inhouse   water  distance_hosptial Edugroup_m Hukou_agricultural_m toilet_sit_inhouse_m  water_m distance_hosptial_m    [pw=INDV_weight_post2] if Wave >= 2011 & Wave <= 2018  , cluster(ID)

ereturn list
mat b = e(b)
mat list b

preserve
gen coeff_Agegroup5 = b[1,1]
gen coeff_Agegroup6 = b[1,2]
gen coeff_Agegroup7 = b[1,3]
gen coeff_Agegroup8 = b[1,4]

gen coeff_Edugroup2 = b[1,5]
gen coeff_Edugroup3 = b[1,6]
gen coeff_Edugroup4 = b[1,7]
gen coeff_Edugroup5 = b[1,8]

gen coeff_Female = b[1,9]
gen coeff_Hukou_agricultural = b[1,10]

gen coeff_toilet_sit_inhouse = b[1,11]
gen coeff_toilet_unsit_inhouse= b[1,12]

gen coeff_water = b[1,13]
gen coeff_distance_hosptial = b[1,14]

keep coeff*

gen ID = 1

keep if _n == 1

save $working_data/adl_iadl_coeff_weight.dta, replace

restore


**-------------------------------------------------------------
** regression coefficients，outcome variable is ADL plus (level 2)
**-------------------------------------------------------------

reg ADL_cs_medicine   Agegroup5 Agegroup6 Agegroup7  Agegroup8 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5  Female Hukou_agricultural  toilet_sit_inhouse  toilet_unsit_inhouse   water  distance_hosptial Edugroup_m Hukou_agricultural_m toilet_sit_inhouse_m  water_m distance_hosptial_m    [pw=INDV_weight_post2] if Wave >= 2011 & Wave <= 2018 , cluster(ID)

ereturn list
mat b = e(b)
mat list b

preserve
gen coeff_Agegroup5 = b[1,1]
gen coeff_Agegroup6 = b[1,2]
gen coeff_Agegroup7 = b[1,3]
gen coeff_Agegroup8 = b[1,4]

gen coeff_Edugroup2 = b[1,5]
gen coeff_Edugroup3 = b[1,6]
gen coeff_Edugroup4 = b[1,7]
gen coeff_Edugroup5 = b[1,8]

gen coeff_Female = b[1,9]
gen coeff_Hukou_agricultural = b[1,10]

gen coeff_toilet_sit_inhouse = b[1,11]
gen coeff_toilet_unsit_inhouse= b[1,12]

gen coeff_water = b[1,13]
gen coeff_distance_hosptial = b[1,14]

keep coeff*

gen ID = 1

keep if _n == 1

save $working_data/adl_plus_coeff_weight.dta, replace

restore

**-------------------------------------------------------------
** regression coefficients，outcome variable is ADL (level 1)
**-------------------------------------------------------------

reg ADL_needhelp_any  Agegroup5 Agegroup6 Agegroup7  Agegroup8 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5  Female Hukou_agricultural  toilet_sit_inhouse  toilet_unsit_inhouse   water  distance_hosptial Edugroup_m Hukou_agricultural_m toilet_sit_inhouse_m  water_m distance_hosptial_m    [pw=INDV_weight_post2] if Wave >= 2011 & Wave <= 2018, cluster(ID)

ereturn list
mat b = e(b)
mat list b

preserve
gen coeff_Agegroup5 = b[1,1]
gen coeff_Agegroup6 = b[1,2]
gen coeff_Agegroup7 = b[1,3]
gen coeff_Agegroup8 = b[1,4]

gen coeff_Edugroup2 = b[1,5]
gen coeff_Edugroup3 = b[1,6]
gen coeff_Edugroup4 = b[1,7]
gen coeff_Edugroup5 = b[1,8]

gen coeff_Female = b[1,9]
gen coeff_Hukou_agricultural = b[1,10]

gen coeff_toilet_sit_inhouse = b[1,11]
gen coeff_toilet_unsit_inhouse= b[1,12]

gen coeff_water = b[1,13]
gen coeff_distance_hosptial = b[1,14]
keep coeff*

gen ID = 1

keep if _n == 1

save $working_data/adl_coeff_weight.dta, replace

restore


**-------------------------------------------------------------------
**---Table_A3 regressions
**-------------------------------------------------------------------
reg ADL_IADL_any    Agegroup5 Agegroup6 Agegroup7  Agegroup8 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5  Female Hukou_agricultural  toilet_sit_inhouse  toilet_unsit_inhouse   water  distance_hosptial Edugroup_m Hukou_agricultural_m toilet_sit_inhouse_m  water_m distance_hosptial_m    [pw=INDV_weight_post2] if Wave >= 2011 & Wave <= 2018 ,cluster(ID) 
mat b_ADL_IADL = e(b)
mat list b_ADL_IADL
mat v_ADL_IADL= e(V)
outreg2 using $tables/Table_A3.xls,replace r2 bdec(3) sdec(5) ctitle(Level_3,11-18)  label sideway stats(coef ci  pval) paren(ci) noaster pdec(5)

reg ADL_cs_medicine   Agegroup5 Agegroup6 Agegroup7  Agegroup8 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5  Female Hukou_agricultural  toilet_sit_inhouse  toilet_unsit_inhouse   water  distance_hosptial Edugroup_m Hukou_agricultural_m toilet_sit_inhouse_m  water_m distance_hosptial_m     [pw=INDV_weight_post2] if Wave >= 2011 & Wave <= 2018 ,cluster(ID) 
mat b_ADL_plus = e(b)
mat v_ADL_plus = e(V)
outreg2 using $tables/Table_A3.xls,append r2 bdec(3) sdec(3) ctitle(Level_2,11-18)  label sideway stats(coef ci  pval) paren(ci) noaster pdec(5)

reg ADL_needhelp_any   Agegroup5 Agegroup6 Agegroup7  Agegroup8 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5  Female Hukou_agricultural  toilet_sit_inhouse  toilet_unsit_inhouse   water  distance_hosptial Edugroup_m Hukou_agricultural_m toilet_sit_inhouse_m  water_m distance_hosptial_m    [pw=INDV_weight_post2]  if Wave >= 2011 & Wave <= 2018 ,cluster(ID) 
mat b_ADL = e(b)
mat v_ADL = e(V)
outreg2 using $tables/Table_A3.xls,append r2 bdec(3) sdec(3) ctitle(Level_1,11-18)  label sideway stats(coef ci  pval) paren(ci) noaster pdec(5)

reg IADL_needhelp_any    Agegroup5 Agegroup6 Agegroup7  Agegroup8 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5  Female Hukou_agricultural  toilet_sit_inhouse  toilet_unsit_inhouse   water  distance_hosptial Edugroup_m Hukou_agricultural_m toilet_sit_inhouse_m  water_m distance_hosptial_m    [pw=INDV_weight_post2] if Wave >= 2011 & Wave <= 2018 ,cluster(ID) 
outreg2 using $tables/Table_A3.xls,append r2 bdec(3) sdec(3) ctitle(IADL,11-18)  label sideway stats(coef ci  pval) paren(ci) noaster pdec(5)

**-------------------------------------------------------------------
**------Figure 5: factors graph over wave, such as education, toilet, water, distance to hospital
**-------------------------------------------------------------------
***key point, missing is missing not o
replace Hukou_agricultural = . if Hukou_agricultural_m == 1
replace toilet_sit_inhouse = . if toilet_sit_inhouse_m == 1 
replace toilet_unsit_inhouse = . if toilet_sit_inhouse_m == 1 
replace water = . if water_m == 1
replace distance_hosptial = .  if distance_hosptial_m == 1
foreach x of numlist 1/5 {
replace  Edugroup`x' = . if  Edugroup_m == 1
}

gen toilet_sit_inhouse_new = 0 if toilet == 1
replace toilet_sit_inhouse_new = 1 if toilet == 1 & toilet_sit_inhouse == 1

ta toilet_sit_inhouse_new toilet_sit_inhouse,m

***Figure_A5_a
preserve
replace Edugroup4 = Edugroup4 * 100
replace Edugroup5 = Edugroup5 * 100


svyset [pw=INDV_weight_post2]
svy: mean Edugroup4,over(Wave)

mat a = r(table)

mat Edugroup4 = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list Edugroup4
mat Edugroup4 = [Edugroup4,(2011,2013,2015,2018,2020)',(1,1,1,1,1)']
mat list Edugroup4

mat drop a

svy: mean Edugroup5,over(Wave)

mat a = r(table)

mat Edugroup5 = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat Edugroup5 = [Edugroup5,(2011,2013,2015,2018,2020)',(2,2,2,2,2)']
mat list Edugroup5

mat drop a

mat edu_all = (Edugroup4 \  Edugroup5 )

mat list edu_all

clear

svmat edu_all,name(col)

cap drop Wave
rename c4 Wave

gen c5_wave = c5 if Wave == 2011
replace c5_wave = c5 + 3 if Wave == 2013
replace c5_wave = c5 + 6 if Wave == 2015
replace c5_wave = c5 + 9 if Wave == 2018
replace c5_wave = c5 + 12 if Wave == 2020

twoway (bar b c5_wave if c5 == 1 ) ///
(bar b c5_wave if c5 == 2 ) ///
(rcap ul ll c5_wave, lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave , msymbol(none) mlabel(b ) mlabposition(1) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Middle school) label(2 High School and above)  label(3 Confidence interval) label(4 "")   pos(11) ring(1) row(1)  )  ///
 ytitle("%")  ylabel(0(5)20) ///
xlabel(1.5 "2011" 4.5 "2013" 7.5 "2015" 10.5 "2018" 13.5 "2020") xtitle("")

gr export $figures/Figure_A5_a.emf,replace
charls_figure2excel   $figures/Figure_A5_a.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A5_a) ///
    cell(1 8)  title("Education level among Wave") note("Based on CHARLS2011-2020")



restore

***Figure_A5_b
preserve

replace water = water * 100
replace toilet = toilet * 100
replace toilet_sit_inhouse_new = toilet_sit_inhouse_new * 100
replace toilet_sit_inhouse = toilet_sit_inhouse * 100

svyset [pw=INDV_weight_post2]
svy: mean water,over(Wave)

mat a = r(table)

mat water = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list water
mat water = [water,(2011,2013,2015,2018,2020)',(1,1,1,1,1)']
mat list water

mat drop a

svy: mean toilet,over(Wave)

mat a = r(table)

mat toilet = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat toilet = [toilet,(2011,2013,2015,2018,2020)',(2,2,2,2,2)']
mat list toilet

mat drop a

svy: mean toilet_sit_inhouse,over(Wave)

mat a = r(table)

mat toilet_sit_inhouse = a["b",1...]',a["ll",1...]',a["ul",1...]'
mat toilet_sit_inhouse = [toilet_sit_inhouse,(2011,2013,2015,2018,2020)',(3,3,3,3,3)']
mat list toilet_sit_inhouse
mat drop a


mat house_envir_all = (water \  toilet \ toilet_sit_inhouse)

mat list house_envir_all

clear

svmat house_envir_all,name(col)

cap drop Wave
rename c4 Wave

gen c5_wave = c5 if Wave == 2011
replace c5_wave = c5 + 3 if Wave == 2013
replace c5_wave = c5 + 6 if Wave == 2015
replace c5_wave = c5 + 9 if Wave == 2018
replace c5_wave = c5 + 12 if Wave == 2020

replace c5_wave = c5_wave - 1 if c5 == 3

twoway (bar b c5_wave if c5 == 2 ) ///
(bar b c5_wave if c5 == 3 ) ///
(bar b c5_wave if c5 == 1 ) ///
(rcap ul ll c5_wave, lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave , msymbol(none) mlabel(b ) mlabposition(12) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Indoor toilet) label(2 Indoor sitting toilet)  label(3 Tap Water) label(4 Confidence interval) label(5 "")   pos(11) ring(1) row(2)  )  ///
 ytitle("%")  ylabel(0(20)100) ///
xlabel(1.5 "2011" 4.5 "2013" 7.5 "2015" 10.5 "2018"  13.5 "2020") xtitle("")
gr export $figures/Figure_A5_b.emf,replace
charls_figure2excel   $figures/Figure_A5_b.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A5_b) ///
    cell(1 8)  title("Water and Toilet among Wave") note("Based on CHARLS2011-2020")

restore

***Figure_A5_c 
preserve

svyset [pw=INDV_weight_post2]
svy: mean distance_hosptial,over(Wave)

mat a = r(table)

mat distance_hosptial = a["b",1...]',a["ll",1...]',a["ul",1...]'

mat list distance_hosptial
mat distance_hosptial = [distance_hosptial,(2011,2013,2015,2018)',(1,1,1,1)']
mat list distance_hosptial

mat drop a

mat list distance_hosptial

clear

svmat distance_hosptial,name(col)

cap drop Wave
rename c4 Wave

gen c5_wave = c5 if Wave == 2011
replace c5_wave = c5 + 2 if Wave == 2013
replace c5_wave = c5 + 4 if Wave == 2015
replace c5_wave = c5 + 6 if Wave == 2018

twoway (bar b c5_wave if c5 == 1 ) ///
(rcap ul ll c5_wave, lcolor(gs10) lwidth(vthin)  lpattern(solid)) ///
(scatter b c5_wave , msymbol(none) mlabel(b ) mlabposition(11) mlabformat(%9.1f) mlabsize(vsmall) mlabcolor(black) ), ///
legend(label(1 Distance to hospital)  label(2 Confidence interval) label(3 "")   pos(1) ring(0) row(5)  )  ///
 ytitle("KM") ylabel(0(1)4)  ///
xlabel(1 "2011" 3 "2013" 5 "2015" 7 "2018" ) xtitle("")
 
gr export $figures/Figure_A5_c.emf,replace
charls_figure2excel   $figures/Figure_A5_c.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A5_c) ///
    cell(1 8)  title("Distance to Hospital") note("Based on CHARLS2011-2018")


restore


collapse Agegroup* Edugroup* Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any toilet toilet_sit_inhouse_new if Age>=60 [pw=INDV_weight_post2] , by(Wave)

gen ID = 1

save $working_data/collapse_X_Y.dta, replace


**----------------------------------------------------------------
** adl (level 1),  contribution of different factors
**----------------------------------------------------------------
use $working_data/collapse_X_Y.dta, clear

drop toilet_sit_inhouse_new toilet
reshape wide Agegroup* Edugroup* Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any,i(ID) j(Wave)
 
*differences in disability rate and independent variables
foreach var in Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
Edugroup1 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any {
	gen d`var'1311=`var'2013-`var'2011
	gen d`var'1511=`var'2015-`var'2011
	gen d`var'1811=`var'2018-`var'2011
	gen d`var'2011=`var'2020-`var'2011
}

keep d* ID  ADL_needhelp_any2011  ADL_cs_medicine2011  ADL_IADL_any2011 
drop distance*
reshape long dAgegroup4 dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8 ///
dEdugroup1 dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse  dtoilet_unsit_inhouse   dwater ddistance_hosptial dADL_needhelp_any  dADL_cs_medicine  dADL_IADL_any  ,i(ID)
rename _j period


merge n:1 ID using $working_data/adl_coeff_weight

drop _merge
 
foreach x in  Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial  {
    gen explained_`x' = d`x'*coeff_`x'
} 

foreach x in  Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial  {
    gen fr_exp_`x' = explained_`x'/dADL_needhelp_any
} 

keep period dADL_needhelp_any  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
coeff_Agegroup5 coeff_Agegroup6 coeff_Agegroup7 coeff_Agegroup8 coeff_Edugroup2 coeff_Edugroup3 coeff_Edugroup4 coeff_Edugroup5 coeff_Female coeff_Hukou_agricultural coeff_toilet_sit_inhouse coeff_toilet_unsit_inhouse coeff_water coeff_distance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial  ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial   

order period dADL_needhelp_any  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
coeff_Agegroup5 coeff_Agegroup6 coeff_Agegroup7 coeff_Agegroup8 coeff_Edugroup2 coeff_Edugroup3 coeff_Edugroup4 coeff_Edugroup5 coeff_Female coeff_Hukou_agricultural coeff_toilet_sit_inhouse coeff_toilet_unsit_inhouse coeff_water coeff_distance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial   ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial    

format d* coeff* explained* fr_exp* %8.5f

replace ddistance_hosptial = ddistance_hosptial[3] if _n == 4

replace explained_distance_hosptial = explained_distance_hosptial[3] if _n == 4
replace fr_exp_distance_hosptial = explained_distance_hosptial/dADL_needhelp_any  if _n == 4

egen explained_total = rowtotal(explained_*)

egen fr_exp_total = rowtotal(fr_exp_*)

keep if period == 2011 

keep period dADL_needhelp_any  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial explained_total ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial   fr_exp_total

order period dADL_needhelp_any  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial   explained_total ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial  fr_exp_total

format d* explained* fr_exp* %8.5f

putexcel set $tables/Lancet_public_health.xlsx, sheet(Table_Contribution_factors, replace) modify

putexcel A3 = "Change in dependency"
putexcel A4 = "Age, years"
putexcel A5 = "Total"
putexcel A6 = "65-69"
putexcel A7 = "70-74"
putexcel A8 = "75-79"
putexcel A9 = ">=80"
putexcel A10 = "Education attainment"
putexcel A11 = "Total"
putexcel A12 = "Literate"
putexcel A13 = "Primary school"
putexcel A14 = "Middle school"
putexcel A15 = "High school and above"
putexcel A16 = "Demographics"
putexcel A17 = "Female"
putexcel A18 = "Rural Hukou"
putexcel A19 = "Age-friendly residential environments"
putexcel A20 = "Total"
putexcel A21 = "Indoor sitting toilet"
putexcel A22 = "Indoor squat toilet"
putexcel A23 = "Indoor tap water"
putexcel A24 = "Access to health-care services"
putexcel A25 = "Total explained change"
putexcel A26 = "Total unexplained change"


putexcel B1 = "Weighted mean difference between 2011 and 2020"
putexcel C1 = "Level 1 dependency"
putexcel C1:D1, merge 
putexcel C2 = "Explained change"
putexcel D2 = "Proportion of total change"

putexcel E1 = "Level 2 dependency"
putexcel E1:F1, merge
putexcel E2 = "Explained change"
putexcel F2 = "Proportion of total change"

putexcel G1 = "Level 3 dependency"
putexcel G1:H1, merge
putexcel G2 = "Explained change"
putexcel H2 = "Proportion of total change"


putexcel B6 = dAgegroup5[1]
putexcel B7 = dAgegroup6[1]
putexcel B8 = dAgegroup7[1]
putexcel B9 = dAgegroup8[1]

putexcel B12 = dEdugroup2[1]
putexcel B13 = dEdugroup3[1]
putexcel B14 = dEdugroup4[1]
putexcel B15 = dEdugroup5[1]

putexcel B17 = dFemale[1]
putexcel B18 = dHukou_agricultural[1]

putexcel B21 = dtoilet_sit_inhouse[1]
putexcel B22 = dtoilet_unsit_inhouse[1]
putexcel B23 = dwater[1]
putexcel B24 = ddistance_hosptial[1]

putexcel C3 = dADL_needhelp_any[1]

putexcel C6 = explained_Agegroup5[1]
putexcel C7 = explained_Agegroup6[1]
putexcel C8 = explained_Agegroup7[1]
putexcel C9 = explained_Agegroup8[1]

putexcel C12 = explained_Edugroup2[1]
putexcel C13 = explained_Edugroup3[1]
putexcel C14 = explained_Edugroup4[1]
putexcel C15 = explained_Edugroup5[1]

putexcel C17 = explained_Female[1]
putexcel C18 = explained_Hukou_agricultural[1]

putexcel C21 = explained_toilet_sit_inhouse[1]
putexcel C22 = explained_toilet_unsit_inhouse[1]
putexcel C23 = explained_water[1]
putexcel C24 = explained_distance_hosptial[1]

putexcel C25 = explained_total[1]

putexcel D3 = 1

putexcel D6 = fr_exp_Agegroup5[1]
putexcel D7 = fr_exp_Agegroup6[1]
putexcel D8 = fr_exp_Agegroup7[1]
putexcel D9 = fr_exp_Agegroup8[1]

putexcel D12 = fr_exp_Edugroup2[1]
putexcel D13 = fr_exp_Edugroup3[1]
putexcel D14 = fr_exp_Edugroup4[1]
putexcel D15 = fr_exp_Edugroup5[1]

putexcel D17 = fr_exp_Female[1]
putexcel D18 = fr_exp_Hukou_agricultural[1]

putexcel D21 = fr_exp_toilet_sit_inhouse[1]
putexcel D22 = fr_exp_toilet_unsit_inhouse[1]
putexcel D23 = fr_exp_water[1]
putexcel D24 = fr_exp_distance_hosptial[1]

putexcel D25 = fr_exp_total[1]

putexcel C5 = formula(C6+C7+C8+C9)
putexcel D5 = formula(D6+D7+D8+D9)

putexcel C11 = formula(C12+C13+C14+C15)
putexcel D11 = formula(D12+D13+D14+D15)

putexcel C20 = formula(C21+C22+C23)
putexcel D20 = formula(D21+D22+D23)

putexcel C26 = formula(C3-C25)
putexcel D26 = formula(D3-D25)



**----------------------------------------------------------------
** adl plus (level 2),  contribution of different factors
**----------------------------------------------------------------
use $working_data/collapse_X_Y.dta, clear

drop toilet_sit_inhouse_new toilet
reshape wide Agegroup* Edugroup* Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any,i(ID) j(Wave)
 

*differences in disability rate and independent variables
foreach var in Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
Edugroup1 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any {
	gen d`var'1311=`var'2013-`var'2011
	gen d`var'1511=`var'2015-`var'2011
	gen d`var'1811=`var'2018-`var'2011
	gen d`var'2011=`var'2020-`var'2011
}

keep d* ID  ADL_needhelp_any2011  ADL_cs_medicine2011  ADL_IADL_any2011 
drop distance*
reshape long dAgegroup4 dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8 ///
dEdugroup1 dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse  dtoilet_unsit_inhouse   dwater ddistance_hosptial dADL_needhelp_any  dADL_cs_medicine  dADL_IADL_any  ,i(ID)
rename _j period


merge n:1 ID using $working_data/adl_plus_coeff_weight

drop _merge
 
foreach x in  Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial  {
    gen explained_`x' = d`x'*coeff_`x'
} 

foreach x in  Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial  {
    gen fr_exp_`x' = explained_`x'/dADL_cs_medicine
} 


keep period dADL_cs_medicine  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
coeff_Agegroup5 coeff_Agegroup6 coeff_Agegroup7 coeff_Agegroup8 coeff_Edugroup2 coeff_Edugroup3 coeff_Edugroup4 coeff_Edugroup5 coeff_Female coeff_Hukou_agricultural coeff_toilet_sit_inhouse coeff_toilet_unsit_inhouse coeff_water coeff_distance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial  ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial   

order period dADL_cs_medicine  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
coeff_Agegroup5 coeff_Agegroup6 coeff_Agegroup7 coeff_Agegroup8 coeff_Edugroup2 coeff_Edugroup3 coeff_Edugroup4 coeff_Edugroup5 coeff_Female coeff_Hukou_agricultural coeff_toilet_sit_inhouse coeff_toilet_unsit_inhouse coeff_water coeff_distance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial   ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial    

format d* coeff* explained* fr_exp* %8.4f

replace ddistance_hosptial = ddistance_hosptial[3] if _n == 4

replace explained_distance_hosptial = explained_distance_hosptial[3] if _n == 4
replace fr_exp_distance_hosptial = explained_distance_hosptial/dADL_cs_medicine  if _n == 4

egen explained_total = rowtotal(explained_*)

egen fr_exp_total = rowtotal(fr_exp_*)

keep if period == 2011 

keep period dADL_cs_medicine  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial explained_total ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial   fr_exp_total 

order period dADL_cs_medicine  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial   explained_total ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial  fr_exp_total 

format d* explained* fr_exp* %8.4f

putexcel E3 = dADL_cs_medicine[1]

putexcel E6 = explained_Agegroup5[1]
putexcel E7 = explained_Agegroup6[1]
putexcel E8 = explained_Agegroup7[1]
putexcel E9 = explained_Agegroup8[1]

putexcel E12 = explained_Edugroup2[1]
putexcel E13 = explained_Edugroup3[1]
putexcel E14 = explained_Edugroup4[1]
putexcel E15 = explained_Edugroup5[1]

putexcel E17 = explained_Female[1]
putexcel E18 = explained_Hukou_agricultural[1]

putexcel E21 = explained_toilet_sit_inhouse[1]
putexcel E22 = explained_toilet_unsit_inhouse[1]
putexcel E23 = explained_water[1]
putexcel E24 = explained_distance_hosptial[1]

putexcel E25 = explained_total[1]

putexcel F3 = 1

putexcel F6 = fr_exp_Agegroup5[1]
putexcel F7 = fr_exp_Agegroup6[1]
putexcel F8 = fr_exp_Agegroup7[1]
putexcel F9 = fr_exp_Agegroup8[1]

putexcel F12 = fr_exp_Edugroup2[1]
putexcel F13 = fr_exp_Edugroup3[1]
putexcel F14 = fr_exp_Edugroup4[1]
putexcel F15 = fr_exp_Edugroup5[1]

putexcel F17 = fr_exp_Female[1]
putexcel F18 = fr_exp_Hukou_agricultural[1]

putexcel F21 = fr_exp_toilet_sit_inhouse[1]
putexcel F22 = fr_exp_toilet_unsit_inhouse[1]
putexcel F23 = fr_exp_water[1]
putexcel F24 = fr_exp_distance_hosptial[1]

putexcel F25 = fr_exp_total[1]


putexcel E5 = formula(E6+E7+E8+E9)
putexcel F5 = formula(F6+F7+F8+F9)

putexcel E11 = formula(E12+E13+E14+E15)
putexcel F11 = formula(F12+F13+F14+F15)

putexcel E20 = formula(E21+E22+E23)
putexcel F20 = formula(F21+F22+F23)

putexcel E26 = formula(E3-E25)
putexcel F26 = formula(F3-F25)


**----------------------------------------------------------------
** adl/iadl (level 3),  contribution of different factors
**----------------------------------------------------------------
use $working_data/collapse_X_Y.dta, clear

drop toilet_sit_inhouse_new toilet
reshape wide Agegroup* Edugroup* Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any,i(ID) j(Wave)
 

*differences in disability rate and independent variables
foreach var in Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
Edugroup1 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any {
	gen d`var'1311=`var'2013-`var'2011
	gen d`var'1511=`var'2015-`var'2011
	gen d`var'1811=`var'2018-`var'2011
	gen d`var'2011=`var'2020-`var'2011
}

keep d* ID  ADL_needhelp_any2011  ADL_cs_medicine2011  ADL_IADL_any2011 
drop distance*
reshape long dAgegroup4 dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8 ///
dEdugroup1 dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse  dtoilet_unsit_inhouse   dwater ddistance_hosptial dADL_needhelp_any  dADL_cs_medicine  dADL_IADL_any  ,i(ID)
rename _j period

merge n:1 ID using $working_data/adl_iadl_coeff_weight

drop _merge
 
foreach x in  Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial  {
    gen explained_`x' = d`x'*coeff_`x'
} 

foreach x in  Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial  {
    gen fr_exp_`x' = explained_`x'/dADL_IADL_any
} 

keep period dADL_IADL_any  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
coeff_Agegroup5 coeff_Agegroup6 coeff_Agegroup7 coeff_Agegroup8 coeff_Edugroup2 coeff_Edugroup3 coeff_Edugroup4 coeff_Edugroup5 coeff_Female coeff_Hukou_agricultural coeff_toilet_sit_inhouse coeff_toilet_unsit_inhouse coeff_water coeff_distance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial  ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial   

order period dADL_IADL_any  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
coeff_Agegroup5 coeff_Agegroup6 coeff_Agegroup7 coeff_Agegroup8 coeff_Edugroup2 coeff_Edugroup3 coeff_Edugroup4 coeff_Edugroup5 coeff_Female coeff_Hukou_agricultural coeff_toilet_sit_inhouse coeff_toilet_unsit_inhouse coeff_water coeff_distance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial   ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial    

format d* coeff* explained* fr_exp* %8.5f

replace ddistance_hosptial = ddistance_hosptial[3] if _n == 4

replace explained_distance_hosptial = explained_distance_hosptial[3] if _n == 4
replace fr_exp_distance_hosptial = explained_distance_hosptial/dADL_IADL_any  if _n == 4

egen explained_total = rowtotal(explained_*)

egen fr_exp_total = rowtotal(fr_exp_*)

keep if period == 2011 

keep period dADL_IADL_any  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial explained_total ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial   fr_exp_total

order period dADL_IADL_any  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial   explained_total ///
fr_exp_Agegroup5 fr_exp_Agegroup6 fr_exp_Agegroup7 fr_exp_Agegroup8 fr_exp_Edugroup2 fr_exp_Edugroup3 fr_exp_Edugroup4 fr_exp_Edugroup5 fr_exp_Female fr_exp_Hukou_agricultural fr_exp_toilet_sit_inhouse fr_exp_toilet_unsit_inhouse fr_exp_water fr_exp_distance_hosptial  fr_exp_total 

format d* explained* fr_exp* %8.4f

putexcel G3 = dADL_IADL_any[1]

putexcel G6 = explained_Agegroup5[1]
putexcel G7 = explained_Agegroup6[1]
putexcel G8 = explained_Agegroup7[1]
putexcel G9 = explained_Agegroup8[1]

putexcel G12 = explained_Edugroup2[1]
putexcel G13 = explained_Edugroup3[1]
putexcel G14 = explained_Edugroup4[1]
putexcel G15 = explained_Edugroup5[1]

putexcel G17 = explained_Female[1]
putexcel G18 = explained_Hukou_agricultural[1]

putexcel G21 = explained_toilet_sit_inhouse[1]
putexcel G22 = explained_toilet_unsit_inhouse[1]
putexcel G23 = explained_water[1]
putexcel G24 = explained_distance_hosptial[1]

putexcel G25 = explained_total[1]

putexcel H3 = 1

putexcel H6 = fr_exp_Agegroup5[1]
putexcel H7 = fr_exp_Agegroup6[1]
putexcel H8 = fr_exp_Agegroup7[1]
putexcel H9 = fr_exp_Agegroup8[1]

putexcel H12 = fr_exp_Edugroup2[1]
putexcel H13 = fr_exp_Edugroup3[1]
putexcel H14 = fr_exp_Edugroup4[1]
putexcel H15 = fr_exp_Edugroup5[1]

putexcel H17 = fr_exp_Female[1]
putexcel H18 = fr_exp_Hukou_agricultural[1]

putexcel H21 = fr_exp_toilet_sit_inhouse[1]
putexcel H22 = fr_exp_toilet_unsit_inhouse[1]
putexcel H23 = fr_exp_water[1]
putexcel H24 = fr_exp_distance_hosptial[1]

putexcel H25 = fr_exp_total[1]


putexcel G5 = formula(G6+G7+G8+G9)
putexcel H5 = formula(H6+H7+H8+H9)

putexcel G11 = formula(G12+G13+G14+G15)
putexcel H11 = formula(H12+H13+H14+H15)

putexcel G20 = formula(G21+G22+G23)
putexcel H20 = formula(H21+H22+H23)

putexcel G26 = formula(G3-G25)
putexcel H26 = formula(H3-H25)


putexcel save


erase $working_data/ADL_2011.dta
erase $working_data/ADL_2013.dta
erase $working_data/ADL_2015.dta
erase $working_data/ADL_2018.dta
erase $working_data/ADL_2020.dta

erase $working_data/ADL_3index_bywave_60.dta
erase $working_data/ADL_3index_bywave_50.dta
erase $working_data/ADL_3index_bywave_50_60.dta

erase $working_data/pop_disability_3index_wave.dta


erase $working_data/adl_iadl_sd2011.dta
erase $working_data/adl_iadl_sd2013.dta
erase $working_data/adl_iadl_sd2015.dta
erase $working_data/adl_iadl_sd2018.dta
erase $working_data/adl_iadl_sd2020.dta

erase $working_data/adl_sd2011.dta
erase $working_data/adl_sd2013.dta
erase $working_data/adl_sd2015.dta
erase $working_data/adl_sd2018.dta
erase $working_data/adl_sd2020.dta


erase $working_data/adl_plus_sd2011.dta
erase $working_data/adl_plus_sd2013.dta
erase $working_data/adl_plus_sd2015.dta
erase $working_data/adl_plus_sd2018.dta
erase $working_data/adl_plus_sd2020.dta

erase $working_data/sd_adl.dta
erase $working_data/sd_adl_plus.dta
erase $working_data/sd_adl_iadl.dta


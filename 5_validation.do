** ================================================================================================
** Aim:             Validation (Table_A6)
** Author:          CHARLS team
** Created:         2020/10/14
** Modified:        2023/3/27
** Data input:      $working_data/disability_3index_bywave_1120
**                  $working_data/collapse_X_Y.dta
**                  $working_data/adl_iadl_coeff_weight
**                  $working_data/adl_plus_coeff_weight
**                  $working_data/adl_coeff_weight
**                  hosptail_all_im (distance to the most visited hospital from 2011 to 2018, collected from community questionnaire, not in public data)
** =================================================================================================

use  $working_data/disability_3index_bywave_1120,clear

replace householdID = householdID + "0" if Wave == 2011
replace ID = householdID + substr(ID,-2,2) if Wave == 2011

merge n:1 communityID using $raw_data/hosptail_all_im, keepusing(jf006_9_2011 jf006_9_2013 jf006_9_2015 jf006_9_2018 im_jf006_9_2011 im_jf006_9_2013 im_jf006_9_2015 im_jf006_9_2018)

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

//We need to assume that the distances to the most vistied hospital in 2020 are the same in 2018
foreach x of numlist 2018 {
    local y = `x' + 2
    replace  distance_hosptial = im_jf006_9_`x' if `y' == Wave 
}


**----------------------------------------------------
**ADL_IADL_any, level 3, get regression coefficients from 2018 and 2020
**----------------------------------------------------

preserve
reg ADL_IADL_any   Agegroup5 Agegroup6 Agegroup7  Agegroup8 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5  Female Hukou_agricultural  toilet_sit_inhouse  toilet_unsit_inhouse   water  distance_hosptial Edugroup_m Hukou_agricultural_m toilet_sit_inhouse_m  water_m distance_hosptial_m    [pw=INDV_weight_post2] if Wave >= 2018 & Wave <= 2020  , cluster(ID)


ereturn list
mat b = e(b)
mat list b


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

save $working_data/adl_iadl_coeff_weight1820.dta, replace
restore

**----------------------------------------------------
**ADL_cs_medicine, level 2, get regression coefficients from 2018 and 2020
**----------------------------------------------------
preserve

reg ADL_cs_medicine   Agegroup5 Agegroup6 Agegroup7  Agegroup8 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5  Female Hukou_agricultural  toilet_sit_inhouse  toilet_unsit_inhouse   water  distance_hosptial Edugroup_m Hukou_agricultural_m toilet_sit_inhouse_m  water_m distance_hosptial_m    [pw=INDV_weight_post2]  if Wave >= 2018 & Wave <= 2020 , cluster(ID)


ereturn list
mat b = e(b)
mat list b

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

save $working_data/adl_plus_coeff_weight1820.dta, replace

restore

**----------------------------------------------------
**ADL_needhelp_any, level 1, get regression coefficients from 2018 and 2020
**----------------------------------------------------
preserve

reg ADL_needhelp_any  Agegroup5 Agegroup6 Agegroup7  Agegroup8 Edugroup2 Edugroup3 ///
Edugroup4 Edugroup5  Female Hukou_agricultural  toilet_sit_inhouse  toilet_unsit_inhouse   water  distance_hosptial Edugroup_m Hukou_agricultural_m toilet_sit_inhouse_m  water_m distance_hosptial_m    [pw=INDV_weight_post2] if Wave >= 2018 & Wave <= 2020  , cluster(ID)

ereturn list
mat b = e(b)
mat list b

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

save $working_data/adl_coeff_weight1820.dta, replace

restore

**----------------------------------------------------------------
**----------------------------------------------------------------
** Based on 2011-2018 regression results, we predict factor driven dependency rate change from 2018 to 2020
** Based on 2018-2020 regression results, we get real factor driven dependency rate change from 2018 to 2020
** Then get performance indicator
**----------------------------------------------------------------
**----------------------------------------------------------------

**----------------------------------------------------------------
** Level 3 validation
**----------------------------------------------------------------

use $working_data/collapse_X_Y.dta, clear

drop toilet_sit_inhouse_new toilet
reshape wide Agegroup* Edugroup* Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any,i(ID) j(Wave)
 

*differences in disability rate and independent variables
foreach var in Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
Edugroup1 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any {
	gen d`var'2018=`var'2020-`var'2018
}

keep d* ID  ADL_needhelp_any2011  ADL_cs_medicine2011  ADL_IADL_any2011 
drop distance*
reshape long dAgegroup4 dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8 ///
dEdugroup1 dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse  dtoilet_unsit_inhouse   dwater ddistance_hosptial dADL_needhelp_any  dADL_cs_medicine  dADL_IADL_any  ,i(ID)
rename _j period


merge n:1 ID using $working_data/adl_iadl_coeff_weight
rename coeff_* coeff1_*

drop _merge

merge n:1 ID using $working_data/adl_iadl_coeff_weight1820
rename coeff_* coeff2_*

drop _merge

reshape long coeff@_Agegroup5 coeff@_Agegroup6 coeff@_Agegroup7 coeff@_Agegroup8 coeff@_Edugroup2 coeff@_Edugroup3 coeff@_Edugroup4 coeff@_Edugroup5 coeff@_Female coeff@_Hukou_agricultural coeff@_toilet_sit_inhouse coeff@_toilet_unsit_inhouse coeff@_water coeff@_distance_hosptial, i(ID) j(time_period)
 
foreach x in  Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial  {
    gen explained_`x' = d`x'*coeff_`x'
} 

replace ddistance_hosptial = 0

replace explained_distance_hosptial = 0

egen explained_total = rowtotal(explained_*)
 

keep if period == 2018 

keep period dADL_IADL_any  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
coeff_Agegroup5 coeff_Agegroup6 coeff_Agegroup7 coeff_Agegroup8 coeff_Edugroup2 coeff_Edugroup3 coeff_Edugroup4 coeff_Edugroup5 coeff_Female coeff_Hukou_agricultural coeff_toilet_sit_inhouse coeff_toilet_unsit_inhouse coeff_water coeff_distance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial explained_total


format d* explained* %8.3f

putexcel set $tables/Lancet_public_health.xlsx, sheet(Table_A6, replace) modify

putexcel A3 = "Panel (a)"
putexcel A4 = "Age group, 65-69"
putexcel A5 = "Age group, 70-74"
putexcel A6 = "Age group, 75-79"
putexcel A7 = "Age group, >=80"
putexcel A8 = "Education group, Literate"
putexcel A9 = "Education group,Primary school"
putexcel A10 = "Education group,Middle school"
putexcel A11 = "Education group, High school and above"
putexcel A12 = "Female"
putexcel A13 = "Rural Hukou"
putexcel A14 = "Indoor sitting toilet"
putexcel A15 = "Indoor squat toilet"
putexcel A16 = "Indoor tap water"
putexcel A17 = "Access to health-care services"
putexcel A18 = "Total explained change"

putexcel A19 = "Panel (b)"
putexcel A20 = "Dependency rate"
putexcel A21 = "Performance indicator"


putexcel B2 = "Difference between 2018 and 2020"

putexcel C1 = "Level 3 dependency"
putexcel C1:F1, merge 
putexcel C2 = "Coefficients (2011-2018)"
putexcel D2 = "Coefficients (2018-2020)"
putexcel E2 = "Coefficients*Diff (2011-2018)"
putexcel F2 = "Coefficients*Diff (2018-2020)"


putexcel G1 = "Level 2 dependency"
putexcel G1:J1, merge
putexcel G2 = "Coefficients (2011-2018)"
putexcel H2 = "Coefficients (2018-2020)"
putexcel I2 = "Coefficients*Diff (2011-2018)"
putexcel J2 = "Coefficients*Diff (2018-2020)"


putexcel K1 = "Level 1 dependency"
putexcel K1:N1, merge
putexcel K2 = "Coefficients (2011-2018)"
putexcel L2 = "Coefficients (2018-2020)"
putexcel M2 = "Coefficients*Diff (2011-2018)"
putexcel N2 = "Coefficients*Diff (2018-2020)"

putexcel E19 = "Model predict factor driven"
putexcel F19 = "Real factor driven"

putexcel I19 = "Model predict factor driven"
putexcel J19 = "Real factor driven"

putexcel M19 = "Model predict factor driven"
putexcel N19 = "Real factor driven"


putexcel B4 = dAgegroup5[1] , nformat( 0.000)
putexcel B5 = dAgegroup6[1] , nformat( 0.000)
putexcel B6 = dAgegroup7[1] , nformat( 0.000)
putexcel B7 = dAgegroup8[1] , nformat( 0.000)

putexcel B8 = dEdugroup2[1] , nformat( 0.000)
putexcel B9 = dEdugroup3[1] , nformat( 0.000)
putexcel B10 = dEdugroup4[1] , nformat( 0.000)
putexcel B11 = dEdugroup5[1] , nformat( 0.000)

putexcel B12 = dFemale[1] , nformat( 0.000)
putexcel B13 = dHukou_agricultural[1] , nformat( 0.000)

putexcel B14 = dtoilet_sit_inhouse[1] , nformat( 0.000)
putexcel B15 = dtoilet_unsit_inhouse[1] , nformat( 0.000)
putexcel B16 = dwater[1] , nformat( 0.000)
putexcel B17 = ddistance_hosptial[1] , nformat( 0.000)



putexcel C4 = coeff_Agegroup5[1] , nformat( 0.000)
putexcel C5 = coeff_Agegroup6[1] , nformat( 0.000)
putexcel C6 = coeff_Agegroup7[1] , nformat( 0.000)
putexcel C7 = coeff_Agegroup8[1] , nformat( 0.000)

putexcel C8 = coeff_Edugroup2[1] , nformat( 0.000)
putexcel C9 = coeff_Edugroup3[1] , nformat( 0.000)
putexcel C10 = coeff_Edugroup4[1] , nformat( 0.000)
putexcel C11 = coeff_Edugroup5[1] , nformat( 0.000)

putexcel C12 = coeff_Female[1] , nformat( 0.000)
putexcel C13 = coeff_Hukou_agricultural[1] , nformat( 0.000)

putexcel C14 = coeff_toilet_sit_inhouse[1] , nformat( 0.000)
putexcel C15 = coeff_toilet_unsit_inhouse[1] , nformat( 0.000)
putexcel C16 = coeff_water[1] , nformat( 0.000)
putexcel C17 = coeff_distance_hosptial[1] , nformat( 0.000)

putexcel D4 = coeff_Agegroup5[2] , nformat( 0.000)
putexcel D5 = coeff_Agegroup6[2] , nformat( 0.000)
putexcel D6 = coeff_Agegroup7[2] , nformat( 0.000)
putexcel D7 = coeff_Agegroup8[2] , nformat( 0.000)

putexcel D8 = coeff_Edugroup2[2] , nformat( 0.000)
putexcel D9 = coeff_Edugroup3[2] , nformat( 0.000)
putexcel D10 = coeff_Edugroup4[2] , nformat( 0.000)
putexcel D11 = coeff_Edugroup5[2] , nformat( 0.000)

putexcel D12 = coeff_Female[2] , nformat( 0.000)
putexcel D13 = coeff_Hukou_agricultural[2] , nformat( 0.000)

putexcel D14 = coeff_toilet_sit_inhouse[2] , nformat( 0.000)
putexcel D15 = coeff_toilet_unsit_inhouse[2] , nformat( 0.000)
putexcel D16 = coeff_water[2] , nformat( 0.000)
putexcel D17 = coeff_distance_hosptial[2] , nformat( 0.000)



putexcel E4 = explained_Agegroup5[1] , nformat( 0.000)
putexcel E5 = explained_Agegroup6[1] , nformat( 0.000)
putexcel E6 = explained_Agegroup7[1] , nformat( 0.000)
putexcel E7 = explained_Agegroup8[1] , nformat( 0.000)

putexcel E8 = explained_Edugroup2[1] , nformat( 0.000)
putexcel E9 = explained_Edugroup3[1] , nformat( 0.000)
putexcel E10 = explained_Edugroup4[1] , nformat( 0.000)
putexcel E11 = explained_Edugroup5[1] , nformat( 0.000)

putexcel E12 = explained_Female[1] , nformat( 0.000)
putexcel E13 = explained_Hukou_agricultural[1] , nformat( 0.000)

putexcel E14 = explained_toilet_sit_inhouse[1] , nformat( 0.000)
putexcel E15 = explained_toilet_unsit_inhouse[1] , nformat( 0.000)
putexcel E16 = explained_water[1] , nformat( 0.000)
putexcel E17 = explained_distance_hosptial[1] , nformat( 0.000)
putexcel E18 = explained_total[1] , nformat( 0.000)


putexcel F4 = explained_Agegroup5[2] , nformat( 0.000)
putexcel F5 = explained_Agegroup6[2] , nformat( 0.000)
putexcel F6 = explained_Agegroup7[2] , nformat( 0.000)
putexcel F7 = explained_Agegroup8[2] , nformat( 0.000)

putexcel F8 = explained_Edugroup2[2] , nformat( 0.000)
putexcel F9 = explained_Edugroup3[2] , nformat( 0.000)
putexcel F10 = explained_Edugroup4[2] , nformat( 0.000)
putexcel F11 = explained_Edugroup5[2] , nformat( 0.000)

putexcel F12 = explained_Female[2] , nformat( 0.000)
putexcel F13 = explained_Hukou_agricultural[2] , nformat( 0.000)

putexcel F14 = explained_toilet_sit_inhouse[2] , nformat( 0.000)
putexcel F15 = explained_toilet_unsit_inhouse[2] , nformat( 0.000)
putexcel F16 = explained_water[2] , nformat( 0.000)
putexcel F17 = explained_distance_hosptial[2] , nformat( 0.000)
putexcel F18 = explained_total[2] , nformat( 0.000)


**----------------------------------------------------------------
** Level 2 validation
**----------------------------------------------------------------

use $working_data/collapse_X_Y.dta, clear

drop toilet_sit_inhouse_new toilet
reshape wide Agegroup* Edugroup* Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any,i(ID) j(Wave)
 
*differences in disability rate and independent variables

foreach var in Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
Edugroup1 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any {
	gen d`var'2018=`var'2020-`var'2018
}

keep d* ID  ADL_needhelp_any2011  ADL_cs_medicine2011  ADL_IADL_any2011 
drop distance*
reshape long dAgegroup4 dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8 ///
dEdugroup1 dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse  dtoilet_unsit_inhouse   dwater ddistance_hosptial dADL_needhelp_any  dADL_cs_medicine  dADL_IADL_any  ,i(ID)
rename _j period


merge n:1 ID using $working_data/adl_plus_coeff_weight
rename coeff_* coeff1_*

drop _merge

merge n:1 ID using $working_data/adl_plus_coeff_weight1820
rename coeff_* coeff2_*

drop _merge

reshape long coeff@_Agegroup5 coeff@_Agegroup6 coeff@_Agegroup7 coeff@_Agegroup8 coeff@_Edugroup2 coeff@_Edugroup3 coeff@_Edugroup4 coeff@_Edugroup5 coeff@_Female coeff@_Hukou_agricultural coeff@_toilet_sit_inhouse coeff@_toilet_unsit_inhouse coeff@_water coeff@_distance_hosptial, i(ID) j(time_period)
 
foreach x in  Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial  {
    gen explained_`x' = d`x'*coeff_`x'
} 
 
replace ddistance_hosptial = 0

replace explained_distance_hosptial = 0

egen explained_total = rowtotal(explained_*)

keep period dADL_cs_medicine  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
coeff_Agegroup5 coeff_Agegroup6 coeff_Agegroup7 coeff_Agegroup8 coeff_Edugroup2 coeff_Edugroup3 coeff_Edugroup4 coeff_Edugroup5 coeff_Female coeff_Hukou_agricultural coeff_toilet_sit_inhouse coeff_toilet_unsit_inhouse coeff_water coeff_distance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial explained_total  

format d* explained*   %8.3f


putexcel G4 = coeff_Agegroup5[1] , nformat( 0.000)
putexcel G5 = coeff_Agegroup6[1] , nformat( 0.000)
putexcel G6 = coeff_Agegroup7[1] , nformat( 0.000)
putexcel G7 = coeff_Agegroup8[1] , nformat( 0.000)

putexcel G8 = coeff_Edugroup2[1] , nformat( 0.000)
putexcel G9 = coeff_Edugroup3[1] , nformat( 0.000)
putexcel G10 = coeff_Edugroup4[1] , nformat( 0.000)
putexcel G11 = coeff_Edugroup5[1] , nformat( 0.000)

putexcel G12 = coeff_Female[1] , nformat( 0.000)
putexcel G13 = coeff_Hukou_agricultural[1] , nformat( 0.000)

putexcel G14 = coeff_toilet_sit_inhouse[1] , nformat( 0.000)
putexcel G15 = coeff_toilet_unsit_inhouse[1] , nformat( 0.000)
putexcel G16 = coeff_water[1] , nformat( 0.000)
putexcel G17 = coeff_distance_hosptial[1] , nformat( 0.000)

putexcel H4 = coeff_Agegroup5[2] , nformat( 0.000)
putexcel H5 = coeff_Agegroup6[2] , nformat( 0.000)
putexcel H6 = coeff_Agegroup7[2] , nformat( 0.000)
putexcel H7 = coeff_Agegroup8[2] , nformat( 0.000)

putexcel H8 = coeff_Edugroup2[2] , nformat( 0.000)
putexcel H9 = coeff_Edugroup3[2] , nformat( 0.000)
putexcel H10 = coeff_Edugroup4[2] , nformat( 0.000)
putexcel H11 = coeff_Edugroup5[2] , nformat( 0.000)

putexcel H12 = coeff_Female[2] , nformat( 0.000)
putexcel H13 = coeff_Hukou_agricultural[2] , nformat( 0.000)

putexcel H14 = coeff_toilet_sit_inhouse[2] , nformat( 0.000)
putexcel H15 = coeff_toilet_unsit_inhouse[2] , nformat( 0.000)
putexcel H16 = coeff_water[2] , nformat( 0.000)
putexcel H17 = coeff_distance_hosptial[2] , nformat( 0.000)



putexcel I4 = explained_Agegroup5[1] , nformat( 0.000)
putexcel I5 = explained_Agegroup6[1] , nformat( 0.000)
putexcel I6 = explained_Agegroup7[1] , nformat( 0.000)
putexcel I7 = explained_Agegroup8[1] , nformat( 0.000)

putexcel I8 = explained_Edugroup2[1] , nformat( 0.000)
putexcel I9 = explained_Edugroup3[1] , nformat( 0.000)
putexcel I10 = explained_Edugroup4[1] , nformat( 0.000)
putexcel I11 = explained_Edugroup5[1] , nformat( 0.000)

putexcel I12 = explained_Female[1] , nformat( 0.000)
putexcel I13 = explained_Hukou_agricultural[1] , nformat( 0.000)

putexcel I14 = explained_toilet_sit_inhouse[1] , nformat( 0.000)
putexcel I15 = explained_toilet_unsit_inhouse[1] , nformat( 0.000)
putexcel I16 = explained_water[1] , nformat( 0.000)
putexcel I17 = explained_distance_hosptial[1] , nformat( 0.000)
putexcel I18 = explained_total[1] , nformat( 0.000)


putexcel J4 = explained_Agegroup5[2] , nformat( 0.000)
putexcel J5 = explained_Agegroup6[2] , nformat( 0.000)
putexcel J6 = explained_Agegroup7[2] , nformat( 0.000)
putexcel J7 = explained_Agegroup8[2] , nformat( 0.000)

putexcel J8 = explained_Edugroup2[2] , nformat( 0.000)
putexcel J9 = explained_Edugroup3[2] , nformat( 0.000)
putexcel J10 = explained_Edugroup4[2] , nformat( 0.000)
putexcel J11 = explained_Edugroup5[2] , nformat( 0.000)

putexcel J12 = explained_Female[2] , nformat( 0.000)
putexcel J13 = explained_Hukou_agricultural[2] , nformat( 0.000)

putexcel J14 = explained_toilet_sit_inhouse[2] , nformat( 0.000)
putexcel J15 = explained_toilet_unsit_inhouse[2] , nformat( 0.000)
putexcel J16 = explained_water[2] , nformat( 0.000)
putexcel J17 = explained_distance_hosptial[2] , nformat( 0.000)
putexcel J18 = explained_total[2] , nformat( 0.000)


**----------------------------------------------------------------
**  Level 1 validation
**----------------------------------------------------------------
use $working_data/collapse_X_Y.dta, clear

drop toilet_sit_inhouse_new toilet
reshape wide Agegroup* Edugroup* Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any,i(ID) j(Wave)
 

*differences in disability rate and independent variables

foreach var in Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
Edugroup1 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial ADL_needhelp_any  ADL_cs_medicine  ADL_IADL_any {
	gen d`var'2018=`var'2020-`var'2018
}

keep d* ID  ADL_needhelp_any2011  ADL_cs_medicine2011  ADL_IADL_any2011 
drop distance*
reshape long dAgegroup4 dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8 ///
dEdugroup1 dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse  dtoilet_unsit_inhouse   dwater ddistance_hosptial dADL_needhelp_any  dADL_cs_medicine  dADL_IADL_any  ,i(ID)
rename _j period


merge n:1 ID using $working_data/adl_coeff_weight
rename coeff_* coeff1_*

drop _merge

merge n:1 ID using $working_data/adl_coeff_weight1820
rename coeff_* coeff2_*

drop _merge

reshape long coeff@_Agegroup5 coeff@_Agegroup6 coeff@_Agegroup7 coeff@_Agegroup8 coeff@_Edugroup2 coeff@_Edugroup3 coeff@_Edugroup4 coeff@_Edugroup5 coeff@_Female coeff@_Hukou_agricultural coeff@_toilet_sit_inhouse coeff@_toilet_unsit_inhouse coeff@_water coeff@_distance_hosptial, i(ID) j(time_period)
 
foreach x in  Agegroup5 Agegroup6 Agegroup7 Agegroup8 ///
 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse  toilet_unsit_inhouse   water distance_hosptial  {
    gen explained_`x' = d`x'*coeff_`x'
} 
 

replace ddistance_hosptial = 0

replace explained_distance_hosptial = 0

egen explained_total = rowtotal(explained_*)
 

keep period dADL_cs_medicine  dAgegroup5 dAgegroup6 dAgegroup7 dAgegroup8  dEdugroup2 dEdugroup3 dEdugroup4 dEdugroup5 dFemale dHukou_agricultural dtoilet_sit_inhouse dtoilet_unsit_inhouse dwater ddistance_hosptial ///
coeff_Agegroup5 coeff_Agegroup6 coeff_Agegroup7 coeff_Agegroup8 coeff_Edugroup2 coeff_Edugroup3 coeff_Edugroup4 coeff_Edugroup5 coeff_Female coeff_Hukou_agricultural coeff_toilet_sit_inhouse coeff_toilet_unsit_inhouse coeff_water coeff_distance_hosptial ///
explained_Agegroup5 explained_Agegroup6 explained_Agegroup7 explained_Agegroup8 explained_Edugroup2 explained_Edugroup3 explained_Edugroup4 explained_Edugroup5 explained_Female explained_Hukou_agricultural explained_toilet_sit_inhouse explained_toilet_unsit_inhouse explained_water explained_distance_hosptial explained_total  

format d* explained*   %8.3f

putexcel K4 = coeff_Agegroup5[1] , nformat( 0.000)
putexcel K5 = coeff_Agegroup6[1] , nformat( 0.000)
putexcel K6 = coeff_Agegroup7[1] , nformat( 0.000)
putexcel K7 = coeff_Agegroup8[1] , nformat( 0.000)

putexcel K8 = coeff_Edugroup2[1] , nformat( 0.000)
putexcel K9 = coeff_Edugroup3[1] , nformat( 0.000)
putexcel K10 = coeff_Edugroup4[1] , nformat( 0.000)
putexcel K11 = coeff_Edugroup5[1] , nformat( 0.000)

putexcel K12 = coeff_Female[1] , nformat( 0.000)
putexcel K13 = coeff_Hukou_agricultural[1] , nformat( 0.000)

putexcel K14 = coeff_toilet_sit_inhouse[1] , nformat( 0.000)
putexcel K15 = coeff_toilet_unsit_inhouse[1] , nformat( 0.000)
putexcel K16 = coeff_water[1] , nformat( 0.000)
putexcel K17 = coeff_distance_hosptial[1] , nformat( 0.000)

putexcel L4 = coeff_Agegroup5[2] , nformat( 0.000)
putexcel L5 = coeff_Agegroup6[2] , nformat( 0.000)
putexcel L6 = coeff_Agegroup7[2] , nformat( 0.000)
putexcel L7 = coeff_Agegroup8[2] , nformat( 0.000)

putexcel L8 = coeff_Edugroup2[2] , nformat( 0.000)
putexcel L9 = coeff_Edugroup3[2] , nformat( 0.000)
putexcel L10 = coeff_Edugroup4[2] , nformat( 0.000)
putexcel L11 = coeff_Edugroup5[2] , nformat( 0.000)

putexcel L12 = coeff_Female[2] , nformat( 0.000)
putexcel L13 = coeff_Hukou_agricultural[2] , nformat( 0.000)

putexcel L14 = coeff_toilet_sit_inhouse[2] , nformat( 0.000)
putexcel L15 = coeff_toilet_unsit_inhouse[2] , nformat( 0.000)
putexcel L16 = coeff_water[2] , nformat( 0.000)
putexcel L17 = coeff_distance_hosptial[2] , nformat( 0.000)



putexcel M4 = explained_Agegroup5[1] , nformat( 0.000)
putexcel M5 = explained_Agegroup6[1] , nformat( 0.000)
putexcel M6 = explained_Agegroup7[1] , nformat( 0.000)
putexcel M7 = explained_Agegroup8[1] , nformat( 0.000)

putexcel M8 = explained_Edugroup2[1] , nformat( 0.000)
putexcel M9 = explained_Edugroup3[1] , nformat( 0.000)
putexcel M10 = explained_Edugroup4[1] , nformat( 0.000)
putexcel M11 = explained_Edugroup5[1] , nformat( 0.000)

putexcel M12 = explained_Female[1] , nformat( 0.000)
putexcel M13 = explained_Hukou_agricultural[1] , nformat( 0.000)

putexcel M14 = explained_toilet_sit_inhouse[1] , nformat( 0.000)
putexcel M15 = explained_toilet_unsit_inhouse[1] , nformat( 0.000)
putexcel M16 = explained_water[1] , nformat( 0.000)
putexcel M17 = explained_distance_hosptial[1] , nformat( 0.000)
putexcel M18 = explained_total[1] , nformat( 0.000)


putexcel N4 = explained_Agegroup5[2] , nformat( 0.000)
putexcel N5 = explained_Agegroup6[2] , nformat( 0.000)
putexcel N6 = explained_Agegroup7[2] , nformat( 0.000)
putexcel N7 = explained_Agegroup8[2] , nformat( 0.000)

putexcel N8 = explained_Edugroup2[2] , nformat( 0.000)
putexcel N9 = explained_Edugroup3[2] , nformat( 0.000)
putexcel N10 = explained_Edugroup4[2] , nformat( 0.000)
putexcel N11 = explained_Edugroup5[2] , nformat( 0.000)

putexcel N12 = explained_Female[2] , nformat( 0.000)
putexcel N13 = explained_Hukou_agricultural[2] , nformat( 0.000)

putexcel N14 = explained_toilet_sit_inhouse[2] , nformat( 0.000)
putexcel N15 = explained_toilet_unsit_inhouse[2] , nformat( 0.000)
putexcel N16 = explained_water[2] , nformat( 0.000)
putexcel N17 = explained_distance_hosptial[2] , nformat( 0.000)
putexcel N18 = explained_total[2] , nformat( 0.000)


**get the model predicted factor driven dependency rate, th real factor driven dependency rate and the performance indicator
** level 3
putexcel E20 = formula(0.237+E18), nformat( 0.000)
putexcel F20 = formula(0.237+F18), nformat( 0.000)
putexcel E21 = formula(1-abs((F20-E20)/F20)), nformat( 0.000)

** level 2
putexcel I20 = formula(0.188+I18), nformat( 0.000)
putexcel J20 = formula(0.188+J18), nformat( 0.000)
putexcel I21 = formula(1-abs((J20-I20)/J20)), nformat( 0.000)

** level 1
putexcel M20 = formula(0.100+M18), nformat( 0.000)
putexcel N20 = formula(0.100+N18), nformat( 0.000)
putexcel M21 = formula(1-abs((N20-M20)/N20)), nformat( 0.000)

putexcel save


erase $working_data/adl_coeff_weight1820.dta
erase $working_data/adl_iadl_coeff_weight1820.dta
erase $working_data/adl_plus_coeff_weight1820.dta



erase $working_data/adl_coeff_weight.dta
erase $working_data/adl_iadl_coeff_weight.dta
erase $working_data/adl_plus_coeff_weight.dta


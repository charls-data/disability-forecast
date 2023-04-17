** ================================================================================================
** Aim:             disability rate and population, decomposition of disability rate (2021-2030)
** Author:          CHARLS team
** Created:         2020/10/14
** Modified:        2023/3/27
** Data input:      China_older_pop_by_sexedu (UN, world population prospects, median variant projection for the year 2021-2030)
**                  $working_data/collapse_X_Y
** ==============================================================================================

**---------------------------------------------------------------------------------------
**-----to get num of pop, age group share, gender share and education group share--------
**---------------------------------------------------------------------------------------
**num of pop over year
use $raw_data\China_older_pop_by_sexedu.dta ,clear

keep if sexedu == "total"
bys year: egen total_pop = sum(pop)
duplicates drop year, force
keep year total_pop

gen growth_rate = ( total_pop[_n] - total_pop[_n-1] )/ total_pop[_n-1] 

gen total_pop2 = 253.849 if year == 2020
replace total_pop2 = total_pop2[_n-1]*(1+growth_rate) if year>2020
//update num of pop because we have the real number in 2020 and then growth rate of pop is assumed to be the same 

drop total_pop growth_rate
rename total_pop2 total_pop

save  $working_data\pop_total.dta,replace

**age group share
use $raw_data\China_older_pop_by_sexedu.dta ,clear

keep if sexedu == "Elementary" ||  sexedu == "Junior High"  ||  sexedu == "Senior High" ///
 || sexedu == "total"   ||  sexedu == "College"  ||   sexedu == "Unschooled"  

keep if sexedu == "total" 

keep if year <= 2030 & year>=2020


bys year:  egen total_pop = sum(pop)

gen share_pop = pop/total_pop


gen age80 = 1 if age_group == "80_84" || age_group == "85_89" ||  age_group == "90_94" ||  ///
age_group == "95_99" ||  age_group == "100"

gen age80_share1 =  share_pop*age80

bys year:  egen age80_share2 = sum(age80_share1)

replace share_pop = age80_share2 if age_group == "80_84"

drop age80 age80_share1 age80_share2


drop if  age_group == "85_89" ||  age_group == "90_94" ||  ///
age_group == "95_99" ||  age_group == "100"

replace age_group = "80" if age_group == "80_84"


bys year: egen tt = sum(share_pop)

ta tt,m
drop tt

gen id = 4 if age_group == "60_64"
replace id = 5 if age_group == "65_69"
replace id = 6 if age_group == "70_74"
replace id = 7 if age_group == "75_79"
replace id = 8 if age_group == "80"

rename share_pop Agegroup

keep year id Agegroup

reshape wide Agegroup, i(year) j(id)

egen tt = rowtotal(Agegroup*)
ta tt

save $working_data\pop_share2020_2030.dta,replace


******* education group share
use $raw_data\China_older_pop_by_sexedu.dta ,clear

keep if sexedu == "Elementary" ||  sexedu == "Junior High"  ||  sexedu == "Senior High" ///
  ||  sexedu == "College"  ||   sexedu == "Unschooled"  

sort year sexedu
keep if year <= 2030 & year>=2020

collapse (sum) pop, by(sexedu year)

bys year: egen total_pop = sum(pop)

gen share_pop = pop/total_pop

gen id = 1 if sexedu == "Unschooled"
replace id = 3 if sexedu == "Elementary"
replace id = 4 if sexedu == "Junior High"
replace id = 5 if sexedu == "Senior High"
replace id = 6 if sexedu == "College"

rename share_pop Edugroup

keep year id Edugroup

reshape wide Edugroup, i(year) j(id)

replace Edugroup5 = Edugroup5+Edugroup6

gen Edugroup2 = 0

drop Edugroup6

egen tt = rowtotal(Edugroup*)
ta tt
save $working_data\edu_share2020_2030.dta,replace


*******gender share
use $raw_data\China_older_pop_by_sexedu.dta ,clear

keep if sexedu == "totalf" ||  sexedu == "totalm" 
  
keep if year <= 2030 & year>=2020

collapse (sum) pop, by(sexedu year)

bys year: egen total_pop = sum(pop)

gen share_pop = pop/total_pop

keep if  sexedu == "totalf"

rename share_pop Female

keep year Female

save $working_data\female_share2020_2030.dta,replace
**---------------------------------------------------------------------------------------
**----get independent variables's values in 2020 and impute other years' independent variable
**---------------------------------------------------------------------------------------
clear
use $working_data/collapse_X_Y

egen a = rowtotal(Agegroup1 Agegroup2 Agegroup3 Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8)
egen b = rowtotal(Edugroup1 Edugroup2 Edugroup3 Edugroup4 Edugroup5)

tab1 a b

replace distance_hosptial = distance_hosptial[4] if _n == 5

keep  Hukou_agricultural toilet_sit_inhouse toilet_unsit_inhouse water ///
distance_hosptial ADL_needhelp_any ADL_cs_medicine ADL_IADL_any Wave

keep if Wave == 2020

rename Wave year

merge 1:1 year using $working_data\pop_share2020_2030.dta

drop _merge

merge 1:1 year using $working_data\edu_share2020_2030.dta

drop _merge tt

merge 1:1 year using $working_data\female_share2020_2030.dta

drop _merge 
**to impute independent variables in 2021-2030

//assume urbanization rate increase 1% per year from 2020

replace Hukou_agricultural = Hukou_agricultural[_n-1] - 0.01 if _n>=2

replace water = water[1]+ (1-water[1])*(year-2020)/10  if _n>=2

replace toilet_sit_inhouse =  toilet_sit_inhouse[1]+ (1-toilet_sit_inhouse[1])*(year-2020)/10 
replace toilet_unsit_inhouse =  toilet_unsit_inhouse[1]+ (0-toilet_unsit_inhouse[1])*(year-2020)/10 
replace distance_hosptial =  distance_hosptial[1]

**get difference between two years
foreach y in Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup2 Edugroup3 Edugroup4 Edugroup5 Female Hukou_agricultural toilet_sit_inhouse toilet_unsit_inhouse water distance_hosptial {
	gen D`y' = `y' - `y'[1]
}

save $working_data\diff_2020_2030.dta, replace

**---------------------------------------------------------------------------------------
**-----ADL/IADL (level 3) disability rate and num, forecast and decomposition------------
**---------------------------------------------------------------------------------------

**ADL/IADL (level 3) 
clear
use $working_data\diff_2020_2030.dta

gen DEdugroup_m = 0
gen DHukou_agricultural_m = 0
gen Dtoilet_sit_inhouse_m = 0
gen Dwater_m = 0
gen Ddistance_hosptial_m = 0

gen Dconstant = 0

foreach x of varlist ADL_IADL_any  {
	replace `x' = `x'[1] if _n>=2 
}

mat list b_ADL_IADL
mat list v_ADL_IADL

mkmat  DAgegroup5 DAgegroup6 DAgegroup7 DAgegroup8  DEdugroup2 DEdugroup3 DEdugroup4 DEdugroup5 DFemale DHukou_agricultural Dtoilet_sit_inhouse Dtoilet_unsit_inhouse Dwater Ddistance_hosptial DEdugroup_m DHukou_agricultural_m Dtoilet_sit_inhouse_m Dwater_m Ddistance_hosptial_m Dconstant, mat(diff_x)

mat list diff_x

mat diff_adl_iadl = diff_x*b_ADL_IADL'
mat list diff_adl_iadl
mat se_adl_iadl_year = diff_x*v_ADL_IADL*diff_x'
mat list se_adl_iadl_year

mat se_adl_iadl_year2 = J(11,1,0)
mat list se_adl_iadl_year2
foreach x of numlist 1/11 {
    mat se_adl_iadl_year2[`x',1] = se_adl_iadl_year[`x',`x']
}
mat list se_adl_iadl_year2

svmat diff_adl_iadl, names(diff_adl_iadl)
svmat se_adl_iadl_year2, names(v_adl_iadl)

gen adl_iadl_year = ADL_IADL_any + diff_adl_iadl1
gen ul_adl_iadl = adl_iadl_year+1.96*(v_adl_iadl1)^0.5
gen ll_adl_iadl = adl_iadl_year-1.96*(v_adl_iadl1)^0.5

drop  ADL_IADL_any 

rename adl_iadl_year ADL_IADL_any
merge 1:1 year using $working_data\pop_total.dta

keep if _merge == 3
drop _merge

gen PopADL_IADL_any = ADL_IADL_any*total_pop
gen PopADL_IADL_any_ul = ul_adl_iadl*total_pop
gen PopADL_IADL_any_ll = ll_adl_iadl*total_pop

gen Avepop = (total_pop[1] + total_pop)/2
gen AveADL_IADL_any = (ADL_IADL_any[1] + ADL_IADL_any)/2

gen Diffpop = total_pop - total_pop[1]
gen DiffADL_IADL_any = ADL_IADL_any - ADL_IADL_any[1]
gen DiffPopADL_IADL_any = PopADL_IADL_any - PopADL_IADL_any[1]
gen Effect_pop = Diffpop*AveADL_IADL_any
gen Effect_disability = DiffADL_IADL_any*Avepop

keep year Hukou_agricultural toilet_sit_inhouse toilet_unsit_inhouse water distance_hosptial ADL_needhelp_any ADL_cs_medicine Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup3 Edugroup4 Edugroup5 Edugroup2 Female diff_adl_iadl1 v_adl_iadl1 ADL_IADL_any ul_adl_iadl ll_adl_iadl total_pop PopADL_IADL_any PopADL_IADL_any_ul PopADL_IADL_any_ll Effect_pop Effect_disability DiffPopADL_IADL_any

preserve
tostring ll_adl_iadl, force replace format( %8.4f)
tostring ul_adl_iadl, force replace format( %8.4f)
tostring PopADL_IADL_any_ll, force replace format( %8.4f)
tostring PopADL_IADL_any_ul, force replace format( %8.4f)

gen adl_iadl_ci = "("+ll_adl_iadl+","+ul_adl_iadl+")"
gen adl_iadl_pop_ci = "("+PopADL_IADL_any_ll+","+PopADL_IADL_any_ul+")"

keep year ADL_IADL_any adl_iadl_ci PopADL_IADL_any adl_iadl_pop_ci Effect_pop Effect_disability  DiffPopADL_IADL_any

order year ADL_IADL_any adl_iadl_ci PopADL_IADL_any adl_iadl_pop_ci Effect_pop Effect_disability  DiffPopADL_IADL_any

label var  ADL_IADL_any "Level 3 projected disability rate"
label var  adl_iadl_ci "CI"
label var  PopADL_IADL_any "Level 3 projected population with care needs"
label var  adl_iadl_pop_ci "CI"
label var  Effect_pop "Growth attributed to population aging"
label var  Effect_disability "Growth attributed to dependency prevalence"
label var  DiffPopADL_IADL_any "Growth in the population with care needs (Reference:2020)"

export excel using $tables\Lancet_public_health.xlsx, firstrow(varlabels) sheet(Table_A4_c, replace) 
restore

keep year ADL_IADL_any ul_adl_iadl ll_adl_iadl PopADL_IADL_any PopADL_IADL_any_ul PopADL_IADL_any_ll  Effect_pop Effect_disability diff_adl_iadl1 DiffPopADL_IADL_any
rename Effect_pop Effect_pop_ADL_IADL_any
rename Effect_disability Effect_dis_ADL_IADL_any
save   $working_data\Decom_ADL_IADL.dta, replace
**---------------------------------------------------------------------------------------
**-------ADL plus (level 2) disability rate and num, forecast and decomposition----------
**---------------------------------------------------------------------------------------

**ADL plus (level 2) 
clear
use  $working_data\diff_2020_2030.dta

foreach x of varlist ADL_cs_medicine  {
	replace `x' = `x'[1] if _n>=2 
}

mat list diff_x
mat list b_ADL_plus
mat list v_ADL_plus

mat diff_adl_plus = diff_x*b_ADL_plus'
mat list diff_adl_plus
mat se_adl_plus_year = diff_x*v_ADL_plus*diff_x'
mat list se_adl_plus_year

mat se_adl_plus_year2 = J(11,1,0)
mat list se_adl_plus_year2
foreach x of numlist 1/11 {
    mat se_adl_plus_year2[`x',1] = se_adl_plus_year[`x',`x']
}
mat list se_adl_plus_year2

svmat diff_adl_plus, names(diff_adl_plus)
svmat se_adl_plus_year2, names(v_adl_plus)

gen adl_plus_year = ADL_cs_medicine + diff_adl_plus1
gen ul_adl_plus = adl_plus_year+1.96*v_adl_plus1^0.5
gen ll_adl_plus = adl_plus_year-1.96*v_adl_plus1^0.5

drop  ADL_cs_medicine 
rename adl_plus_year ADL_plus_any
merge 1:1 year using $working_data\pop_total.dta

keep if _merge == 3
drop _merge

gen PopADL_plus_any = ADL_plus_any*total_pop
gen PopADL_plus_any_ul = ul_adl_plus*total_pop
gen PopADL_plus_any_ll = ll_adl_plus*total_pop

gen Avepop = (total_pop[1] + total_pop)/2
gen AveADL_plus_any = (ADL_plus_any[1] + ADL_plus_any)/2

gen Diffpop = total_pop - total_pop[1]
gen DiffADL_plus_any = ADL_plus_any - ADL_plus_any[1]
gen Effect_pop = Diffpop*AveADL_plus_any
gen Effect_disability = DiffADL_plus_any*Avepop
gen DiffPopADL_plus_any = PopADL_plus_any - PopADL_plus_any[1]

keep year Female Hukou_agricultural toilet_sit_inhouse toilet_unsit_inhouse water distance_hosptial Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup3 Edugroup4 Edugroup5 Edugroup2  ADL_plus_any ul_adl_plus ll_adl_plus total_pop PopADL_plus_any PopADL_plus_any_ul PopADL_plus_any_ll Effect_pop Effect_disability DiffPopADL_plus_any

preserve
tostring ll_adl_plus, force replace format( %8.4f)
tostring ul_adl_plus, force replace format( %8.4f)
tostring PopADL_plus_any_ll, force replace format( %8.4f)
tostring PopADL_plus_any_ul, force replace format( %8.4f)

gen adl_plus_ci = "("+ll_adl_plus+","+ul_adl_plus+")"
gen adl_plus_pop_ci = "("+PopADL_plus_any_ll+","+PopADL_plus_any_ul+")"


keep year  ADL_plus_any adl_plus_ci  PopADL_plus_any adl_plus_pop_ci  Effect_pop Effect_disability DiffPopADL_plus_any

order year  ADL_plus_any adl_plus_ci  PopADL_plus_any adl_plus_pop_ci  Effect_pop Effect_disability DiffPopADL_plus_any

label var  ADL_plus_any "Level 2 projected disability rate"
label var  adl_plus_ci "CI"
label var  PopADL_plus_any "Level 2 projected population with care needs"
label var  adl_plus_pop_ci "CI"
label var  Effect_pop "Growth attributed to population aging"
label var  Effect_disability "Growth attributed to dependency prevalence"
label var  DiffPopADL_plus_any "Growth in the population with care needs (Reference:2020)"

export excel using $tables\Lancet_public_health.xlsx, firstrow(varlabels) sheet(Table_A4_b, replace) 

restore
keep year ADL_plus_any ul_adl_plus ll_adl_plus  PopADL_plus_any  PopADL_plus_any_ul PopADL_plus_any_ll Effect_pop Effect_disability DiffPopADL_plus_any
rename Effect_pop Effect_pop_ADL_plus_any
rename Effect_disability Effect_dis_ADL_plus_any
save  $working_data\Decom_ADL_Plus.dta, replace

**---------------------------------------------------------------------------------------
**------ADL (level 1) disability rate and num, forecast and decomposition----------------
**---------------------------------------------------------------------------------------
**ADL (level 1) 
clear
use  $working_data\diff_2020_2030.dta

foreach x of varlist ADL_needhelp_any   {
	replace `x' = `x'[1] if _n>=2 
}


mat list diff_x
mat list b_ADL
mat list v_ADL

mat diff_adl = diff_x*b_ADL'
mat list diff_adl
mat se_adl_year = diff_x*v_ADL*diff_x'
mat list se_adl_year

mat se_adl_year2 = J(11,1,0)
mat list se_adl_year2
foreach x of numlist 1/11 {
    mat se_adl_year2[`x',1] = se_adl_year[`x',`x']
}
mat list se_adl_year2

svmat diff_adl, names(diff_adl)
svmat se_adl_year2, names(v_adl)

gen adl_year = ADL_needhelp_any + diff_adl1
gen ul_adl = adl_year+1.96*v_adl1^0.5
gen ll_adl = adl_year-1.96*v_adl1^0.5

drop  ADL_needhelp_any 
rename adl_year ADL_needhelp_any
merge 1:1 year using $working_data\pop_total.dta

keep if _merge == 3
drop _merge

gen PopADL_needhelp_any = ADL_needhelp_any*total_pop
gen PopADL_ul = ul_adl*total_pop
gen PopADL_ll = ll_adl*total_pop

gen Avepop = (total_pop[1] + total_pop)/2
gen AveADL_needhelp_any = (ADL_needhelp_any[1] + ADL_needhelp_any)/2

gen Diffpop = total_pop - total_pop[1]
gen DiffADL_needhelp_any = ADL_needhelp_any - ADL_needhelp_any[1]
gen Effect_pop = Diffpop*AveADL_needhelp_any
gen Effect_disability = DiffADL_needhelp_any*Avepop
gen DiffPopADL_needhelp_any = PopADL_needhelp_any - PopADL_needhelp_any[1]


keep year Female Hukou_agricultural toilet_sit_inhouse toilet_unsit_inhouse water distance_hosptial Agegroup4 Agegroup5 Agegroup6 Agegroup7 Agegroup8 Edugroup1 Edugroup3 Edugroup4 Edugroup5 Edugroup2  ADL_needhelp_any ul_adl ll_adl total_pop PopADL_needhelp_any PopADL_ul PopADL_ll Effect_pop Effect_disability DiffPopADL_needhelp_any

preserve

tostring ll_adl, force replace format( %8.4f)
tostring ul_adl, force replace format( %8.4f)
tostring PopADL_ll, force replace format( %8.4f)
tostring PopADL_ul, force replace format( %8.4f)

gen adl_ci = "("+ll_adl+","+ul_adl+")"
gen adl_pop_ci = "("+PopADL_ll+","+PopADL_ul+")"

keep year  ADL_needhelp_any adl_ci  PopADL_needhelp_any adl_pop_ci  Effect_pop Effect_disability DiffPopADL_needhelp_any

order year  ADL_needhelp_any adl_ci  PopADL_needhelp_any adl_pop_ci  Effect_pop Effect_disability DiffPopADL_needhelp_any


label var  ADL_needhelp_any "Level 1 projected disability rate"
label var  adl_ci "CI"
label var  PopADL_needhelp_any "Level 1 projected population with care needs"
label var  adl_pop_ci "CI"
label var  Effect_pop "Growth attributed to population aging"
label var  Effect_disability "Growth attributed to dependency prevalence"
label var  DiffPopADL_needhelp_any "Growth in the population with care needs (Reference:2020)"

export excel using $tables\Lancet_public_health.xlsx, firstrow(varlabels) sheet(Table_A4_a, replace) 

restore


keep year  ADL_needhelp_any ul_adl ll_adl  PopADL_needhelp_any PopADL_ul PopADL_ll  Effect_pop Effect_disability DiffPopADL_needhelp_any
rename Effect_pop Effect_pop_ADL_needhelp_any
rename Effect_disability Effect_dis_ADL_needhelp_any
save  $working_data\Decom_ADL.dta, replace

**---------------------------------------------------------------------------------------
**------Figure A7 (a), (b)---------------------------------------------------------------
**---------------------------------------------------------------------------------------
clear
use  $working_data\Decom_ADL.dta
merge 1:1 year using  $working_data\Decom_ADL_Plus.dta

drop _merge
merge 1:1 year using $working_data\Decom_ADL_IADL.dta

drop _merge

replace ADL_needhelp_any = ADL_needhelp_any*100
replace ADL_plus_any = ADL_plus_any*100
replace ADL_IADL_any = ADL_IADL_any*100

replace ul_adl = ul_adl*100
replace ll_adl = ll_adl*100

replace ul_adl_plus = ul_adl_plus*100
replace ll_adl_plus = ll_adl_plus*100


replace ul_adl_iadl = ul_adl_iadl*100
replace ll_adl_iadl = ll_adl_iadl*100

twoway rarea ul_adl ll_adl year if year>=2021, color(gs14)   ||  rarea ul_adl_plus ll_adl_plus year if year>=2021, color(gs14)  ||  rarea ul_adl_iadl ll_adl_iadl year if year>=2021, color(gs14)  || line ADL_needhelp_any year if year>=2021 ,  lpattern(solid) lcolor(blue) || line ADL_plus_any year if year>=2021,  lpattern(solid) lcolor(red)   || line ADL_IADL_any year if year>=2021,  lpattern(dash) ||, ytitle("%")  legend( order(4 5 6 1 ) label(1 "Confidence Interval") label(2 "95% CI for Level-2 Dependency") label(3 "95% CI for Level-3 Dependency")  label(4 "Level-1 Dependency") label(5 "Level-2 Dependency")  label(6 "Level-3 Dependency")  size(vsmall)  row(2) ring(1)) xtitle("Year")  xlabel(2021(2)2030 2030 )  ylabel(6(2)18)
gr export $figures\Figure_A7_a.emf, replace

charls_figure2excel   $figures/Figure_A7_a.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A7_a) ///
    cell(1 8) width(500) title("Disability projection") note("Based on UN pop foreacst, assumption on independent variables and regression coeffieicnts")


twoway rarea PopADL_ul PopADL_ll year if year>=2021, color(gs14)   ||  rarea PopADL_plus_any_ul PopADL_plus_any_ll year if year>=2021, color(gs14)  ||  rarea PopADL_IADL_any_ul PopADL_IADL_any_ll year if year>=2021, color(gs14)  || line PopADL_needhelp_any year if year>=2021,  lpattern(solid) lcolor(blue) || line PopADL_plus_any year if year>=2021,  lpattern(solid) lcolor(red)  || line PopADL_IADL_any year if year>=2021,  lpattern(dash)    ||, ytitle("Million") legend( order(4 5 6 1 ) label(1 "Confidence Interval") label(2 "") label(3 "")  label(4 "Level-1 Dependency") label(5 "Level-2 Dependency")  label(6 "Level-3 Dependency")   size(vsmall)  row(2) ring(1)) xtitle("Year")  xlabel(2021(2)2030 2030)  
gr export $figures\Figure_A7_b.emf, replace

charls_figure2excel   $figures/Figure_A7_b.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A7_b) ///
    cell(30 8) width(500) title("Disability pop projection") note("Based on UN pop foreacst, assumption on independent variables and regression coeffieicnts")


**---------------------------------------------------------------------------------------
**------Figure A8 (a), (b) and (c)-------------------------------------------------------
**---------------------------------------------------------------------------------------
graph bar DiffPopADL_needhelp_any Effect_pop_ADL_needhelp_any Effect_dis_ADL_needhelp_any    ///
if year == 2021 | year == 2022 |  year == 2024 |  year == 2026 |   year == 2028 |   year == 2030 , over(year) title(Level-1 Dependency)  ///
legend( label(1 "Total Effect") label(2 "Population Effect")  label(3 "Disability Effect") size(small)  position(10))  ytitle("Million")  ///
bargap(10) blabel(bar, pos(outside)  size(vsmall) format(%9.2f))

gr export $figures\Figure_A8_a.emf, replace
charls_figure2excel   $figures/Figure_A8_a.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A8_a) ///
    cell(1 8) width(500) title("Level 1 decomposition") 

graph bar DiffPopADL_plus_any Effect_pop_ADL_plus_any Effect_dis_ADL_plus_any  ///
if year == 2021 | year == 2022 |  year == 2024 |  year == 2026 |   year == 2028 |   year == 2030 , over(year) title(Level-2 Dependency)  ///
legend( label(1 "Total Effect") label(2 "Population Effect")  label(3 "Disability Effect") size(small) position(10))  ytitle("Million")  ///
bargap(10) blabel(bar, pos(outside)  size(vsmall) format(%9.2f))

gr export $figures\Figure_A8_b.emf, replace
charls_figure2excel   $figures/Figure_A8_b.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A8_b) ///
    cell(1 8) width(500) title("Level 2 decomposition") 


graph bar DiffPopADL_IADL_any Effect_pop_ADL_IADL_any Effect_dis_ADL_IADL_any   ///
if year == 2021 | year == 2022 |  year == 2024 |  year == 2026 |   year == 2028 |   year == 2030 , over(year) title(Level-3 Dependency)  ///
legend( label(1 "Total Effect") label(2 "Population Effect")  label(3 "Disability Effect") size(small) position(10))  ytitle("Million")  ///
bargap(10) blabel(bar, pos(outside)  size(vsmall) format(%9.2f))

gr export $figures\Figure_A8_c.emf, replace
charls_figure2excel   $figures/Figure_A8_c.emf  using $tables/Lancet_public_health.xlsx, sheet(Figure_A8_c) ///
    cell(1 8) width(500) title("Level 3 decomposition") 


erase $working_data/pop_share2020_2030.dta
erase $working_data/female_share2020_2030.dta
erase $working_data/edu_share2020_2030.dta
erase $working_data/pop_total.dta

erase $working_data/diff_2020_2030.dta

erase $working_data/Decom_ADL_Plus.dta
erase $working_data/Decom_ADL_IADL.dta
erase $working_data/Decom_ADL.dta

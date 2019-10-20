use "C:\Users\khyli\OneDrive\SPIDEROECD.dta", clear
isid freq indicatorname unit location age_group sex countryname source_type time value time value Year Country, missok
unab `vlist : _all
sort `vlist'
quietly by `vlist': gen dup = cond(_N==1,0,_n)
drop if dup>0
tab dup
reshape wide h_hiv_wdi h_lowweightbabies_wdi lifeexp_f_wdi lifeexp_m_wdi, i(time) j(location) string
mvencode freq  unit indicatorname location age_group sex countryname source_type time value Year Country, mv(99999)
drop Year //no values in this variable, all the years are in variable time//
reshape wide h_hiv_wdi h_lowweightbabies_wdi lifeexp_f_wdi lifeexp_m_wdi, i(time) j(location) string
mvencode location, mv(99999)
destring, replace
mvencode time, mv(99999)
reshape wide h_hiv_wdi h_lowweightbabies_wdi lifeexp_f_wdi lifeexp_m_wdi, i(time) j(countryname) string
tab countryname, mi
mvencode countryname, mv(99999)

destring location, generate (newlo) force
tab location, mi
replace location = . if location ==""
replace location = . if location =""
replace location = . if location ==" "
replace location =. if location ""
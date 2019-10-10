use "https://docs.google.com/uc?id=1mIfqPkaYz2FJuFDw_5HjEglNE8UtbNuR&export=download", clear

sort countryname
 
append using "https://docs.google.com/uc?id=13KCmLDi7hMphxMO5yh3ciYvMKKACdWFW&export=download", keep(countrycode) force

//I used append to convert both master and using files to long// 

merge 1:1 _n using "https://docs.google.com/uc?id=13KCmLDi7hMphxMO5yh3ciYvMKKACdWFW&export=download", update force

//I merged the two datasets by countryname, which resulted in 1,320 merged observations and 511 variables total.//

sort countryname

//After sorting by countryname, the shared variable, I renamed the variables I wanted to keep, then kept only those variables. This left me with 15 variables and 61 observations (not ideal)//

rename V10 happiness

rename V7 PolImp

rename V11 healthstate

rename V47 womenworkprob

rename V57 marital

rename V9 religimp

rename V140 democimp

rename V125_00 europunimp

rename V240 sex

rename V242 age

keep countryname happiness healthstate womenworkprob marital religimp democimp europunimp sex age DISBELIEF SCEPTICISM I_NATIONALISM AUTONOMY I_WOMJOB

collapse happiness healthstate womenworkprob marital religimp democimp europunimp sex age DISBELIEF SCEPTICISM I_NATIONALISM AUTONOMY I_WOMJOB, by(countryname)

reshape wide happiness, i(healthstate womenworkprob DISBELIEF SCEPTICISM) j(countryname)

reshape long

sort countryname

//Honesty: It looks as though I made the data useless, probably collapsing wasn't useful here as it created means from categorical variables. But for practice I did it anyway. I will clean up and use different manipulations relevant to the data in subsequent PSs.//



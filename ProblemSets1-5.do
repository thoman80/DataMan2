//Galadriel Thoman//
//Problem Sets//
//Stata Version 16//

//I noticed that other students had one do-file for all the combined problem sets and that combining them was actually in the instructions for the later problem sets, so I am combining them here.//

////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////PROBLEM SET ONE////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

//For this problem set, I used Wave 6 of the World Values Survey to do a simple test of the Trust in Fairness variable and the Interest in Politics variable, to see if there is a correlation between someone's level of trust in other's inherent fairness and how interested in politics they are. I intend to use different data for subsequent problem sets, or else refine this data.//

use "https://docs.google.com/uc?id=1YYjZgzqcq7p8ORMxSS32LHg6axQAnQUm&export=download", clear
rename V56 TrustFair
//TrustFair: Do you think most people would try to take advantage of you if they got a chance, or would they try to be fair? Please show your response on this card, where 1 means that “people would try to take advantage of you,” and 10 means that “people would try to be fair”//
rename V84 PoliInt
//PoliInt: How interested would you say you are in politics?//
tab TrustFair
replace TrustFair =. if TrustFair==-2
tab PoliInt
replace PoliInt =. if PoliInt==-2
//For some reason, even though the scales for these variables are 1-10 and 1-5, respectively, there were negative values for both. I removed those from the analysis.//
summarize TrustFair PoliInt, detail
tabulate TrustFair, plot
tabulate PoliInt, plot
pwcorr TrustFair PoliInt, listwise print(5) star(5)
//This table shows that there is a statistically significant negative correlation between Trust in Fairness and Political Interest.//
ttest TrustFair == PoliInt, unpaired unequal
//This t-test table shows that there is a statistically significant difference in means between the two variables, and that the null hypothesis can be rejected.//
export excel TrustFair PoliInt using "PS1WVSExcelFormat", firstrow(variables)
export delimited TrustFair PoliInt using "PS1WVSCSVFormat", delimiter(tab) replace

                                    ///End PS1///

/////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////Problem Set Two//////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

use "https://docs.google.com/uc?id=1mIfqPkaYz2FJuFDw_5HjEglNE8UtbNuR&export=download", clear

sort countryname
 append using "https://docs.google.com/uc?id=13KCmLDi7hMphxMO5yh3ciYvMKKACdWFW&export=download", keep(countrycode) force

 //I used append to convert both master and using files to long// 

merge 1:1 _n using "https://docs.google.com/uc?id=13KCmLDi7hMphxMO5yh3ciYvMKKACdWFW&export=download", update force

//I merged the two datasets by countryname, which resulted in 1,320 merged observations and 511 variables total.//

sort countryname

//After sorting by countryname, the shared variable, I renamed the variables I wanted to keep, then kept only those variables, along with the _merge variable. This created 16 variables and 90,885 observations.//

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

keep countryname happiness healthstate womenworkprob marital religimp democimp europunimp sex age DISBELIEF SCEPTICISM I_NATIONALISM AUTONOMY I_WOMJOB _merge

//I kept these variables to potentially examine the values of happiness, subjective health, the belief that women should not work, religion, and religious belief variables, as well as feelings of nationalism and belonging to the EU, and gender differences. This needs refining.//

tab _merge
tabulate happiness democimp, chi2
collapse _merge happiness healthstate womenworkprob marital religimp democimp europunimp DISBELIEF SCEPTICISM I_NATIONALISM AUTONOMY I_WOMJOB, by(sex)

reshape wide happiness, i(healthstate womenworkprob DISBELIEF SCEPTICISM) j(countryname)
reshape long
sort countryname

//Honesty: It looks as though I made the data useless, probably collapsing wasn't useful here. But for practice I did it anyway. I will clean up and use different manipulations relevant to the data in subsequent PSs.//

										///End PS2///

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Problem Set Three////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

//I am doing a project on poverty in Botswana for another class, and I am interested in comparing the country to other countries in Africa statistically, as Botswana is known as the "African Exception" and considered an economic success. However, there are still several measures that is is lagging behind in. Using a combination of data from several global institutions, I want to examine if Botswana is statistically still improving and doing better than its neighbors on these measures that I have chosen to reflect the characteristics of growth, such as polity, corruption, HIV prevalence, and several poverty measures.//

//The first dataset was imported through the Stata command, and each other source for the subsequent datasets are in the comments between the **  **.//

use "https://docs.google.com/uc?id=1iftEgeiRwATNdqOtNqJWDoRHyg04bYyT&export=download", clear
drop empty
wbopendata, language(en - English) country() topics(11 - Poverty) indicator() long

//With this command you actually can't pick more than one indicator at a time; to get multiple indicators for all the countries you have to choose a topic and keep which ones you want. I decided to use the Poverty topic, which has multiple poverty indicators for all countries.//

rename countryname COUNTRY
rename countrycode countryname
rename en_pop_slum_ur_zs popslums
rename si_pov_dday pov190
rename si_pov_gini povgini
rename si_pov_lmic pov320
rename si_pov_nagp povlinesgap
rename si_pov_rugp rurpov
rename si_pov_urgp urbpov
rename si_pov_umic_gp pov550
rename si_pov_gaps povgap190
rename si_pov_lmic_gp povgap320
rename pov550 povgap550

keep countryname year popslums pov190 povgini pov320 povlinesgap rurpov urbpov povgap550 povgap190 povgap320

mvencode *, mv(99999)

drop if year<1995
drop if year>2015

//I am merging a World Population dataset downloaded from here: ** https://population.un.org/wpp/Download/Standard/Population/ **(first download, Total Population). I changed the country names to abreviations and kept only the years from 1995 to 2015.//

merge 1:1 countryname year using "https://docs.google.com/uc?id=1D_ZZAVjNAeqjUgypf31e3XDscl6s1xjK&export=download"

tab countryname _merge

//There were only 3700 matched observations because the main dataset (the wbopendata set) is missing countried that the dataset on disk includes.//

//I am now merging a dataset with Income Per Capita (adjusted for PPP), found at **https://www.gapminder.org/data/documentation/gd001/ **. Like the population dataset, I edited the country names to country name abreviations so that they would match with the other datasets I planned to use, and kept only the years between 1995-2015.//

merge 1:1 countryname year using "https://docs.google.com/uc?id=17HKL3exP9lFG7eZvlx5KW3goJyKR3xY2&export=download", generate(_merge2)

//There were only 3700 matches for the same reason, there are countries in the merged datasets that are not in the main dataset.//

sort countryname year

//I am now merging an OECD dataset called SPIDER, found at: **https://www.oecd.org/economy/growth/structural-policy-indicators-database-for-economic-research.htm **//

//I cleaned up the years, keeping only in the parameter of 1995-2015, and only 7 of the variables. Again, there is not a perfect match of countries, which led to a not perfect match.//

merge 1:m countryname year using "https://docs.google.com/uc?id=1hod9Y7IZ6OUN6aQC8uATU5SaiJNhfp_x&export=download", generate(_merge3)

//To clean up the data and help it match the final merge dataset, I dropped observations for all countries that were not in the dataset in disk. This took a long time and there may have been an easier way, but I couldn't think of one, so I used the Data Editor.//

drop in 1/21
drop in 85/145
drop in 85/105
drop in 127/168
drop in 337/357
drop in 379/399
drop in 379/399
drop in 442/482
drop in 526/546
drop in 547/567
drop in 757/777
drop in 778/819
drop in 862/882

drop in 925/987
drop in 925/966
drop in 967/987
drop in 1051/1092
drop in 1114/1134
drop in 1114/1134
drop in 1198/1238
drop in 1324/1344

drop in 1345/1365
drop in 1366/1386
drop in 1408/1428
drop in 1471/1512
drop in 1471/1512
drop in 1492/1575
drop in 1765/1806
drop in 1807/1827

drop in 1891/1995
drop in 1912/1953
drop in 1933/1953
drop in 1996/2037
drop in 2017/2037
drop in 2080/2100
drop in 2101/2142
drop in 2185/2205
drop in 2227/2247
drop in 2269/2288
drop in 2332/2352
drop in 2353/2373
drop in 2479/2499
drop in 2500/2520

drop in 2521/2541
drop in 2605/2645
drop in 2647/2688
drop in 2731/2793
drop in 2815/2835
drop in 2962/2982
drop in 3004/3024
drop in 3025/3066
drop in 3109/3128
drop in 3151/3171

drop in 3193/3213
drop in 3214/3255
drop in 3298/3318
drop in 3319/3402
drop in 3382/3422
drop in 3403/3422
drop in 3424/3443
drop in 3445/3465
drop in 3508/3528
drop in 3529/3570
drop in 3571/3612
drop in 3634/3653
drop in 3676/3811

//Finally, I am merging a dataset pertaining to democracy indicators. **I found this data here: https://www.v-dem.net/en/data/data-version-9/ **//

//I downloaded the Core dataset, which is very large, but I cleaned up the data and only kept a few of the variables.//

merge 1:1 countryname year using"https://docs.google.com/uc?id=1P9K8pDDo3IIh5LXt9CyOXFmAxICUst5C&export=download", generate(_merge4)

//It looks like cleaning up the data first and dropping mismatches helped this last merge match almost completely. Looking at the data after the merge it appears that there was one country's data that did not match each dataset. I'm going to drop those observations, as well as drop the _merge variables.)

drop in 3676/3696
drop _merge _merge2 _merge3 _merge4

//Now that I've done all the merges, I'll make it really simple to reshape.//

keep countryname year popslums povlinesgap rurpov urbpov
reshape wide povlinesgap popslums rurpov urbpov, i(countryname) j(year)

//And then I'll return it to long because it's much better that way.//

reshape long

//I realize that I should have cleaned up the countries in all the datasets at the beginning but I didn't realize it until I was so far along that going back would have taken hours. This is why some of merges didn't match up well, because there were countries in one dataset that weren't in the others. But I fixed that before the last merge, and it seemed to do the trick.//

                                    ///End PS3///

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Problem Set 4//////////////////////////////////////////

            									   
//I have tweaked the direction I am going with my final project to examine the interation between social attitudes and democracy indicators. I am using data that includes many different countries in several regions, in order to gauge the differences between cultures and geographic location. Some questions I am aiming to answer are: Is there a relationship between happiness or satifaction with political security?  Does political stability impact social priorities?: among others.) I am trying to find usable poverty indicator data that is workable within these other two datasets, as the world bank poverty data has multiple datapoints per year which makes Stata unhappy. Ultimately I want to add poverty indicators to examine whether poverty mediates any effect between social attitudes and political indicators.//

//To begin, I will start with the World Values Survey compiled data from all available waves and clean it up for my purposes. In order for Google to import the shareable link I had to keep only a handful of the variables to start with. I located the data here: http://www.worldvaluessurvey.org/WVSDocumentationWVL.jsp//

use "https://drive.google.com/uc?id=1g19OBqdrHBu0xkgcAeFNhuOPaJhbCV19&export=download", clear

rename S003 countryname

//In order to merge the datasets I am going to use, I have to edit the WVS dataset from spelled out country names to abbreviated country names, as is common with the other datasets.//

tostring countryname, generate(country_name)
replace country_name = "ARG" if country_name == "32"
replace country_name = "AUS" if country_name == "36"
replace country_name = "FIN" if country_name == "246"
replace country_name = "HUN" if country_name == "348"
replace country_name = "JPN" if country_name == "392"
replace country_name = "MEX" if country_name == "484"
replace country_name = "ZAF" if country_name == "710"
replace country_name = "KOR" if country_name == "410"
replace country_name = "SWE" if country_name == "752"
replace country_name = "USA" if country_name == "840"
replace country_name = "BLR" if country_name == "112"
replace country_name = "BAR" if country_name == "76"
replace country_name = "CZE" if country_name == "203"
replace country_name = "CHL" if country_name == "152"
replace country_name = "CHN" if country_name == "156"
replace country_name = "IND" if country_name == "356"
replace country_name = "NGA" if country_name == "566"
replace country_name = "POL" if country_name == "616"
replace country_name = "RUS" if country_name == "643"
replace country_name = "SVK" if country_name == "703"
replace country_name = "ESP" if country_name == "724"
replace country_name = "CHE" if country_name == "756"
replace country_name = "TUR" if country_name == "792"
replace country_name = "ALB" if country_name == "8"
replace country_name = "ARM" if country_name == "51"
replace country_name = "AZE" if country_name == "31"
replace country_name = "BGD" if country_name == "50"
replace country_name = "BIH" if country_name == "914"
replace country_name = "BGR" if country_name == "100"
replace country_name = "COL" if country_name == "170"
replace country_name = "HRV" if country_name == "191"
replace country_name = "DOM" if country_name == "214"
replace country_name = "SLV" if country_name == "222"
replace country_name = "EST" if country_name == "233"
replace country_name = "GEO" if country_name == "268"
replace country_name = "DEU" if country_name == "276"
replace country_name = "GBR" if country_name == "826"
replace country_name = "LVA" if country_name == "428"
replace country_name = "LTU" if country_name == "440"
replace country_name = "MKD" if country_name == "807"
replace country_name = "MDA" if country_name == "498"
replace country_name = "MNE" if country_name == "499"
replace country_name = "NZL" if country_name == "554"
replace country_name = "NOR" if country_name == "578"
replace country_name = "PAK" if country_name == "586"
replace country_name = "PER" if country_name == "604"
replace country_name = "PHL" if country_name == "608"
replace country_name = "PRI" if country_name == "630"
replace country_name = "ROU" if country_name == "642"
replace country_name = "SRB" if country_name == "688"
replace country_name = "SVN" if country_name == "705"
drop in 102959/103358
replace country_name = "TWN" if country_name == "158"
replace country_name = "UKR" if country_name == "804"
replace country_name = "URY" if country_name == "858"
replace country_name = "VEN" if country_name == "862"
replace country_name = "DZA" if country_name == "12"
replace country_name = "BIH" if country_name == "70"
replace country_name = "CAN" if country_name == "124"
replace country_name = "EGY" if country_name == "818"
replace country_name = "IDN" if country_name == "360"
replace country_name = "IRN" if country_name == "364"
replace country_name = "IRQ" if country_name == "368"
replace country_name = "ISR" if country_name == "376"
replace country_name = "JOR" if country_name == "400"
replace country_name = "KGZ" if country_name == "417"
replace country_name = "MAR" if country_name == "504"
replace country_name = "SAU" if country_name == "682"
replace country_name = "SGP" if country_name == "702"
replace country_name = "TZA" if country_name == "834"
replace country_name = "UGA" if country_name == "800"
replace country_name = "VNM" if country_name == "704"
replace country_name = "ZWE" if country_name == "716"
replace country_name = "AND" if country_name == "20"
replace country_name = "BFA" if country_name == "854"
replace country_name = "CYP" if country_name == "196"
replace country_name = "ETH" if country_name == "231"
replace country_name = "FRA" if country_name == "250"
replace country_name = "GHA" if country_name == "288"
replace country_name = "GTM" if country_name == "320"
replace country_name = "HKG" if country_name == "344"
replace country_name = "ITA" if country_name == "380"
replace country_name = "MYS" if country_name == "458"
replace country_name = "MLI" if country_name == "466"
replace country_name = "NLD" if country_name == "528"
replace country_name = "RWA" if country_name == "646"
replace country_name = "THA" if country_name == "764"
replace country_name = "TTO" if country_name == "780"
replace country_name = "ZMB" if country_name == "894"
replace country_name = "ECU" if country_name == "218"
replace country_name = "HTI" if country_name == "332"
replace country_name = "KAZ" if country_name == "398"
replace country_name = "KWT" if country_name == "414"
replace country_name = "LBN" if country_name == "422"
replace country_name = "LBY" if country_name == "434"
replace country_name = "PSE" if country_name == "275"
replace country_name = "QAT" if country_name == "634"
replace country_name = "TUN" if country_name == "788"
//I dropped two countries that only showed up in the last wave.//

drop in 340055/342554

rename S020 year
rename S003A countrysplit
rename A001 famimp
rename A006 religimp
rename A003 leisimp
rename A004 polimp
rename A008 feelhappy
rename A009 subjhealth
rename A010 excited
rename A007 serviceimp
rename A013 feellonely
rename A016 topofworld
rename A017 depressed
rename A020 homerelaxed
rename A024 homesecure
rename A022 homehappy
rename A165 trustmost
rename A168 takeadvantage
rename A170 lifesatisfy
rename A171 ls5yrsago
rename A173 freecontrol
rename D077 wifeobey
rename G045 toomanyimm
rename S006 respnum
rename S002 wave

sort country_name year

//Now that the data is whittled down, I can see that some of the variables I kept were not asked in most countries and years, so I am dropping them.//

drop wave
drop respnum serviceimp
drop excited feellonely topofworld homerelaxed homehappy homesecure toomanyimm

//I'm saving this cleaned dataset so I can work on the next one I want to use. The command saves to my personal desktop, but I will use a shareable link when I merge it.//
//i don't understand this, just save here


//The second dataset I am using is a world dataset with democracy indicators. I found the data here: https://www.v-dem.net/en/data/data-version-9/ (I used the Country-Year: V-Dem Core). Like above, I had to start with a selected number of variables so that Google could import a shareable link. The same goes for github- I initially tried to upload the full datasets there and got an error message that the files were too large.//

use "https://drive.google.com/uc?id=1QTWNysOsWVBX1jiALaw6GakaNzO-fmCL&export=download", clear

rename country_name countryname
rename country_text_id country_name

drop if year<1981
drop if year>2015

rename v2x_polyarchy electdemindex
rename v2x_libdem libdemindex
rename v2x_partipdem particdemindex
rename v2x_freexp_altinf freeexpindex
rename v2xel_frefair freefairelec
rename v2xcl_rol indlibertyind
rename v2elvotbuy votebuy
rename v2elintim electintim
rename v2elpeace electviolence
rename v2exrescon respectconst
rename v2exbribe execbribe
rename v2dlengage engagedsoc
rename v2clacfree freeacexp
rename v2clrelig freerelig
rename v2clkill nopolitkill
rename v2clfmove freeformove
rename v2clprptyw femproperty
rename v2mecenefm mediacensor
rename v2mecenefi internetcensor
rename v2pepwrses socclasspower
rename v2clgencl genderequal
rename v2xnp_regcorr regimecorrupt
rename v2x_civlib civillibindex
rename v2x_corr politcorruptind

//Now that it's cleaned up a bit, I can see some more variables that can be dropped due to missing data.//

drop votebuy electintim electviolence

//again and again, pls never do that:
drop in 1/35
drop in 1/35
drop in 36/70
//always drop on some condition!

//anad again just save here easier for everyone
//I'm going to switch back to the WVS data that has been cleaned.//

use "https://drive.google.com/uc?id=1rWzhhvAyc4bgMpHHW6Egd_dADRx_E08W&export=download", clear

//And then I am going to merge the WVS data with the cleaner VDem data.//

drop countryname //this variable was stored as int rather than string, and my efforts to convert it to string didn't do what I wanted, so I am dropping the variable. This is ok because I am using the abbreviated country names variable, country_name. This will allow the merge to go through without using the force option.//

merge m:1 country_name year using "https://drive.google.com/uc?id=1m9xtLKZX6NcR1qfaHVaHgVGAcM6-k1DW&export=download"

//The merge was largely successful- the unmatched observations are due to countries existing in the WVS data that are not in the VDem dataset.//

drop _merge
drop wifeobey takeadvantage
drop countryname
drop if year<1995

//With the datasets merged, I can finally start exploring the data. I will begin with descriptive statistics, and some graphs.//

summarize famimp leisimp polimp religimp feelhappy subjhealth depressed trustmost lifesatisfy ls5yrsago freecontrol electdemindex libdemindex particdemindex freefairelec indlibertyind respectconst execbribe engagedsoc freeacexp freerelig nopolitkill freeformove femproperty mediacensor internetcensor socclasspower genderequal regimecorrupt civillibindex politcorruptind, detail

//The above is a detailed summary of each of the variables.//
//Next I have correlation tables of all the variables. Looking at the output, I can see I can drop another variable.//

correlate
drop ls5yrsago depressed
correlate

//I am going to do some specific correlations with different variables.//

correlate feelhappy subjhealth engagedsoc genderequal regimecorrupt lifesatisfy //The results here are interesting, particularly the correlation between gender equality, regime corruption, and an engaged society. Also interesting to note is that feeling happy has a very low correlation with the rest of the variables.//

correlate feelhappy subjhealth lifesatisfy  freecontrol freefairelec libdemindex //Again, there are interesting results when examining correlations between happiness measures (feeling happy, subjective health state, and life satisfaction) and measures of democracy (in this case freedom of control and choice, free fair elections, and liberal democracy index). Especially interesting is that again, happiness is not correlating strongly with democracy measures.//

correlate feelhappy subjhealth lifesatisfy respectconst execbribe freerelig //Here I am interested to note that there is a moderate positive correlation between respect for the constitution and executive bribery- I would have anticipated that the incidence of bribery would lower as respect for the constitution rises.//

correlate famimp polimp religimp feelhappy subjhealth lifesatisfy //Examining some of the measures in the WVS, it is again interesting to note the less than powerful correlations between happiness and other measures.//

pcorr feelhappy freecontrol freefairelec engagedsoc femproperty socclasspower genderequal //This shows that happiness has no significant correlation with some of the democracy measures.//

drop leisimp indlibertyind freeacexp socclasspower //I am just whittling down variables here.//

//SOME GRAPHS!//

graph bar (mean) subjhealth (mean) freecontrol //well need more, just 2 bars is not interesting
graph bar (mean) feelhappy (mean) freefairelec

twoway (line subjhealth year, sort cmissing(n)) //this doesnt make sense

drop if subjhealth<0
drop if feelhappy<0
drop if genderequal<0
drop if trustmost<0
drop if freecontrol<0
drop if engagedsoc<0

//can you interpret the following? i'm not sure what is useful about them? what do we learn?
histogram subjhealth, bin(15) frequency fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Percentage) ylabel(, angle(horizontal)) xtitle(Subjective Health) title(Subjective Health, color(blue))

histogram subjhealth, bin(15) frequency fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Frequency) ylabel(, angle(horizontal)) xtitle(Subjective Health) title(Subjective Health, color(blue))

histogram feelhappy, bin(15) fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Percentage) ylabel(, angle(horizontal)) xtitle(Happiness) title(Happiness, color(blue))

histogram genderequal, bin(15) percent fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Precentage) ylabel(, angle(horizontal)) xtitle(Gender Equality) title(Gender Equality, color(blue))

histogram genderequal, bin(15) percent fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Precentage) ylabel(, angle(horizontal)) xtitle(Engaged Society) title(Engaged Society, color(blue))

kdensity feelhappy

//Let's do some t-tests with happiness and various democracy measures.//

ttest feelhappy == genderequal, unpaired unequal welch
ttest feelhappy == freerelig, unpaired unequal welch
ttest feelhappy == freefairelec, unpaired unequal
ttest feelhappy == femproperty, unpaired unequal
ttest feelhappy == freecontrol, unpaired unequal
ttest feelhappy == electdemindex, unpaired unequal
ttest feelhappy == libdemindex, unpaired
ttest feelhappy == particdemindex, unpaired
ttest feelhappy == respectconst, unpaired
ttest feelhappy == mediacensor, unpaired
ttest feelhappy == civillibindex, unpaired

//Now for some regressions.//
//what is the bottomline? what have we leanred?

regress feelhappy subjhealth, vce(robust)
estimates store m1, title(Model 1)
regress feelhappy subjhealth freefairelec, vce(robust)
estimates store m2, title(Model 2)
regress feelhappy subjhealth freefairelec engagedsoc, vce(robust)
estimates store m3, title(Model 3)
estout m1 m2 m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats (r2 df_r bic)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))


regress feelhappy trustmost, vce(robust)
estimates store m1, title(Model 1)
regress feelhappy trustmost genderequal, vce(robust)
estimates store m2, title(Model 2)
regress feelhappy trustmost genderequal regimecorrupt, vce(robust)
estimates store m3, title(Model 3)
estout m1 m2 m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats (r2 df_r bic)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))

regress feelhappy lifesatisfy, vce(robust)
estimates store m1, title(Model 1)
regress feelhappy lifesatisfy freecontrol, vce(robust)
estimates store m2, title(Model 2)
regress feelhappy lifesatisfy freecontrol freerelig, vce(robust)
estimates store m3, title(Model 3)
estout m1 m2 m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats (r2 df_r bic)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))

regress subjhealth trustmost, vce(robust)
estimates store m1, title(Model 1)
regress subjhealth trustmost freecontrol, vce(robust)
estimates store m2, title(Model 2)
regress subjhealth trustmost freecontrol year, vce(robust)
estimates store m3, title(Model 3)
estout m1 m2 m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats (r2 df_r bic)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))

/////////////////////////////////End of PS4, continuing into PS5////////////////////////////

//PS5 is a continuation of PS4.//

//I want to include two other survey datasets to examine these connections for two specific regions: Europe and Africa. To do this, I will anyalyze relevant variables from the European Social Survey Round 8 (2016) and the Afrobarometer Wave 6. Because these surveys do not ask the same questions and only have the year in common, I will not merge or amend them; instead I will compare regressions from variables that deal with the same metric as my merged dataset. I will first work on the ESS to clean it, then the Afrobarometer, then I will be able to compare the findings later.//

//European Social Survey downloaded from here: https://www.europeansocialsurvey.org/downloadwizard//
//I chose the well-being and the political variables//

use "https://drive.google.com/uc?id=1-4mfS3x-QihX376eQw_YjZnsJMTcgias&export=download", clear

rename cntry country_name
rename psppsgv govsay
rename actrolg activerole
rename actrolga activerole2
rename psppipl govinflue
rename psppipla govinflue2
rename cptppola confpolpart
rename polcmpl polcomplic
rename poldcs poldecide
rename trstprl trustparl
rename trstlgl trustlegal
rename trstplc trustpolice
rename trstprt trustpolpart
rename vote votelast
rename wrkprty workpolparty
rename wrkorg workorg
rename sgnptit signpetit
rename pbldmn particdmn
rename bctprd boycottprod
rename clsprty closeparty
rename mmbprty memberparty
rename lrscale leftright
rename stflife satislife
rename stfeco satisecon
rename stfgov satisgov
rename stfdem satisdem
rename stfedu satisedu
rename stfhlth satishealth
rename freehms gayfree
rename scnsenv scisolve
rename imueclt cultimmig
rename imwbcnt immigbetter
rename sclmeet oftensoc
rename inmdisc closedisc
rename inprdsc manyclose
rename sclact socialact
rename crmvct assaultburg
rename aesfdrk safedark
rename rlgblg belongrel
rename dscrgrp discrimgroup

keep cseqno name essround idno dweight polintr govsay activerole activerole2 govinflue govinflue2 confpolpart polcomplic poldecide trustparl trustlegal trustpolice trustpolpart votelast workpolparty workorg badge signpetit particdmn boycottprod closeparty memberparty leftright satislife satisecon satisdem satisgov satisedu satishealth gincdif gayfree prtyban scisolve cultimmig immigbetter happy oftensoc closedisc manyclose socialact assaultburg safedark health belongrel discrimgroup

//There are still too many variables, so I have to whittle them down more.//

keep cseqno name essround idno dweight polintr govsay govinflue trustparl trustlegal votelast badge signpetit particdmn boycottprod leftright satisecon satisgov satisgov gayfree happy oftensoc closedisc socialact health manyclose discrimgroup

//This leaves about 10 political measures and 10 well-being measures.//

svyset _n, weight(dweight)
local politico polintr govsay govinflue votelast

sum `politico'

//Macros and Loops//

local politics polintr votelast leftright


foreach var of local politics{
         replace `var'= . if `var'==.a
         }


sum `politics'
local polpart votelast badge signpetit particdmn boycottprod
sum `polpart'
local swb happy oftensoc manyclose socialact health
sum `swb'

levelsof polintr, local(pollevs)

foreach v of varlist polintr votelast leftright{
	reg happy `v'
		reg health `v'
}

	
foreach var of local politics {
	histogram `var'
	}

foreach var of local swb {
	histogram `var'
	}
	
set trace off 

svy: reg `politics'
svy: reg `swb'

svy: regress happy health
estimates store m1, title(Model 1)
svy: regress happy health polintr
estimates store m2, title(Model 2)
svy: regress happy health polintr leftright
estimates store m3, title(Model 3)
estout m1 m2 m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats (r2 df_r bic)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))


local graphs "happy votelast polintr"
local lilgraphs "votelast polintr"

// var labels
label var happy     "Level of Happiness"
label var polintr    "Interest in Politics"
label var votelast   "Voted in Last Election"
label var leftright    "Position on Political Scale"
label var health        "Subjective General Health"
label var socialact    "Social Activity"
label var manyclose  "Close Friends"
label var gayfree  "Gays and Lesbians Free"

graph bar `politics'
graph bar `swb'
graph bar happy health gayfree
graph bar, over(happy) ytitle(Frequency)


//I will add more regressions and statistical tests as well as analysis later, as well as include the Afrobarometer dataset (I ran out of time to include it in this). This is just what I have so far.//




//i dont see branching or nested loops
//and in general seems like much code and output doesnt serve any purpose, we run a bunch of stuff but so what? why do we do that?
//what did we learn?











































































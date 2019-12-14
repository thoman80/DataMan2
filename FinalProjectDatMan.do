//Galadriel Thoman//
//Problem Set 6//
//Stata Version 16//

//The final project starts with PS3.//

//****I took out the python part so it can be a separate file. But as a note, I had asked you if I could put it in the do-file because you can run python directly from Stata- I even put the command to switch to and off python in the code. You told me to go ahead and put the python code in the do-file for that reason. But if it makes it easier, a separate python file is on my github.****///

//At first, I was interested in examing Africa and Botswana and comparing the economic factors that made the country unique. As it kept going it seemed less possible given the data that was accessible. There are large gaps in data in Africa, probably just because it's difficult to reach people in some areas. Unfortunately, this created a bit of a problem so I moved on to another topic in Problem Set 4.//

//My ultimate research interest is in examining the interation between social attitudes and democracy indicators outside of the US (meaning a subset of countries in all other regions but our half of North America.) I am just looking at comparisons and the data for the purposes of probing the data, rather than to test any specific hypotheses. It could be interesting to delve deeper if the data shows promising connections, but for now I am only wanting to see if the relationships exist. It would also be interesting to add the US to this data, but that would be a larger project I may not have time for. I am using data that includes many different countries in several regions, in order to gauge the differences between cultures and geographic location. Some questions I am aiming to answer are://

//1. Is there a relationship between well-being indicators and political security?//
	//Although I am not testing hypotheses, I believe that there will be a positive correlation between these two variables, in that people who feel more secure politically will also show higher levels of well-being (of course, there are several possible confounding or mediating variables that are not being tested here.)//
//2. Does political stability impact social priorities?//
	//Again, I believe that the results will show that when people live in a politically stable country, they have more energy for other social priorities that don't involve politics.//
//3. Does equality or lack thereof correlate with voting behavior or political interest?//
	//I hypothesize that those who are vulnerable to lack of equality would either be more interested in voting or politics if they feel they are able to make a difference in their country by voting; however, the feeling of apathy or powerlessness could make it less likely for those people to vote. Otherwise, there may be too many variables that would mediate an effect between high levels of equality and voting behavior. Since the data doesn't involve variables of sex, race, or orientation, I am not able to test the connection on a direct level.//
	

///////////////////////DATA CLEANING/////////////////////////

///////////////////PROBLEM SET 3/////////////////////////////


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

//Finally, I am merging a dataset pertaining to democracy indicators. **I found this data here: https://www.v-dem.net/en/data/data-version-9/ **//

//I downloaded the Core dataset, which is very large, but I cleaned up the data and only kept a few of the variables.//

merge 1:1 countryname year using"https://docs.google.com/uc?id=1P9K8pDDo3IIh5LXt9CyOXFmAxICUst5C&export=download", generate(_merge4)

//The merge was not clean because the master dataset had countries the using did not. So I am dropping the non-merged observations, as recommended. Then I will drop the merge variables.//

drop if _merge4==1

drop _merge _merge2 _merge3 _merge4

//Now that I've done all the merges, I'll make it really simple to reshape.//

keep countryname year popslums povlinesgap rurpov urbpov
reshape wide povlinesgap popslums rurpov urbpov, i(countryname) j(year)

//And then I'll return it to long because it's much better that way.//

reshape long

save PS3Cleaned, replace

//I realize that I should have cleaned up the countries in all the datasets at the beginning but I didn't realize it until I was so far along that going back would have taken hours. This is why some of merges didn't match up well, because there were countries in one dataset that weren't in the others. But I fixed that before the last merge, and it seemed to do the trick.//

                                    ///End PS3///


						///////////////PROBLEM SET 4///////////////
      									   
//This begins the research I ultimately landed on.//

//To begin, I will start with the World Values Survey compiled data from all available waves and clean it up for my purposes. In order for Google (or github for that matter) to import the shareable link I had to keep only a handful of the variables to start with. I located the data here: http://www.worldvaluessurvey.org/WVSDocumentationWVL.jsp//

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

// Time to rename everything!//

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

keep S001 wave countryname country_name countrysplit respnum year famimp polimp religimp feelhappy subjhealth lifesatisfy freecontrol

save WVSClean, replace

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

keep countryname country_name country_id year electdemindex libdemindex particdemindex freeexpindex freefairelec indlibertyind respectconst execbribe engagedsoc freeacexp freerelig nopolitkill freeformove femproperty mediacensor socclasspower genderequal regimecorrupt civillibindex politcorruptind

save VDemCleaner, replace

//I'm going to switch back to the WVS data that has been cleaned.//

use "https://drive.google.com/uc?id=1rWzhhvAyc4bgMpHHW6Egd_dADRx_E08W&export=download", clear

//And then I am going to merge the WVS data with the cleaner VDem data.//

drop countryname //this variable was stored as int rather than string, and my efforts to convert it to string didn't do what I wanted, so I am dropping the variable. This is ok because I am using the abbreviated country names variable, country_name. This will allow the merge to go through without using the force option.//

merge m:1 country_name year using "https://drive.google.com/uc?id=1m9xtLKZX6NcR1qfaHVaHgVGAcM6-k1DW&export=download"

//The merge was largely successful- the unmatched observations are due to countries existing in the WVS data that are not in the VDem dataset.//
//I'm whittling down the variables now.//

keep country_name countrysplit year famimp polimp religimp feelhappy subjhealth lifesatisfy freecontrol freefairelec engagedsoc freeacexp mediacensor femproperty genderequal regimecorrupt politcorruptind

drop if year<1995

save WVSVDemMerge, replace

//Now I am adding world population data, then merging it to the WVS and VDem data.//

use "https://docs.google.com/uc?id=1D_ZZAVjNAeqjUgypf31e3XDscl6s1xjK&export=download", clear

rename countryname country_name

save FixedWorldPop, replace

use "https://drive.google.com/uc?id=1VeyVAO9ynS-LrkVjJQhYiMWJ-Tyfv5f0&export=download", clear

merge m:1 country_name year using "https://docs.google.com/uc?id=1LiupapBEw6gE3Dg5AZwWnWnk96eWXLVt&export=download"

drop if year<1998
drop if year<2012

//Again, due to discrepancies in countries between the datasets, this was not a perfect merge.//

save WVSVDemWorldPopMerge, replace 

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

keep cseqno name essround idno dweight polintr trustparl trustlegal votelast badge signpetit particdmn boycottprod leftright satisecon satisgov satisgov gayfree happy oftensoc socialact health manyclose discrimgroup

local politico polintr votelast badge

sum `politico'

//Macros and Loops//

local politics polintr votelast leftright


foreach var of local politics{
         replace `var'= . if `var'==.a
         }

save ESSClean, replace

//Now to clean the Afrobaromter data, which is found here: http://afrobarometer.org/data/merged-round-6-data-36-countries-2016. In order for it to be able to be imported to Stata over the web with a shareable link, I had to reduce the file size.//

use "https://drive.google.com/uc?id=1irvJ6GcXDWBEGfB3Lx8-E3P_HWPpt1h7&export=download", clear

//Whitling down some more variables before renaming.//

keep respno country COUNTRY_BY_REGION region urbrur EA_FAC_B EA_FAC_D Q3 Q4A Q4B Q5 Q6 Q7 Q8A Q8B Q12E Q13 Q14 Q15A Q15B Q15C Q21 Q22 Q23A Q23B Q23C Q23D Q26A Q26B Q26C Q26D Q27E Q30 Q40 Q41 Q48A Q48B Q48C Q48D Q48E Q48F Q52A Q52B Q52C Q52E Q53A Q53B Q53C Q54 Q55C Q76 Q89A Q89B Q89C Q89D Q89E Q95 West_Africa_only East_Africa_only Southern_Africa_only North_Africa_only Central_Africa_only



rename country countryname
rename COUNTRY_BY_REGION countryregion
rename EA_FAC_B school
rename EA_FAC_D healthclinic
rename Q3 directcountry
rename Q4A presentcond
rename presentcond presentecon
rename Q4B livingcond
rename Q5 livcondvsothers
rename Q8A withoutfood
rename Q8B withoutwater
rename Q15A freethink
rename Q15B freejoin
rename Q15C freevote
rename Q21 recentvote
rename Q22 freefairelec
rename Q26B citavoidcrit
rename Q27E attendrally
rename Q30 supportdem
rename Q41 satisdem
rename Q52A trustpres
rename Q52B trustparl
rename Q54 levcorrupt
rename Q55C diffmedtreat
rename Q76 freevslimitmove

keep respno countryname countryregion urbrur region school healthclinic directcountry presentecon livingcond livcondvsothers withoutfood withoutwater freethink freejoin freevote recentvote freefairelec citavoidcrit attendrally supportdem satisdem trustpres trustparl levcorrupt diffmedtreat freevslimitmove

save AfrobaromClean, replace

/////GRAPHING///////

//First set of datasets first.//

use "https://docs.google.com/uc?id=1ljuhmpTe0glL0OMFl_CQi6qWfdV9nQlv&export=download", clear

drop _merge
drop if subjhealth<0
drop if feelhappy<0
drop if genderequal<0
drop if freecontrol<0
drop if engagedsoc<0
drop if polimp<0


twoway (connected subjhealth year, sort), ytitle(Subjective Health) xtitle(Year) title(Subjective Health Over Time)
//I'm not sure why the graph looks like this, but it appears that because there are so many country data points over time, it's muddy. However, as one might expect, subjective health has gone up and down over time.//
twoway (line subjhealth year in 25598/28588, sort), ytitle(Subjective Health) xtitle(Year) title(Subjective Health Over Time China)
//Looks like subjective health has gone down slightly, but the data ends at 2007, so it's not clear.//

graph hbar (mean) subjhealth (mean) lifesatisfy (mean) freecontrol, over(year) nofill cw ylabel(, angle(forty_five)) ymtick(, angle(forty_five))
//This graph is interesting because it looks like subjective health has stayed relatively low and even over time, whereas both life satisfaction and feeling you have freedom of choice has dipped and risen sharply over the period of 35 years. I would have expected life satisfaction and health to be closer to each other. Otherwise, I expected to see the dips and high points as everyone has high points and low points, depending on life experiences and what is going on at that time in their country.//

graph dot (mean) feelhappy (mean) subjhealth (mean) genderequal, over(year) nofill cw ylabel(, angle(forty_five)) ymtick(, angle(forty_five))
//This shows mean gender equality levels being lower than the means of happiness and health over time.//

histogram subjhealth, bin(15) frequency fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Percentage) ylabel(, angle(horizontal)) xtitle(Subjective Health) title(Subjective Health, color(blue))

histogram subjhealth, bin(15) frequency fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Frequency) ylabel(, angle(horizontal)) xtitle(Subjective Health) title(Subjective Health, color(blue))

histogram feelhappy, bin(15) fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Percentage) ylabel(, angle(horizontal)) xtitle(Happiness) title(Happiness, color(blue))

histogram genderequal, bin(15) percent fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Precentage) ylabel(, angle(horizontal)) xtitle(Gender Equality) title(Gender Equality, color(blue))

histogram genderequal, bin(15) percent fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Precentage) ylabel(, angle(horizontal)) xtitle(Engaged Society) title(Engaged Society, color(blue))


//Graphs for ESS Data//

use "https://drive.google.com/uc?id=1UHWAxLwYJIJaT57sStFb0_pNOrS91Zb4&export=download", clear

// var labels

label var happy     "Level of Happiness"
label var polintr    "Interest in Politics"
label var votelast   "Voted in Last Election"
label var leftright    "Position on Political Scale"
label var health        "Subjective General Health"
label var socialact    "Social Activity"
label var manyclose  "Close Friends"
label var gayfree  "Gays and Lesbians Free"

local politics polintr trustparl satisgov leftright
sum `politics'
local polpart votelast badge signpetit particdmn boycottprod
sum `polpart'
local swb happy oftensoc manyclose socialact health
sum `swb'

foreach var of local politics {
	histogram `var'
	}

foreach var of local swb {
	histogram `var'
	}
	
histogram polintr, discrete percent ytitle(Political Interest) ylabel(, angle(forty_five)) ymtick(, angle(forty_five)) xlabel(, angle(forty_five)) xmtick(, angle(forty_five))

//This shows percentages of political interest on a scale of 1-4: 1 being Very Interested and 4 being Not Interested at All.  As might be expected, Europe falls within a fairly even distribution of most people being in the middle, with the extremes on either end. However, there is a larger percentage of people who have no interest at all in politics than those who are very interested.//

//I installed catplot in order to create better graphs of the categorical data.//

catplot votelast
//This is promising, although it is to be expected since voting levels are much higher in Europe than in the US.//
catplot polintr
catplot signpetit
//As might be expected, many more people did not sign petitions than did.//
catplot leftright
catplot gayfree
//This chart is very positive to see. Those who approve strongly or approve of LGBTQ+ are much higher than those who don't.//
catplot satisecon
//This chart also shows a fairly even distribution of economic satisfaction.//
catplot badge
catplot trustlegal
catplot boycottprod

////Graphs for Afrobarometer 6///

use "https://drive.google.com/uc?id=1OZw3t6ou50TeuPaVpoTM1QbHpCtV9038&export=download", clear

//I am installing some user-written packages to be better able to work with categorical data. I wish I had known about this in Quant 2!//

ssc install tabplot
ssc install catgraph
ssc install dummieslab
ssc install fbar
ssc install pieplot
ssc install summtab
ssc install ttestplus

tabplot recentvote, xlabel (, angle (45))
tabplot livcondvsothers, xlabel (, angle (45))
tabplot withoutfood, xlabel (, angle (45))
tabplot withoutwater xlabel (, angle (45))
tabplot freevote xlabel (, angle (45))

pieplot urbrur
pieplot livingcond
pieplot urbrur livingcond, sum plabelsubopts(size(*2)) pie(1, color(red*2)) pie(2, color(red)) pie(3, color(red*0.7)) pie(4, color(red*0.5)) pie(5,color(red*0.3)) legend(row(1))
//While messy, this pie chart of living conditions is interesting, because rural citizens reported both lower AND higher levels of satisfaction with their living conditions.//

fbar livingcond, by(school)
//This chart reflects perceived living conditions by whether or not the area has a school. This chart makes it appear that there is little impact from having a school on your living conditions. Perhaps that is only because there are so many other variables that would explain how one feels about their living conditions.//

catplot livingcond
catplot freevote
catplot livcondvsothers
catplot levcorrupt
//This graph shows that the sentiment in Africa is that corruption has increased overall. This is somewhat surprising given that the graph on free voting indicates the people of Africa feel that they can vote freely for whomever they want.//


//////STATISTICAL TESTS//////////

//Afrobarometer Tests//

by countryname, sort : summarize livingcond livcondvsothers freethink freevote

tabulate urbrur livingcond, cchi2 chi2
//Unsurprisingly, where you live impacts your perception of your living conditions.//

tabulate freevote livingcond, cchi2 chi2
tab2 urbrur school healthclinic directcountry  presentecon  livingcond withoutfood withoutwater freethink, chi2

drop if school>1

ttestplus livingcond livcondvsothers, by(school)
//This test actually confirms the graph above regarding living conditions and school presence. The p-value for both living conditions and living conditions compared to others (relative deprivation) against both schools being available or not available are not significant. This is again a very surprising result, but it's good to confirm the graph.//

drop if healthclinic>1
ttestplus livingcond livcondvsothers, by(healthclinic)

mlogit livingcond urbrur countryname, vce(robust) cformat(%9.2f) pformat(%5.2f) sformat(%8.2f)
mprobit livingcond withoutfood withoutwater, vce(robust) cformat(%9.2f) pformat(%5.2f) sformat(%8.2f)

//ESS Statistical Tests//

use "https://drive.google.com/uc?id=1UHWAxLwYJIJaT57sStFb0_pNOrS91Zb4&export=download", clear

foreach v of varlist polintr votelast leftright{
	reg happy `v'
		reg health `v'
}

tab2 polintr trustlegal votelast, chi2
mvtest correlations polintr votelast happy
ttest trustparl == votelast, unpaired unequal
ttest happy == gayfree, unpaired unequal

regress happy health
estimates store m1, title(Model 1)
regress happy health polintr
estimates store m2, title(Model 2)
regress happy health polint leftright
estimates store m3, title(Model 3)
estout m1 m2 m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats (r2 df_r bic)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))

local graphs "happy votelast polintr"
local lilgraphs "votelast polintr"

regress `graphs'

////Democracy Indicators Dat//

use "https://docs.google.com/uc?id=1ljuhmpTe0glL0OMFl_CQi6qWfdV9nQlv&export=download", clear

summarize
correlate
correlate

//I am going to do some specific correlations with different variables.//

correlate feelhappy subjhealth engagedsoc genderequal regimecorrupt lifesatisfy //The results here are interesting, particularly the correlation between gender equality, regime corruption, and an engaged society. Also interesting to note is that feeling happy has a very low correlation with the rest of the variables.//

correlate feelhappy subjhealth lifesatisfy  freecontrol freefairelec //Again, there are interesting results when examining correlations between happiness measures (feeling happy, subjective health state, and life satisfaction) and measures of democracy (in this case freedom of control and choice, free fair elections, and liberal democracy index). Especially interesting is that again, happiness is not correlating strongly with democracy measures.//

correlate feelhappy subjhealth lifesatisfy freefairelec genderequal //Here I am interested to note that there is a moderate positive correlation between respect for the constitution and executive bribery- I would have anticipated that the incidence of bribery would lower as respect for the constitution rises.//

correlate famimp polimp religimp feelhappy subjhealth lifesatisfy //Examining some of the measures in the WVS, it is again interesting to note the less than powerful correlations between happiness and other measures.//

pcorr feelhappy freecontrol freefairelec engagedsoc femproperty genderequal //This shows that happiness has no significant correlation with some of the democracy measures.//


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
regress feelhappy lifesatisfy freecontrol freefairelec, vce(robust)
estimates store m3, title(Model 3)
estout m1 m2 m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats (r2 df_r bic)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))

regress subjhealth lifesatisfy, vce(robust)
estimates store m1, title(Model 1)
regress subjhealth lifesatisfy freecontrol, vce(robust)
estimates store m2, title(Model 2)
regress subjhealth lifesatisfy freecontrol year, vce(robust)
estimates store m3, title(Model 3)
estout m1 m2 m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats (r2 df_r bic)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant)stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))



///END//
//Python file in github, to be included for extra credit.//



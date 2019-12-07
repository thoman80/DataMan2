/*
there's progress, but still some more work to be done
python does help but
don't put python code in dofile!!!it must be separate .py file
reorganize stuff in dofile eg labels must come before graphs and regressions!
do make sure it is all cofrect! any misakes would be a major problem for final project, and do ask questions if in doubt!
need research questions and hypotheses at the beginning!!! and then need to interpret descriptive and inferential stats with those in mind and circle back and provide thorough research interpretation, not just say what the stats shows
pls do take into account comments i made in class
*/
//Galadriel Thoman//
//Problem Set 6//
//Stata Version 16//

//This rough draft starts with Problem Set 3. I deleted 1 and 2 for efficiency.//

//I have put three sections of Python code at the end of the do-file. I used the suggested command to import python into Stata, but if for some reason it doesn't work, just cut and paste. Also, I included install commands for all of the modules used like you asked, but if you run a chunk with already installed modules, Python yells at you and says it's not in the proper syntax. It is, it's just already installed so it won't do it again.//

/////////////////////////////////////////////////////////DATA CLEANING SECTION///////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////PROBLEM 3////////////////////////////////////////////////////////////////////////////////////

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

//To clean up the data and help it match the final merge dataset, I dropped observations for all countries that were not in the dataset in disk. This took a long time and there may have been an easier way, but I couldn't think of one, so I used the Data Editor. I know you said to always drop by condition but in this case that really isn't possible.//

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

//////////////////////////////////////////////////////////////////////////Problem Set 4//////////////////////////////////////////////////////////////////

            									   
//I have tweaked the direction I am going with my final project to examine the interation between social attitudes and democracy indicators outside of the US (meaning a subset of countries in all other regions but our half of North America.) It would be interesting to add the US to this data, but that would be a larger project I may not have time for. I am using data that includes many different countries in several regions, in order to gauge the differences between cultures and geographic location. Some questions I am aiming to answer are://

//Is there a relationship between well-being indicators and political security?//
//Does political stability impact social priorities?//
//Does equality or lack thereof correlate with voting behavior or political interest?//

//I have been searching for poverty data that will is mergeable or useable but I haven't been able to yet. I will continue to search and add these indicators to the final project.//

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

save VDemCleaner

//I'm going to switch back to the WVS data that has been cleaned.//

use "https://drive.google.com/uc?id=1rWzhhvAyc4bgMpHHW6Egd_dADRx_E08W&export=download", clear

//And then I am going to merge the WVS data with the cleaner VDem data.//

drop countryname //this variable was stored as int rather than string, and my efforts to convert it to string didn't do what I wanted, so I am dropping the variable. This is ok because I am using the abbreviated country names variable, country_name. This will allow the merge to go through without using the force option.//

merge m:1 country_name year using "https://drive.google.com/uc?id=1m9xtLKZX6NcR1qfaHVaHgVGAcM6-k1DW&export=download"

//The merge was largely successful- the unmatched observations are due to countries existing in the WVS data that are not in the VDem dataset.//
//I'm whittling down the variables now.//

keep country_name countrysplit year famimp polimp religimp feelhappy subjhealth lifesatisfy freecontrol freefairelec engagedsoc freeacexp mediacensor femproperty genderequalregimecorrupt politcorruptind
drop if year<1995

save WVSVDemMerge

//Now I am adding world population data, then merging it to the WVS and VDem data.//

use "https://docs.google.com/uc?id=1D_ZZAVjNAeqjUgypf31e3XDscl6s1xjK&export=download", clear

rename countryname country_name

save FixedWorldPop

use "https://drive.google.com/uc?id=1VeyVAO9ynS-LrkVjJQhYiMWJ-Tyfv5f0&export=download", clear

merge m:1 country_name year using "https://docs.google.com/uc?id=1LiupapBEw6gE3Dg5AZwWnWnk96eWXLVt&export=download"

drop if year<1998
drop if year<2012

//Again, due to discrepancies in countries between the datasets, this was not a perfect merge.//

save WVSVDemWorldPopMerge


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

local politico polintr govsay votelast

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

///////////////////////////////////////////////////////////////////GRAPHING SECTION///////////////////////////////////////////////////////////////////////

//First set of datasets first.//

use "https://docs.google.com/uc?id=1ljuhmpTe0glL0OMFl_CQi6qWfdV9nQlv&export=download", clear

drop _merge2
drop if subjhealth<0
drop if feelhappy<0
drop if genderequal<0
drop if freecontrol<0
drop if engagedsoc<0

drop in 216108/218950 //These are lines from the dataset that were empty that I removed using the Data Editor. I thought if I left them in it would confuse the data.//

svyset, _n //Ostensibly setting the data to survey data, although I'm not entirely sure if it worked.//

//I WILL BE ADDING ANALYSIS OF BOTH THE GRAPHS AND STATISTICAL TESTS IN THE FINAL PROJECT.///

twoway (connected subjhealth year, sort), ytitle(Subjective Health) xtitle(Year) title(Subjective Health Over Time)
twoway (line subjhealth year in 25598/28588, sort), ytitle(Subjective Health) xtitle(Year) title(Subjective Health Over Time China)
graph bar (mean) feelhappy (mean) subjhealth (mean) lifesatisfy, over(year) ytitle(Frequency)
graph bar (mean) freecontrol (mean) freefairelec (mean) polimp, over(year) ytitle(Frequency)


histogram subjhealth, bin(15) frequency fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Percentage) ylabel(, angle(horizontal)) xtitle(Subjective Health) title(Subjective Health, color(blue))

histogram subjhealth, bin(15) frequency fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Frequency) ylabel(, angle(horizontal)) xtitle(Subjective Health) title(Subjective Health, color(blue))

histogram feelhappy, bin(15) fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Percentage) ylabel(, angle(horizontal)) xtitle(Happiness) title(Happiness, color(blue))

histogram genderequal, bin(15) percent fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Precentage) ylabel(, angle(horizontal)) xtitle(Gender Equality) title(Gender Equality, color(blue))

histogram genderequal, bin(15) percent fcolor(ltbluishgray) addlabel addlabopts(mlabsize(medsmall) mlabcolor(midblue) mlabangle(horizontal)) ytitle(Precentage) ylabel(, angle(horizontal)) xtitle(Engaged Society) title(Engaged Society, color(blue))




//More to be added//


//Commands for ESS data to be organized and added later: (I had this in another section but I need to organize it for the graphs and stats tests sections)//
//sum `politics'//
//local polpart votelast badge signpetit particdmn boycottprod//
//sum `polpart'//
//local swb happy oftensoc manyclose socialact health//
//sum `swb'//

//levelsof polintr, local(pollevs)//

//foreach v of varlist polintr votelast leftright{
	reg happy `v'
		reg health `v'
}//

//foreach var of local politics {
	histogram `var'
	}//

//foreach var of local swb {
	histogram `var'
	}//
	



//////////////////////////////////////////////////////STATISTICAL TESTS SECTION///////////////////////////////////////////////////////////////////////

//Will be analyzed for final project.//

summarize famimp leisimp polimp religimp feelhappy subjhealth depressed trustmost lifesatisfy ls5yrsago freecontrol electdemindex libdemindex particdemindex freefairelec indlibertyind respectconst execbribe engagedsoc freeacexp freerelig nopolitkill freeformove femproperty mediacensor internetcensor socclasspower genderequal regimecorrupt civillibindex politcorruptind, detail

//The above is a detailed summary of each of the variables.//
//Next I have correlation tables of all the variables. Looking at the output, I can see I can drop another variable.//

correlate
drop ls5yrsago depressed
correlate

//I am going to do some specific correlations with different variables.//

correlate feelhappy subjhealth engagedsoc genderequal regimecorrupt lifesatisfy //The results here are interesting, particularly the correlation between gender equality, regime corruption, and an engaged society. Also interesting to note is that feeling happy has a very low correlation with the rest of the variables.//

correlate feelhappy subjhealth lifesatisfy  freecontrol freefairelec libdemindex //Again, there are interesting results when examining correlations between happiness measures (feeling happy, subjective health state, and life satisfaction) and measures of democracy (in this case freedom of control and choice, free fair elections, and liberal democracy index). Especially interesting is that again, happiness is not correlating strongly with democracy measures.//
TODO

correlate feelhappy subjhealth lifesatisfy respectconst execbribe freerelig //Here I am interested to note that there is a moderate positive correlation between respect for the constitution and executive bribery- I would have anticipated that the incidence of bribery would lower as respect for the constitution rises.//

correlate famimp polimp religimp feelhappy subjhealth lifesatisfy //Examining some of the measures in the WVS, it is again interesting to note the less than powerful correlations between happiness and other measures.//

pcorr feelhappy freecontrol freefairelec engagedsoc femproperty socclasspower genderequal //This shows that happiness has no significant correlation with some of the democracy measures.//

drop leisimp indlibertyind freeacexp socclasspower //I am just whittling down variables here.//


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


/////////////////////////////////////////////////////////////////////////////PYTHON SECTION//////////////////////////////////////////////////////////////

//As an addition to the final project I decided to do some things in Python. I wanted to examine sentiment and opinions from Twitter. To do this I applied for and was approved for a Twitter Developer API, which allowed me to mine and scrape data from Twitter using my model. I am not done adding to this part, but I am including what I have so far. I lost many many hours in trial and error! To call Python into Stata, you just use the python command and set an end point to stop. This first section is an api that finds common words in the grabbed tweets using Putin as a search term.//

python

Spyder Editor

pip install tweepy
pip install seaborn
pip install pandas
pip install itertools
pip install matplotlib.pyplot 
pip install nltk

import matplotlib.pyplot as plt

import os
import seaborn as sns

import itertools
import pandas as pd
import collections
import nltk
from nltk.corpus import stopwords
import re
import networkx

import warnings

# The following is my Twitter Developer credentials, which are used to authorize my app.#

consumer_key= 'Xr9VwmlPNLT2NivIMWUPPYysT'
consumer_secret= 'SaI9MpQkArKRU4W9KQBG3gpojporZihUQkpJcCa46G11gzsWD1'
access_token= '286826733-tQpQY605CrxvFQr8DKp4nvEcIdnXBhsSTaiGIELm'
access_token_secret= 'oNL954A1GiJAu8SaNBw9axSQiPky3cY60l4AIYSBLaOyy'


auth = tweepy.OAuthHandler("Xr9VwmlPNLT2NivIMWUPPYysT", "SaI9MpQkArKRU4W9KQBG3gpojporZihUQkpJcCa46G11gzsWD1")
auth.set_access_token("286826733-tQpQY605CrxvFQr8DKp4nvEcIdnXBhsSTaiGIELm", "oNL954A1GiJAu8SaNBw9axSQiPky3cY60l4AIYSBLaOyy")

# This sets how the api works, and tells it to wait when it reaches the rate limit of Twitter instead of ending the program#

api = tweepy.API(auth, wait_on_rate_limit=True,
    wait_on_rate_limit_notify=True)

# The following is the search terms and the start date. I decided to search Putin. #

search_words = "#Putin"
date_since = "2016-11-08"

tweets = tweepy.Cursor(api.search,
              q=search_words,
              lang="en",
              since=date_since).items(250)
tweets

tweets = tweepy.Cursor(api.search,
              q=search_words,
              lang="en",
              since=date_since).items(25)
tweets

# Collect tweets

tweets = tweepy.Cursor(api.search,
                       q=search_words,
                       lang="en",
                       since=date_since).items(5)

# Collect a list of tweets
[tweet.text for tweet in tweets]

new_search = "Putin +  -filter:retweets"
new_search

tweets = tweepy.Cursor(api.search,
                       q=new_search,
                       lang="en",
                       since=date_since).items(25)

[tweet.text for tweet in tweets]

tweets = tweepy.Cursor(api.search, 
                           q=new_search,
                           lang="en",
                           since=date_since).items(25)

users_locs = [[tweet.user.screen_name, tweet.user.location] for tweet in tweets]
users_locs

import pandas

tweet_text = pandas.DataFrame(data=users_locs, 
                    columns=['user', "location"])
tweet_text

import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import itertools
import collections

import tweepy as tw
import nltk
from nltk.corpus import stopwords
import re
import networkx

import warnings
warnings.filterwarnings("ignore")

sns.set(font_scale=1.5)
sns.set_style("whitegrid")

search_term = "#Putin -filter:retweets"

tweets = tw.Cursor(api.search,
                   q=search_term,
                   lang="en",
                   since='2016-11-08').items(1000)

all_tweets = [tweet.text for tweet in tweets]

all_tweets[:250]

# This removes any urls from the grabbed tweets. #

def remove_url(txt):
    
    return " ".join(re.sub("([^0-9A-Za-z \t])|(\w+:\/\/\S+)", "", txt).split())

all_tweets_no_urls = [remove_url(tweet) for tweet in all_tweets]
all_tweets_no_urls[:250]

#This will make all elements in the list lowercase #

all_tweets_no_urls[0].lower().split()

words_in_tweet = [tweet.lower().split() for tweet in all_tweets_no_urls]
words_in_tweet[:2]

# List of all words across tweets #
all_words_no_urls = list(itertools.chain(*words_in_tweet))

# This creates a counter.# 
counts_no_urls = collections.Counter(all_words_no_urls)

counts_no_urls.most_common(15)

#This puts the data in a dataframe, using pandas.#

clean_tweets_no_urls = pd.DataFrame(counts_no_urls.most_common(15),
                             columns=['words', 'count'])

clean_tweets_no_urls.head()

fig, ax = plt.subplots(figsize=(8, 8))

# Plot horizontal bar graph
clean_tweets_no_urls.sort_values(by='count').plot.barh(x='words',
                      y='count',
                      ax=ax,
                      color="purple")

ax.set_title("Common Words Found in Tweets (Including All Words)")

plt.show()

nltk.download('stopwords')
stop_words = set(stopwords.words('english'))

# View a few words from the set
list(stop_words)[0:10]
words_in_tweet[0]
tweets_nsw = [[word for word in tweet_words if not word in stop_words]
              for tweet_words in words_in_tweet]

tweets_nsw[0]

all_words_nsw = list(itertools.chain(*tweets_nsw))

counts_nsw = collections.Counter(all_words_nsw)

counts_nsw.most_common(15)

clean_tweets_nsw = pd.DataFrame(counts_nsw.most_common(15),
                             columns=['words', 'count'])

fig, ax = plt.subplots(figsize=(8, 8))

# Plot horizontal bar graph #

clean_tweets_nsw.sort_values(by='count').plot.barh(x='words',
                      y='count',
                      ax=ax,
                      color="purple")

ax.set_title("Common Words Found in Tweets (Without Stop Words)")

plt.show()

collection_words = ['putin']

tweets_nsw_nc = [[w for w in word if not w in collection_words]
                 for word in tweets_nsw]
tweets_nsw[0]
tweets_nsw_nc[0]

# This flattens a list of words in clean tweets #

all_words_nsw_nc = list(itertools.chain(*tweets_nsw_nc))

# Create counter of words in clean tweets

counts_nsw_nc = collections.Counter(all_words_nsw_nc)

counts_nsw_nc.most_common(15)
len(counts_nsw_nc)

clean_tweets_ncw = pd.DataFrame(counts_nsw_nc.most_common(15),
                             columns=['words', 'count'])
clean_tweets_ncw.head()

fig, ax = plt.subplots(figsize=(8, 8))

# Plot horizontal bar graph
clean_tweets_ncw.sort_values(by='count').plot.barh(x='words',
                      y='count',
                      ax=ax,
                      color="purple")

ax.set_title("Common Words Found in Tweets (Without Stop or Collection Words)")

plt.show()

from nltk import bigrams
from nltk.corpus import stopwords
import re

import networkx as nx
# Create list of lists containing bigrams in tweets
terms_bigram = [list(bigrams(tweet)) for tweet in tweets_nsw_nc]

# View bigrams for the first tweet
terms_bigram[0]

tweets_nsw_nc[0]

# Flatten list of bigrams in clean tweets
bigrams = list(itertools.chain(*terms_bigram))

# This creates a counter of words in clean bigrams (words found together) #

bigram_counts = collections.Counter(bigrams)

bigram_counts.most_common(25)

bigram_df = pd.DataFrame(bigram_counts.most_common(20),
                             columns=['bigram', 'count'])

bigram_df

# Create dictionary of bigrams and their counts

d = bigram_df.set_index('bigram').T.to_dict('records')


# Create network plot 
G = nx.Graph()

# Create connections between nodes
for k, v in d[0].items():
    G.add_edge(k[0], k[1], weight=(v * 10))

G.add_node("china", weight=100)

fig, ax = plt.subplots(figsize=(10, 8))

pos = nx.spring_layout(G, k=1)

# Plotting the networks. #

nx.draw_networkx(G, pos,
                 font_size=16,
                 width=3,
                 edge_color='grey',
                 node_color='purple',
                 with_labels = False,
                 ax=ax)

# Creating offset labels. #

for key, value in pos.items():
    x, y = value[0]+.135, value[1]+.045
    ax.text(x, y,
            s=key,
            bbox=dict(facecolor='red', alpha=0.25),
            horizontalalignment='center', fontsize=13)
    
plt.show()

end 


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//This second Python section does simple sentiment analysis on a grabbed subsection of tweets written by Bernie Sanders. There are still bugs in the code, it worked the first time and then didn't when I was checking before submitting to github. I'm including the code so you can see it, but it's still a work in progress and won't run past the extractor now (it did before, need to figure out why)//
    
python

pip install utils
pip install numpy

import tweepy as tw
import matplotlib
import numpy
from IPython.display import display
import matplotlib.pyplot as plt
import seaborn as sns
%matplotlib inline
consumer_key= 'Xr9VwmlPNLT2NivIMWUPPYysT'
consumer_secret= 'SaI9MpQkArKRU4W9KQBG3gpojporZihUQkpJcCa46G11gzsWD1'
access_token= '286826733-tQpQY605CrxvFQr8DKp4nvEcIdnXBhsSTaiGIELm'
access_token_secret= 'oNL954A1GiJAu8SaNBw9axSQiPky3cY60l4AIYSBLaOyy'


auth.set_access_token("286826733-tQpQY605CrxvFQr8DKp4nvEcIdnXBhsSTaiGIELm", "oNL954A1GiJAu8SaNBw9axSQiPky3cY60l4AIYSBLaOyy")

def twitter_setup():
    auth = tw.OAuthHandler("Xr9VwmlPNLT2NivIMWUPPYysT", "SaI9MpQkArKRU4W9KQBG3gpojporZihUQkpJcCa46G11gzsWD1")

api = tw.API(auth)

api = tw.API(auth, wait_on_rate_limit=True,
wait_on_rate_limit_notify=True)
    
#Creating a tweet extractor- This is where the bugs happen. I am now getting a "twitter_setup not defined error##

extractor = twitter_setup()

tweets = extractor.user_timeline(screen_name="@BernieSanders", count=200)
print("Number of Extracted Tweets: {}.\n".format(len(tweets)))

#Shows the first 5 recent tweets#

print("Five Most Recent Tweets:\n")
for tweet in tweets[:5]:
    print(tweet.text)
    print() 

data = pd.DataFrame(data=[tweet.text for tweet in tweets], columns=['Tweets'])
display(data.head(10))

print(dir(tweets[0]))
print(tweets[0].id)
print(tweets[0].created_at)
print(tweets[0].source)
print(tweets[0].favorite_count)
print(tweets[0].retweet_count)
print(tweets[0].geo)
print(tweets[0].coordinates)
print(tweets[0].entities)

data['len']  = np.array([len(tweet.text) for tweet in tweets])
data['ID']   = np.array([tweet.id for tweet in tweets])
data['Date'] = np.array([tweet.created_at for tweet in tweets])
data['Source'] = np.array([tweet.source for tweet in tweets])
data['Likes']  = np.array([tweet.favorite_count for tweet in tweets])
data['RTs']    = np.array([tweet.retweet_count for tweet in tweets])

display(data.head(10))
mean = np.mean(data['len'])

print("Average Character Length: {}".format(mean))


fav_max = np.max(data['Likes'])
rt_max  = np.max(data['RTs'])

fav = data[data.Likes == fav_max].index[0]
rt  = data[data.RTs == rt_max].index[0]


print("Most Liked Tweet: \n{}".format(data['Tweets'][fav]))
print("Total Number of Likes: {}".format(fav_max))
print("{} characters.\n".format(data['len'][fav]))


print("Most Re-Tweeted Tweet: \n{}".format(data['Tweets'][rt]))
print("Total Number of Retweets: {}".format(rt_max))
print("{} characters.\n".format(data['len'][rt]))

#This creates a time series#

tlen = pd.Series(data=data['len'].values, index=data['Date'])
tfav = pd.Series(data=data['Likes'].values, index=data['Date'])
tret = pd.Series(data=data['RTs'].values, index=data['Date'])

tlen.plot(figsize=(16,4), color='r');
tfav.plot(figsize=(16,4), label="Likes", legend=True)
tret.plot(figsize=(16,4), label="Retweets", legend=True);

sources = []
for source in data['Source']:
    if source not in sources:
        sources.append(source)

print("Content Sources:")
for source in sources:
    print("* {}".format(source))
	
percent = np.zeros(len(sources))

for source in data['Source']:
    for index in range(len(sources)):
        if source == sources[index]:
            percent[index] += 1
            pass

percent /= 100


pie_chart = pd.Series(percent, index=sources, name='Sources')
pie_chart.plot.pie(fontsize=11, autopct='%.2f', figsize=(6, 6));

from textblob import TextBlob
import re

def clean_tweet(tweet):
    return ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet).split())

def analize_sentiment(tweet):
    analysis = TextBlob(clean_tweet(tweet))
    if analysis.sentiment.polarity > 0:
        return 1
    elif analysis.sentiment.polarity == 0:
        return 0
    else:
        return -1
		
data['SA'] = np.array([ analize_sentiment(tweet) for tweet in data['Tweets'] ])

display(data.head(10))

pos_tweets = [ tweet for index, tweet in enumerate(data['Tweets']) if data['SA'][index] > 0]
neu_tweets = [ tweet for index, tweet in enumerate(data['Tweets']) if data['SA'][index] == 0]
neg_tweets = [ tweet for index, tweet in enumerate(data['Tweets']) if data['SA'][index] < 0]

print("Percentage of Positive Tweets: {}%".format(len(pos_tweets)*100/len(data['Tweets'])))
print("Percentage of Neutral Tweets: {}%".format(len(neu_tweets)*100/len(data['Tweets'])))
print("Percentage of Negative Tweets: {}%".format(len(neg_tweets)*100/len(data['Tweets'])))#



//I am not done working with Python for the project: I'm trying to learn how to use it to create a predictive sentiment analysis api to examine the environment for the 2020 election (such as attitudes about the Democrat frontrunners.) I am having some progress but it's not working yet, so I didn't include it here. If I am able to, it will be in the final project.//

//DISCLAIMER//


//I have spent a sizable amount of time trying to learn how to do some things in Python for the project, which unfortunately took so long I ran out of time to make sure everything was close to done for PS6. I know I should have managed my time better, but to be honest I was getting a little obsessed with making the Python projects work once I was able to get some of it to function. Everything will be done in the final project submission. //

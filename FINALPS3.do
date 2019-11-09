//there are 4 merges, not 5, and some important mistakes; still, its a huge progress, good job, but try to make it even better

//Galadriel Thoman//
//PS3-REDO//
//Stata Version 16//

//I am doing a project on poverty in Botswana for another class, and I am interested in comparing the country to other countries in Africa statistically, as Botswana is known as the "African Exception" and considered an economic success. However, there are still several measures that is is lagging behind in. Using a combination of data from several global institutions, I want to examine if Botswana is statistically still improving and doing better than its neighbors on these measures that I have chosen to reflect the characteristics of growth, such as polity, corruption, HIV prevalence, and several poverty measures.//

//The first dataset was imported through the Stata command, and each other source for the subsequent datasets are in the comments between the **  **.//

//this dataset is empty! why we load empty data??? there should be no mistakes in the dofile
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

mvencode *, mv(99999) //why would you do that? stata's code for missing is . !

drop if year<1995
drop if year>2015

//I am merging a World Population dataset downloaded from here: ** https://population.un.org/wpp/Download/Standard/Population/ **(first download, Total Population). I changed the country names to abreviations and kept only the years from 1995 to 2015.//

merge 1:1 countryname year using "https://docs.google.com/uc?id=1D_ZZAVjNAeqjUgypf31e3XDscl6s1xjK&export=download"

tab countryname _merge

//There were only 3700 matched observations because the main dataset (the wbopendata set) is missing countried that the dataset on disk includes.//

//I am now merging a dataset with Income Per Capita (adjusted for PPP), found at **https://www.gapminder.org/data/documentation/gd001/ **. Like the population dataset, I edited the country names to country name abreviations so that they would match with the other datasets I planned to use, and kept only the years between 1995-2015.//
//ok, good you explain what you did, but why not have code for that here? i hope you didnt use excel!

merge 1:1 countryname year using "https://docs.google.com/uc?id=17HKL3exP9lFG7eZvlx5KW3goJyKR3xY2&export=download", generate(_merge2)

//There were only 3700 matches for the same reason, there are countries in the merged datasets that are not in the main dataset.//

sort countryname year

//I am now merging an OECD dataset called SPIDER, found at: **https://www.oecd.org/economy/growth/structural-policy-indicators-database-for-economic-research.htm **//

//I cleaned up the years, keeping only in the parameter of 1995-2015, and only 7 of the variables. Again, there is not a perfect match of countries, which led to a not perfect match.//

//no, thats a mistake, should be 1:1
merge 1:m countryname year using "https://docs.google.com/uc?id=1hod9Y7IZ6OUN6aQC8uATU5SaiJNhfp_x&export=download", generate(_merge3)

//To clean up the data and help it match the final merge dataset, I dropped observations for all countries that were not in the dataset in disk. This took a long time and there may have been an easier way, but I couldn't think of one, so I used the Data Editor.//

//no! never drop like that! always drop on some condition like drop if _merge==1, _merge2==1 etc
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

//End PS3//





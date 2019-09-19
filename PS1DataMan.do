//*Galadriel Thoman
*PS1, September 2019*//
Version 16
//great preamble

//and great to explain what you are doing

//For this problem set, I used Wave 6 of the World Values Survey to do a simple test of the Trust in Fairness variable and the Interest in Politics variable, to see if there is a correlation between someone's level of trust in other's inherent fairness and how interested in politics they are. I intend to use different data for subsequent problem sets, or else refine this data.//

use "https://docs.google.com/uc?id=1YYjZgzqcq7p8ORMxSS32LHg6axQAnQUm&export=download", clear
rename V56 TrustFair //great to rename, but need to lead raw dataset!!! this breaks!!
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
file PS1WVSSASFormat.sas saved //this shou;ld not be here

//Galadriel Thoman//
//PS3 10/17/19//
Stata Version 16

//I am doing a project on poverty in Botswana for another class, and I am interested in comparing the country to other countries in Africa statistically, as Botswana is known as the "African Exception" and considered an economic success. However, there are still several measures that is is lagging behind in. Using a combination of data from several global institutions, I want to examine if Botswana is statistically still improving and doing better than its neighbors, particulary at both the national level and at a community level (thorugh survey data).//

//installed stata packages: povcalnet and prosperity//

use "https://docs.google.com/uc?id=170HGK-ylI7gE7unHS9myb0CWeeosKRkk&export=download", clear

//Master dataset is Botswana. I am merging this with similar datasets for Zambia, Zimbabwe, Gabon, Mauritius, and Nigeria, on indicator name, country name, and years 1995-2014.//

merge 1:1 indicatorname countryname yr1995 yr1996 yr1997 yr1998 yr1999 yr2000 yr2001 yr2002 yr2003 yr2004 yr2005 yr2006 yr2007 yr2008 yr2009 yr2010 yr2011 using "https://docs.google.com/uc?id=1Lsb0IuJlOOBE0Qtfph7LnRxrt75xLwSs&export=download"

merge 1:1 indicatorname countryname yr1995 yr1996 yr1997 yr1998 yr1999 yr2000 yr2001 yr2002 yr2003 yr2004 yr2005 yr2006 yr2007 yr2008 yr2009 yr2010 yr2011 using"https://docs.google.com/uc?id=19u7upZgsqCjY_oImJSwey0gDeTw-JyGk&export=download", generate(_merge2)

merge 1:1 indicatorname countryname yr1995 yr1996 yr1997 yr1998 yr1999 yr2000 yr2001 yr2002 yr2003 yr2004 yr2005 yr2006 yr2007 yr2008 yr2009 yr2010 yr2011 using "https://docs.google.com/uc?id=1fR8GeyxxcjwG88XAQ0OIWWdYtSFcLzan&export=download", generate(_merge3)

merge 1:1 indicatorname countryname yr1995 yr1996 yr1997 yr1998 yr1999 yr2000 yr2001 yr2002 yr2003 yr2004 yr2005 yr2006 yr2007 yr2008 yr2009 yr2010 yr2011 using "https://docs.google.com/uc?id=1bKm6jbnJdbWEcBZ5ao2AJGrRrapaYHSA=&export=download", generate(_merge4)

merge 1:1 indicatorname countryname yr1995 yr1996 yr1997 yr1998 yr1999 yr2000 yr2001 yr2002 yr2003 yr2004 yr2005 yr2006 yr2007 yr2008 yr2009 yr2010 yr2011 using "https://docs.google.com/uc?id=1V-5GALAGsPt-1PP8LwfK_3EWOuDZYJvR&export=download", generate(_merge5)

//Next I am merging a dataset on health indicators.//

merge 1:1 indicatorname countryname yr1995 yr1996 yr1997 yr1998 yr1999 yr2000 yr2001 yr2002 yr2003 yr2004 yr2005 yr2006 yr2007 yr2008 yr2009 yr2010 yr2011 using "https://docs.google.com/uc?id=16_j9G6cE1v0Cq5i44V34WI5IH4Aovz8a&export=download", generate(_merge6)

//Next I am using append to combine this new dataset with a dataset from UNSD with economic, enivornmental, and poverty statistics.//

append using "https://docs.google.com/uc?id=1KX1j7VVDs4POqdQCamLpld6sQlZMRnyY&export=download"

//Next I am appending to add poverty statistics to dataset.//

 append using "https://docs.google.com/uc?id=1fBjeBz-Yzprx12hHhzrYFM0f0v0f8J-L&export=download"
 
//Next I am appending a dataset called Afrobarometer, which is survey data on a multitude of social well-being indicators. I appended because there were no common variables to merge on and Stata wasn't recognizing variables that did exist.//

append using "https://docs.google.com/uc?id=1P0xHrLwZ9xMpZ6YTC-vpgbeHV_lgHMb3&export=download"

//I could not for the life of me figure out how to make a m:1 or 1:m merge work. I continuously got errors like "variable "" does not uniquely identify observations in master data" and "variable '' not found" even when the variables existed in both datasets. I dropped duplicates, I searched with isid on everything that made sense, I sorted on different variables, I did everything I could think of and I couldn't make it happen. I had the same trouble with reshape. I don't know what I was doing wrong but by the time I realized it wasn't working I had an emergency and wasn't able to get help.//






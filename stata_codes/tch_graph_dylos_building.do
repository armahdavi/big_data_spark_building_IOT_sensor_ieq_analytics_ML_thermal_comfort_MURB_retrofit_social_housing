* Program to sketch number concentration vs. building type in box blot figure 
* 160614_am

set more off 

// Reading count C data and refining
use "${path}Google Drive/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/STcompleteAppend (1).dta", clear

capture gen buildingID = substr(locID,1,3)
capture encode locID, gen(locCode)
encode buildingID, gen(buildCode)

gen byte smokes2 = .
replace smokes2 = 1 if smokes == "Yes"
replace smokes2 = 2 if smokes == "No"

quietly sum small_countm3 if (small_countm3  > 100000 & small_countm3  <100000000) & smokes2==1, d
local med_smoke = `r(p50)'
quietly sum small_countm3 if (small_countm3  > 100000 & small_countm3  <100000000) & smokes2==2, d
local med_nosmoke = `r(p50)'

// Graphing box plot
#delimit ;
graph box small_countm3 if small_countm3  > 100000 & small_countm3  <100000000, over(buildCode, ax(off)  )  asyvars noout

ytitle(PM > 0.5 µm (#/m{superscript:3}), size(large)) 
yscale(range(100000 100000000) log)
ylabel(100000 300000 1000000 3000000 10000000 30000000 100000000 , format(%1.0e) nogrid angle(horizontal) valuelabel tposition(crossing) labsize(medlarge))

legend(off)
legend(size(large))  
legend(pos(1) ring(0))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
yli(`med_smoke', lp(dash) lc(gs4))
yli(`med_nosmoke', lp(solid) lc(gs10))


;
delimit cr

graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\ia2016_building.gph", replace
graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\ia2016_building.eps", replace

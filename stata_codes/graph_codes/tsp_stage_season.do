* Program to sketch TSP based on season and stage

set more off
clear all

use "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/summary/tsp_master.dta", clear
gen bldg_no = substr(Suite,3,1)
destring bldg_no, replace

do "${path2}PhD Research/MURB Building IOT/ado/label_tsp.do"
* encode Stage, gen (stage) label(stage)
* encode Season, gen (season) label(season)
* encode smoke_evidence, gen (smoke) label(smoke)

so bldg stage season smoke
* drop Stage Season smoke_evidence

#delimit ;
graph box tsp_conc, over(season) over(stage, label(nolab)) asyvars noout note("")
box(1, col(green)) box(2, col(orange))
ylabel(1 10 100 1000 , tposition(crossing) angle(horizontal) nogrid)
yscale(range(1 1000) log)
legend(order(1 "Summer" 2 "Fall"))
legend(pos(1) ring(0))

ytitle("TSP Concentration (µg/m{superscript:3})", size (large)) 

plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(zero) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(t=11 b=9 l =10))

text(0.7 25 "2015", size(medium))
text(0.7 75 "2017", size(medium))

;
#delimit cr

* Program to sketch tch and 1649 count concentrations

// Reading ASHRAE 1640 data
set more off
use "${path2}/ASHRAE_1649/data/processed/qff_psd/dc_1700_append_all.dta", replace
gen case = "RP-1649"

// Appending with TCH concentration data
append using "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/dc_all.dta"

replace case = "TCH Non-Smoke" if case == "" & smoke == 0
replace case = "TCH Smoke" if case == "" & smoke == 1

replace small_CountPerFoot3 =. if small_CountPerFoot3 == 0

// Graphing
#delimit ;
graph box small_CountPerFoot3, over(case) asyvars noout note("")
box(1, col(gs9)) box(2, col(black))
ylabel(10 1000 100000 10000000, tposition(crossing) angle(horizontal) nogrid)
yscale(range(10 10000000) log)
legend(order(1 "RP-1646" 2 "TCH Non-Smoke" 3 "TCH Smoke"))
legend(rows(3) pos(11) ring(0))

ytitle("TSP Concentration (µg/m{superscript:3})", size (large)) 

plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(zero) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(t=11 b=9 l =10))

;
#delimit cr

graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\tsp_comparison_count.gph", replace
graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\tsp_comparison_count.eps", replace

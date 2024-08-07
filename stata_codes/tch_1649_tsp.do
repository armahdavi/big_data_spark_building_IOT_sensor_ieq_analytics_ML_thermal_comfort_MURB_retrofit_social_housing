* Program to skecth tch and 1649 tsp concentrations

// Reading TCH TSP concentration and refining
set more off
use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta" , clear
keep if stage == 2
gen site = substr(Suite,3,1)
destring site, replace
* rename FilterType filter_type
rename tsp_conc TSP_conc_ug_m3
keep Suite site season smokes runtime TSP_conc_ug_m3  

// Merging with RP-1649 TSP concentrations
append using "${path2}/ASHRAE_1649/data/processed/ldps/d_D_qff_psd_all.dta", force
keep Suite site round  TSP_conc_ug_m3 smokes filter_type

gen case = "TCH Smoke"
replace case = "TCH Nonsmoke" if Suite != "" & smoke == 0
replace case = "RP-1649" if Suite == ""

// Graphing
#delimit ;
graph box TSP_conc_ug_m3, over(case)  asyvars noout note("")
box(1, col(gs9)) box(2, col(black))
ylabel(1 10 100 1000 , tposition(crossing) angle(horizontal) nogrid)
yscale(range(1 1000) log)
legend(order(1 "RP-1646" 2 "TCH Non-Smoke" 3 "TCH Smoke"))
legend(rows(3) pos(1) ring(0))

ytitle("TSP Concentration (µg/m{superscript:3})", size (large)) 

plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(zero) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(t=11 b=9 l =10))

;
#delimit cr

graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\tsp_comparison_old.gph", replace
graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\tsp_comparison_old.eps", replace

/*
text(150 96.5 "n = `ind_7_smoke'", size(vsmall) orientation(vertical))


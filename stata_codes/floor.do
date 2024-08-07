* Program to sketch scatter plot of TSP versus suite height

// Reading TSP data
set more off
use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta", clear

// estimating suite floor height
gen floor = substr(Suite,6,1)
replace floor = substr(Suite,5,2) if substr(Suite,5,1) == "1"
destring floor, replace
replace floor = floor * 2.5
gen bldg = substr(Suite,1,3)
save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_housing\processed\tsp_height.dta", replace


// Graphing for separate buildings
levelsof bldg

foreach item in `r(levels)' {
	use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_height.dta", clear
	keep if bldg == "`item'"
      
	#delimit ;

    twoway (
		scatter tsp_con floor if smoke_evidence == "N", mcol(black) mfcol(white) 
			ylabel(10 30 100, tposition(crossing) angle(horizontal) nogrid)
			ytitle("TSP Concentration (µg/m{superscript:3})", size (mede)) 
			yscale(range(6 300) log)
			xscale(range(0 50))
			xlabel(0 (10) 50, tpos(none)) 
			xtick(, noticks) 
			xtitle("Suite Height (m)")
			legend(on)
			legend(order(1 "Non-smoking" 2 "Smoking"))
			plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(zero) lpattern(solid) ifcolor(none) ilcolor(none)
			ilwidth(none) ilpattern(solid))
			graphregion(color(white) margin(t=11 b=9 l =10))
			)
  
		(scatter tsp_con floor if smoke_evidence == "Y", mcol(black) mfcol(black)) 
		;
		#delimit cr

	graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\fig_`item'_height.gph", replace
	graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\fig_`item'_height.eps", replace
	}
         

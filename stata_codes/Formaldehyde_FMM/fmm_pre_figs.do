* Data preparation for FMM

set more off
use "${path2}PhD Research/MURB Building IOT/Processed Data/fmm_all.dta", clear
gen round = 1
replace rou = 2 if Season == "Fall" & Stage == "Pre"
replace rou = 3 if Season == "Summer" & Stage == "Post"
replace rou = 4 if Season == "Fall" & Stage == "Post"

collapse (median) round, by(Suite)

use "${path2}PhD Research/MURB Building IOT/Processed Data/fmm_all.dta", clear
collapse (median) HCHO_u, by(Suite Season Stage)

gen keepdrop =  ""
levelsof Suite
foreach suite in `r(levels)' {
	count if Suite == "`suite'"
	replace keepdrop = "keep" if `r(N)' > 1 & Suite == "`suite'"
	}
keep if keepd == "keep"
keep Suite Season Stage

merge 1:m Suite Season Stage using "${path2}PhD Research/MURB Building IOT/Processed Data/fmm_all.dta"
keep if _merge == 3

	
gen round = 1
replace rou = 2 if Season == "Fall" & Stage == "Pre"
replace rou = 3 if Season == "Summer" & Stage == "Post"
replace rou = 4 if Season == "Fall" & Stage == "Post"
 

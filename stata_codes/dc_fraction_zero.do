* To explore what fraction of dc data is zero

set more off
use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/dc_all.dta", clear

local i 1
// the zero observations has taken place all during summer pre-retrofit
levelsof Suite if small_C == 0
foreach suite in `r(levels)' {
	use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/dc_all.dta", clear
	keep if Suite == "`suite'"
	count if small_C == 0
	local zero = `r(N)'
	count
	local tot = `r(N)'
	
	drop _all
	set obs 1 
	gen Suite = "`suite'"
	gen zero_fraction = (`zero'/`tot') * 100
	
	if `i' == 1 {
		save "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/dc_zero_fraction.dta", replace
		local ++i
		}
	else {
		append using "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/dc_zero_fraction.dta"
		save "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/dc_zero_fraction.dta", replace
		}
	}
	

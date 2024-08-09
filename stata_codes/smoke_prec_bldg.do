* Program to calculate the percentage of smoking suites in each studied building

use "${path2}PhD Research/MURB Building IOT/Processed Data/tch_st_sensor_master_spreadsheet.dta", clear
keep Suite
duplicates drop

merge 1:m Suite using "${path2}PhD Research/MURB Building IOT/Processed Data/smoke_master_reshape_round.dta"
keep if _merge != 2

gen smoke = 1 if smoke_pre == 1 | smoke_post == 1
foreach i in "1" "2" "3" "4" "5" "6" "7" {
	count if substr(Suite,3,1) == "`i'" & smoke == 1
	local no_`i' = `r(N)'
	count if substr(Suite,3,1) == "`i'"
	local perc_`i' = `no_`i'' / `r(N)'
	}

drop _all
set obs 7
gen bldg_id = _n

gen perc_smoke = .
gen no_smoke = .
foreach i in 1 2 3 4 5 6 7 {
	replace no_smoke = `no_`i'' in `i'
	replace perc_smoke = `perc_`i'' in `i'
	}


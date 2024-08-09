* Program to make TCH sensor master spreadsheet by going through all recorded files and checks which suites had which type of sensor

set more off
clear all

do "${path2}/TAF UofT IEQ Study/ado/label_tsp.do"

local sensorfiles "${path2}/TAF UofT IEQ Study/Data/Raw Data/Short term packages/"
local files: dir "`sensorfiles'" files "*.dta"

local i 1
local j 1

// all non-opc data reading
foreach file in `files' {
	if substr("`file'",14,3) == "dc1" {
		
		use "`sensorfiles'/`file'", clear
			
		sum small if small != 0
		local DC_small_zero = `r(N)'
		sum large if large != 0
		local DC_large_zero = `r(N)'
		// drop small_CountPerFoot3 large_CountPerFoot3 time clocktime GMTtime // drop _all doesn't work. It also drops the above locals !!
		drop _all
		
		set obs 1
		gen DC_file_name = "`file'"
		gen DC_small_zero = `DC_small_zero'
		gen DC_large_zero = `DC_large_zero'
		gen Suite = substr("`file'",5,8)
		gen Season = substr("`file'",29,2)
		replace Season = "Spring/Summer" if Season == "05" | Season == "06" | Season == "07"
		replace Season = "Fall/Winter" if Season == "11" | Season == "12"

		gen Stage = substr("`file'",27,2)
		replace Stage = "Pre" if Stage == "15"
		replace Stage = "Post" if Stage == "17"
		
		
		if `i' == 1 {
			save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_dc_master.dta", replace
			local ++i
			}
		else {	
			append using "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_dc_master.dta"
			save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_dc_master.dta", replace
			
			}
		}
	}

foreach file in `files' {
	if substr("`file'",14,3) == "fmm" {
		drop _all
		set obs 1
		gen Suite = substr("`file'",5,8)
		gen Season = "" 
		replace Season = "Spring/Summer" if substr("`file'",29,2) == "05" | substr("`file'",29,2) == "06" | substr("`file'",29,2) == "07"
		replace Season = "Fall/Winter" if substr("`file'",29,2) == "11" | substr("`file'",29,2) == "12"
		gen Stage = "" 
		replace Stage = "Pre" if substr("`file'",27,2) == "15"
		replace Stage = "Post" if substr("`file'",27,2) == "17"
		
		gen FMM_file_name = "`file'"
			
		if `j' == 1 {
			save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_fmm_master.dta", replace
			local ++j
			}
		else {	
			append using "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_fmm_master.dta"
			save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_fmm_master.dta", replace
			}
		}
	}

merge m:m Suite Season Stage using "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_dc_master.dta"
drop _merge
save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_master_spreadsheet.dta", replace

/*
use "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_dc_master.dta", clear
encode Season, gen(season) label(season)
encode Stage, gen(stage) label(stage)
drop Stage Season
save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_dc_master.dta", replace

use "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_fmm_master.dta", clear
encode Season, gen(season) label(season)
encode Stage, gen(stage) label(stage)
drop Stage Season
save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_fmm_master.dta", replace
*/

// ssc install fs
// cd "${path2}/TAF UofT IEQ Study/Data/Raw Data/Short term packages/OPC"
// folders 18*

set more off
clear all
local opcfiles "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/opc_processed_incomplete_timestamps"
local files: dir "`opcfiles'" files "*.dta"

local k 1
foreach file in `files' {
	local Suite = substr("`file'",11,8)
	local Season = substr("`file'",35,2)
	local Stage = substr("`file'",33,2)
	// local OPC_file_name = "`file'"
	
	use "`opcfiles'/`file'", clear
	
	sum small if small != 0
	local OPC_small_zero = `r(N)'
	sum large if large != 0
	local OPC_large_zero = `r(N)'
	
	drop small_Count large_Count timestamp smoking_evidence // again why not drop _all work?
	
	set obs 1
	gen Suite = "`Suite'"
	gen Season = "`Season'" 
	gen Stage = "`Stage'" 
	
	gen OPC_small_zero = `OPC_small_zero'
	gen OPC_large_zero = `OPC_large_zero'
	gen OPC_file_name = "`file'"
	
	
	if `k' == 1 {
		save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_opc_master.dta", replace
		local ++k
		}
	else {
		append using "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_opc_master.dta"
		save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_opc_master.dta", replace
		}
	}

replace Season = "Spring/Summer" if Season == "05" | Season == "06" | Season == "07"
replace Season = "Fall/Winter" if Season == "11" | Season == "12"
	
replace Stage = "Pre" if Stage == "15"
replace Stage = "Post" if Stage == "17"
save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_opc_master.dta", replace

merge m:m Suite Season Stage using "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_master_spreadsheet.dta"
drop _merge

do "${path2}/TAF UofT IEQ Study/ado/label_tsp.do"
encode Season, gen(season) label(season)
encode Stage, gen(stage) label(stage)
drop Stage Season 
save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_master_spreadsheet.dta", replace	

// save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_opc_master.dta", replace

use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta", clear

// replace Season = "Spring/Summer" if Season == "Summer"
// replace Season = "Fall/Winter" if Season == "Fall"

merge m:m Suite season stage using "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_master_spreadsheet.dta"
keep Suite season stage FMM_file_name DC_large_zero DC_small_zero DC_file_name OPC_file_name OPC_large_zero OPC_small_zero tsp_conc tsp_conc_error
/* 
do "${path2}/TAF UofT IEQ Study/ado/label_tsp.do"
encode Stage, gen (stage) label(stage)
encode Season, gen (season) label(season)
drop Stage
drop Season
*/

merge m:m Suite using "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/smoke_master_final.dta"
drop if _merge == 2
drop _merge 

order Suite stage season smoke tsp* FMM DC* OPC_f
so Suite stage season

save "${path2}/TAF UofT IEQ Study/Data/tch_st_sensor_master_spreadsheet.dta", replace


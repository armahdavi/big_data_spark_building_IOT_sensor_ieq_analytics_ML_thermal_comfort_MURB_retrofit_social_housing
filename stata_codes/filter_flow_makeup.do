* ?

// do "${path2}/TAF UofT IEQ Study/ado/flow_correction_ratio.do"
import excel "${path2}/TAF UofT IEQ Study/Data/Raw Data/Filters/raw_mr0_00aa_xr1_1015C00010_181127_am.xlsx", sheet("Filter_Master") firstrow clear

// clean up
drop if locID == ""
drop if xr100SN == "Field Blank"
replace FilterType = "uniform" if FilterType == "unifrom" | FilterType == "Unifrom" | FilterType == "Uniform"
drop if preDeployFlow_cfm == "n/a"
drop if FilterType != "uniform"
destring preDeployFlow_cfm, replace

gen flow_cat = "lack" if preDeployFlow_cfm == .
replace preDeployFlow_cfm = preDeployFlow_cfm * flow_cor if substr(iDa,3,2) == "15"

keep preDeployFlow_cfm postDeployFlow_cfm deltaMass_g filterSN flow_cat

gen flow_decrease = ((preDeployFlow_cfm - postDeployFlow_cfm) / preDeployFlow_cfm) * 100

regress flow_decrease deltaMass_g if delt > 0
gen flow_dec_calc = deltaMass_g * _b[deltaMass_g] + _b[_cons]

replace flow_decrease = deltaMass_g * _b[deltaMass_g] + _b[_cons] if flow_cat == "lack"
gen flow_dec_offset = flow_decrease - flow_dec_calc if flow_cat != "lack" // for the rest of observations for flow errors

replace preDeployFlow_cfm = postDeployFlow_cfm / (1-(flow_decrease/100)) if flow_cat == "lack" & delt >0
gen flow_offset = postDeployFlow_cfm / (1-(flow_dec_offset/100)) if flow_cat != "lack" & delt >0

sum flow_offset, detail
gen flow_error = `r(p95)' if flow_cat == "lack"
drop if flow_cat != "lack"

keep fil pre flow_error
drop if pre < 0
drop if pre == .

rename pre Pre

save "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_flow_makeup.dta", replace

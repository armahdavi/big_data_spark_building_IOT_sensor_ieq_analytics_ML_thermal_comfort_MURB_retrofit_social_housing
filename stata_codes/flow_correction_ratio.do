* Program to calculate flow uncertainty
* This is essential as the chamber tested during pre and post-retrofit filter deployment changed. The post-deployment chamber was much more airtight (plexiglass vs. cardboard)

import excel "${path2}PhD Research/MURB Building IOT/Data/raw_mr0_00aa_xr1_1015C00010_181127_am.xlsx", sheet("Filter_Master") firstrow clear
// clean up
drop if locID == ""
drop if xr100SN == "Field Blank"
replace FilterType = "uniform" if FilterType == "unifrom" | FilterType == "Unifrom" | FilterType == "Uniform"
drop if preDeployFlow_cfm == "n/a"
drop if FilterType != "uniform"
destring preDeployFlow_cfm, replace

keep iDa preDeployFlow_cfm 
keep if pre != .

gen Stage = "Pre" if substr(iDa,3,2) == "15"
replace Stage = "Post" if Stage == ""

sum pre if Stage == "Pre", detail
local med_pre `r(p50)'
sum pre if Stage == "Post", detail
local med_post `r(p50)'

scalar flow_cor = `med_post'/`med_pre'

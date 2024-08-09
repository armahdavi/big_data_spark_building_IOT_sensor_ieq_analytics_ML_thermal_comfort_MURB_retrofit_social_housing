* Program to evaluate tsp uncertainties

// Calculating a scalar variable called mass_er whic is the median of all undertainties
import excel "${path2}/TAF UofT IEQ Study/Data/Raw Data/Filters/raw_mr0_00aa_xr1_1015C00010_181127_am.xlsx", sheet("Filter_Master") firstrow clear
keep if xr100SN == "Field Blank"
replace FilterType = "uniform" if FilterType == "unifrom" | FilterType == "Unifrom" | FilterType == "Uniform"
keep if FilterT == "uniform"
drop if locID == ""
gen Stage = "Pre" if substr(iDa,3,2) == "15"
replace Stage = "Post" if substr(iDa,3,2) == "17"

gen Season = "Summer" if substr(iDa,6,2) == "05" | substr(iDa,6,2) == "06" | substr(iDa,6,2) == "07"
replace Season = "Fall" if substr(iDa,6,2) == "11" | substr(iDa,6,2) == "12"
keep locID delta Season Stage 

do "${path2}/TAF UofT IEQ Study/ado/label_tsp.do"
encode Stage, gen (stage) label(stage)
encode Season, gen (season) label(season2)
drop Stage Season
rename locID Suite 
merge 1:m Suite stage season using "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/smoke_master.dta"
keep if _merge == 3
drop _merge
so smokes
gen mass_error = abs(delta)
sum mass, detail
scalar mass_er = `r(p50)'

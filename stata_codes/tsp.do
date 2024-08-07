* Program to create a master database for all TSP measured by XR-100 filters

// Reading start and end runtimes
set more off
import excel "${path2}/TAF UofT IEQ Study/Data/FDS/XR-100_times.xlsx", firstrow clear

drop if Install_time == ""
drop if Missinghours == "U"

replace Install_date = substr(Install_date,1,4) + "." + substr(Install_date,6,2) + "." + substr(Install_date,9,2)
replace Retrieve_date = substr(Retrieve_date,1,4) + "." + substr(Retrieve_date,6,2) + "." + substr(Retrieve_date,9,2)
replace Install_time = Install_date + " " + Install_time
replace Retrieve_time = Retrieve_date + " " + Retrieve_time
drop Install_date Retrieve_date Comm

gen double install_time = clock(Install_time, "YMDhm")
gen double retrieve_time = clock(Retrieve_time, "YMDhm")
format install_time retrieve_time %tc
drop Install Ret
destring Miss, replace
gen runtime = ((retr - install))/1000
replace runtime = runtime - Miss * 60*60 if Miss != .
drop if runtime < 0
drop Mis
save "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta" , replace

// Reading TSP mass values (later used for TSP concentration values
import excel "${path2}/TAF UofT IEQ Study/Data/Raw Data/Filters/raw_mr0_00aa_xr1_1015C00010_181127_am.xlsx", sheet("Filter_Master") firstrow clear
drop if locID == ""
drop if xr100SN == "Field Blank"
replace FilterType = "uniform" if FilterType == "unifrom" | FilterType == "Unifrom" | FilterType == "Uniform"
drop if preDeployFlow_cfm == "n/a"
drop if FilterType != "uniform"
destring preDeployFlow_cfm, replace

// Making season and stage for merge
gen Stage = "Pre" if substr(iDa,1,4) == "2015"
replace Stage = "Post" if substr(iDa,1,4) == "2017"
gen Season = "Summer" if substr(iDa,6,2) == "05" | substr(iDa,6,2) == "06" | substr(iDa,6,2) == "07"
replace Season = "Fall" if substr(iDa,6,2) == "11" | substr(iDa,6,2) == "12"
drop if Stage == ""
keep filterSN FilterType preDeployMass preDeployFlow_cfm locID postDeployFlow_cfm postConditionMass deltaMass_g Season Stage

// Merging with flowrate lab data sheet and filtration volume calculations, cleanups and TSP concentration calculations
merge m:1 filterSN using "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_flow_makeup.dta"
replace preDeployF = Pre if preDeployF == .
drop Pre

replace preDeployFlow_cfm = preDeployFlow_cfm * flow_cor if Stage == "Pre"
replace postDeployFlow_cfm = postDeployFlow_cfm * flow_cor if Stage == "Pre"

gen flow = ((postDeployFlow_cfm + preDeployFlow_cfm)/2) * 1.69901082

replace flow_error = 0.03 * sqrt(postDeployFlow_cfm^2 + preDeployFlow_cfm^2) * 1.69901082 if Stage == "Post" & _merge != 3
replace flow_error = 0.13 * sqrt(postDeployFlow_cfm^2 + preDeployFlow_cfm^2) * 1.69901082 if Stage == "Pre" & _merge != 3
replace flow_error = sqrt((0.13 * sqrt(postDeployFlow_cfm^2 + preDeployFlow_cfm^2))^2 + flow_error ^ 2) * 1.69901082 if _merge == 3

drop if flow == . // sad but one round doesn't have flow before deploy
drop _merge
rename locID Suite

merge m:m Stage Season Suite using "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta"
drop _merge
drop if flow == . // mostly conaminated by composite filter and deployment round of jun 22 2015 which initial flows weren't measured
drop if runtime == . // observbations were mass was measured but filter was unplagged

gen tsp_conc = (deltaMass_g*1000000)/(flow*(runtime/3600))
drop if tsp_conc < 0

do "${path2}/TAF UofT IEQ Study/ado/label_tsp.do"
encode Stage, gen (stage) label(stage)
encode Season, gen (season) label(season2)
drop Stage Season

merge m:m Suite using "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/smoke_master.dta"
keep if _merge == 3
drop _merge
duplicates drop

keep deltaMass_g filterSN Suite flow_error flow runtime tsp_conc stage season smokes // smoke_pre smoke_post

gen tsp_conc_error = tsp_conc * sqrt((mass_er/deltaMass_g)^2 + (flow_error/flow)^2 + ((8*60*60)/runtime)^2)
so Suite stage

save "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta" , replace
so tsp_conc

* to make smoke master: long and wide (reshaped)

* Important file: smoke_evidence.xlsx (This file has all the FDS data recorded in one spreadsheet, so no need to check FDSs anymore)

* Program Steps: 
* 1- Read smoke data (smoke_evidence.xlsx) (Line 13)
* 2- generate important variables : smoke, season, rerofit stage (pre, post), and label them (using label_tsp.do), save in a master file (smoke_master.dta) (Line 14-39)
* 2-a- 
* 3- Make up any data if lost in FDSs from tracking_document and merge into smoke_master.dta (Line 41-72)
* 4- Make final decision of smoke based on pre and post record of smoking and returns one single "Y" or "N" case to a suite (for the entire project) (Line 83-113)
* 5- Make two formats of smoke data (wide showing round by round, and long showing evidence per suite) (Line 83-end)

import excel "${path2}PhD Research/MURB Building IOT/Data/smoke_evidence.xlsx", firstrow clear
rename locID Suite
tostring date_install date_r, replace
gen Stage = "Pre" if substr(date_r,1,2) == "15" | substr(date_i,1,2) == "15"
replace Stage = "Post" if substr(date_r,1,2) == "17" | substr(date_i,1,2) == "17"

gen Season = "Summer" if (substr(date_r,3,2) == "05" | substr(date_r,3,2) == "06" | substr(date_r,3,2) == "07") | substr(date_i,3,2) == "05" | substr(date_i,3,2) == "06" | substr(date_i,3,2) == "07"
replace Season = "Fall" if (substr(date_r,3,2) == "11" | substr(date_r,3,2) == "12") | (substr(date_i,3,2) == "11" | substr(date_i,3,2) == "12")

keep smoke_i_decided smoke_r_decided Suite Stage Season
gen smoke_evidence_row = smoke_i + smoke_r
gen smoke_evidence = "" 

replace smoke_evidence = "Y" if substr(smoke_evidence_row,1,1) == "Y" | substr(smoke_evidence_row,2,1) == "Y"
replace smoke_evidence = "U" if smoke_evidence_row == "UU"
replace smoke_evidence = "N" if smoke_evidence == ""
drop smoke_i smoke_r smoke_evidence_r

// gen merge_id = Suite + "_" + Stage + "_" + Season
do "${path2}/TAF UofT IEQ Study/ado/label_tsp.do"

encode Stage, gen (stage) label(stage)
encode Season, gen (season) label(season2)
encode smoke_evidence, gen (smokes) label (smoke)

drop Stage Season smoke_evidence
save "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/summary/smoke_master.dta", replace

import excel "${path2}/TAF UofT IEQ Study/Tracking document/Tracking_document_v58_KC.xlsx", sheet("Participating units") firstrow clear
keep AW AX G
drop in 1

rename G Suite
rename AW Smokes
rename AX Smokes_evidence

replace Smokes = substr(Smokes,1,1)
replace Smokes = "U" if Smokes == ""
gen Stage = "Pre"
gen Season = "Summer"

drop if substr(Suite,5,2) == "co" | substr(Suite,5,2) == "CO" // data sanitization from CO2 sensors
drop if Suite == "" // data sanitization

do "${path2}/TAF UofT IEQ Study/ado/label_tsp.do"
encode Stage, gen (stage) label(stage)
encode Season, gen (season) label(season2)
encode Smokes, gen (smokes2) label (smoke)

drop Stage Season Smokes Smokes_ev
merge 1:1 Suite stage season using "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/summary/smoke_master.dta"
gsort _merge Suite

replace smokes = smokes2 if _merge == 1
replace smokes = smokes2 if _merge == 3 & smokes == 3
// replace smokes = smokes2 if _merge == 3 & (substr(Suite,3,1) != "6" | substr(Suite,3,1) != "7") 
drop smokes2 _merge
// duplicates drop 
save "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/summary/smoke_master.dta", replace
so Suite

//obs 321

/*
temporary for verification
keep if _merge == 3
keep if smokes != smokes2
drop if smokes == 3
*/

sort stage season
gen round = 1
replace round = 2 if stage == 1 & season == 2
replace round = 3 if stage == 2 & season == 1
replace round = 4 if stage == 2 & season == 2
so Suite round
drop stage season

reshape wide smoke, i(Suite) j(round)

gen smoke_pre = "Y" if smokes1 == 1 | smokes2 == 1 
replace smoke_pre = "U" if smoke_pre != "Y" & ((smokes1 == 2 | smokes1 == .) & (smokes2 == 2 | smokes2 == .)) 
replace smoke_pre = "N" if smoke_pre == "" 
replace smoke_pre = "" if smokes1 == . & smokes2 == .

gen smoke_post = "Y" if smokes3 == 1 | smokes4 == 1 
replace smoke_post = "U" if smoke_post != "Y" & ((smokes3 == 2 | smokes3 == .) & (smokes4 == 2 | smokes4 == .)) 
replace smoke_post = "N" if smoke_post == ""
replace smoke_post = "" if smokes3 == . & smokes4 == .

encode smoke_pre , gen (smoke_pre2) label (smoke)
encode smoke_post , gen (smoke_post2) label (smoke)
drop smoke_pre smoke_post
rename smoke_pre2 smoke_pre
rename smoke_post2 smoke_post

gen smoke_final = "Y" if smoke_pre == 1 | smoke_post == 1
replace smoke_final = "N" if smoke_final != "Y"
encode smoke_final, gen(smoke_final2) label (smoke)
drop smoke_final
rename smoke_final2 smoke_final

save "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/summary/smoke_master_reshape_round.dta", replace
keep Suite smoke_final
save "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/summary/smoke_master_final.dta", replace

use "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/summary/smoke_master_reshape_round.dta", clear

drop smokes* smoke_final

reshape long smoke, i(Suite) j(Stage) string

drop if smoke == .

replace Stage = "Pre" if Stage == "_pre"
replace Stage = "Post" if Stage == "_post"

do "${path2}/TAF UofT IEQ Study/ado/label_tsp.do"
encode Stage, gen(stage) label(stage)
drop Stage
// obs 182

merge 1:m Suite stage using "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/summary/smoke_master.dta"
drop if season == .
drop _merge smokes

so Suite stage 
order Suite stage season smoke
rename smoke smokes
drop if season == .
save "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/summary/smoke_master.dta", replace

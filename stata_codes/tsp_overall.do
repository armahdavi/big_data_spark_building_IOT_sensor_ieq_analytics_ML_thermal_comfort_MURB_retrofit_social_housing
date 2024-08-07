* to sketch TSP data versus smoke, season, and retrofit stage- overall

set more off
drop _all

// Reading x-axis cases
import excel "${path2}/TAF UofT IEQ Study/ado/graphs/case_identifier.xlsx", clear firstrow
save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_housing\processed\case_identifier.dta", replace

// Reading tsp and identifying building no.
use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta", clear
rename smokes smoke
gen bldg_no = substr(Suite,3,1)
destring bldg_no, replace

// labeling and sorting
do "${path2}/TAF UofT IEQ Study/ado/label_tsp.do"
* encode stage, gen (stage) label(stage)
* encode season, gen (season) label(season)
* encode smoke_evidence, gen (smoke) label(smoke)

so bldg stage season smoke
* drop stage Season smoke_evidence

// Merging tsp data with x-axis cases
merge m:1 bldg season smoke stage using "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_housing\processed\case_identifier.dta"
drop if _merge == 2
drop _merge

// Reading statistics of TSP concentration data for graph labeling
sum tsp_conc if smoke == 0, detail
local med_nosmoke = `r(p50)'
sum tsp_conc if smoke == 1, detail
local med_smoke = `r(p50)'

sum tsp_conc if season == 1, detail
local med_summer = `r(p50)'
sum tsp_conc if season == 2, detail
local med_fall = `r(p50)'

sum tsp_conc if stage == 1, detail
local med_pre = `r(p50)'
sum tsp_conc if stage == 2, detail
local med_post = `r(p50)'


local i 1
whil `i' <= 7 {
	count if bldg_no == `i' & smoke == 1
	local ind_`i'_smoke = `r(N)'
	count if bldg_no == `i' & smoke == 0
	local ind_`i'_nonsmoke = `r(N)' 
	local ++i
	}


// Box plot of concentrations vs. building number and smole
#delimit ;
graph box tsp_conc, over(smoke) over(bldg, label(nolab)) asyvars noout note("")
box(1, col(gs9)) box(2, col(black))
ylabel(1 10 100 1000 , tposition(crossing) angle(horizontal) nogrid)
yscale(range(1 1000) log)
legend(order(1 "No Smoke" 2 "Smoke"))
ytitle("TSP Concentration (µg/m{superscript:3})", size (large)) 

plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(zero) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(t=11 b=9 l =10))

text(700 7.1 "A", size(medium))
text(700 21.4 "B", size(medium))
text(700 35.7 "C", size(medium))
text(700 50 "D", size(medium))
text(700 64.3 "E", size(medium))
text(700 79.6 "F", size(medium))
text(700 92.9 "G", size(medium))

text(40 3 "n = `ind_1_nonsmoke'", size(vsmall) orientation(vertical))
text(45 17.5 "n = `ind_2_nonsmoke'", size(vsmall) orientation(vertical))
text(70 32 "n = `ind_3_nonsmoke'", size(vsmall) orientation(vertical))
text(40 46.5 "n = `ind_4_nonsmoke'", size(vsmall) orientation(vertical))
text(70 61 "n = `ind_5_nonsmoke'", size(vsmall) orientation(vertical))
text(90 75.5 "n = `ind_6_nonsmoke'", size(vsmall) orientation(vertical))
text(150 90 "n = `ind_7_nonsmoke'", size(vsmall) orientation(vertical))

text(300 8.5 "n = `ind_1_smoke'", size(vsmall) orientation(vertical))
text(200 23 "n = `ind_2_smoke'", size(vsmall) orientation(vertical))
text(250 38 "n = `ind_3_smoke'", size(vsmall) orientation(vertical))
text(100 53 "n = `ind_4_smoke'", size(vsmall) orientation(vertical))
text(200 67.5 "n = `ind_5_smoke'", size(vsmall) orientation(vertical))
text(250 82 "n = `ind_6_smoke'", size(vsmall) orientation(vertical))
text(150 96.5 "n = `ind_7_smoke'", size(vsmall) orientation(vertical))

;
#delimit cr


graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\tsp_by_smoke.gph", replace
graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\tsp_by_smoke.eps", replace


// scatter plot of concentrations vs. building number, season, retrofit stage and smoke

* Color code - Season: red (summer) vs. blue (fall)
* Symbod code - Retrofti stage: Pre (X) vs. post (O)

#delimit ;
twoway (
scatter tsp_conc case_id_2 if bldg == 1 & stage == 1 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(X) msize(small) 

ytitle("TSP Concentration (µg/m{superscript:3})", size (large)) 
ylabel( 1 10 100 1000 , tposition(crossing) angle(horizontal) nogrid)
yscale(range(1 1000) log )
xscale(range(0 21))
xlabel(none, tpos(none)) 
xtick(, noticks) 
xtitle("") 
text(0.5 10.5 "Smoking - N: No, Y: Yes", size(medium))

legend(order(1 "Summer Pre-Retrofit" 2 "Summer Post-Retrofit" 3 "Fall Pre-Retrofit" 4 "Fall Post-Retrofit") position(12))

plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(zero) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(t=11 b=9 l =10))

xli(3 6 9 12 15 18, lp(dash) lc(gs4))

text(0.8 1 "N", size(small))
text(0.8 2 "Y", size(small))

text(0.8 4 "N", size(small))
text(0.8 5 "Y", size(small))

text(0.8 7 "N", size(small))
text(0.8 8 "Y", size(small))

text(0.8 10 "N", size(small))
text(0.8 11 "Y", size(small))

text(0.8 13 "N", size(small))
text(0.8 14 "Y", size(small))

text(0.8 16 "N", size(small))
text(0.8 17 "Y", size(small))

text(0.8 19 "N", size(small))
text(0.8 20 "Y", size(small))

text(700 1.5 "A", size(medium))
text(700 4.5 "B", size(medium))
text(700 7.5 "C", size(medium))
text(700 10.5 "D", size(medium))
text(700 13.5 "E", size(medium))
text(700 16.5 "F", size(medium))
text(700 19.5 "G", size(medium))
)

(scatter tsp_conc case_id_2 if bldg == 1 & stage == 2 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(circle) msize(small)) 
(scatter tsp_conc case_id_2 if bldg == 1 & stage == 1 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(X) msize(small))	
(scatter tsp_conc case_id_2 if bldg == 1 & stage == 2 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(circle) msize(small))

(scatter tsp_conc case_id_2 if bldg == 1 & stage == 1 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 1 & stage == 2 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 1 & stage == 1 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 1 & stage == 2 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(circle) msize(small))


(scatter tsp_conc case_id_2 if bldg == 2 & stage == 1 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 2 & stage == 2 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 2 & stage == 1 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 2 & stage == 2 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(circle) msize(small))

(scatter tsp_conc case_id_2 if bldg == 2 & stage == 1 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 2 & stage == 2 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 2 & stage == 1 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 2 & stage == 2 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(circle) msize(small))


(scatter tsp_conc case_id_2 if bldg == 3 & stage == 1 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 3 & stage == 2 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 3 & stage == 1 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 3 & stage == 2 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(circle) msize(small))

(scatter tsp_conc case_id_2 if bldg == 3 & stage == 1 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 3 & stage == 2 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 3 & stage == 1 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 3 & stage == 2 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(circle) msize(small))


(scatter tsp_conc case_id_2 if bldg == 4 & stage == 1 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 4 & stage == 2 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 4 & stage == 1 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 4 & stage == 2 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(circle) msize(small))

(scatter tsp_conc case_id_2 if bldg == 4 & stage == 1 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 4 & stage == 2 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 4 & stage == 1 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 4 & stage == 2 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(circle) msize(small))


(scatter tsp_conc case_id_2 if bldg == 5 & stage == 1 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 5 & stage == 2 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 5 & stage == 1 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 5 & stage == 2 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(circle) msize(small))

(scatter tsp_conc case_id_2 if bldg == 5 & stage == 1 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 5 & stage == 2 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 5 & stage == 1 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 5 & stage == 2 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(circle) msize(small))


(scatter tsp_conc case_id_2 if bldg == 6 & stage == 1 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 6 & stage == 2 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 6 & stage == 1 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 6 & stage == 2 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(circle) msize(small))

(scatter tsp_conc case_id_2 if bldg == 6 & stage == 1 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 6 & stage == 2 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 6 & stage == 1 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 6 & stage == 2 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(circle) msize(small))


(scatter tsp_conc case_id_2 if bldg == 7 & stage == 1 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 7 & stage == 2 & season == 1 & smoke == 0, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 7 & stage == 1 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 7 & stage == 2 & season == 2 & smoke == 0, mcol(blue) mfcol(white) msymbol(circle) msize(small))

(scatter tsp_conc case_id_2 if bldg == 7 & stage == 1 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 7 & stage == 2 & season == 1 & smoke == 1, mcol(red) mfcol(white) msymbol(circle) msize(small))
(scatter tsp_conc case_id_2 if bldg == 7 & stage == 1 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(X) msize(small))
(scatter tsp_conc case_id_2 if bldg == 7 & stage == 2 & season == 2 & smoke == 1, mcol(blue) mfcol(white) msymbol(circle) msize(small))


;
#delimit cr

graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\scatter_tsp_by_smoke_stage_season.gph", replace
graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\scatter_tsp_by_smoke_stage_season.eps", replace



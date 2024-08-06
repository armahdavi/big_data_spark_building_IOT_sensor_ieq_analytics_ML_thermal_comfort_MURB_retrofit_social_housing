* Program to track TSP concentrations in smoking and non-smoking suites over deployment rounds

// Reading TSP master dataset building by building (1 to 7)
set more off
drop _all

use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta", clear

drop if substr(Suite,3,1) != "1"
so Suite
levelsof Suite
foreach item in `r(levels)' {
	count if Suite == "`item'"
	drop if Suite == "`item'" & `r(N)' == 1
	}
order Suite smokes tsp_conc

keep if Suite == "mr1_02bi"
save "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/Social_housing/processed/temp_suite_smoke_diff.dta", replace


use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta", clear

drop if substr(Suite,3,1) != "2"
so Suite
levelsof Suite
foreach item in `r(levels)' {
	count if Suite == "`item'"
	drop if Suite == "`item'" & `r(N)' == 1
	}
order Suite smokes tsp_conc
keep if Suite == "mr2_02bb"
append using "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/Social_housing/processed/temp_suite_smoke_diff.dta"
save "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/Social_housing/processed/temp_suite_smoke_diff.dta", replace

use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta", clear
drop if substr(Suite,3,1) != "4"
so Suite
levelsof Suite
foreach item in `r(levels)' {
	count if Suite == "`item'"
	drop if Suite == "`item'" & `r(N)' == 1
	}
order Suite smokes tsp_conc
keep if Suite == "mr4_02ai" | Suite == "mr4_03ah"
append using "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/Social_housing/processed/temp_suite_smoke_diff.dta"
save "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/Social_housing/processed/temp_suite_smoke_diff.dta", replace

use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta", clear
drop if substr(Suite,3,1) != "5"
so Suite
levelsof Suite
foreach item in `r(levels)' {
	count if Suite == "`item'"
	drop if Suite == "`item'" & `r(N)' == 1
	}
order Suite smokes tsp_conc
keep if Suite == "mr5_03ag" | Suite == "mr5_06ae" | Suite == "mr5_09ad"
append using "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/Social_housing/processed/temp_suite_smoke_diff.dta"
save "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/Social_housing/processed/temp_suite_smoke_diff.dta", replace


use "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta", clear
drop if substr(Suite,3,1) != "6"
so Suite
levelsof Suite
foreach item in `r(levels)' {
	count if Suite == "`item'"
	drop if Suite == "`item'" & `r(N)' == 1
	}
order Suite smokes tsp_conc
keep if Suite == "mr6_06ac" | Suite == "mr6_09aj" | Suite == "mr6_11ac"
append using "${path2}/TAF UofT IEQ Study/Data/Processed Data/UofT/temp_suite_smoke_diff"
save "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/Social_housing/processed/temp_suite_smoke_diff.dta", replace


// Graphing
so Suite round
#delimit ;
twoway (
line tsp_conc round if Suite == "mr1_02bi", lcol(black) 

ylabel(10 30 100, tposition(crossing) angle(horizontal) nogrid)
ytitle("TSP Concentration (µg/m{superscript:3})", size (mede)) 
yscale(range(6 200) log)
xscale(range(1.5 4.5))
xlabel(none, tpos(none)) 
xtick(, noticks) 
xtitle("")
legend(on)
legend(order(1 "mr1_02bi" 2 "mr2_02bb" 3 "mr4_03ah" 4 "mr4_02ai" 5 "mr5_09ad" 6 "mr5_06ae" 7 "mr5_03ag" 8 "mr6_11ac" 9 "mr6_09aj" 10 "mr6_06ac"))
legend(pos(12) ring(1) size(tiny) rows(2) colfirst rowgap(0))

plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(zero) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(t=11 b=9 l =10))

text(5 2 "Fall 2015", size(small)) 
text(5 3 "Summer 2017", size(small))
text(5 4 "Fall 2017", size(small))

text(4 3 "Deployment Round", size(medsmall))
)

(line tsp_conc round if Suite == "mr2_02bb", lcol(blue) )
(line tsp_conc round if Suite == "mr4_03ah", lcol(green))
(line tsp_conc round if Suite == "mr4_02ai", lcol(brown))
(line tsp_conc round if Suite == "mr5_09ad", lcol(orange) )
(line tsp_conc round if Suite == "mr5_06ae", lcol(red))
(line tsp_conc round if Suite == "mr5_03ag", lcol(pink) )
(line tsp_conc round if Suite == "mr6_11ac", lcol(gs10))
(line tsp_conc round if Suite == "mr6_09aj", lcol(gs5))
(line tsp_conc round if Suite == "mr6_06ac", lcol(yellow))

(scatter tsp_conc round if smoke_evidence == "Y" & Suite == "mr1_02bi", mcol(black) msymbol(circle) mfcol(black))
(scatter tsp_conc round if smoke_evidence == "N" & Suite == "mr1_02bi", mcol(black) msymbol(circle) mfcol(white))

(scatter tsp_conc round if smoke_evidence == "Y" & Suite == "mr2_02bb", mcol(blue) msymbol(circle) mfcol(blue))
(scatter tsp_conc round if smoke_evidence == "N" & Suite == "mr2_02bb", mcol(blue) msymbol(circle) mfcol(white))

(scatter tsp_conc round if smoke_evidence == "Y" & Suite == "mr4_03ah", mcol(green) msymbol(circle) mfcol(green))
(scatter tsp_conc round if smoke_evidence == "N" & Suite == "mr4_03ah", mcol(green) msymbol(circle) mfcol(white))

(scatter tsp_conc round if smoke_evidence == "Y" & Suite == "mr4_02ai", mcol(brown) msymbol(circle) mfcol(brown))
(scatter tsp_conc round if smoke_evidence == "N" & Suite == "mr4_02ai", mcol(brown) msymbol(circle) mfcol(white))

(scatter tsp_conc round if smoke_evidence == "Y" & Suite == "mr5_09ad", mcol(orange) msymbol(circle) mfcol(orange))
(scatter tsp_conc round if smoke_evidence == "N" & Suite == "mr5_09ad", mcol(orange) msymbol(circle) mfcol(white))

(scatter tsp_conc round if smoke_evidence == "Y" & Suite == "mr5_06ae", mcol(red) msymbol(circle) mfcol(red))
(scatter tsp_conc round if smoke_evidence == "N" & Suite == "mr5_06ae", mcol(red) msymbol(circle) mfcol(white))

(scatter tsp_conc round if smoke_evidence == "Y" & Suite == "mr5_03ag", mcol(pink) msymbol(circle) mfcol(pink))
(scatter tsp_conc round if smoke_evidence == "N" & Suite == "mr5_03ag", mcol(pink) msymbol(circle) mfcol(white))

(scatter tsp_conc round if smoke_evidence == "Y" & Suite == "mr6_11ac", mcol(gs10) msymbol(circle) mfcol(gs10))
(scatter tsp_conc round if smoke_evidence == "N" & Suite == "mr6_11ac", mcol(gs10) msymbol(circle) mfcol(white))

(scatter tsp_conc round if smoke_evidence == "Y" & Suite == "mr6_09aj", mcol(gs5) msymbol(circle) mfcol(gs5))
(scatter tsp_conc round if smoke_evidence == "N" & Suite == "mr6_09aj", mcol(gs5) msymbol(circle) mfcol(white))

(scatter tsp_conc round if smoke_evidence == "Y" & Suite == "mr6_06ac", mcol(yellow) msymbol(circle) mfcol(yellow))
(scatter tsp_conc round if smoke_evidence == "N" & Suite == "mr6_06ac", mcol(yellow) msymbol(circle) mfcol(white))

;
#delimit cr

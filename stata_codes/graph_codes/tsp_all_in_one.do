* Program to sketch all TSP concentrations ordered by retrofit round, and the magnitude of TSP

set more off
use "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/summary/tsp_master.dta", clear

so stage season smokes tsp_conc
drop if smokes == .
drop if season == 1 & stage == 1

gen case_id = _n 
replace case_id = _n + 1 if stage == 1 & season == 2 & smokes == 1

replace case_id = _n + 10 if stage == 2 & season == 1 & smokes == 0
replace case_id = _n + 11 if stage == 2 & season == 1 & smokes == 1

replace case_id = _n + 15 if stage == 2 & season == 2 & smokes == 0
replace case_id = _n + 16 if stage == 2 & season == 2 & smokes == 1

gen tsp_min = tsp_conc - tsp_conc_error
gen tsp_max = tsp_conc + tsp_conc_error

replace tsp_conc = 200 if tsp_conc > 200
replace tsp_max = 200 if tsp_max > 200


#delimit ;
graph twoway (
bar tsp_conc case_id if smokes == 0, col(gs16) lcol(black)
xscale(range(-1 154)) 

legend(on)
legend(order(1 "No Smoke"  2 "Smoke" ))
legend(ring(1) position(12) rows(1) size(medlarge))
xtitle("")
xlabel(none ,tlength(0))
yscale(range(0 200))
ylabel(0 (50) 200,   angle(horizontal) nogrid tpos(out) ) 
ytitle("Concentrations (µg/m{superscript:3})", size(large)  height(4) orientation(vertical))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(zero) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(vlarge))

text(-13 17 "Pre-retrofit Fall", size(small))
text(-13 71 "Post-retrofit Spring", size(small))
text(-13 128 "Post-retrofit Fall", size(small))

text(100 10 "n = 21", size(small))
text(150 27 "n = 13", size(small))

text(100 62 "n = 35", size(small))
text(150 90 "n = 18", size(small))

text(100 118 "n = 33", size(small))
text(150 144 "n = 16", size(small))

)

(bar tsp_conc case_id if smokes == 1, col(gs4) lcol(black))
(rcap tsp_min tsp_max case_id, lcol(black) lpattern(shortdash) msize(zero))

;
#delimit cr

blah
set more off
use "C:\Users\alima\Google Drive\TAF UofT IEQ Study\Data\Processed Data\UofT\shortTerm\summary\tsp_master.dta", clear

so stage season smokes tsp_conc
drop if smokes == .

gen case_id = _n 
replace case_id = _n + 1 if stage == 1 & season == 1 & smokes == 1

replace case_id = _n + 5 if stage == 1 & season == 2 & smokes == 0
replace case_id = _n + 6 if stage == 1 & season == 2 & smokes == 1

replace case_id = _n + 15 if stage == 2 & season == 1 & smokes == 0
replace case_id = _n + 16 if stage == 2 & season == 1 & smokes == 1

replace case_id = _n + 19 if stage == 2 & season == 2 & smokes == 0
replace case_id = _n + 20 if stage == 2 & season == 2 & smokes == 1

gen tsp_min = tsp_conc - tsp_conc_error
gen tsp_max = tsp_conc + tsp_conc_error

replace tsp_conc = 200 if tsp_conc > 200
replace tsp_max = 200 if tsp_max > 200

#delimit ;
graph twoway (
bar tsp_conc case_id if smokes == 0, col(gs16) lcol(black)
xscale(range(-2 175)) 

legend(on)
legend(order(1 "No Smoke"  2 "Smoke"))
legend(ring(1) position(12) rows(1) size(medlarge))
xtitle("")
xlabel(none ,tlength(0))
yscale(range(0 200))
ylabel(0 (50) 200,   angle(horizontal) nogrid tpos(out) ) 
ytitle("Concentrations (µg/m{superscript:3})", size(large)  height(4) orientation(vertical))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(zero) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(vlarge))

text(-30 28 "Pre-retrofit", size(medlarge))
text(-30 120 "Post-retrofit", size(medlarge))

text(-13 8 "Spring/Summer", size(small))
text(-13 39 "Fall", size(small))

text(-13 92 "Summer", size(small))
text(-13 147 "Fall", size(small))
)

(bar tsp_conc case_id if smokes == 1, col(gs4) lcol(black))
(rcap tsp_min tsp_max case_id, lcol(black) lpattern(shortdash) msize(zero))

;
#delimit cr

graph save "${path2}PhD Research/MURB Building IOT/Processed Data/figures/tsp_conc_ordered.gph", replace
graph export "${path2}PhD Research/MURB Building IOT/Processed Data/figures/tsp_conc_ordered.eps", replace


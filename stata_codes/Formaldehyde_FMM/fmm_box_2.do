* FMM box figures

set more off
use "C:\Users\alima\Google Drive\TAF UofT IEQ Study\Data\Processed Data\UofT\shortTerm\fmm_all.dta", clear

collapse (median) HCHO_u, by(Suite Season Stage)

merge m:m Suite using "C:\Users\alima\Google Drive\TAF UofT IEQ Study\Data\Processed Data\UofT\shortTerm\summary\smoke_master.dta"
keep if _mer == 3
drop _merge stage season
duplicates drop 

expand 2

replace smokes = 2 if _n > 50

gen  box_cat = "All"
replace box_cat = "No Smoke" if smokes == 0
replace box_cat = "Smoke" if smokes == 1


#delimit ;
graph box HCHO_u, over(smokes) asyvar noout
box (1, col(brown)) 
box (2, col(gs12)) 
box (3, col(gs4)) 

ytitle("HCHO Concentrations (µg/m{superscript:3})", size(large) height(4)) 
yscale(range(0 50))
ylabel(0 (10) 50 , angle(horizontal) nogrid tpos(centre))

legend(off)
legend(order(1 "All" 2 "No Smoke" 3 "Smoke")) 
legend(size(small)) 
legend(pos(12) ring(0) rows(1))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
note("") 

text(-3 17 "All", size(medsmall))
text(-3 50 "No Smoke", size(medsmall))
text(-3 83 "Smoke", size(medsmall))

text(46 17 "n = 24", size(medsmall))
text(45 50 "n = 17", size(medsmall))
text(46 83 "n = 7", size(medsmall))

; 
#delimit cr

* fmm periods

set more off
use "C:\Users\alima\Google Drive\TAF UofT IEQ Study\Data\Processed Data\UofT\shortTerm\fmm_all.dta", clear

collapse (median) HCHO_u, by(Suite Season Stage)

gen keepdrop =  ""
levelsof Suite
foreach suite in `r(levels)' {
	count if Suite == "`suite'"
	replace keepdrop = "keep" if `r(N)' > 1 & Suite == "`suite'"
	}

keep if keepdr == "keep"


levelsof Suite
use "C:\Users\alima\Google Drive\TAF UofT IEQ Study\Data\Processed Data\UofT\shortTerm\fmm_all.dta", clear

gen keepdrop =  ""
foreach suite in `r(levels)' {
	replace keepdrop = "keep" if Suite == "`suite'"
	}

keep if keepdr == "keep"

merge m:m Suite using "C:\Users\alima\Google Drive\TAF UofT IEQ Study\Data\Processed Data\UofT\shortTerm\summary\smoke_master.dta"
drop if _mer == 2
drop _merge stage season

gen round = 1
replace round = 2 if Stage == "Pre" & Season == "Fall"
replace round = 3 if Stage == "Post" & Season == "Summer"
replace round = 4 if Stage == "Post" & Season == "Fall"

gen bldg = substr(Suite,3,1)

#delimit ;
graph box HCHO_u if smoke == 0, over(round) over(bldg, relabel(1 "A" 2 "B" 3 "C" 4 "D" 5 "E" 6 "F" 7 "G")) asyvar noout
box (1, col(green*0.5)) 
box (2, col(blue*0.5))  
box (3, col(green))  
box (4, col(blue))

ytitle("HCHO Concentrations (µg/m{superscript:3})", size(large) height(4)) 
yscale(range(0 85))
ylabel(0 (20) 80 , angle(horizontal) nogrid tpos(centre))

legend(on)
legend(order(1 "Pre-retrofit Spring" 2 "Pre-retrofit Fall" 3 "Post-retrofit Spring" 4 "Post-retrofit Fall")) 
legend(size(1.5)) 
legend(pos(12) ring(1) rows(1))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
note("") 
text(80 12 "Non-smoking Suites", size(small))


; 
#delimit cr

graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\fmm_box_non_smoke.gph", replace
graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\fmm_box_non_smoke.eps", replace



blah

#delimit ;
graph box HCHO_u if smoke == 1, over(round) over(bldg, relabel(1 "A" 2 "B" 3 "C" 4 "D" 5 "E" 6 "F" 7 "G")) asyvar noout
box (1, col(green*0.5)) 
box (2, col(blue*0.5))  
box (3, col(green))  
box (4, col(blue))

ytitle("HCHO Concentrations (µg/m{superscript:3})", size(large) height(4)) 
yscale(range(0 85))
ylabel(0 (20) 80 , angle(horizontal) nogrid tpos(centre))

legend(on)
legend(order(1 "Pre-retrofit Spring" 2 "Pre-retrofit Fall" 3 "Post-retrofit Spring")) 
legend(size(vsmall)) 
legend(pos(12) ring(1) rows(1))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
note("") 

text(80 12 "Smoking Suites", size(small))

; 
#delimit cr

graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\fmm_box_smoke.gph", replace
graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\fmm_box_smoke.eps", replace


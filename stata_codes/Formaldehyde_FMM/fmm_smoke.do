* Illustrate FMM vs. buildings

set more off
use "${path2}PhD Research/MURB Building IOT/Processed Data/fmm_all.dta", clear
collapse (median) HCHO_u, by(Suite Season Stage)

gen keepdrop =  ""
levelsof Suite
foreach suite in `r(levels)' {
	count if Suite == "`suite'"
	replace keepdrop = "keep" if `r(N)' > 1 & Suite == "`suite'"
	}

keep if keepdr == "keep"

levelsof Suite
use "${path2}PhD Research/MURB Building IOT/Processed Data/fmm_all.dta", clear

gen keepdrop =  ""
foreach suite in `r(levels)' {
	replace keepdrop = "keep" if Suite == "`suite'"
	}

keep if keepdr == "keep"

merge m:m Suite using "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/summary/smoke_master.dta"
drop if _mer == 2
drop _merge stage season

/*gen HCHO_smoke = HCHO_u if smoke == 1
replace HCHO_u = . if smoke == 1

order Suite HCHO_u HCHO_smoke 
*/

gen bldg = substr(Suite,3,1)

#delimit ;
graph box HCHO_u, over(smoke) over(bldg, relabel(1 "A" 2 "B" 3 "C" 4 "D" 5 "E" 6 "F" 7 "G")) asyvar noout
box (1, col(gs12)) 
box (2, col(gs4)) 

ytitle("HCHO Concentrations (µg/m{superscript:3})", size(large) height(4)) 
yscale(range(0 85))
ylabel(0 (20) 80 , angle(horizontal) nogrid tpos(centre))

legend(on)
legend(order(1 "No Smoke" 2 "Smoke")) 
legend(size(small)) 
legend(pos(12) ring(0) rows(1))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
note("") 

text(21 3 "n = 1", size(small))
text(75 9 "n = 1", size(small))

text(63 18 "n = 2", size(small))
text(70 24 "n = 1", size(small))

text(51 32 "n = 2", size(small))
text(34 38 "n = 1", size(small))

text(18 47 "n = 1", size(small))
text(28 53 "n = 1", size(small))

text(50 62 "n = 4", size(small))

text(68 76 "n = 2", size(small))

text(82 91 "n = 2", size(small))

; 
#delimit cr

graph save "${path2}PhD Research/MURB Building IOT/Processed Data/figures/fmm_box_bldg_smoke.gph", replace
graph save "${path2}PhD Research/MURB Building IOT/Processed Data/figures/fmm_box_bldg_smoke.eps", replace


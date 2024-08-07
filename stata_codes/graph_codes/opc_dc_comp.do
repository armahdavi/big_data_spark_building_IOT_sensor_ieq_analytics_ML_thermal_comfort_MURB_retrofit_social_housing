* Program to graph OPC vs DC for pm large, median, and small channels


// Reading all opc files and append them
drop _all
local files: dir "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/dc_opc_adjust" files "opc_*.dta"
local i 1
foreach file in `files' { // this loop appends all the files from separate units (both opc and dc)
	use "${path2}PhD Research/Processed Data/shortTerm/dc_opc_adjust/`file'", clear
	gen loc = substr("`file'",13,8)
	gen date = substr("`file'",-10,6)
	
	if `i' == 1 {
		save "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/dc_opc_adjust/comb_opc_dc.dta", replace
		}
	else {
		append using "${path2}PhD Research/MURB Building IOT/Processed Data/UofT/shortTerm/dc_opc_adjust/comb_opc_dc.dta"
		save "${path2}PhD Research/MURB Building IOT/shortTerm/dc_opc_adjust/comb_opc_dc.dta", replace
		}
	local ++i
	}

// Clean up all and generate mid size bin
drop loc date
append using "${path2}PhD Research/MURB Building IOT/Processed Data/shortTerm/dc_opc_adjust/comb_opc_dc.dta"
replace loc = "all" if loc == ""
replace date = "all" if date == ""
gen med_bin = small_bin - large_bin

drop if substr(loc,1,3) != "mr2" // this is hard-coding: to remove the observations where opc and dc periods are not the same


// Graphing: comparing two sensors

* Small bin
#delimit ;
graph box small_bin, over(device) over(loc) asyvars noout
box (1, col(purple)) box (2, col(green))

ytitle((Concentration: #/m{superscript:3}), size(large)) 
yscale(range(10000 100000000) log)
ylabel(10000 100000 1000000 10000000 100000000 1000000000, format(%1.0e) nogrid angle(horizontal) valuelabel tposition(crossing) labsize(medlarge))

legend(on)
legend(order(1 "DC" 2 "OPC")) 
legend(size(large)) 
legend(pos(1) ring(0))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
note("") 

; 
#delimit cr

graph save "${path2}PhD Research/MURB Building IOT/Processed Data/figures/small_bin.gph", replace
graph export "${path2}PhD Research/MURB Building IOT/Processed Data/figures/small_bin.eps", replace



* Large bin
#delimit ;
graph box large_bin if large_bin > 0, over(device) over(loc) asyvars noout
box (1, col(purple)) box (2, col(green))

ytitle((Concentration: #/m{superscript:3}), size(large)) 
yscale(range(10000 100000000) log)
ylabel(10000 100000 1000000 10000000 100000000 1000000000, format(%1.0e) nogrid angle(horizontal) valuelabel tposition(crossing) labsize(medlarge))

legend(on)
legend(order(1 "DC" 2 "OPC")) 
legend(size(large)) 
legend(pos(1) ring(0))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
note("") 

; 
#delimit cr

graph save "${path2}PhD Research/MURB Building IOT/Processed Data/figures/small_bin.gph", replace
graph export "${path2}PhD Research/MURB Building IOT/Processed Data/figures/small_bin.eps", replace


* Medium bin
#delimit ;
graph box med_bin if med_bin > 0, over(device) over(loc) asyvars noout
box (1, col(purple)) box (2, col(green))

ytitle((Concentration: #/m{superscript:3}), size(large)) 
yscale(range(10000 100000000) log)
ylabel(10000 100000 1000000 10000000 100000000 1000000000, format(%1.0e) nogrid angle(horizontal) valuelabel tposition(crossing) labsize(medlarge))

legend(on)
legend(order(1 "DC" 2 "OPC")) 
legend(size(large)) 
legend(pos(1) ring(0))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
note("") 

; 
#delimit cr

graph save "${path2}PhD Research/MURB Building IOT/Processed Data/figures/small_bin.gph", replace
graph export "${path2}PhD Research/MURB Building IOT/Processed Data/figures/small_bin.eps", replace


// Other notes
/*
dc/opc

ec
Mean: 280/175
Median: 180/102

db
Mean 3.54/4.38
Median: 1.20/1.01

all
Mean 1.91/2.28 
Median 442/201

Steps:
1- See if large channel by including channel 6 in full

ec
Mean: 280/175
Median: 180/102

db
Mean 3.54/4.38
Median: 1.20/1.02

all
Mean 1.91/2.28 
Median 442/201
*/

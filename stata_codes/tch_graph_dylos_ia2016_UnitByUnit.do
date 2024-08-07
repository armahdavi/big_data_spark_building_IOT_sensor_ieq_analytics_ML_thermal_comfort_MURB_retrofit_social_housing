* Program to sketch PM concentrations (small bin number) vs. building type and smoke status (suite by suite)

// Reading PM data and refining
use "${path2}PhD Research/MURB Building IOT/Processed Data/STcompleteAppend.dta", clear

// Graphing
#delimit ;
graph box small_countm3 if small_countm3  > 100000 & small_countm3  <100000000, over(smokes2, ax(off)  ) over(locID, ax(off)  ) asyvars noout
box (1, col(purple)) box (2, col(green))

ytitle(PM > 0.5 µm (#/m{superscript:3}), size(large)) 
yscale(range(100000 100000000) log)
ylabel(100000 300000 1000000 3000000 10000000 30000000 100000000 , format(%1.0e) nogrid angle(horizontal) valuelabel tposition(crossing) labsize(medlarge))

text(40000 50 "Building ID", size (vlarge))

legend(on)
legend(order(1 "Smoking" 2 "Non-smoking")) 
legend(size(large)) 
legend(pos(1) ring(0))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
note("") 
text(70000 `plot1' "A", size (large))
text(70000 `plot2' "B", size (large))
text(70000 `plot3' "C", size (large))
text(70000 `plot4' "D", size (large))
text(70000 `plot5' "E", size (large))
text(70000 `plot6' "F", size (large))
text(70000 `plot7' "G", size (large))

yli(`med_smoke', lp(dash) lc(gs4))
yli(`med_nosmoke', lp(solid) lc(gs10))

; 
#delimit cr

graph save "${path2}PhD Research/MURB Building IOT/Processed Data/figures/ia2016_fig2_UnitByUnit.gph", replace
graph export "${path2}PhD Research/MURB Building IOT/Processed Data/figures/ia2016_fig2_UnitByUnit.eps", replace


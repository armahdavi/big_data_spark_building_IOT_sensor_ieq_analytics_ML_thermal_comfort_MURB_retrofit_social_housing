* Program to process and graph CF2.5 and CF10 (ratios of PMs to TSP)

// reading opc data from R-code processed
use "C:\Users\alima\Google Drive\TAF UofT IEQ Study\Paper\R\Objects\opc_dataframe.dta", clear
drop if measurements_nonzero_small < 15000
drop if measurements_nonzero_large < 15000

collapse (mean) pm25_conc pm10_conc, by(unit season pre_post)

rename unit_ID Suite
rename pre_post stage

// bringing labels for season labelling
do "Google Drive\TAF UofT IEQ Study\ado\label_tsp.do"
encode season, gen(season2) label(season3)
encode stage, gen(stage2) label(stage)

drop season stage
ren season2 season
ren stage2 stage

save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_housing\processed\tsp_pm.dta", replace

// merging smoke and season data
use "C:\Users\alima\Google Drive\TAF UofT IEQ Study\Data\tch_st_sensor_master_spreadsheet.dta", clear
keep if tsp_conc != . 
keep if stage == 2
keep Suite stage season smoke_final tsp*
rename smoke smoke

merge m:m Suite season using "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_housing\processed\tsp_pm.dta"
keep if _mer == 3
drop _merge

// final corrections and clean-up
gen conc_error = "Err" if tsp_conc < pm10 | tsp_conc < pm25
drop if conc_error == "Err"
gen pm_above_10 = tsp_conc - pm10
gen pm_25_10 = pm10 - pm25

so smoke season tsp_conc

capture drop case_id
gen case_id = _n + 1
replace case_id = _n + 3 if season == 2 & smoke == 0

replace case_id = _n + 7 if season == 1 & smoke == 1
replace case_id = _n + 9 if season == 2 & smoke == 1

duplicates drop

// Graphing
* Bar graph showing contributions of PMs to TSP
#delimit;
twoway 
(bar tsp_conc pm10 pm_25 case_id,

xscale(range(0 82))    
xlabel(none, angle(horizontal) nogrid tpos(crossing))
xtitle("")

yscale(range(0 210))    
ylabel(0 (50) 200, angle(horizontal) nogrid tpos(crossing))
ytitle("Concentration (µg/m{superscript:3})", size(large) orientation(vertical))
graphregion(color(white) margin(medium))

legend(on)
legend(order(3 "PM{subscript:2.5}" 2 "PM{subscript:10}" 1 "TSP")) 
legend(size(small)) 
legend(pos(12) ring(0) rows(1))

plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(zero) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))

text(-5 16 "Spring No Smoke", size(vsmall))
text(-5 45 "Fall No Smoke", size(vsmall))
text(-5 65.5 "Spring Smoke", size(vsmall))
text(-5 76.5 "Fall Smoke", size(vsmall))

)
;
#delimit cr

graph save "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/stata/figures/pm_conc_bar.gph", replace
graph export "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/stata/figures/pm_conc_bar.eps", replace

* Scatter plot showing correlations of TSP and PMs
gen line1 = 0 in 1 
replace line1 = 210 in 2


#delimit ;
twoway (
scatter tsp_conc pm10, mcol(red) msymbol(circle)

legend(order(1 "FF" 2 "QFF"))
legend(on)
legend(ring(0) position(1) cols(1)) 
ylabel(0 (50) 200, tposition(crossing) angle(horizontal) nogrid)
ytitle("TSP Concentration (µg/m{superscript:3})", size (large)) 
yscale(range(0 210))
xscale(range(0 210))
xlabel(0 (50) 200, tpos(none)) 
xtick(, noticks) 
xtitle("PM{subscript:2.5}/PM{subscript:10} Concentration (µg/m{superscript:3})", size (large) height(6))

legend(order(1 "PM{subscript:2.5}" 2 "PM{subscript:10}"))
legend(pos(5) ring(0) size(small) rows(1) colfirst)

plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(zero) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(large))

)

(scatter tsp_conc pm_25 , mcol(green) msymbol(circle))
(line line1 line1, mcol(black) )

;
#delimit cr

graph save "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/stata/figures/pm_conc_scatter.gph", replace
graph export "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/stata/figures/pm_conc_scatter.eps", replace



/*
bar(1, col(black) lcolor(black)) bar(2, col(gs9) lcolor(black)) bar(3, col(gs13) lcolor(black)) bar(4, col(brown) lcolor(black)) bar(5, col(brown*0.6) lcolor(black)) bar(6, col(brown*0.3) lcolor(black))

graph bar tempjan tempjuly, over(region) stack

bar trbc_post_centername trbc_intra_centername if region_label=3D=3D1, stac= k percent fcolor(red) lcolor(red)))

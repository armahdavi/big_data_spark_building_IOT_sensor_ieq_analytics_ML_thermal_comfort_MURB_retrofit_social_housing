* Program to sketch PM concentrations (small bin number) vs. building tupe and smoke status

// Reading PM data and refining
set more off
use "${path}Google Drive/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/STcompleteAppend (1).dta", clear

capture gen buildingID = substr(locID,1,3)
capture encode locID, gen(locCode)
encode buildingID, gen(buildCode)
gen byte smokes2 = .
replace smokes2 = 1 if smokes =="Yes"
replace smokes2 = 2 if smokes =="No"
capture gen IDfloor = substr(locID,5,2)
save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_Housing\processed\PM_for_plot.dta", replace

// Summarizing statistical medians of each group for labeling later in the figure
quietly sum small_countm3 if (small_countm3  > 100000 & small_countm3  <100000000) & smokes2==1, d
local med_smoke = `r(p50)'
quietly sum small_countm3 if (small_countm3  > 100000 & small_countm3  <100000000) & smokes2==2, d
local med_nosmoke = `r(p50)'
quietly sum large_countm3 if (small_countm3  > 10000 & small_countm3  <10000000) & smokes2==1, d //for adding line indicators for median of large particles to the figure, AM
local med_smoke_large = `r(p50)'
quietly sum large_countm3 if (small_countm3  > 10000 & small_countm3  <10000000) & smokes2==1, d //for adding line indicators for median of large particles to the figure, AM
local med_nosmoke_large = `r(p50)' 

// Making a groupby by building
collapse (median) small_countm3 smokes2, by(locID)
drop if small_countm3  < 100000 | small_countm3  >100000000
gen byte bldg = real(substr(locID,3,1))
local bldg 1

// Additional locals for labeling in the graph: Building ID and number of smoking units
while `bldg' <=7 {
		quietly sum bldg if bldg  ==`bldg' 
		local numunits`bldg' =  `r(N)'
		quietly sum bldg if bldg  ==`bldg' & smokes2 == 1
		local numsmoke`bldg' =  `r(N)'
		local numnonsmoke`bldg' = `numunits`bldg'' -`numsmoke`bldg''
		di "`numunits`bldg''"
						
		di "`numsmoke`bldg''"
		di "`numnonsmoke`bldg''"
		local ++bldg
}

// Going back to the previous version of dataframe (non-groupby)
use "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_Housing\processed\PM_for_plot.dta", clear

gen byte bldg = real(substr(locID,3,1))
local bldg 1

while `bldg' <=7 {
		foreach smokes in 1 2 {
			quietly sum small_countm3 if bldg  ==`bldg' & smokes2==`smokes' & small_countm3  > 100000 & small_countm3  <100000000, d
			if "`r(p95)'" == "" {
				local plot_n_`smokes'_`bldg' = 40000000
			}
			else {
				local plot_n_`smokes'_`bldg' = 40000000 
			}
			
			local j_`smokes'_`bldg' = ((`smokes'-1)+`bldg')*2 + (`bldg'-1)*(26/6)  
		}
		local ++bldg
	}



// Graphing

#delimit ;
graph box small_countm3 if small_countm3  > 100000 & small_countm3  <100000000, over(smokes2, ax(off)  ) over(buildCode, ax(off)  ) asyvars noout
box (1, col(purple)) box (2, col(green))


ytitle(PM > 0.5 µm (#/m{superscript:3}), size(large)) 
yscale(range(100000 100000000) log)
ylabel(100000 300000 1000000 3000000 10000000 30000000 100000000 , format(%1.0e) nogrid angle(horizontal) valuelabel tposition(crossing) labsize(medlarge))

legend(on)
legend(order(1 "Smoking" 2 "Non-smoking")) 
legend(size(large)) 
legend(pos(1) ring(0))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
note("") 
yli(`med_smoke', lp(dash) lc(gs4))
yli(`med_nosmoke', lp(solid) lc(gs10))
scheme(s1mono)

text(`plot_n_1_1' 3.1 "`numsmoke1'", size (medium))
text(`plot_n_2_1' 8.9 "`numnonsmoke1'", size (medium))
text(`plot_n_1_2' 17.8 "`numsmoke2'", size (medium))
text(`plot_n_2_2' 23.6 "`numnonsmoke2'", size (medium))
text(`plot_n_1_3' 32.5 "`numsmoke3'", size (medium))
text(`plot_n_2_3' 38.3 "`numnonsmoke3'", size (medium))
text(`plot_n_1_4' 47.2 "`numsmoke4'", size (medium))
text(`plot_n_2_4' 53 "`numnonsmoke4'", size (medium))
text(`plot_n_1_5' 61.9 "`numsmoke5'", size (medium))
text(`plot_n_2_5' 67.7 "`numnonsmoke5'", size (medium))
text(`plot_n_1_6' 76.6 "`numsmoke6'", size (medium))
text(`plot_n_2_6' 82.4 "`numnonsmoke6'", size (medium))
text(`plot_n_1_7' 91 "`numsmoke7'", size (medium))
text(`plot_n_2_7' 96.8 "`numnonsmoke7'", size (medium))

text(70000 5 "A", size (large))
text(70000 20 "B", size (large))
text(70000 35 "C", size (large))
text(70000 50 "D", size (large))
text(70000 65 "E", size (large))
text(70000 80 "F", size (large))
text(70000 95 "G", size (large))

text(40000 50 "Building ID", size (vlarge))

; 
#delimit cr

graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\ia2016_building_smoke.gph", replace
graph save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\stata\figures\ia2016_building_smoke.eps", replace


* program to sketch tsp data from TCH, 1649, and HUD projects

* Important note: The TSP data from HUD dta files are weird recorded in a weid way, so I recalculated them here based on the tsp mass and filtratio volume. The results are consistent to Givehchi et al. (2019) IA
* Program Steps: 
* 1- Calculate tsp data in HUD and record it in a universal file (tsp_interstudy_dta: this file will be auto-appended as the code goes on) (Line 13 -18)
* 2- Read tch tsp data (from tsp_master.dta), lable parameters as "smoke", "no smoke", and "all" (data are duplicated for "all"), and append (Line 20-32) 
* 3- Read 1649 tsp data (from d_D_qff_psd_all.dta), and append (Line 34-42)
* 4- Classify groups (Line 44-48)
* 5- Sketch the graph (Line > 50)

// Reading HUD TSP data and re-calculating TSP concentration
set more off
use "C:\Users\alima\Google Drive\TAF UofT IEQ Study\Data\Processed Data\UofT\HUD_QFF_concentration.dta", clear
gen tsp_conc = (dust_weight / k) * 1000
keep tsp_conc season site
ren site Suite
tostring Suite, replace
gen study = "HUD"

save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_housing\processed\tsp_interstudy_comp.dta", replace

// Reading Social Housing MURB TSP data  and cleaning up
use "C:\Users\alima\Google Drive\TAF UofT IEQ Study\Data\Processed Data\UofT\shortTerm\summary\tsp_master.dta", clear
drop if stage == 1 & season == 1

keep Suite tsp_conc stage smokes
gen study = "TCH Smoke"
replace study = "TCH No Smoke" if smoke == 0

expand 2
replace study = "TCH All" if _n > 136

append using "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_housing\processed\tsp_interstudy_comp.dta"

save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_housing\processed\tsp_interstudy_comp.dta", replace

// Reading RP-1649 TSP data and cleaning up
use "C:\Users\alima\Google Drive\ASHRAE_1649\data\processed\ldps\d_D_qff_psd_all.dta", clear
keep TSP_conc_ug_m3 round site
rename TSP_conc tsp_conc
rename site Suite
tostring Suite, replace
gen study = "1649"
append using "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_housing\processed\tsp_interstudy_comp.dta"

save "C:\Life\5- Career & Business Development\Portfolio - Git\Buildings IOT\Social_housing\processed\tsp_interstudy_comp.dta", replace

gen class = 1
replace class = 2 if study == "TCH No Smoke"
replace class = 3 if study == "TCH Smoke"
replace class = 4 if study == "HUD"
replace class = 5 if study == "1649"


// Graphing all TSP Data
#delimit ;
graph box tsp_conc, over(class, relabel(1 " TCH All" 2 "TCH No Smoke" 3 "TCH Smoke" 4 "HUD" 5 "RP-1649"))  asyvar noout
box (1, col(gs8)) 
box (2, col(gs12))  
box (3, col(gs2))  
box (4, col(brown*0.6))
box (5, col(brown)) 

ytitle("Concentrations (µg/m{superscript:3})", size(large) height(4)) 
yscale(range(1 1000) log)
ylabel(1 10 100 1000 , angle(horizontal) nogrid tpos(centre))

legend(off)
legend(order(1 "TCH All" 2 "TCH No Smoke" 3 "TCH Smoke" 4 "Central Texas" 5 "Toronto SFD")) 
legend(size(small)) 
legend(pos(11) ring(0) rows(2))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
note("") 

text(0.7 10 "This Study All", size(vsmall))
text(0.7 30 "This Study No Smoke", size(vsmall))
text(0.7 50 "This Study Smoke", size(vsmall))
text(0.7 70 "C. Texas SFD", size(vsmall))
text(0.7 90 "Toronto SFD", size(vsmall))

text(136 10 "n = 136", size(small))
text(79 30 "n = 89", size(small))
text(225 50 "n = 47", size(small))
text(110 70 "n = 99", size(small))
text(500 90 "n = 79", size(small))

; 
#delimit cr


graph save "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/stata/figures/tsp_all_projects.gph", replace
graph export "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/stata/figures/tsp_all_projects.eps", replace


/*
gen class = "TCH No Smoke"
replace = 
replace class = "TCH Smoke" if season == 1 & smoke == 1

replace class = "TCH f ns" if season == 2 & smoke == 0
replace class = "TCH f s" if season == 2 & smoke == 1



#delimit ;
graph box tsp_conc, over(class2)  asyvar noout
box (1, col(gs12)) 
box (2, col(gs12))  
box (3, col(gs4))  
box (4, col(gs4))
box (5, col(brown*0.2)) 
box (6, col(brown*0.5))  
box (7, col(brown*0.7))  
box (8, col(brown))

ytitle("Concentrations (µg/m{superscript:3})", size(large) height(4)) 
yscale(range(0 500))
ylabel(0 (100) 500 , angle(horizontal) nogrid tpos(centre))

legend(off)
legend(order(1 "SH Summer Non-Smoking" 2 "SH Summer Smoking" 3 "SH Fall Non-smoking" 4 "SH Fall Smkoing" 5 "1649 Winter" 6 "1649 Spring" 7 "1649 Summer" 8 "1649 Summer")) 
legend(size(medsmall)) 
legend(pos(1) ring(0) rows(4))
plotregion(fcolor(white) lcolor(black) lwidth(medium) margin(small) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none) ilpattern(solid))
graphregion(color(white) margin(l=3 r=3 b=13 t=3))
note("") 

text(200 7 "Social Housing Summer Non-smoking", size(vsmall) orientation(vertical))
text(200 19 "Social Housing Fall Non-smoking", size(vsmall) orientation(vertical))
text(300 31 "Social Housing Summer Smoking", size(vsmall) orientation(vertical))
text(350 43 "Social Housing Fall Smoking", size(vsmall) orientation(vertical))

text(200 57 "1649 Winter", size(vsmall) orientation(vertical))
text(420 69 "1649 Spring", size(vsmall) orientation(vertical))
text(400 81 "1649 Summer", size(vsmall) orientation(vertical))
text(350 93 "1649 Fall", size(vsmall) orientation(vertical))

; 
#delimit cr


//


drop if smokes == .
gen class = "TCH s ns"
replace class = "TCH s s" if season == 1 & smoke == 1

replace class = "TCH f ns" if season == 2 & smoke == 0
replace class = "TCH f s" if season == 2 & smoke == 1

append using  "C:\Users\alima\Google Drive\ASHRAE_1649\data\processed\ldps\d_D_qff_psd_all.dta"
keep Suite stage season smokes class tsp* round site TSP_conc_ug_m3 TSP_conc_error

replace class = "1649 w" if round == 1
replace class = "1649 sp" if round == 2
replace class = "1649 s" if round == 3
replace class = "1649 f" if round == 4

replace tsp_conc = TSP_conc_ug_m3 if round != . 
replace tsp_conc_error = TSP_conc_error if round != . 

drop TSP_conc_ug_m3 TSP_conc_error

gen class2 = 1 if class == "TCH s ns"
replace class2 = 2 if class == "TCH f ns"

replace class2 = 3 if class == "TCH s s"
replace class2 = 4 if class == "TCH f s"

replace class2 = 5 if class == "1649 w"
replace class2 = 6 if class == "1649 sp"
replace class2 = 7 if class == "1649 s"
replace class2 = 8 if class == "1649 f"




text(200 7 "Social Housing Summer Non-smoking", size(vsmall) orientation(vertical))
text(200 19 "Social Housing Fall Non-smoking", size(vsmall) orientation(vertical))
text(300 31 "Social Housing Summer Smoking", size(vsmall) orientation(vertical))
text(350 43 "Social Housing Fall Smoking", size(vsmall) orientation(vertical))

text(200 57 "1649 Winter", size(vsmall) orientation(vertical))
text(420 69 "1649 Spring", size(vsmall) orientation(vertical))
text(400 81 "1649 Summer", size(vsmall) orientation(vertical))
text(350 93 "1649 Fall", size(vsmall) orientation(vertical))


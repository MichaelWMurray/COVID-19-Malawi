clear

use "C:\Users\emper\OneDrive\Desktop\Grad School\ECON676 Econ Develop\Final Report\Data\Combined Data\Combined Collapsed by District\Combined LSMS and High Freq by District V6.dta"

sort District date
xtset District date

gen AfterCOVID = 1
replace AfterCOVID = 0 if date==2017
replace AfterCOVID = 0 if date==2019
label var AfterCOVID "=1 After start of pandemic"

replace Region=1 if Region>3 & Region<60
replace Region=2 if Region>60 & Region<100
replace Region=3 if Region>100
label define Region1 1 "North" 2 "Central" 3 "South"
label values Region Region1

* Create Education level variable
gen Educationlvl = 0
replace Educationlvl = 1 if Education>.5
replace Educationlvl = 2 if Education>1.5
replace Educationlvl = 3 if Education>2.5
replace Educationlvl = 4 if Education>3.5
replace Educationlvl = 5 if Education>4.5
label var Educationlvl "Avg lvl of Education"
label define Edulvl 1 "None" 2 "Primary" 3 "Some Secondary" 4 "Secondary" 5 "A-level"
label values Educationlvl Edulvl

gen hhsizesq = hhsize^2

* Base Specification
* Skip A Meal - B4 and After COVID
* Having to Skip A Meal = 2 had to skip a meal.

xtreg SkipAMeal AfterCOVID, fe vce(cluster District)
eststo SkipReg1

xtreg SkipAMeal AfterCOVID urb_rural, fe vce(cluster District)
eststo SkipReg2

xtreg SkipAMeal AfterCOVID urb_rural hhsize, fe vce(cluster District)
eststo SkipReg3

xtreg SkipAMeal AfterCOVID urb_rural hhsize WorkHHFarm, fe vce(cluster District)
eststo SkipReg4

xtreg SkipAMeal AfterCOVID urb_rural hhsize WorkHHFarm b2019.date, fe vce(cluster District)
eststo SkipReg5

xtreg SkipAMeal AfterCOVID urb_rural hhsize WorkHHFarm b2019.date i.Educationlvl, fe vce(cluster District)
eststo SkipReg6

testparm i.date
testparm i.Educationlvl

esttab SkipReg1 SkipReg2 SkipReg3 SkipReg4 SkipReg5 SkipReg6

* Looking at before only data
xtreg SkipAMeal urb_rural hhsize WorkHHFarm i.date i.Educationlvl if AfterCOVID==0, fe vce(cluster District)
eststo regb4covid

testparm i.Educationlvl

* Looking at only after data
xtreg SkipAMeal urb_rural hhsize WorkHHFarm i.date i.Educationlvl if AfterCOVID==1, fe vce(cluster District)
eststo regaftercovid

testparm i.date
testparm i.Educationlvl

esttab regb4covid regaftercovid

xtreg SkipAMeal urb_rural hhsize WorkHHFarm i.Region i.Educationlvl if AfterCOVID==1, vce(cluster District)

***** Income Decline  ***************
* Income Declined = 1 if Income Declined since previous survey/last year

xtreg IncomeDecline AfterCOVID, vce(cluster District)
eststo IReg1

xtreg IncomeDecline AfterCOVID urb_rural, fe vce(cluster District)
eststo IReg2

xtreg IncomeDecline AfterCOVID urb_rural hhsize, fe vce(cluster District)
eststo IReg3

xtreg IncomeDecline AfterCOVID urb_rural hhsize WorkHHFarm, fe vce(cluster District)
eststo IReg4

xtreg IncomeDecline AfterCOVID urb_rural hhsize WorkHHFarm b2019.date, fe vce(cluster District)
eststo IReg5

xtreg IncomeDecline AfterCOVID urb_rural hhsize WorkHHFarm b2019.date i.Educationlvl, fe vce(cluster District)
eststo IReg6

testparm i.date
testparm i.Educationlvl

esttab IReg1 IReg2 IReg3 IReg4 IReg5 IReg6

* Looking at before only data
xtreg IncomeDecline urb_rural hhsize WorkHHFarm i.date i.Educationlvl if AfterCOVID==0, fe vce(cluster District)
eststo iregb4covid

testparm i.date
testparm i.Educationlvl

xtreg IncomeDecline urb_rural hhsize WorkHHFarm i.date i.Educationlvl if AfterCOVID==1, fe vce(cluster District)
eststo iregaftercovid

testparm i.date
testparm i.Educationlvl

esttab iregb4covid iregaftercovid

gen After2017 = 1
replace After2017 =0 if date==2017


****************
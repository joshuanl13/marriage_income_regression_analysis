**********************************************
*Import data*
**********************************************

infile using mar_inc_13, clear

  rename R0000100 PUBID_1997
  rename R0536300 KEYSEX_1997
  rename R1482600 KEYRACE_ETHNICITY_1997
  rename T8123600 CV_AGE_INT_DATE_2013
  rename T8123700 CV_CENSUS_REGION_2013
  rename T8128900 CV_HGC_EVER_EDT_2013
  rename T8134500 CV_URBAN_RURAL_2013  
  rename T8848400 YMAR_620_2013  
  rename T9218000 BIOADOPTCHILD_RESIDE_01_2013   
  rename T9218100 BIOADOPTCHILD_RESIDE_02_2013   
  rename T9218200 BIOADOPTCHILD_RESIDE_03_2013  
  rename T9218300 BIOADOPTCHILD_RESIDE_04_2013  
  rename T9218400 BIOADOPTCHILD_RESIDE_05_2013  
  rename T9218500 BIOADOPTCHILD_RESIDE_06_2013  
  rename T9218600 BIOADOPTCHILD_RESIDE_07_2013  
  rename T9218700 BIOADOPTCHILD_RESIDE_08_2013  
  rename T9218800 BIOADOPTCHILD_RESIDE_09_2013   
  rename T9218900 BIOADOPTCHILD_RESIDE_10_2013 
  rename T9219000 BIOADOPTCHILD_RESIDE_11_2013  
  rename U0956100 YINC_NEW2_2015 
  rename U0956200 YINC_NEW3_2015   
  rename Z9058000 CVC_WKSWK_YR_ET_00_XRND  
  rename Z9058100 CVC_WKSWK_YR_ET_01_XRND 
  rename Z9058200 CVC_WKSWK_YR_ET_02_XRND  
  rename Z9058300 CVC_WKSWK_YR_ET_03_XRND  
  rename Z9058400 CVC_WKSWK_YR_ET_04_XRND 
  rename Z9058500 CVC_WKSWK_YR_ET_05_XRND  
  rename Z9058600 CVC_WKSWK_YR_ET_06_XRND  
  rename Z9058700 CVC_WKSWK_YR_ET_07_XRND 
  rename Z9058800 CVC_WKSWK_YR_ET_08_XRND  
  rename Z9058900 CVC_WKSWK_YR_ET_09_XRND 
  rename Z9058901 CVC_WKSWK_YR_ET_10_XRND 
  rename Z9058902 CVC_WKSWK_YR_ET_11_XRND 
  rename Z9058903 CVC_WKSWK_YR_ET_12_XRND 
  rename Z9058904 CVC_WKSWK_YR_ET_13_XRND 
  rename Z9060700 CVC_WKSWK_YR_ET_97_XRND 
  rename Z9060800 CVC_WKSWK_YR_ET_98_XRND 
  rename Z9060900 CVC_WKSWK_YR_ET_99_XRND 
  rename Z9069704 CVC_HOURS_WK_YR_ALL_13_XRND 


*Adding correct work experience data*
merge 1:1 PUBID_1997 using correct_exper_updated
drop _merge


*Reformat variables to lowercase*  
findit tolower
tolower




**********************************************
*Data Cleaning & Variable Construction
**********************************************

**id**

rename pubid_1997 id
label var id "identification number of respondent"




**Sex - female**

rename keysex_1997 sex
codebook sex

generate female=1 if sex==2
replace female=0 if female==.
label var female "=1 if respondent is female"
label define vlfemale 0 "male" 1 "female"
label values female vlfemale

codebook female

drop sex




**Race - black, hispanic, mixed**

rename keyrace_ethnicity_1997 race
codebook race

	*black*

	generate black=1 if race==1
	replace black=0 if black==.
	label var black "=1 if respondent is black"
	label define vlblack 0 "not black" 1 "black"
	label values black vlblack
	
	codebook black


	*hispanic*

	generate hispanic=1 if race==2
	replace hispanic=0 if hispanic==.
	label var hispanic "=1 if respondent is hispanic"
	label define vlhispanic 0 "not hispanic" 1 "hispanic"
	label values hispanic vlhispanic
	
	codebook hispanic


	*mixed*

	generate mixed=1 if race==3
	replace mixed=0 if mixed==.
	label var mixed "=1 if respondent is mixed"
	label define vlmixed 0 "not mixed" 1 "mixed"
	label values mixed vlmixed
	
	codebook mixed
	
drop race




**Age**

rename cv_age_int_date_2013 age
codebook age // 1,844 observations of -5 (non-interviews)

drop if age<0 // must drop so it doesn't distort the numbers during regression

label var age "age of respondent"

codebook age




**Region - northeast, northcentral, west**

rename cv_census_region_2013 region
codebook region // 65 observations of -4 (valid skips), 3 observations of -3 (invalid skips)

drop if region<0 // could distort results, cannot be incorporated into regression analysis

codebook region

	*northeast*

	generate northeast=1 if region==1
	replace northeast=0 if northeast==.
	label var northeast "=1 if respondent resides in the Northeast region (CT, ME, MA, NH, NJ, NY, PA, RI, VT)"
	label define vlnortheast 0 "does not reside in northeast" 1 "resides in northeast"
	label values northeast vlnortheast
	
	codebook northeast


	*northcentral*

	generate northcentral=1 if region==2
	replace northcentral=0 if northcentral==.
	label var northcentral "=1 if respondent resides in northcentral region (IL, IN, IA, KS, MI, MN, MO, NE, OH, ND, SD, WI)"
	label define vlnorthcentral 0 "does not reside in northcentral" 1 "resides in northcentral"
	label values northcentral vlnorthcentral
	
	codebook northcentral

	
	*west*

	generate west=1 if region==4
	replace west=0 if west==.
	label var west "=1 if respondent resides in the western region(AK, AZ, CA, CO, HI, ID, MT, NV, NM, OR, UT, WA, WY)"
	label define vlwest 0 "does not reside in the west" 1 "resides in the west"
	label values west vlwest
	
	codebook west
	
drop region




**Education (highest grade completed)**

rename cv_hgc_ever_edt_2013 educ
label var educ "highest grade respondent has ever completed"
codebook educ
tab educ

drop if educ<0 // 80 observations of -3 (invalid skips)
drop if educ>21 // 13 observation of 95 (ungraded)

label define vleduc 0 "NONE" 1 "1ST GRADE" 2 "2ND GRADE" 3 "3RD GRADE" 4 "4TH GRADE" 5 "5TH GRADE" 6 "6TH GRADE" 7 "7TH GRADE" 8 "8TH GRADE" 9 "9TH GRADE" 10 "10TH GRADE" 11 "11TH GRADE" 12 "12TH GRADE" 13 "1ST YEAR COLLEGE" 14 "2ND YEAR COLLEGE" 15 "3RD YEAR COLLEGE" 16 "4TH YEAR COLLEGE" 17 "5TH YEAR COLLEGE" 18 "6TH YEAR COLLEGE" 19 "7TH YEAR COLLEGE" 20 "8TH YEAR COLLEGE OR MORE"
label values educ vleduc

tab educ




**Urban vs. Rural**

rename cv_urban_rural_2013 urbrur
codebook urbrur

drop if urbrur<0 // 10 observations of -3 (invalid skips). represented people without valid addresses
drop if urbrur==2 // 54 observations of 2 (unknown). represented people who had zip codes that included both ubran and rural or could not specify between areas

	*urban
	generate urban=1 if urbrur==1
	replace urban=0 if urban==.
	label var urban "=1 if respondent resides in urban area"
	label define vlurban 0 "resides in rural area" 1 "resides in urban area"
	label values urban vlurban
	
	codebook urban

drop urbrur




**number of biological or adopted children currently residing in the household**

browse bioadoptchild_reside_01_2013 bioadoptchild_reside_02_2013 bioadoptchild_reside_03_2013 bioadoptchild_reside_04_2013 bioadoptchild_reside_05_2013 bioadoptchild_reside_06_2013 bioadoptchild_reside_07_2013 bioadoptchild_reside_08_2013 bioadoptchild_reside_09_2013 bioadoptchild_reside_10_2013 bioadoptchild_reside_11_2013 

sort bioadoptchild_reside_01_2013 bioadoptchild_reside_02_2013 bioadoptchild_reside_03_2013 bioadoptchild_reside_04_2013 bioadoptchild_reside_05_2013 bioadoptchild_reside_06_2013 bioadoptchild_reside_07_2013 bioadoptchild_reside_08_2013 bioadoptchild_reside_09_2013 bioadoptchild_reside_10_2013 bioadoptchild_reside_11_2013 

count if bioadoptchild_reside_01_2013==-4 // 2556 observations (valid skips). maybe means has no kids?
count if bioadoptchild_reside_01_2013==0 // 799 observations. means has kids but doesn't reside in same houshold?
*if -4 (valid skip) means that they don't have kids then convert to 0 to include when running regression because technically, they also have no children residing within the hosuehold

codebook bioadoptchild_reside_01_2013
generate kids1=1 if bioadoptchild_reside_01_2013==1
replace kids1=0 if kids1==.
label var kids1 "=1 if respondent has a child residing in household"
codebook kids1

codebook bioadoptchild_reside_02_2013
generate kids2=1 if bioadoptchild_reside_02_2013==1
replace kids2=0 if kids2==.
label var kids2 "=1 if respondent has a 2nd child residing in household"
codebook kids2

codebook bioadoptchild_reside_03_2013
generate kids3=1 if bioadoptchild_reside_03_2013==1
replace kids3=0 if kids3==.
label var kids3 "=1 if respondent has a 3rd child residing in household"
codebook kids3

codebook bioadoptchild_reside_04_2013
generate kids4=1 if bioadoptchild_reside_04_2013==1
replace kids4=0 if kids4==.
label var kids4 "=1 if respondent has a 4th child residing in household"
codebook kids4

codebook bioadoptchild_reside_05_2013
generate kids5=1 if bioadoptchild_reside_05_2013==1
replace kids5=0 if kids5==.
label var kids5 "=1 if respondent has a 5th child residing in household"
codebook kids5

codebook bioadoptchild_reside_06_2013
generate kids6=1 if bioadoptchild_reside_06_2013==1
replace kids6=0 if kids6==.
label var kids6 "=1 if respondent has a 6th child residing in household"
codebook kids6

codebook bioadoptchild_reside_07_2013
generate kids7=1 if bioadoptchild_reside_07_2013==1
replace kids7=0 if kids7==.
label var kids7 "=1 if respondent has a 7th child residing in household"
codebook kids7

codebook bioadoptchild_reside_08_2013
generate kids8=1 if bioadoptchild_reside_08_2013==1
replace kids8=0 if kids8==.
label var kids8 "=1 if respondent has a 8th child residing in household"
codebook kids8

codebook bioadoptchild_reside_09_2013
generate kids9=1 if bioadoptchild_reside_09_2013==1
replace kids9=0 if kids9==.
label var kids9 "=1 if respondent has a 9th child residing in household"
codebook kids9

codebook bioadoptchild_reside_10_2013
generate kids10=1 if  bioadoptchild_reside_10_2013==1
replace kids10=0 if kids10==.
label var kids10 "=1 if respondent has a 10th child residing in household"
codebook kids10

codebook bioadoptchild_reside_11_2013
generate kids11=1 if bioadoptchild_reside_11_2013==1
replace kids11=0 if kids11==.
label var kids11 "=1 if respondent has a 11th child residing in household"
codebook kids11

generate numhhkids=kids1+kids2+kids3+kids4+kids5+kids6+kids7+kids8+kids9+kids10+kids11
label var numhhkids "number of kids residing in the household"


drop kids1 kids2 kids3 kids4 kids5 kids6 kids7 kids8 kids9 kids10 kids11

drop bioadoptchild_reside_01_2013 bioadoptchild_reside_02_2013 bioadoptchild_reside_03_2013 bioadoptchild_reside_04_2013 bioadoptchild_reside_05_2013 bioadoptchild_reside_06_2013 bioadoptchild_reside_07_2013 bioadoptchild_reside_08_2013 bioadoptchild_reside_09_2013 bioadoptchild_reside_10_2013 bioadoptchild_reside_11_2013 

	*convert to at least one kid residing in the household
	gen childhh=1 if numhhkids>=1
	replace childhh=0 if childhh==.
	label variable childhh "=1 if respondent has at least 1 child that resides in the household"
	label define vlchildhh 0 "no children in the household" 1 "at least one child in the household"
	label values childhh vlchildhh
	
	codebook childhh
	
	drop numhhkids




**Married**

rename ymar_620_2013 marstat
codebook marstat // 1 observation of -2, 3 observations of -3

drop if marstat<0 

generate married=1 if marstat==1
replace married=0 if married==.
label var married "=1 if respondent is married"
label define vlmarried 0 "not married" 1 "married"
label values married vlmarried

codebook married

drop marstat




**Income**

rename yinc_new2_2015 income
label var income "total income from wages and salary in 2013"
tab income // 85 observations of 222152 which are top-coded values
/*		427 observations of -5 
		1541 observations of -4
		651 observations of -2
		63 observations of -1
		16 observations of 0
not sure whether to replace any negative responses that have answered in estimated income variable as that variable is more categorical has it defines a range in where their income was as opposed to a single numerical variable so will drop sruvey codes
 */
 
drop if income<0

tab income

gen lnincome=ln(income+1)
label var lnincome "ln(income+1)"





**Experience**

rename cvc_wkswk_yr_all_97_xrnd wkswkany97
tab wkswkany97
replace wkswkany97=. if wkswkany97<0

rename cvc_wkswk_yr_all_98_xrnd wkswkany98
tab wkswkany98
replace wkswkany98=. if wkswkany98<0


rename cvc_wkswk_yr_all_99_xrnd wkswkany99
tab wkswkany99
replace wkswkany99=. if wkswkany99<0

rename cvc_wkswk_yr_all_00_xrnd wkswkany00
tab wkswkany00
replace wkswkany00=. if wkswkany00<0

rename cvc_wkswk_yr_all_01_xrnd wkswkany01
tab wkswkany01
replace wkswkany01=. if wkswkany01<0

rename cvc_wkswk_yr_all_02_xrnd wkswkany02
tab wkswkany02
replace wkswkany02=. if wkswkany02<0

rename cvc_wkswk_yr_all_03_xrnd wkswkany03
tab wkswkany03
replace wkswkany03=. if wkswkany03<0

rename cvc_wkswk_yr_all_04_xrnd wkswkany04
tab wkswkany04
replace wkswkany04=. if wkswkany04<0

rename cvc_wkswk_yr_all_05_xrnd wkswkany05
tab wkswkany05
replace wkswkany05=. if wkswkany05<0

rename cvc_wkswk_yr_all_06_xrnd wkswkany06
tab wkswkany06
replace wkswkany06=. if wkswkany06<0

rename cvc_wkswk_yr_all_07_xrnd wkswkany07
tab wkswkany07
replace wkswkany07=. if wkswkany07<0

rename cvc_wkswk_yr_all_08_xrnd wkswkany08
tab wkswkany08
replace wkswkany08=. if wkswkany08<0

rename cvc_wkswk_yr_all_09_xrnd wkswkany09
tab wkswkany09
replace wkswkany09=. if wkswkany09<0

rename cvc_wkswk_yr_all_10_xrnd wkswkany10
tab wkswkany10
replace wkswkany10=. if wkswkany10<0

rename cvc_wkswk_yr_all_11_xrnd wkswkany11
tab wkswkany11
replace wkswkany11=. if wkswkany11<0

rename cvc_wkswk_yr_all_12_xrnd wkswkany12
tab wkswkany12
replace wkswkany12=. if wkswkany12<0

rename cvc_wkswk_yr_all_13_xrnd wkswkany13
tab wkswkany13
replace wkswkany13=. if wkswkany13<0

browse wkswkany97 wkswkany98 wkswkany99 wkswkany00 wkswkany01 wkswkany02 wkswkany03 wkswkany04 wkswkany05 wkswkany06 wkswkany07 wkswkany08 wkswkany09 wkswkany10 wkswkany11 wkswkany12 wkswkany13
sort wkswkany97

egen cumwkexper=rowtotal(wkswkany97 wkswkany98 wkswkany99 wkswkany00 wkswkany01 wkswkany02 wkswkany03 wkswkany04 wkswkany05 wkswkany06 wkswkany07 wkswkany08 wkswkany09 wkswkany10 wkswkany11 wkswkany12 wkswkany13)
browse cumwkexper
sort cumwkexper

gen exper=cumwkexper/52
browse exper
label var exper "years of work experience in any job"

drop wkswkany97 wkswkany98 wkswkany99 wkswkany00 wkswkany01 wkswkany02 wkswkany03 wkswkany04 wkswkany05 wkswkany06 wkswkany07 wkswkany08 wkswkany09 wkswkany10 wkswkany11 wkswkany12 wkswkany13 cumwkexper




**Interaction terms**

gen marriedxfemale=(married*female)
label var marriedxfemale "interaction term: married x female"

gen femalexchild=(female*childhh)
label var femalexchild "interaction term: female x hhkid"




**Drop unecessary variables**
drop cvc_wkswk_yr_et_00_xrnd cvc_wkswk_yr_et_01_xrnd cvc_wkswk_yr_et_02_xrnd cvc_wkswk_yr_et_03_xrnd cvc_wkswk_yr_et_04_xrnd cvc_wkswk_yr_et_05_xrnd cvc_wkswk_yr_et_06_xrnd cvc_wkswk_yr_et_07_xrnd cvc_wkswk_yr_et_08_xrnd cvc_wkswk_yr_et_09_xrnd cvc_wkswk_yr_et_10_xrnd cvc_wkswk_yr_et_11_xrnd cvc_wkswk_yr_et_12_xrnd cvc_wkswk_yr_et_13_xrnd cvc_wkswk_yr_et_97_xrnd cvc_wkswk_yr_et_98_xrnd cvc_wkswk_yr_et_99_xrnd

drop yinc_new3_2015 

drop cvc_hours_wk_yr_all_13_xrnd



**Save cleaned dataset and export copy as .csv**
save mar_inc_13_updated, replace

export delimited using "mar_inc_13_updated.csv", replace

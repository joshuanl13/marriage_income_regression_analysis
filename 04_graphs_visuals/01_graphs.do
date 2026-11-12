use mar_inc_13_updated, clear




*Histogram

histogram income, normal
graph save hist_income, replace
graph export hist_income.png, replace

sum income, detail

histogram lnincome, normal
graph save hist_lnincome, replace
graph export hist_lnincome.png, replace





*Box Plots

graph box income, over(married, label(angle(45))) ylabel(, angle(0)) graphregion(margin(l+10 r+10 b+10 t+0)) ytitle("Total Annual Income") by(female, title("Total Annual Income by Marital Status") subtitle("Data from 2013") note("Source: NLSY1997"))

graph save box_mar_inc_13_updated, replace
graph export box_mar_inc_13_updated.png, replace




*Scatter Plots
twoway(scatter income married)
scatter income married, by(female)

twoway(qfitci income married, stdf) (scatter income married)
twoway(lfitci income married, stdf) (scatter income married)

reg income married // adj. r^2=0.0341
reg income married marriedxfemale // adj. r^2=0.0732

reg lnincome married // adj. r^2=0.0176
reg lnincome married marriedxfemale // adj. r^2=0.0483

scatter income married || lfit income married, title("Total Annual Income vs. Married") subtitle("  ") note("Source: NLYS1997") ytitle("Total Annual Income") xtitle("Not Married or Married") xlabel(0(1)1) aspectratio(.75) plotregion(margin(l+20 r+20))

graph save scatter_mar_inc_13_updated, replace
graph export scatter_mar_inc_13_updated.png, replace


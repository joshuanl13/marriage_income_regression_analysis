use mar_inc_13_updated, clear





******************************
*Model specification testing
******************************

*Interaction term: married x female
reg lnincome married female childhh educ exper age black hispanic mixed urban west northeast northcentral // adj r^2= .1663
reg lnincome married female marriedxfemale childhh educ exper age black hispanic mixed urban west northeast northcentral // adj r^2= .1742


* Interaction term: female x childhh
reg lnincome married female marriedxfemale childhh educ exper age black hispanic mixed urban west northeast northcentral // adj r^2= .1742
rvpplot married, yline(0)

reg lnincome married female marriedxfemale childhh femalexchild educ exper age black hispanic mixed urban west northeast northcentral // adj r^2= .1821 ; adding interaction term for female between childhh
rvpplot married, yline(0)


*Quadratics: educ^2 and exper^2
gen educsq=educ^2
gen expersq=exper^2

reg lnincome married female marriedxfemale childhh educ exper age black hispanic mixed urban west northeast northcentral // adj r^2= .1742
reg lnincome married female marriedxfemale childhh educ educsq exper age black hispanic mixed urban west northeast northcentral // adj r^2= .1741 ; do not square educ


reg lnincome married female marriedxfemale childhh educ exper age black hispanic mixed urban west northeast northcentral // adj r^2= .1742
reg lnincome married female marriedxfemale childhh educ exper expersq age black hispanic mixed urban west northeast northcentral // adj r^2= .1740 ; do not square exper





*RVF plot
reg income married
rvfplot, yline(0)

reg lnincome married
rvfplot, yline(0)


reg lnincome married female marriedxfemale childhh educ exper age black hispanic mixed urban west northeast northcentral 
rvfplot, yline(0)

reg lnincome married female marriedxfemale femalexchild childhh educ exper age black hispanic mixed urban west northeast northcentral
rvfplot, yline(0)





*RVP plot

reg lnincome married female childhh educ exper age black hispanic mixed urban west northeast northcentral 
rvpplot married, yline(0)

reg lnincome married female marriedxfemale femalexchild childhh educ exper age black hispanic mixed urban west northeast northcentral 
rvpplot married, yline(0)





*Robustness check
reg lnincome married female marriedxfemale childhh femalexchild educ exper age black hispanic mixed urban west northeast northcentral, vce(robust)








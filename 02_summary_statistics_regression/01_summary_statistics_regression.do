use mar_inc_13_updated, clear




*Summary statistics
sum income married female childhh educ exper age black hispanic mixed urban west northeast northcentral, separator(15)

/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
      income |      4,229    42982.37       34966          0     222152
     married |      4,229    .4473871     .497283          0          1
      female |      4,229    .4797825    .4996502          0          1
     childhh |      4,229    .5303854    .4991349          0          1
        educ |      4,229    14.29061    2.874538          6         20
       exper |      4,229    11.52923    3.269452          0   17.05769
         age |      4,229    30.94325    1.438455         28         34
       black |      4,229    .2364625    .4249596          0          1
    hispanic |      4,229    .2102152    .4075095          0          1
       mixed |      4,229     .009222    .0955989          0          1
       urban |      4,229    .8465358     .360477          0          1
        west |      4,229    .2288957    .4201717          0          1
   northeast |      4,229    .1555923    .3625113          0          1
northcentral |      4,229    .2312603    .4216883          0          1

*/




*Regression
reg lnincome married female marriedxfemale childhh femalexchild educ exper age black hispanic mixed urban west northeast northcentral, vce(robust)

/*
Linear regression                               Number of obs     =      4,229
                                                F(15, 4213)       =      47.74
                                                Prob > F          =     0.0000
                                                R-squared         =     0.1850
                                                Root MSE          =     1.0057

--------------------------------------------------------------------------------
               |               Robust
      lnincome |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
---------------+----------------------------------------------------------------
       married |   .2594231   .0361011     7.19   0.000     .1886459    .3302002
        female |  -.0859455   .0476496    -1.80   0.071    -.1793639    .0074729
marriedxfemale |  -.2525871   .0625162    -4.04   0.000    -.3751519   -.1300223
       childhh |   .2001197   .0385757     5.19   0.000      .124491    .2757484
  femalexchild |   -.445956   .0598987    -7.45   0.000    -.5633891   -.3285229
          educ |   .0889031   .0058691    15.15   0.000     .0773966    .1004097
         exper |   .0806713   .0072929    11.06   0.000     .0663733    .0949693
           age |  -.0289342   .0120157    -2.41   0.016    -.0524914   -.0053771
         black |  -.0831914   .0460959    -1.80   0.071    -.1735637    .0071808
      hispanic |  -.0007349   .0408314    -0.02   0.986     -.080786    .0793162
         mixed |   .0798007   .1289084     0.62   0.536    -.1729278    .3325292
         urban |   .0801789   .0438875     1.83   0.068    -.0058637    .1662216
          west |   .0122708   .0425249     0.29   0.773    -.0711005    .0956421
     northeast |   .0119382   .0512117     0.23   0.816    -.0884636      .11234
  northcentral |  -.1111537   .0392148    -2.83   0.005    -.1880355    -.034272
         _cons |   9.007051   .3610605    24.95   0.000     8.299182     9.71492
--------------------------------------------------------------------------------

*/

reg lnincome married female marriedxfemale childhh femalexchild educ exper age black hispanic mixed urban west northeast northcentral
estat hettest

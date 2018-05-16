# PAIRWISE COMPARISONS BETWEEN HABITATS BY EACH BAY, THEN BETWEEN BAYS 


#Pairwise comparisons in environmental parameters between HABITATS within Bays

Env.Data.Master.noOuts_daily$variable<-relevel(Env.Data.Master.noOuts_daily$variable, ref = "PG-B") #change "ref" bay for new comparisons
# Require p=0.05/28=0.0017857

## DAILY MEANS 

# Mean pH
summary(lm(daily.mean ~ variable, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "pH"),]))
# CI-E -- CI-B -0.258435   0.029207  -8.848   <2e-16 ***
# FB-E -- FB-B -0.438295   0.028907 -15.162  < 2e-16 ***
# WB-E -- WB-B -0.20497    0.02808  -7.300 1.99e-12 ***
  
# Mean DO
summary(lm(daily.mean ~ variable, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "DO"),]))
# CI-E -- CI-B  -1.5302     0.2498  -6.125 2.32e-09 ***
# PG-E -- PG-B   1.0491     0.2524   4.157 4.01e-05 ***
# FB-E -- FB-B   0.5235     0.3102   1.688  0.09234 .   <-- ND
# WB-E -- WB-B   0.1472     0.2427   0.607  0.54436     <-- ND

# Mean T
summary(lm(daily.mean ~ variable, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Temperature"),])) #NO DIFFERENCES
# CI-E -- CI-B  -0.1191     0.2109  -0.564    0.573    <--ND
# PG-E -- PG-B -0.02619    0.21306  -0.123    0.902    <--ND
# FB-E -- FB-B -0.04184    0.21092  -0.198    0.843    <--ND
# WB-E -- WB-B  -0.1178     0.2049  -0.575    0.566    <--ND

# Mean Salinity
summary(lm(daily.mean ~ variable, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Salinity"),]))

# CI-E -- CI-B  -2.3340     0.3106  -7.514 9.88e-13 ***
# FB-E -- FB-B  -0.7184     0.3515  -2.044    0.042 *  <--ND
# WB-E -- WB-B  -2.5012     0.3803  -6.577 2.73e-10 ***
  
## DAILY STANDARD DEVIATION 
Env.Data.Master.noOuts_daily$variable<-relevel(Env.Data.Master.noOuts_daily$variable, ref = "WB-E") #change "ref" variable for new comparisons

# pH SD
summary(lm(daily.sd ~ variable, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "pH"),]))
#CI-E -- CI-B -0.039799   0.009803  -4.060 6.08e-05 ***
# FB-E -- FB-B -0.017208   0.009702  -1.774 0.077007 .  <--ND
# WB-E -- WB-B 0.042235   0.009424   4.482 1.01e-05 ***
  
# SD DO
summary(lm(daily.sd ~ variable, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "DO"),])) 
# CI-E -- CI-B  -0.7874     0.1885  -4.178 3.68e-05 ***
# PG-E -- PG-B  0.02549    0.19039   0.134   0.8935     <--ND
# FB-E -- FB-B   1.0276     0.2340   4.391 1.47e-05 ***
# WB-E -- WB-B   0.1003     0.1831   0.548    0.584     <--ND

# SD T
summary(lm(daily.sd ~ variable, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Temperature"),]))
# CI-E -- CI-B -0.005215   0.205312  -0.025 0.979749    <--ND
# PG-E -- PG-B   0.2751     0.2074   1.327 0.185432     <--ND
# FB-E -- FB-B  0.03083    0.20531   0.150  0.88072     <--ND
# WB-E -- WB-B  0.04862    0.19942   0.244 0.807507     <--ND

# SD Salinity
summary(lm(daily.sd ~ variable, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Salinity"),]))
# CI-E -- CI-B  0.60890    0.07713   7.894 8.87e-14 ***
# FB-E -- FB-B  0.07640    0.08729   0.875  0.38227     <--ND
# WB-E -- WB-B  0.54048    0.09443   5.724 2.94e-08 ***
  

#Pairwise comparisons in environmental parameters between BAYS

Env.Data.Master.noOuts_daily$Bay<-relevel(Env.Data.Master.noOuts_daily$Bay, ref = "PG") #change "ref" bay for new comparisons
# Require p=0.05/(6*8)=0.0010417

## DAILY MEANS 

# Mean pH
summary(lm(daily.mean ~ Bay, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "pH"),]))
# CI-PG       -0.36261    0.03601 -10.071  < 2e-16 *** 
# CI-FB       -0.09507    0.02925  -3.250  0.00127 **  <-- ND
# CI-WB       -0.06462    0.02884  -2.241  0.02568 *   <-- ND
# FB-PG       -0.26754    0.03589  -7.455 7.14e-13 *** 
# FB-WB        0.03046    0.02869   1.062  0.28914     <-- ND
# PG-WB        0.29800    0.03555   8.383 1.29e-15 *** 

# Mean DO
summary(lm(daily.mean ~ Bay, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "DO"),]))

# CI-PG         1.5927     0.1899   8.385 1.04e-15 ***
# CI-FB         0.4642     0.2049   2.266    0.024 *    <--ND
# CI-WB        -1.3613     0.1863  -7.308 1.66e-12 ***
# FB-PG         1.1285     0.2058   5.484 7.68e-08 ***
# FB-WB        -1.8256     0.2024  -9.019  < 2e-16 ***
# PG-WB        -2.9541     0.1873 -15.775  < 2e-16 ***

# Mean T
summary(lm(daily.mean ~ Bay, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Temperature"),]))
  
# CI-PG        -1.0524     0.1493  -7.050 7.92e-12 ***
# CI-FB        -1.3624     0.1485  -9.173  < 2e-16 ***
# CI-WB         1.8278     0.1464  12.484  < 2e-16 ***
# FB-PG         0.3101     0.1493   2.077   0.0384 *   <-- ND
# FB-WB         3.1902     0.1464  21.789   <2e-16 ***
# PG-WB         2.8801     0.1472  19.569  < 2e-16 ***
  
# Mean Salinity
summary(lm(daily.mean ~ Bay, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Salinity"),]))
# CI-PG         0.6802     0.3437   1.979   0.0489 *   <--ND
# CI-FB         8.5104     0.3065  27.768  < 2e-16 ***
# CI-WB         1.5323     0.3101   4.941 1.41e-06 ***
# FB-PG        -7.8302     0.3065  -25.55   <2e-16 ***
# FB-WB        -6.9781     0.2683  -26.01   <2e-16 ***
# PG-WB         0.8521     0.3101   2.748  0.00643 **  <--ND


## DAILY STANDARD DEVIATION 
Env.Data.Master.noOuts_daily$Bay<-relevel(Env.Data.Master.noOuts_daily$Bay, ref = "PG") #change "ref" bay for new comparisons

# pH SD
summary(lm(daily.sd ~ Bay, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "pH"),]))
# CI-PG        0.025501   0.008923   2.858 0.004522 **  <--ND
# CI-FB        0.050786   0.007249   7.006 1.27e-11 ***
# CI-WB       -0.024683   0.007147  -3.454 0.000621 ***
# FB-PG       -0.025285   0.008893  -2.843  0.00473 **  <--ND
# FB-WB       -0.075468   0.007110 -10.615  < 2e-16 ***
# PG-WB       -0.050183   0.008810  -5.696 2.61e-08 ***

# SD DO
summary(lm(daily.sd ~ Bay, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "DO"),])) 

# CI-PG        1.30827    0.13974   9.362  < 2e-16 ***
# CI-FB        2.53044    0.15075  16.785  < 2e-16 ***
# CI-WB       -0.51140    0.13705  -3.731  0.00022 ***
# FB-PG        -1.2222     0.1514  -8.072 9.54e-15 ***
# FB-WB        -3.0418     0.1489 -20.425  < 2e-16 ***
# PG-WB       -1.81967    0.13777 -13.208  < 2e-16 ***

# SD T
summary(lm(daily.sd ~ Bay, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Temperature"),]))

# CI-PG        0.65722    0.14552   4.516 8.29e-06 ***
# CI-FB       -0.08819    0.14479  -0.609    0.543     <--ND
# CI-WB       -0.15689    0.14272  -1.099    0.272     <--ND
# FB-PG        0.74541    0.14552   5.122  4.7e-07 ***
# FB-WB       -0.06870    0.14272  -0.481    0.631     <--ND
# PG-WB        -0.8141     0.1435  -5.674 2.67e-08 ***
  
# SD Salinity
summary(lm(daily.sd ~ Bay, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Salinity"),]))
# CI-PG       -0.28765    0.08335  -3.451 0.000653 ***
# CI-FB       -0.19476    0.07432  -2.620 0.009309 **  <--ND
# CI-WB       -0.43567    0.07520  -5.793 2.03e-08 ***
# FB-PG       -0.09289    0.07432  -1.250 0.212529     <--ND
# FB-WB       -0.24091    0.06506  -3.703 0.000261 ***
# PG-WB       -0.14802    0.07520  -1.968 0.050118 .   <--ND

  
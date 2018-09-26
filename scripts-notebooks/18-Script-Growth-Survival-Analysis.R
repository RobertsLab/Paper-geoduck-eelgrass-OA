# Assess growth, survival 

# Import growth data 
Growth <- read.csv("data/GeoduckGrowth.csv", header=TRUE, stringsAsFactors = T, na.strings = "NA")
Growth$Growth <- Growth$FShell - Growth$AvgIShell

# Get growth summary stats
mean(Growth$AvgIShell) #Mean shell length prior to deployment
sd(Growth$AvgIShell) #SD shell length prior to deployment
mean(Growth$FShell) #Mean shell length at retrieval
sd(Growth$FShell) #SD shell length at retrieval

# Check out if growth significantly differed between habitat, site, and both
par(mfrow=c(1,1))
hist(Growth$AvgIShell) #normal dist? 
hist(Growth$FShell) #normal dist? 

anova(lm(Growth ~ Bay*Habitat, data=Growth)) #no growth differences between habitats across all bays, so now look at all combination of bays 
anova(lm(Growth ~ Bay, data=Growth)) # yes, growth differences between bays. 

# Any habitat influence on growth within each bay? 
anova(lm(Growth ~ Habitat, data=subset(Growth, Bay=="FB")))  #no
anova(lm(Growth ~ Habitat, data=subset(Growth, Bay=="PG")))  #no
anova(lm(Growth ~ Habitat, data=subset(Growth, Bay=="CI")))  #no
anova(lm(Growth ~ Habitat, data=subset(Growth, Bay=="WB")))  #no

# Any habitat influence on growth within regions? 
anova(lm(Growth ~ Both, data=subset(Growth, (Bay=="FB" | Bay=="PG"))))

anova(lm(Growth ~ Both, data=subset(Growth, (Bay=="CI" | Bay=="WB"))))

# See which bays had diff. growth. Pull t-value and p-values from summary() with various Bay as the reference factors 
Growth$Bay<-relevel(Growth$Bay, ref = "CI")
summary(lm(Growth ~ Bay, data=Growth))

Growth$Bay<-relevel(Growth$Bay, ref = "FB")
summary(lm(Growth ~ Bay, data=Growth))

Growth$Bay<-relevel(Growth$Bay, ref = "PG")
summary(lm(Growth ~ Bay, data=Growth))

# Growth comparisons between Bays - no diff. within southern, and within northern bays
# Estimate    Std. Error    t value     Pr(>|t|)    
# CI-FB         3.0585     0.5022   6.091 2.38e-08 ***
# CI-PG         3.2551     0.4980   6.536 3.13e-09 ***
# CI-WB         1.0952     0.4870   2.249   0.0268 *  <-- after bonferroni adjustment, not sig.
# FB-PG         0.1966     0.4622   0.425    0.672    
# FB-WB        -1.9634     0.4503  -4.360 3.29e-05 ***
# PG-WB        -2.1599     0.4456  -4.847 4.88e-06 ***

# How significant was the growth by region? 
anova(lm(Growth ~ Region, data=Growth)) 

Growth$Percent <- (((Growth$Growth+Growth$AvgIShell)/Growth$AvgIShell)-1)*100
aggregate(Percent ~ Both, Growth, mean)
aggregate(Percent ~ Both, Growth, sd)

# Survival statistics
Survival <- read.csv("data/Geoduck-Survival.csv", header=TRUE, stringsAsFactors = TRUE)
chisq.test(table(Survival$Survival, Survival$Both)) #not significant  
chisq.test(table(Survival$Survival, Survival$Bay)) #not significant  
chisq.test(table(Survival$Survival, Survival$Region)) #not significant  
anova(lm(Survival ~ Bay*Patch, data=Survival)) #No difference in survival between site or habitat

# Survival different between patches, within regions? 
anova(lm(Survival ~ Bay*Patch, data=subset(Survival, (Bay=="FB" | Bay=="PG")))) #
anova(lm(Survival ~ Bay*Patch, data=subset(Survival, (Bay=="CI" | Bay=="WB")))) #
chisq.test(table(subset(Survival, (Bay=="FB" | Bay=="PG"))$Survival, subset(Survival, (Bay=="FB" | Bay=="PG"))$Patch)) #not significant  
chisq.test(table(subset(Survival, (Bay=="FB" | Bay=="PG"))$Survival, subset(Survival, (Bay=="CI" | Bay=="WB"))$Patch)) #not significant  

# Survival different between patches, within bays?  NO 
chisq.test(table(subset(Survival, Bay=="FB")$Survival, subset(Survival, Bay=="FB")$Patch))  
chisq.test(table(subset(Survival, Bay=="PG")$Survival, subset(Survival, Bay=="PG")$Patch))   
chisq.test(table(subset(Survival, Bay=="CI")$Survival, subset(Survival, Bay=="CI")$Patch))   
chisq.test(table(subset(Survival, Bay=="WB")$Survival, subset(Survival, Bay=="WB")$Patch)) 

anova(lm(Survival ~ Patch, data=subset(Survival, Bay=="FB"))) 
anova(lm(Survival ~ Patch, data=subset(Survival, Bay=="PG"))) 
anova(lm(Survival ~ Patch, data=subset(Survival, Bay=="CI"))) 
anova(lm(Survival ~ Patch, data=subset(Survival, Bay=="WB"))) 

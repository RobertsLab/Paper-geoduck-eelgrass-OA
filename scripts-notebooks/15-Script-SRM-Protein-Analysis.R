# Statistical analysis on protein SRM abundance data. 
# In this analysis, I will assume protein abundances are independent of each other, aka the abundance of one does not directly influence another 
# Use "SRM.final" dataset

# Mean CV from remaining technical rep transitions 
mean(SRM.final$cv)

#melt SRM data to prepare for analysis & merge back with metadata 
data.melted <- melt(SRM.final[c("Transition", "Sample", "mean", "Protein", "Peptide")], id=c("Transition", "Sample", "Protein", "Peptide"), variable.name = "mean.abund", value.name = "mean")
data.melted.plus <- merge(x=data.melted, y=repsTOsamples.filtered.annotated[,c("Comment", "Bay", "Habitat", "Exclosure", "Sample.Shorthand")], by.x="Sample", by.y="Comment", all.x=T, all.y=F)
data.melted.plus[,c(-5:-6)] <- lapply(data.melted.plus[,c(-5:-6)], factor)

#Create new column to assign NMDS-clustering Regions, CI & WB = South, FB & PG = North
data.melted.plus$Region <- data.melted.plus$Bay
data.melted.plus$Region <- gsub("CI|WB", "South", data.melted.plus$Region)
data.melted.plus$Region <- gsub("FB|PG", "North", data.melted.plus$Region)

write.csv(data.melted.plus, "results/SRM/SRM-data-meaned-melted.csv")

head(data.melted.plus)

# Calculate protein abundance Coefficients of Variation for each transition, grouped by location

# What's the overall peptide variance by protein 
transition.variances.all <- data.melted.plus%>%group_by(Transition,Peptide,Protein)%>%dplyr::summarise(SD=sd(value), Mean=mean(value))
transition.variances.all$cv <- transition.variances.all$SD/transition.variances.all$Mean
mean(transition.variances.all$cv) #this is the grand CV = 53.1% 
summary(transition.variances.all$cv) #transition CV range, all locations: 40.4% - 70.1%
write.csv(file="results/SRM/transition-CV-all.csv", transition.variances.all)

# Transition abundance within bays
transition.variances.bays <- data.melted.plus%>%group_by(Transition,Peptide,Protein,Bay)%>%dplyr::summarise(SD=sd(value), Mean=mean(value))
transition.variances.bays$cv <- transition.variances.bays$SD/transition.variances.bays$Mean
mean(transition.variances.bays$cv) #this is the grand CV = 53.1% 
summary(transition.variances.bays$cv) #transition CV range, all locations: 40.4% - 70.1%
write.csv(file="results/SRM/transition-CV-by-bay.csv", transition.variances.bays)
aggregate(data=transition.variances.bays, cv ~ Protein, mean) #Mean transition CV grouped by bay, for each protein 

# CV by protein, grouped by location 
transition.variances.location <- data.melted.plus%>%group_by(Transition,Peptide,Protein,Sample.Shorthand,Bay)%>%dplyr::summarise(SD=sd(value), Mean=mean(value))
transition.variances.location$cv <- transition.variances.location$SD/transition.variances.location$Mean
mean(transition.variances.location$cv, na.rm = T) # 57% CV when grouped by location
summary(transition.variances.location$cv, na.rm = T) # 11.6% - 93.0% CV range, when grouped by location
write.csv(file="results/SRM/transition-CV-by-location.csv", transition.variances.location)

# Mean CV by various grouping factors and save as .csv 
transition.variances.mean <- aggregate(data=transition.variances, cv ~ Transition+Peptide+Protein, mean) #mean CV for each peptide 
protein.variances.sites <- aggregate(data=transition.variances, cv ~ Sample.Shorthand, mean) #mean CV of peptides by location
protein.variances.protein <- aggregate(data=transition.variances, cv ~ Protein, mean) #mean CV of peptides by protein 
protein.variances.protein.location <- aggregate(data=transition.variances, cv ~ Protein + Sample.Shorthand, mean) #mean CV of peptides by protein 
protein.variances.protein.bay <- aggregate(data=transition.variances, cv ~ Protein + Bay, mean) #mean CV of peptides by protein 
aggregate(data=transition.variances, cv ~ Bay, mean) #mean CV of peptides by protein

write.csv(file="results/SRM/transition-CV.csv", transition.variances.mean)
write.csv(file="results/SRM/transition-CV-by-location.csv", protein.variances.sites)
write.csv(file="results/SRM/transition-CV-by-protein-location.csv", dcast(protein.variances.protein.location, Protein ~ Sample.Shorthand, value.var="cv"))
write.csv(file="results/SRM/transition-CV-by-protein-bay.csv", dcast(protein.variances.protein.bay, Protein ~ Bay, value.var="cv"))

# Sum transitions within each peptide 
data.melted.plus.pepsum <- aggregate(value ~ Peptide + Sample + Protein + Region + Bay + Habitat + Exclosure + Sample.Shorthand, data.melted.plus, sum)
write.csv(data.melted.plus.pepsum, "results/SRM/SRM-data-peptide-summed.csv")

# pull out protein names 
Protein.names <- levels(data.melted.plus.pepsum$Protein)

# Average peptide abundance by protein 
data.melted.plus.promean <- aggregate(value ~ Protein + Sample + Region + Bay + Habitat + Exclosure + Sample.Shorthand, data.melted.plus.pepsum, mean)
write.csv(data.melted.plus.promean, "results/SRM/SRM-data-protein-mean.csv")

# View summary statistics of peptide abundances (not including 0 values where NA)
summary(data.melted.plus.pepsum$value[data.melted.plus.pepsum$value>0])


# Test for normality
par(mfrow = c(3, 3))
for (i in 1:length(Protein.names)) {
    qqnorm(data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),][["value"]], main = Protein.names[[i]],
           xlab = "Theoretical Quantiles", ylab = "Peptide Abundance", plot.it = TRUE)
    qqline(data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),][["value"]])
}

# Some are not normal. Apply "transformTukey" to identify the best lambda value to transform abudance data

#calculate lambda value to use to transform data; value is printed in the console and the following plots are generated: lambda test values, transformed data distribution, transformed data qqplot; each row represents one protein
par(mfrow = c(4, 3)) #NEED TO figure out how to add protein names to the plots
for (i in 1:length(Protein.names)) {
  print(Protein.names[[i]])
  transformTukey(data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),][["value"]]+1, plotit=TRUE, statistic = 1) 
}

#Create new column in dataframe with lambda-transformed area data
data.melted.plus.pepsum$lambda.t <- c(rep("x", times=nrow(data.melted.plus.pepsum)))

# Transform abundance data via its designated lambda value 
lambda <- c(0.175, -0.2, 0.05, 0.275, 0.15, 0.375, 0.125, 0.3, 0.1, 0.3, 0.175, -0.075, 0.25) #pulled from console print-out 
for (i in 1:length(Protein.names)) {
  data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),][["lambda.t"]] <- (data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),][["value"]])^lambda[i]
  }

#convert lambda.t values to numeric
data.melted.plus.pepsum$lambda.t <- as.numeric(data.melted.plus.pepsum$lambda.t) 

# Regenerate all QQplots using the transformed area data, lambda.t
par(mfrow = c(3, 3))
for (i in 1:length(Protein.names)) {
  qqnorm(data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),][["lambda.t"]], main = paste(Protein.names[[i]], "\nlambda-transformed", sep=""),
         xlab = "Theoretical Quantiles", ylab = "Peptide Abundance", plot.it = TRUE)
  qqline(data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),][["lambda.t"]])
}

# Create box plots and ID outliers
OutVals <- vector("list", length(Protein.names))
names(OutVals) <- Protein.names

png("results/SRM/protein-boxplots-%02d.png", width=700, height=700)
par(mfrow = c(3, 3))
for (i in 1:length(Protein.names)) {
  OutVals[[i]] = boxplot(data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),][["lambda.t"]] ~ data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),][["Sample.Shorthand"]], main = paste(Protein.names[[i]], "\nlambda-transformed", sep=""), xlab = "Location", ylab = "Peptide Abundance (transf.)", type="p")$out
}
dev.off()

# Generate a dataframe of outliers to inspect. If ANOVA results indicate differences in the peptides/locations included in the outliers list, then consider whether the outliers should be removed from the dataset.
outliers = list()
for (i in 1:length(Protein.names)) {
  outliers[[i]] <- data.melted.plus.pepsum[data.melted.plus.pepsum$lambda.t %in% OutVals[[i]],]
}
Prot.outliers  = do.call(rbind, outliers) #this is a dataframe with outliers, as determined by boxplots

## Use ANOVA to determine any difference in protein abundance between habitat, bay, or NMDS-clustered regions. Don't include HSP70, Peroxiredoxin or Ras-related proteins in anova analysis.  

# Test differences in all proteins combined between bay, habitat 
qqnorm(log(subset(data.melted.plus.pepsum, Protein != "HSP70|Peroxiredoxin-1|Ras-related")$value)) #log-transformed abundance are normally distributed 

lm.all.proteins <- lm(log(value) ~ Bay*Habitat, data=subset(data.melted.plus.pepsum, Protein != "HSP70|Peroxiredoxin-1|Ras-related"))
hist(case(lm.all.proteins)[,"stu.res"]) #residuals are normally distributed
anova(lm.all.proteins) #sig. difference by bay, not habitat 

lm.all.proteins.region.habitat <- lm(log(value) ~ Region*Habitat, data=subset(data.melted.plus.pepsum, Protein != "HSP70|Peroxiredoxin-1|Ras-related"))
hist(case(lm.all.proteins.region.habitat)[,"stu.res"]) #residuals are normally distributed
anova(lm.all.proteins.region.habitat) #sig. difference by region, not habitat 

lm.all.proteins.habitat <- lm(log(value) ~ Habitat, data=subset(data.melted.plus.pepsum, Protein != "HSP70|Peroxiredoxin-1|Ras-related"))
hist(case(lm.all.proteins.habitat)[,"stu.res"]) #residuals are normally distributed
anova(lm.all.proteins.habitat) #no sig. difference by habitat 

lm.all.proteins.bay <- lm(log(value) ~ Bay, data=subset(data.melted.plus.pepsum, Protein != "HSP70|Peroxiredoxin-1|Ras-related"))
hist(case(lm.all.proteins.bay)[,"stu.res"])
anova(lm.all.proteins.bay) #sig. difference

lm.all.proteins.region <- lm(log(value) ~ Region, data=subset(data.melted.plus.pepsum, Protein != "HSP70|Peroxiredoxin-1|Ras-related"))
hist(case(lm.all.proteins.region)[,"stu.res"])
anova(lm.all.proteins.region) #sig. difference 

# 2-way ANOVA on protein abundance for each protein individually: data is analyzed by protein, but each point represents peptides (sum of transitions for each peptide), lambda-transformed for each peptide to acheive normal distribution 

p.ANOVA.hb <- vector("list", length(Protein.names))
names(p.ANOVA.hb) <- Protein.names
for (i in 1:length(Protein.names)) {
  temp1 <- lm(lambda.t ~ Bay+Habitat, data=data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),])
  temp2 <- anova(temp1)
  p.ANOVA.hb[[i]] <- as.data.frame(temp2[,c(1:5)])
  p.ANOVA.hb[[i]]$Protein <- c((Protein.names[i]))
  p.ANOVA.hb[[i]]$Comparison <- rownames(p.ANOVA.hb[[i]])
}
Prot.ANOVA.hb <- do.call(rbind, p.ANOVA.hb) #this is a dataframe with ANOVA results for each protein with each comparison. 
Prot.ANOVA.hb$P.adj <- (Prot.ANOVA.hb$`Pr(>F)`*14)
write.csv(file="results/SRM/Protein-ANOVA-Habitat-Results.csv", Prot.ANOVA.hb)

# ANOVA on protein abundances for each bay 
p.ANOVA.b <- vector("list", length(Protein.names))
names(p.ANOVA.b) <- Protein.names
for (i in 1:length(Protein.names)) {
  temp1 <- lm(lambda.t ~ Bay, data=data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),])
  temp2 <- anova(temp1)
  p.ANOVA.b[[i]] <- as.data.frame(temp2[,c(1:5)])
  p.ANOVA.b[[i]]$Protein <- c((Protein.names[i]))
  p.ANOVA.b[[i]]$Comparison <- rownames(p.ANOVA.b[[i]])
}
Prot.ANOVA.b <- do.call(rbind, p.ANOVA.b) #this is a dataframe with ANOVA results for each protein with each comparison. 
Prot.ANOVA.b$P.adj <- (Prot.ANOVA.b$`Pr(>F)`*14)
write.csv(file="results/SRM/Protein-ANOVA-Bay-Results.csv", Prot.ANOVA.b)

# Differentially expressed proteins by Bay - which bays are different? 

# HSP90
data.melted.plus.pepsum$Bay<-relevel(data.melted.plus.pepsum$Bay, ref = "CI")
summary(lm(lambda.t ~ Bay, data=data.melted.plus.pepsum[grepl("HSP90-alpha", data.melted.plus.pepsum$Protein),]))

data.melted.plus.pepsum$Bay<-relevel(data.melted.plus.pepsum$Bay, ref = "FB")
summary(lm(lambda.t ~ Bay, data=data.melted.plus.pepsum[grepl("HSP90-alpha", data.melted.plus.pepsum$Protein),]))

data.melted.plus.pepsum$Bay<-relevel(data.melted.plus.pepsum$Bay, ref = "PG")
summary(lm(lambda.t ~ Bay, data=data.melted.plus.pepsum[grepl("HSP90-alpha", data.melted.plus.pepsum$Protein),]))

# HSP90 - which bays are different? 
#  CI - FB         153.45      36.04   4.258 3.91e-05 *** <----Different 
#  CI - PG         100.42      34.43   2.917  0.00416 **  <----Different
#  CI - WB          24.44      34.43   0.710  0.47910     <----Not different
#  FB - PG         -53.03      35.32  -1.502 0.135615     <----Not different
#  FB - WB        -129.01      35.32  -3.653 0.000374 *** <----Different
#  PG - WB         -75.98      33.67  -2.257  0.02569 *   <----Different

# Trifunctional Enzyme Subunit-B (TEB)
data.melted.plus.pepsum$Bay<-relevel(data.melted.plus.pepsum$Bay, ref = "CI")
summary(lm(lambda.t ~ Bay, data=data.melted.plus.pepsum[grepl("Trifunctional", data.melted.plus.pepsum$Protein),]))

data.melted.plus.pepsum$Bay<-relevel(data.melted.plus.pepsum$Bay, ref = "FB")
summary(lm(lambda.t ~ Bay, data=data.melted.plus.pepsum[grepl("Trifunctional", data.melted.plus.pepsum$Protein),]))

data.melted.plus.pepsum$Bay<-relevel(data.melted.plus.pepsum$Bay, ref = "PG")
summary(lm(lambda.t ~ Bay, data=data.melted.plus.pepsum[grepl("Trifunctional", data.melted.plus.pepsum$Protein),]))

# TEB - which bays are different? 
  # CI-PG          3.471      1.389   2.499 0.014372 *    <----Different
  # CI-FB          5.524      1.454   3.798 0.000271 ***  <--- Different
  # CI-WB          2.027      1.389   1.459 0.148150      <----Not Different 
  # FB-PG         -2.052      1.425  -1.440 0.153462      <----Not Different
  # FB-WB         -3.496      1.425  -2.453 0.016170 *    <----Different
  # PG-WB        -1.4440     1.3588  -1.063   0.2909      <----Not Different
  
# ANOVA by Region (north= Fidalgo Bay & Port Gamble Bay, south=Case Inlet & Willapa Bay)
p.ANOVA.r <- vector("list", length(Protein.names))
names(p.ANOVA.r) <- Protein.names
for (i in 1:length(Protein.names)) {
  temp1 <- lm(lambda.t ~ Region, data=data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),])
  temp2 <- anova(temp1)
  p.ANOVA.r[[i]] <- as.data.frame(temp2[,c(1:5)])
  p.ANOVA.r[[i]]$Protein <- c((Protein.names[i]))
  p.ANOVA.r[[i]]$Comparison <- rownames(p.ANOVA.r[[i]])
}
Prot.ANOVA.r <- do.call(rbind, p.ANOVA.r) #this is a dataframe with ANOVA results for each protein with each comparison. 
Prot.ANOVA.r$P.adj <- (Prot.ANOVA.r$`Pr(>F)`*14)
write.csv(file="results/SRM/Protein-ANOVA-Region-Results.csv", Prot.ANOVA.r)

# Test correlation between peptides within a protein. Run Pearson Correlation test, and plot protein peptides against each other to confirm linear correlation; equation should be ~1:1 

# First, create new column in peptide dataframe to house the peptide # (1, 2 or 3)
Protein2Peptide <- data.melted.plus.pepsum[!duplicated(data.melted.plus.pepsum$Peptide),c("Peptide", "Protein", "lambda.t")] #Isolate unique peptides, and include Protein name and abundance for ordering purposes
Protein2Peptide <- Protein2Peptide[with(Protein2Peptide , order(Protein, lambda.t)), ] #Order by protein, then abundance
Protein2Peptide$Pep <- c(1,2,3,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,1,1,2,3,1,1,2,1,2,1,2) # Create new column with the Peptide # 
data.melted.plus.pepsum <- merge(x=data.melted.plus.pepsum, y=Protein2Peptide[,c("Peptide", "Pep")], by.x="Peptide", by.y="Peptide", all.x=T, all.y=F)
data.melted.plus.pepsum.wide <- dcast(data.melted.plus.pepsum, Protein+Sample+Bay+Habitat+Sample.Shorthand+Region~Pep, value.var="lambda.t")
names(data.melted.plus.pepsum.wide) <- c("Protein","Sample","Bay","Habitat","Sample.Shorthand","Region","Pep1","Pep2","Pep3")

cor.test(data.melted.plus.pepsum.wide$Pep1, data.melted.plus.pepsum.wide$Pep2, method="pearson")
cor.test(data.melted.plus.pepsum.wide$Pep1, data.melted.plus.pepsum.wide$Pep3, method="pearson")
cor.test(data.melted.plus.pepsum.wide$Pep2, data.melted.plus.pepsum.wide$Pep3, method="pearson")

# Plot peptides within a protein against each other. Should be linearly correlated. summary() shows equation with R^2
par(mfrow = c(1,1))
# Peptide 1 x Peptide 2
pep12 <- lm(Pep1 ~ Pep2, data=data.melted.plus.pepsum.wide)
summary(pep12)
summary(pep12)[[4]]
with(data.melted.plus.pepsum.wide, plot(`Pep1`,`Pep2`))
abline(pep12)

# Peptide 1 x Peptide 3
pep13 <- lm(Pep1 ~ Pep3, data=data.melted.plus.pepsum.wide)
summary(pep13)
with(data.melted.plus.pepsum.wide, plot(`Pep1`,`Pep3`))
abline(pep13)

# Peptide 2 x Peptide 3
pep23 <- lm(Pep2 ~ Pep3, data=data.melted.plus.pepsum.wide)
summary(pep23)
with(data.melted.plus.pepsum.wide, plot(Pep2,Pep3))
abline(pep13)

########## Comparing protein expression between habitats within each bay, and within southern/northern bays 

data.melted.plus.pepsum.south <- subset(data.melted.plus.pepsum, (Protein != "HSP70|Peroxiredoxin-1|Ras-related" & (Bay == "CI" | Bay == "WB")))
data.melted.plus.pepsum.north <- subset(data.melted.plus.pepsum, (Protein != "HSP70|Peroxiredoxin-1|Ras-related" & (Bay == "FB" | Bay == "PG")))
data.melted.plus.pepsum.FB <- subset(data.melted.plus.pepsum, (Protein != "HSP70|Peroxiredoxin-1|Ras-related" & Bay == "FB"))
data.melted.plus.pepsum.PG <- subset(data.melted.plus.pepsum, (Protein != "HSP70|Peroxiredoxin-1|Ras-related" & Bay == "PG"))
data.melted.plus.pepsum.CI <- subset(data.melted.plus.pepsum, (Protein != "HSP70|Peroxiredoxin-1|Ras-related" & Bay == "CI"))
data.melted.plus.pepsum.WB <- subset(data.melted.plus.pepsum, (Protein != "HSP70|Peroxiredoxin-1|Ras-related" & Bay == "WB"))

# ANOVA on protein abundances for between habitat, for SOUTHERN bays only 
p.ANOVA.south.habitat <- vector("list", length(Protein.names))
names(p.ANOVA.south.habitat) <- Protein.names
for (i in 1:length(Protein.names)) {
  temp1 <- lm(lambda.t ~ Bay*Habitat, data=data.melted.plus.pepsum.south[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum.south$Protein),])
  temp2 <- anova(temp1)
  p.ANOVA.south.habitat[[i]] <- as.data.frame(temp2[,c(1:5)])
  p.ANOVA.south.habitat[[i]]$Protein <- c((Protein.names[i]))
  p.ANOVA.south.habitat[[i]]$Comparison <- rownames(p.ANOVA.south.habitat[[i]])
}
Prot.ANOVA.south.habitat <- do.call(rbind, p.ANOVA.south.habitat) #this is a dataframe with ANOVA results for each protein with each comparison. 
Prot.ANOVA.south.habitat$P.adj <- (Prot.ANOVA.south.habitat$`Pr(>F)`*14)
write.csv(file="results/SRM/Protein-ANOVA-South-Habitat-Results.csv", Prot.ANOVA.south.habitat)

# ANOVA on protein abundances for between habitat, for NORTHERN bays only 
p.ANOVA.north.habitat <- vector("list", length(Protein.names))
names(p.ANOVA.north.habitat) <- Protein.names
for (i in 1:length(Protein.names)) {
  temp1 <- lm(lambda.t ~ Bay*Habitat, data=data.melted.plus.pepsum.north[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum.north$Protein),])
  temp2 <- anova(temp1)
  p.ANOVA.north.habitat[[i]] <- as.data.frame(temp2[,c(1:5)])
  p.ANOVA.north.habitat[[i]]$Protein <- c((Protein.names[i]))
  p.ANOVA.north.habitat[[i]]$Comparison <- rownames(p.ANOVA.north.habitat[[i]])
}
Prot.ANOVA.north.habitat <- do.call(rbind, p.ANOVA.north.habitat) #this is a dataframe with ANOVA results for each protein with each comparison. 
Prot.ANOVA.north.habitat$P.adj <- (Prot.ANOVA.north.habitat$`Pr(>F)`*14)
write.csv(file="results/SRM/Protein-ANOVA-North-Habitat-Results.csv", Prot.ANOVA.north.habitat)

# ANOVA on protein abundances for between habitat, for FIDALGO Bay 
p.ANOVA.FB.habitat <- vector("list", length(Protein.names))
names(p.ANOVA.FB.habitat) <- Protein.names
for (i in 1:length(Protein.names)) {
  temp1 <- lm(lambda.t ~ Habitat, data=data.melted.plus.pepsum.FB[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum.FB$Protein),])
  temp2 <- anova(temp1)
  p.ANOVA.FB.habitat[[i]] <- as.data.frame(temp2[,c(1:5)])
  p.ANOVA.FB.habitat[[i]]$Protein <- c((Protein.names[i]))
  p.ANOVA.FB.habitat[[i]]$Comparison <- rownames(p.ANOVA.FB.habitat[[i]])
}
Prot.ANOVA.FB.habitat <- do.call(rbind, p.ANOVA.FB.habitat) #this is a dataframe with ANOVA results for each protein with each comparison. 
Prot.ANOVA.FB.habitat$P.adj <- (Prot.ANOVA.FB.habitat$`Pr(>F)`*14)
write.csv(file="results/SRM/Protein-ANOVA-FB-Habitat-Results.csv", Prot.ANOVA.FB.habitat)

# ANOVA on protein abundances for between habitat, for PORT GAMBLE Bay 
p.ANOVA.PG.habitat <- vector("list", length(Protein.names))
names(p.ANOVA.PG.habitat) <- Protein.names
for (i in 1:length(Protein.names)) {
  temp1 <- lm(lambda.t ~ Habitat, data=data.melted.plus.pepsum.PG[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum.PG$Protein),])
  temp2 <- anova(temp1)
  p.ANOVA.PG.habitat[[i]] <- as.data.frame(temp2[,c(1:5)])
  p.ANOVA.PG.habitat[[i]]$Protein <- c((Protein.names[i]))
  p.ANOVA.PG.habitat[[i]]$Comparison <- rownames(p.ANOVA.PG.habitat[[i]])
}
Prot.ANOVA.PG.habitat <- do.call(rbind, p.ANOVA.PG.habitat) #this is a dataframe with ANOVA results for each protein with each comparison. 
Prot.ANOVA.PG.habitat$P.adj <- (Prot.ANOVA.PG.habitat$`Pr(>F)`*14)
write.csv(file="results/SRM/Protein-ANOVA-PG-Habitat-Results.csv", Prot.ANOVA.PG.habitat)

# ANOVA on protein abundances for between habitat, for CASE INLET 
p.ANOVA.CI.habitat <- vector("list", length(Protein.names))
names(p.ANOVA.CI.habitat) <- Protein.names
for (i in 1:length(Protein.names)) {
  temp1 <- lm(lambda.t ~ Habitat, data=data.melted.plus.pepsum.CI[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum.CI$Protein),])
  temp2 <- anova(temp1)
  p.ANOVA.CI.habitat[[i]] <- as.data.frame(temp2[,c(1:5)])
  p.ANOVA.CI.habitat[[i]]$Protein <- c((Protein.names[i]))
  p.ANOVA.CI.habitat[[i]]$Comparison <- rownames(p.ANOVA.CI.habitat[[i]])
}
Prot.ANOVA.CI.habitat <- do.call(rbind, p.ANOVA.CI.habitat) #this is a dataframe with ANOVA results for each protein with each comparison. 
Prot.ANOVA.CI.habitat$P.adj <- (Prot.ANOVA.CI.habitat$`Pr(>F)`*14)
write.csv(file="results/SRM/Protein-ANOVA-CI-Habitat-Results.csv", Prot.ANOVA.CI.habitat)

# ANOVA on protein abundances for between habitat, for WILLAPA Bay 
p.ANOVA.WB.habitat <- vector("list", length(Protein.names))
names(p.ANOVA.WB.habitat) <- Protein.names
for (i in 1:length(Protein.names)) {
  temp1 <- lm(log(value) ~ Habitat, data=data.melted.plus.pepsum.WB[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum.WB$Protein),])
  temp2 <- anova(temp1)
  p.ANOVA.WB.habitat[[i]] <- as.data.frame(temp2[,c(1:5)])
  p.ANOVA.WB.habitat[[i]]$Protein <- c((Protein.names[i]))
  p.ANOVA.WB.habitat[[i]]$Comparison <- rownames(p.ANOVA.WB.habitat[[i]])
}
Prot.ANOVA.WB.habitat <- do.call(rbind, p.ANOVA.WB.habitat) #this is a dataframe with ANOVA results for each protein with each comparison. 
Prot.ANOVA.WB.habitat$P.adj <- (Prot.ANOVA.WB.habitat$`Pr(>F)`*14)
write.csv(file="results/SRM/Protein-ANOVA-WB-Habitat-Results.csv", Prot.ANOVA.WB.habitat)

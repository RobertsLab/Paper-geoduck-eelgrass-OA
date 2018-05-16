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

# Calculate protein abundance Coefficients of Variation for each peptide, grouped by location

# What's the overall peptide variance by protein, NOT grouped by location? 
peptide.variances.NOTsite <- data.melted.plus.pepsum%>%group_by(Peptide,Protein)%>%dplyr::summarise(SD=sd(value), Mean=mean(value))
peptide.variances.NOTsite$cv <- peptide.variances.NOTsite$SD/peptide.variances.NOTsite$Mean
mean(peptide.variances.NOTsite$cv) #this is the grand CV = 60% 

# CV by protein, grouped by location 
peptide.variances <- data.melted.plus.pepsum%>%group_by(Peptide,Protein,Sample.Shorthand)%>%dplyr::summarise(SD=sd(value), Mean=mean(value))
peptide.variances$cv <- peptide.variances$SD/peptide.variances$Mean
mean(peptide.variances$cv, na.rm = T) # 57% CV when grouped by location 

# Mean CV by various grouping factors and save as .csv 
peptide.variances.mean <- aggregate(data=peptide.variances, cv ~ Peptide+Protein, mean) #mean CV for each peptide 
protein.variances.sites <- aggregate(data=peptide.variances, cv ~ Sample.Shorthand, mean) #mean CV of peptides by location 
protein.variances.protein <- aggregate(data=peptide.variances, cv ~ Protein, mean) #mean CV of peptides by protein 

write.csv(file="results/SRM/peptide-CV.csv", peptide.variances.mean)
write.csv(file="results/SRM/peptide-CV-by-location.csv", protein.variances.sites)
write.csv(file="results/SRM/peptide-CV-by-protein.csv", protein.variances.protein)

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

## Use ANOVA to determine any difference in protein abundance between habitat, bay, or NMDS-clustered regions 

# 2-way ANOVA on protein abundance for each protein individually: data is analyzed by protein, but each point represents the sum of transitions within a peptide, lambda-transformed. 

p.ANOVA.hb <- vector("list", length(Protein.names))
names(p.ANOVA.hb) <- Protein.names
for (i in 1:length(Protein.names)) {
  temp1 <- lm(lambda.t ~ Bay*Habitat, data=data.melted.plus.pepsum[grepl(c(Protein.names[[i]]), data.melted.plus.pepsum$Protein),])
  temp2 <- anova(temp1)
  p.ANOVA.hb[[i]] <- as.data.frame(temp2[,c(1:5)])
  p.ANOVA.hb[[i]]$Protein <- c((Protein.names[i]))
  p.ANOVA.hb[[i]]$Comparison <- rownames(p.ANOVA.hb[[i]])
}
Prot.ANOVA.hb <- do.call(rbind, p.ANOVA.hb) #this is a dataframe with ANOVA results for each protein with each comparison. 
Prot.ANOVA.hb$P.adj <- (Prot.ANOVA.hb$`Pr(>F)`*13)
write.csv(file="results/SRM/Protein-ANOVA-Habitat-Results.csv", Prot.ANOVA.hb)

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
Prot.ANOVA.r$P.adj <- (Prot.ANOVA.r$`Pr(>F)`*13)
write.csv(file="results/SRM/Protein-ANOVA-Region-Results.csv", Prot.ANOVA.r)

# Test correlation between peptides within a protein. Run Pearson Correlation test, and plo protein peptides against each other to confirm linear correlation; equation should be ~1:1 

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
pep12 <- lm(log(Pep1) ~ log(Pep2), data=data.melted.plus.pepsum.wide)
summary(pep12)
with(data.melted.plus.pepsum.wide, plot(`Pep1`,`Pep2`))
abline(pep12)

# Peptide 1 x Peptide 3
pep13 <- lm(log(Pep1) ~ log(Pep3), data=data.melted.plus.pepsum.wide)
summary(pep13)
with(data.melted.plus.pepsum.wide, plot(`Pep1`,`Pep3`))
abline(pep13)

# Peptide 2 x Peptide 3
pep23 <- lm(log(Pep2) ~ log(Pep3), data=data.melted.plus.pepsum.wide)
summary(pep23)
with(data.melted.plus.pepsum.wide, plot(Pep2,Pep3))
abline(pep13)

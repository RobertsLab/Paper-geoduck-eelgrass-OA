# Use PRTC retention times (RT) in DIA and SRM to predict the RT for SRM targets 

# load retention time files, which were exported from Skyline 

RT.DIA.Ducks <- read.csv("data/DIA/2017-07-15-Spencer-DIA-Retention-Time.csv", header=T, na.strings = "#N/A")
RT.DIA.PRTC <- read.csv("data/DIA/2017-07-18_DIA-PRTC_RT.csv", header=T, na.strings = "#N/A")
RT.SRM <- read.csv("data/SRM/2017-08-11_SRM-Retention-Times.csv", header=T, na.strings = "#N/A")

# Aggregate all SRM replicates' PRTC retention times to calculate average
RT.PRTC.DIA.mean <- aggregate(Peptide.Retention.Time~Peptide.Sequence, RT.DIA.PRTC, mean, na.action = na.omit)
names(RT.DIA.mean) <- c("Peptide", "DIA.RT")
RT.SRM.mean <- aggregate(Peptide.Retention.Time~Peptide.Sequence+Protein.Name, RT.SRM, mean, na.action = na.omit)
names(RT.SRM.mean) <- c("Peptide", "Protein", "SRM.RT")

# Merge the two dataframes 
RT.PRTC.merged <- merge(x=RT.DIA.mean, y=RT.SRM.mean, by.x="Peptide", by.y="Peptide", all.x=T, all.y=T) 

#generate linear model, x= DIA RT, y=SRM RT
summary(PRTC.RT.lm <- lm(SRM.RT ~ DIA.RT, data=filter(RT.PRTC.merged, Protein=="PRTC peptides")))
# fitted equation: SRM RT = 10.411495 * 0.274494*(DIA RT); Adjusted R-squared = 0.9987

png("analyses/SRM/PRTC-RT.jpg")
plot(x=RT.PRTC.merged$DIA.RT, y=RT.PRTC.merged$SRM.RT, main="PRTC Retention Times, SRM ~ DIA\nSRM RT = 10.411495 * 0.274494*(DIA RT)\nAdjusted R-squared = 0.9987", xlab = "DIA RT", ylab="SRM RT")
abline(RT.lm)
dev.off()

# Use fitted equation to predict RT for all SRM targets then average 
RT.DIA.Ducks$SRM.Predicted <- RT.DIA.Ducks$Peptide.Retention.Time*0.274494 + 10.411495
RT.DIA.Ducks.mean <- aggregate(SRM.Predicted~Peptide.Sequence, RT.DIA.Ducks, mean, na.action = na.omit)

# Merge predicted RT with actual RT 
RT.SRM.Pred.Act <- merge(x=RT.DIA.Ducks.mean, y=RT.SRM.mean, by.x="Peptide.Sequence", by.y="Peptide")
summary(RT.Fit <- lm(SRM.RT ~ SRM.Predicted, data=RT.SRM.Pred.Act))

# Save regression plot 
png("results/SRM/SRM-Predicted-vs-Actual-RT-plot.png")
plot(x=RT.SRM.Pred.Act$SRM.Predicted, y=RT.SRM.Pred.Act$SRM.RT, xlab="Predicted RT", ylab="Actual RT", main="Geoduck Peptide Retention Times\nActual ~ Predicted\nAdjusted R-squared=0.9933")
abline(RT.Fit)
dev.off()
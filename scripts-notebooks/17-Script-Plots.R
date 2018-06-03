# Plots for paper  

# Environmental parameters - daily mean, with error bars = standard deviation 

group.colors <- c(WB = "sienna1", CI = "goldenrod1", PG ="steelblue2",  FB = "royalblue3")

# Daily mean pH 

png("results/Environmental/pH-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Fidalgo Bay daily mean pH") + ylim(6.84, 8.24) + xlim("0016-06-01"," 0016-07-19")
dev.off() 

png("results/Environmental/pH-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Port Gamble Bay daily mean pH") + ylim(6.84, 8.24) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/pH-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Case Inlet daily mean pH") + ylim(6.84, 8.24) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/pH-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Willapa Bay daily mean pH") + ylim(6.84, 8.24) + xlim("0016-06-01"," 0016-07-19")
dev.off()

# Daily mean DO
png("results/Environmental/DO-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="DO" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3") + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Fidalgo Bay daily mean DO")  + ylim(0, 21) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/DO-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="DO" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Port Gamble Bay daily mean DO") + ylim(0, 21) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/DO-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="DO" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Case Inlet daily mean DO") + ylim(0, 21) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/DO-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="DO" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Willapa Bay daily mean DO") + ylim(0, 21) + xlim("0016-06-01"," 0016-07-19")
dev.off()

# Daily Mean Temperature 
png("results/Environmental/Temp-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Temperature" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3") + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Fidalgo Bay Temperature")  + ylim(10, 25) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Temp-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Temperature" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Port Gamble Bay Temperature") + ylim(10, 25) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Temp-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Temperature" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Case Inlet Temperature") + ylim(10, 25) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Temp-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Temperature" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Willapa Bay Temperature") + ylim(10, 25) + xlim("0016-06-01"," 0016-07-19")
dev.off()

# Daily Mean Salinity 
png("results/Environmental/Salinity-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Salinity" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3") + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Fidalgo Bay Salinity")  + ylim(25, 45) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Salinity-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Salinity" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Port Gamble Bay Salinity") + ylim(25, 45) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Salinity-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Salinity" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Case Inlet Salinity") + ylim(25, 45) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Salinity-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Salinity" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Willapa Bay Salinity") + ylim(25, 45) + xlim("0016-06-01"," 0016-07-19")
dev.off()
























# ------

# Draw Boxplots of differentially expressed proteins, by bay, keeping data as peptide abundance 

data.melted.plus.pepsum.Puromycin <- data.melted.plus.pepsum[grepl(c("Puromycin"), data.melted.plus.pepsum$Protein.Name),]
data.melted.plus.pepsum.HSP90 <- data.melted.plus.pepsum[grepl(c("HSP90"), data.melted.plus.pepsum$Protein.Name),]
data.melted.plus.pepsum.Trifunctional <- data.melted.plus.pepsum[grepl(c("Trifunctional"), data.melted.plus.pepsum$Protein.Name),]

png(file="results/SRM/Diff-Exp-Proteins-bay.png", width =800 , height =1000)
par(mfrow=c(3,1),
    oma = c(5,3,3,0) + 1,
    mar = c(0,0,3,2) + 0.1,
    cex = 1)
plot(data.melted.plus.pepsum.HSP90$lambda.t ~ data.melted.plus.pepsum.HSP90$SITE, main="Heat Shock Protein 90", xlab=NULL, ylab="Peptide Abundance", xaxt="n", yaxt="n")
axis(4)
plot(data.melted.plus.pepsum.Puromycin$lambda.t ~ data.melted.plus.pepsum.Puromycin$SITE, main="Puromycin-sensitive aminopeptidase", xlab=NULL, ylab="Peptide Abundance", xaxt="n", yaxt="n")
axis(4)
plot(data.melted.plus.pepsum.Trifunctional$lambda.t ~ data.melted.plus.pepsum.Trifunctional$SITE, main="Trifunctional enzyme subunit beta", xlab="SITE", ylab=NULL, yaxt="n")
axis(4)
title(main = "Differentially Expressed Proteins, SRM Analysis on Geoduck Ctenidia",
      xlab = "Bay",
      ylab = "Peptide Abundances, lambda-transformed",
      outer = TRUE, line = 2.25, cex.lab=1.5)
dev.off()

# Draw boxplots for each protein (peptides summed within protein) for diff. expressed proteins for paper

# First, generate summary data frames for each protein: 
library(dplyr)
library(ggplot2)

ProSumm4plot <- data.melted.plus.prosum[grepl(c("HSP90|Puromycin|Trifunctional"), data.melted.plus.prosum$Protein.Name),] %>% # the names of the new data frame and the data frame to be summarised
  group_by_at(vars(Protein.Name, SITE)) %>%   # the grouping variable
  summarise(mean = mean(mean),  # calculates the mean of each group
            sd = sd(mean), # calculates the standard deviation of each group
            n = n(),  # calculates the sample size per group
            SE = sd(mean)/sqrt(n())) # calculates the standard error of each group

ProSumm4plot.both <- data.melted.plus.prosum[grepl(c("HSP90|Puromycin|Trifunctional"), data.melted.plus.prosum$Protein.Name),] %>% # the names of the new data frame and the data frame to be summarised
  group_by_at(vars(Protein.Name, BOTH, SITE)) %>%   # the grouping variable
  summarise(mean = mean(mean),  # calculates the mean of each group
            sd = sd(mean), # calculates the standard deviation of each group
            n = n(),  # calculates the sample size per group
            SE = sd(mean)/sqrt(n())) # calculates the standard error of each group


### IMPORTANT ### 
# Barplots: mean peptide abundances summed by protein, error bars = standard error. 
marker1 = c("sienna1", "goldenrod1", "steelblue2", "royalblue3")
group.colors <- c(WB = "sienna1", CI = "goldenrod1", PG ="steelblue2",  FB = "royalblue3")


ggplot(ProSumm4plot[grepl(c("HSP90"), ProSumm4plot$Protein.Name),], aes(x=as.factor(Protein.Name), y=mean, fill=SITE)) +
  geom_bar(position=position_dodge(), stat="identity") + xlab("") + ylab("Mean Spectral Abundance") +
  geom_errorbar(aes(ymin=mean-SE, ymax=mean+SE), width=.2,position=position_dodge(.9)) +
  scale_fill_manual(values=group.colors, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) +
  theme_light() + theme(plot.title = element_text(size=19, face="bold"), axis.text.y=element_text(size=14, angle=45, face="bold"), axis.title=element_text(size=16,face="bold"), legend.position = c(0.3, .8), legend.title=element_blank(), legend.key.size = unit(2.5,"line"), legend.text=element_text(size=15, face="bold"), legend.background=element_blank(), panel.background = element_blank(), axis.text.x=element_blank()) + ggtitle("Heat Shock\nProtein 90-å") + guides(fill = guide_legend(reverse = TRUE))

ggplot(ProSumm4plot[grepl(c("Puromycin"), ProSumm4plot$Protein.Name),], aes(x=as.factor(Protein.Name), y=mean, fill=SITE)) +
  geom_bar(position=position_dodge(), stat="identity") + xlab("") + ylab("") +
  geom_errorbar(aes(ymin=mean-SE, ymax=mean+SE), width=.2,position=position_dodge(.9)) +
  scale_fill_manual(values=group.colors) +
  theme_light() + theme(plot.title = element_text(size=19, face="bold"), axis.text.y=element_text(size=15, angle=45, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank(), axis.text.x=element_blank()) + ggtitle("Puromycin-sensitive\nAminopeptidase ")

ggplot(ProSumm4plot[grepl(c("Trifunctional"), ProSumm4plot$Protein.Name),], aes(x=as.factor(BOTH), y=mean, fill=SITE)) +
  geom_bar(position=position_dodge(), stat="identity") + xlab("") + ylab("") +
  geom_errorbar(aes(ymin=mean-SE, ymax=mean+SE), width=.2,position=position_dodge(.9)) +
  scale_fill_manual(values=group.colors) +
  theme_light() + theme(plot.title = element_text(size=19, face="bold"), axis.text.y=element_text(size=15, angle=45, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank(), axis.text.x=element_blank()) + ggtitle("Trifunctional enzyme\nβ-subunit")

# Plot for NSA Presentation - break proteins down by both 

ProSumm4plot.both$BOTH<-factor(ProSumm4plot.both$BOTH, levels=c("WB-Bare", "WB-Eel",  "CI-Bare", "CI-Eel", "PG-Bare", "PG-Eel", "FB-Bare", "FB-Eel"))
ProSumm4plot.both$SITE<-factor(ProSumm4plot.both$SITE, levels=c("WB", "CI", "PG", "FB"))

ggplot(ProSumm4plot.both[grepl(c("Trifunctional"), ProSumm4plot.both$Protein.Name),], aes(x=as.factor(BOTH), y=mean, fill=SITE)) +
  geom_bar(position=position_dodge(), stat="identity") + xlab("") + ylab("") +
  geom_errorbar(aes(ymin=mean-SE, ymax=mean+SE), width=.2,position=position_dodge(.9)) +
  scale_fill_manual(values=group.colors) +
  theme_light() + theme(plot.title = element_text(size=19, face="bold"), axis.text.y=element_text(size=15, angle=45, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank(), axis.text.x=element_blank()) + ggtitle("Trifunctional enzyme\nβ-subunit")



# Boxplots by site/treatment

data.melted.plus.pepsum.HSP90$BOTH<-factor(data.melted.plus.pepsum.HSP90$BOTH, levels=c("WB-Bare", "WB-Eel",  "CI-Bare", "CI-Eel", "PG-Bare", "PG-Eel",  "FB-Bare", "FB-Eel"))
data.melted.plus.pepsum.Puromycin$BOTH<-factor(data.melted.plus.pepsum.Puromycin$BOTH, levels=c("WB-Bare", "WB-Eel",  "CI-Bare", "CI-Eel", "PG-Bare", "PG-Eel", "FB-Bare", "FB-Eel"))
data.melted.plus.pepsum.Trifunctional$BOTH<-factor(data.melted.plus.pepsum.Trifunctional$BOTH, levels=c("WB-Bare", "WB-Eel",  "CI-Bare", "CI-Eel", "PG-Bare", "PG-Eel",  "FB-Bare", "FB-Eel"))

png(file="results/SRM/Diff-Exp-Proteins-site.png", width =800 , height =1000)
par(mfrow=c(3,1),
    oma = c(5,3,3,0) + 1,
    mar = c(0,0,3,2) + 0.1,
    cex = 1)
plot(data.melted.plus.pepsum.HSP90$lambda.t ~ data.melted.plus.pepsum.HSP90$BOTH, main="Heat Shock Protein 90", xlab=NULL, ylab="Peptide Abundance", xaxt="n", yaxt="n")
axis(4)
plot(data.melted.plus.pepsum.Puromycin$lambda.t ~ data.melted.plus.pepsum.Puromycin$BOTH, main="Puromycin-sensitive aminopeptidase", xlab=NULL, ylab="Peptide Abundance", xaxt="n", yaxt="n")
axis(4)
plot(data.melted.plus.pepsum.Trifunctional$lambda.t ~ data.melted.plus.pepsum.Trifunctional$BOTH, main="Trifunctional enzyme subunit beta", xlab="SITE", ylab=NULL, yaxt="n")
axis(4)
title(main = "Differentially Expressed Proteins, SRM Analysis on Geoduck Ctenidia",
      xlab = "Site Locations",
      ylab = "Peptide Abundances, lambda-transformed",
      outer = TRUE, line = 2.25, cex.lab=1.5)
dev.off()

plot_ly(data=data.melted.plus.pepsum, y=~lambda.t, x=~Protein, type="box", color=~Sample.Shorthand) %>% 
  layout(title="Overall Protein Abundances, 2016 DNR outplant",
         yaxis = list(title = 'Protein Abundance'),
         legend = list(x=.85, y=.95))

plot_ly(data=data.melted.plus.pepsum, y=~lambda.t, x=~Protein, type="box", color=~Bay) %>% 
  layout(title="Overall Protein Abundances, 2016 DNR outplant",
         yaxis = list(title = 'Protein Abundance'),
         legend = list(x=.85, y=.95))

plot_ly(data=data.melted.plus.pepsum, y=~lambda.t, x=~Protein, type="box", color=~Habitat) %>% 
  layout(title="Overall Protein Abundances, 2016 DNR outplant",
         yaxis = list(title = 'Protein Abundance'),
         legend = list(x=.85, y=.95))

plot_ly(data=data.pepsum.Env.Stats, x=~Protein) %>% 
  add_trace(y=~Pep1, hovertext=~Protein, showlegend = FALSE, type="box") %>%
  add_trace(y=~Pep2, hovertext=~Protein, showlegend = FALSE, type="box") %>%
  add_trace(y=~Pep3, hovertext=~Protein, showlegend = FALSE, type="box") %>%
  layout(title="Overall Protein Abundances, \nbroken into peptides, 2016 DNR outplant",
         yaxis = list(title = 'Protein Abundance'),
         legend = list(x=.85, y=.95))
plot(lambda.t ~ Protein, data=data.melted.plus.pepsum, cex=1)



# Run stats: 

# Generate growth boxplot

Growth4plot <- Growth[!grepl(c("SK"), Growth$Bay),] %>% # Remove SK data
  group_by_at(vars(Both, Bay)) %>%   # the grouping variable
  summarise(mean = mean(Perc.Growth),  # calculates the mean of each group
            sd = sd(Perc.Growth), # calculates the standard deviation of each group
            n = n(),  # calculates the sample size per group
            SE = sd(Perc.Growth)/sqrt(n())) # calculates the standard error of each group

# Barplots: mean growth, error bars = standard error. 
marker1 = c("sienna1", "goldenrod1", "steelblue2", "royalblue3")
# group.colors <- c(WB = "sienna1", CI = "goldenrod1", PG ="steelblue2",  FB = "royalblue3")

Growth4plot$Both<-factor(Growth4plot$Both, levels=c("WB-B", "WB-E",  "CI-B", "CI-E", "PG-B", "PG-E", "FB-B", "FB-E"))
Growth4plot$Site<-factor(Growth4plot$Bay, levels=c("WB", "CI", "PG", "FB"))

ggplot(Growth4plot, aes(x=as.factor(Both), y=100*mean, fill=Site)) +
  geom_bar(position=position_dodge(), stat="identity") + xlab("") + ylab("Mean Growth (%)") +
  geom_errorbar(aes(ymin=100*(mean-SE), ymax=100*(mean+SE)), width=.2,position=position_dodge(.9)) +
  scale_fill_manual(values=group.colors, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) +
  theme_light() + theme(plot.title = element_text(size=19, face="bold"), axis.text.y=element_text(size=14, angle=45, face="bold"), axis.title=element_text(size=16,face="bold"), legend.position = "none", panel.background = element_blank(), axis.text.x=element_blank()) + ggtitle("Relative growth by Site") + guides(fill = guide_legend(reverse = TRUE))

# Revised barplot for size, not growth for NSA
Size <- read.csv("../../data/GeoduckGrowth-for-NSA-2.csv", header=TRUE, stringsAsFactors = FALSE, na.strings = "NA")
#marker2 = c("gray", "sienna1", "goldenrod1", "steelblue2", "royalblue3")
group.colors2 <- c(INITIAL = "gray", WB = "sienna1", CI = "goldenrod1", PG ="steelblue2",  FB = "royalblue3")
Size$BOTH<-factor(Size$BOTH, levels=c("INITIAL", "WB-B", "WB-E",  "CI-B", "CI-E", "PG-B", "PG-E", "FB-B", "FB-E"))
Size$SITE<-factor(Size$SITE, levels=c("INITIAL", "WB", "CI", "PG", "FB"))

# Size compared to initial
ggplot(Size, aes(x=as.factor(BOTH), y=Mean.Final, fill=SITE)) +
  geom_bar(position=position_dodge(), stat="identity") + xlab("") + ylab("Mean Length (mm)") +
  geom_errorbar(aes(ymin=Mean.Final-SD.Final, ymax=Mean.Final+SD.Final), width=.2,position=position_dodge(.9)) +
  scale_fill_manual(values=group.colors2, labels=c("Initial", "Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) +
  theme_light() + theme(plot.title = element_text(size=19, face="bold"), axis.text.y=element_text(size=14, angle=45, face="bold"), axis.title=element_text(size=16,face="bold"), legend.position = "none", panel.background = element_blank(), axis.text.x=element_blank()) + ggtitle("Growth by Site") + guides(fill = guide_legend(reverse = TRUE))

# Relative Size
ggplot(data=Growth, aes(x=as.factor(Both), y=Growth, fill=Bay)) +
  geom_bar(position=position_dodge(), stat="identity") + xlab("") + ylab("Relative Mean Length (mm)") +
  geom_errorbar(aes(ymin=(mean(Growth ~ Both)-sd(Growth ~ Both)), ymax=(mean(Growth~Both)+sd(Growth~Both)))), width=.2,position=position_dodge(.9)) +
  scale_fill_manual(values=group.colors2, labels=c("Initial", "Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) +
  theme_light() + theme(plot.title = element_text(size=19, face="bold"), axis.text.y=element_text(size=14, angle=45, face="bold"), axis.title=element_text(size=16,face="bold"), legend.position = "none", panel.background = element_blank(), axis.text.x=element_blank()) + ggtitle("Growth by Location") + guides(fill = guide_legend(reverse = TRUE))



## Need to figure out how to make eelgrass/bare pattern or colors different. 

ggplot(Survival4plot, aes(x=as.factor(Both), y=100*mean, fill=Site)) +
  geom_bar(position=position_dodge(), stat="identity") + xlab("") + ylab("Mean Sruvival (%)") +
  geom_errorbar(aes(ymin=100*(mean-SE), ymax=100*(mean+SE)), width=.2,position=position_dodge(.9)) +
  scale_fill_manual(values=group.colors, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) +
  theme_light() + theme(plot.title = element_text(size=19, face="bold"), axis.text.y=element_text(size=14, angle=45, face="bold"), axis.title=element_text(size=16,face="bold"), legend.position = "none", panel.background = element_blank(), axis.text.x=element_blank()) + ggtitle("Survival by Site") + guides(fill = guide_legend(reverse = TRUE))



### Need to figure out how to run chi-square test on all my data here. 
Survival4plot <- Survival %>% # Remove SK data
  group_by_at(vars(Both, Site)) %>%   # the grouping variable
  summarise(mean = mean(Survival),  # calculates the mean of each group
            sd = sd(Survival), # calculates the standard deviation of each group
            n = n(),  # calculates the sample size per group
            SE = sd(Survival)/sqrt(n())) # calculates the standard error of each group

Survival4plot$Both<-factor(Survival4plot$Both, levels=c("WB-B", "WB-E",  "CI-B", "CI-E", "PG-B", "PG-E", "FB-B", "FB-E"))
Survival4plot$Site<-factor(Survival4plot$Site, levels=c("WB", "CI", "PG", "FB"))

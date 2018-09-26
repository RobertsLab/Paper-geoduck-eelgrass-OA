# Plots for paper  

##### Map with bay locations 

# Import deployment latitude and longitude data
locationCords <- read.csv("data/Environmental/Deployment-Coordinates.csv", header = T, stringsAsFactors = T) #Import outplant coordinate information
locationCords <- locationCords[order(locationCords$Latitude),] #Reorder location coordinates by latittude (south to north)
locationCords.bay <- locationCords[c(2,4,6,7),] #pull out one set of coordinates for each bay 
marker1 = c("sienna1", "goldenrod1", "steelblue2", "royalblue3") #marker colors for each bay, from south to north 
symbols <- c(21, 22, 23, 24) #symbol shapes for each bay, south to north 
data(nepacLLhigh) #Load set of polygons for the NE Pacific Ocean in high resolution from PBSmapping

# Create file to save map 
# svg(filename = "results/Deployment-map.svg") # uncomment/comment depending on which file type you want 
png(filename = "results/Deployment-map.png") #save this way for now- need to make high resolution later 

# Create base map of coastal WA state 
plotMap(nepacLLhigh, xlim = c(-125, -121.9), ylim = c(46, 48.9), col = "gray92", bg = "gray85", xaxt = "n", yaxt = "n", xlab = "", ylab = "", ann = FALSE) #Create a map with high resolution NE Pacific Ocean data. Remove axes since those will be manually added

# Modify base map 
axis(side = 1, at = c(-124.5, -124, -123.5, -123, -122.5), labels=c("124.5°W", "124°W", "123.5°W", "123°W", "122.5°W"), tick = TRUE, col.axis = "grey20") #Add longitude axis
axis(side = 2, at = c(46.5, 47, 47.5, 48, 48.5), labels=c("46.5ºN", "47°N", "47.5°N", "48°N", "48.5°N"), tick = TRUE, col.axis = "grey20") #Add latitude axis

#Add points to map 
for (i in 1:length(symbols)) {
  points(x = locationCords.bay$Longitude[i], y = locationCords.bay$Latitude[i], pch= symbols[i], add = TRUE, col = marker1[i], bg=marker1[i], lwd=2, cex=2.5)
}
# Add legend 
legend("topleft", inset=0.05, legend=rev(locationCords.bay$Site), col=rev(marker1), cex=1.2, pt.cex = 2, pt.bg=rev(marker1), bg="gray92", pch=rev(symbols), box.lty=1, box.lwd=1, box.col="black")
dev.off() #Turn off plotting device

#####  Environmental parameter time series - daily mean over time, gray ribbons = daily standard deviation 

group.colors <- c(WB = "sienna1", CI = "goldenrod1", PG ="steelblue2",  FB = "royalblue3")

# Daily mean pH 

# Fidalgo Bay
#png("results/Environmental/pH-FB-daily-mean.png", width=700, height=685)

pH.FB <- ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=14, face="bold", margin=margin(0,0,2,0)), axis.text.y=element_text(size=14, angle=45), axis.text.x=element_text(size=14, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=14, face="bold"), axis.title.y=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Fidalgo Bay daily mean pH") + ylim(6.84, 8.24) + labs(x="Date", y="pH", size=14) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + theme(plot.margin=unit(c(.2,.2,.5,0),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))

#Port Gamble
pH.PG <- ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=14, face="bold", margin=margin(0,0,2,0)), axis.text.y=element_text(size=14, angle=45), axis.text.x=element_text(size=14, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Port Gamble Bay daily mean pH") + ylim(6.84, 8.24)  + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + theme(plot.margin=unit(c(.2,.2,.5,0),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))

#Case Inlet
pH.CI <- ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=14, face="bold", margin=margin(0,0,2,0)), axis.text.y=element_text(size=14, angle=45), axis.title.y=element_blank(), legend.position = "none", panel.background = element_blank()) +  ggtitle("Case Inlet daily mean pH") + ylim(6.84, 8.24)  + labs(x="Date", y="pH", size=18) + theme(plot.margin=unit(c(.2,.2,.5,0),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())

#Willapa Bay
pH.WB <- ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=14, face="bold", margin=margin(0,0,2,0)), axis.text.y=element_text(size=14, angle=45), axis.text.x=element_text(size=14, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=16, face="bold"), axis.title.y=element_blank(), legend.position = "none", panel.background = element_blank()) + labs(x="Date", y="pH", size=16) +  ggtitle("Willapa Bay daily mean pH") + ylim(6.84, 8.24) + theme(plot.margin=unit(c(.2,.2,.2,0),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))

plot_grid(pH.FB, pH.PG, pH.CI, pH.WB,
          align = "v",   
          nrow=4,
          rel_heights = c(.5, .5, .5, .7)) #adjust row heights so plots in last row aren't smaller (they have x-axis tex
# saved with width=600, height=1200

#### Relative Growth 

# Boxplot outline colors 
group.colors2 <- c(`WB-U` = "sienna3", `WB-E` = "sienna1", `CI-U` = "goldenrod3", `CI-E` = "goldenrod1", `PG-U` ="steelblue3", `PG-E` ="steelblue2", `FB-U` = "royalblue4", `FB-E` = "royalblue3")

# Boxplot fill colors 
group.colors3 <- c(`WB-U` = "sienna1", `WB-E` = "white", `CI-U` = "goldenrod1", `CI-E` = "white", `PG-U` ="steelblue2", `PG-E` ="white", `FB-U` = "royalblue3", `FB-E` = "white")

# Reorder factors geographically, north to south (FB -> PGB -> CI -> WB)
Growth$Both<-factor(Growth$Both, levels=c("FB-U", "FB-E", "PG-U", "PG-E", "CI-U", "CI-E", "WB-U", "WB-E"))
Growth$Bay<-factor(Growth$Bay, levels=c("FB", "PG", "CI", "WB"))

png("results/Growth-plot.png", width=700, height=700)
ggplot(Growth, aes(x=factor(Both), y=as.numeric(Growth), color=Both, fill=Both)) + geom_boxplot() + xlab("Location") + ylab("Growth (mm)") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=26, face="bold"), axis.text.y=element_text(size=28, angle=45, face="bold"), axis.text.x=element_text(size=24, angle=45, hjust=0.95, vjust=0.9), axis.title=element_text(size=28,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("Growth (mm) relative to \ninitial group length") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + ylim(-3,8.25) + 
  annotate('segment', x = 4.75, xend = 8.25, y = 5, yend=5, colour="black") + 
  annotate('segment', x = 0.75, xend = 4.25, y = 6.5, yend=6.5, colour="black") + 
  annotate('segment', x = 2.5, xend = 6.5, y = 7.5, yend=7.5, colour="black") +
  annotate('segment', x=2.5, xend=2.5, y=6.75, yend=7.5, colour="black") +
  annotate('segment', x=6.5, xend=6.5, y=5.25, yend=7.5, colour="black") +
  annotate("text", x=4.5, y=8, label =" p = 4.9e-11", size=7) 
dev.off()

# Protein plots 

# generate dataframe with mean peptide abundance for each protein, each sample 
data.melted.plus.promean <- aggregate(value ~ Sample + Protein + Region + Bay + Habitat + Exclosure + Sample.Shorthand, data.melted.plus, mean)
write.csv(data.melted.plus.promean, "results/SRM/SRM-data-protein-meanpeptide.csv") #save to file 

# Swap out "U" (unvegetated) for "B" (bare) in the location code 
data.melted.plus.promean$Sample.Shorthand <- sub("-B", "-U", data.melted.plus.promean$Sample.Shorthand)
  
# Reorder factors geographically, north to south (FB -> PGB -> CI -> WB)
data.melted.plus.promean$Sample.Shorthand <- as.factor(data.melted.plus.promean$Sample.Shorthand)
data.melted.plus.promean$Sample.Shorthand<-factor(data.melted.plus.promean$Sample.Shorthand, levels=c("FB-U", "FB-E", "PG-U", "PG-E",  "CI-U", "CI-E", "WB-U", "WB-E"))
data.melted.plus.promean$Bay<-factor(data.melted.plus.promean$Bay, levels=c("FB", "PG", "CI", "WB"))

# create empty protein plot list 
protein.plots <- vector("list", length(Protein.names))
names(protein.plots) <- Protein.names

# generate ggplot boxplot for each protein, with base formatting 
for (i in 1:length(Protein.names)) {
  protein.plots[[i]] <-  ggplot(subset(data.melted.plus.promean, Protein==Protein.names[[i]]), aes(x=factor(Sample.Shorthand), y=value, color=Sample.Shorthand, fill=Sample.Shorthand)) + geom_boxplot() + scale_color_manual(values=group.colors2) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=14, face="bold", margin=margin(0,0,2,0)), axis.title.y=element_blank(), axis.text.y=element_text(size=14, face="bold", angle=25), axis.text.x=element_text(size=14, angle=45, hjust=0.95, vjust=0.9, face="bold"), axis.title=element_text(size=14,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle(Protein.names[[i]]) + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.1,.1,.1,.1),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) +   theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
}

# customize each boxplot with title, and y axis, and last 2 plots with x-axis text and title 
protein.plots[[1]] <- protein.plots[[1]] + ggtitle("arachidonate 5-lipoxygenase") + scale_y_continuous(labels=scales::scientific, breaks=c(1e6, 2e6, 3e6))
protein.plots[[2]] <- protein.plots[[2]] + ggtitle("catalase") + scale_y_continuous(labels=scales::scientific)
protein.plots[[3]] <- protein.plots[[3]] + ggtitle("cytochrome P450") + scale_y_continuous(labels=scales::scientific, breaks=c(2e5, 4e5, 6e5))
protein.plots[[4]] <- protein.plots[[4]] + ggtitle("glycogen phosphorylase") + scale_y_continuous(labels=scales::scientific, breaks=c(3e5, 5.5e5, 8e5))
# protein.plots[[5]] <- do not include HSP70 (omitted in screening)
protein.plots[[6]] <- protein.plots[[6]] + ggtitle("**heat shock protein 90-alpha") + scale_y_continuous(labels=scales::scientific, breaks=c(2e6, 4e6, 6e6))
protein.plots[[7]] <- protein.plots[[7]] + ggtitle("protein disulfide-isomerase") + scale_y_continuous(labels=scales::scientific, breaks=c(1.5e6, 2.5e6, 3.5e6))
# protein.plots[[8]]  <- do not include Peroxiredoxin-1 (omitted in screening)
protein.plots[[9]] <- protein.plots[[9]] + ggtitle("*puromycin-sensitive aminopeptidase") + scale_y_continuous(labels=scales::scientific, breaks=c(2e5, 6e5, 1e6))
# protein.plots[[10]] <- do not include Ras-related protein (omitted in screening)
protein.plots[[11]] <- protein.plots[[11]] + ggtitle("Na/K-transporting ATPase") + scale_y_continuous(labels=scales::scientific, breaks=c(1.3e5, 2.5e5, 3.7e5))
protein.plots[[12]] <- protein.plots[[12]] + xlab("Location") + theme(axis.text.x=element_text(size=14, angle=45, hjust=0.95, vjust=0.9, face="bold"), axis.title.x=element_text(size=14,face="bold")) + ggtitle("superoxide dismutase") + scale_y_continuous(labels=scales::scientific, breaks=c(2e5, 4e5, 6e5))
protein.plots[[13]] <- protein.plots[[13]] + xlab("Location") + theme(axis.text.x=element_text(size=14, angle=45, hjust=0.95, vjust=0.9, face="bold"), axis.title.x=element_text(size=14,face="bold")) + ggtitle("**trifunctional enzyme β-subunit") + scale_y_continuous(labels=scales::scientific, breaks=c(6e4, 1.4e5, 2.2e5))

plot_grid(protein.plots[[1]],
          protein.plots[[2]],
          protein.plots[[3]],
          protein.plots[[4]],
          protein.plots[[6]],
          protein.plots[[7]],
          protein.plots[[9]],
          protein.plots[[11]],
          protein.plots[[12]],
          protein.plots[[13]],
          align = "v",   
          nrow=5, 
          rel_heights = c(rep(.5, times=4), 0.7)) #adjust row heights so plots in last row aren't smaller (they have x-axis text)

#### Plots included in supplementary 

#####  NMDS Plot
marker1 = c("sienna1", "goldenrod1", "steelblue2", "royalblue3")

png("results/SRM/SRM-NMDS-for-paper.png", width = 800, height = 600) 
par(mar=c(5,5,4,1)+.1)
plot.default(x=NULL, y=NULL, type="n", xlab="Axis 1", ylab="Axis 2", xlim=c(-3.8,3), ylim=c(-0.28,0.22), asp=NA, main="Geoduck SRM Protein Abundance\nNMDS Similarity Plot", width=600,height=600, cex.axis=1.8, cex.lab=1.8, cex.main=1.8)
points(SRM.nmds4plotly[c(CI.B.samples),], col=marker1[2], pch=15, cex=2.7, lwd=2)
points(SRM.nmds4plotly[c(CI.E.samples),], col=marker1[2], pch=8, cex=2.7, lwd=2)
points(SRM.nmds4plotly[c(PG.B.samples),], col=marker1[3], pch=15, cex=2.7, lwd=2)
points(SRM.nmds4plotly[c(PG.E.samples),], col=marker1[3], pch=8, cex=2.7, lwd=2)
points(SRM.nmds4plotly[c(WB.B.samples),], col=marker1[1], pch=15, cex=2.7, lwd=2)
points(SRM.nmds4plotly[c(WB.E.samples),], col=marker1[1], pch=8, cex=2.7, lwd=2)
points(SRM.nmds4plotly[c(FB.B.samples),], col=marker1[4], pch=15, cex=2.7, lwd=2)
points(SRM.nmds4plotly[c(FB.E.samples),], col=marker1[4], pch=8, cex=2.7, lwd=2)
legend(-3.6,0.22, pch=c(rep(16,4), 8, 15), cex=1.4, legend=c("Fidalgo Bay", "Port Gamble", 'Case Inlet', "Willapa Bay", "Eelgrass", "Unvegetated"), col=c(marker1[4], marker1[3], marker1[2], marker1[1], "black", "black"))
dev.off()

# Daily mean DO

#Fidalgo Bay
png("results/Environmental/DO-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="DO" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3") + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(A) Fidalgo Bay daily mean DO") + ylim(0, 21) + labs(x="Date", y="DO (mg/L)", size=18) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()

# Port Gamble Bay
png("results/Environmental/DO-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="DO" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("(B) Port Gamble Bay daily mean DO") + ylim(0, 21)  + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()

# Case Inlet
png("results/Environmental/DO-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="DO" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) +  ggtitle("(C) Case Inlet daily mean DO") + ylim(0, 21)  + labs(x="Date", y="DO (mg/L)", size=18) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()

# Willapa Bay
png("results/Environmental/DO-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="DO" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1") + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + scale_linetype_manual(values=c("dashed", "solid")) + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) + labs(x="Date", y="DO (mg/L)", size=18) +  ggtitle("(D) Willapa Bay daily mean DO") + ylim(0, 21) + theme(axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + theme(plot.margin=unit(c(.2,.2,.2,1),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()

# Daily mean Temperature

#Fidalgo Bay
png("results/Environmental/Temp-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Temperature" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3") + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(A) Fidalgo Bay daily mean temperature") + ylim(10, 25) + labs(x="Date", y="Temperature (°C)", size=18) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()

#Port Gamble Bay
png("results/Environmental/Temp-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Temperature" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("(B) Port Gamble Bay daily mean temperature") + ylim(10, 25)  + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()

# Case Inlet
png("results/Environmental/Temp-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Temperature" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) +  ggtitle("(C) Case Inlet daily mean temperature") + ylim(10, 25)  + labs(x="Date", y="Temperature (°C)", size=18) + theme(plot.margin=unit(c(.2,.5,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()

# Willapa Bay
png("results/Environmental/Temp-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Temperature" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1") + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + scale_linetype_manual(values=c("dashed", "solid")) + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) + labs(x="Date", y="DO (mg/L)", size=18) +  ggtitle("(D) Willapa Bay daily mean temperature") + ylim(10, 25) + theme(axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + theme(plot.margin=unit(c(.2,.2,.2,1),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()


# Daily mean Salinity

# Fidalgo Bay
png("results/Environmental/Salinity-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Salinity" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3") + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(A) Fidalgo Bay daily mean salinity") + labs(x="Date", y="Salinity (PSU)", size=18) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + theme(plot.margin=unit(c(.2,.2,.8,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + ylim(20.2, 31.1)
dev.off()

#Port Gamble Bay
png("results/Environmental/Salinity-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Salinity" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("(B) Port Gamble Bay daily mean salinity")  + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))  + ylim(20.2, 31.1)
dev.off()

#Case Inlet
png("results/Environmental/Salinity-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Salinity" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) +  ggtitle("(C) Case Inlet daily mean salinity")  + labs(x="Date", y="Salinity (PSU)", size=18) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))  + ylim(20.2, 31.1)
dev.off()

# Willapa Bay
png("results/Environmental/Salinity-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="Salinity" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1") + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + scale_linetype_manual(values=c("dashed", "solid")) + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) + labs(x="Date", y="DO (mg/L)", size=18) +  ggtitle("(D) Willapa Bay daily mean salinity") + theme(axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + theme(plot.margin=unit(c(.2,.2,.2,1),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + ylim(20.2, 31.1)
dev.off()







#### below are plots not included in current paper draft 

# Initial length

# Import initial size data for plot 
InitialSize <- read.csv("data/GeoduckInitialSize.csv", header=TRUE, stringsAsFactors = TRUE, na.strings = "NA")
InitialSize.long <- melt(InitialSize, id=c("Region", "Bay", "Habitat", "Both", "Exclosure"))
InitialSize.long$value <- as.numeric(InitialSize.long$value)

# Reorder factors geographically, south to north (WB -> CI -> PGB -> FB)
InitialSize.long$Both<-factor(InitialSize.long$Both, levels=c("WB-U", "WB-E",  "CI-U", "CI-E", "PG-U", "PG-E", "FB-U", "FB-E"))
InitialSize.long$Bay<-factor(InitialSize.long$Bay, levels=c("WB", "CI", "PG", "FB"))

png("results/Initial-shell-length.png", width=700, height=700)
ggplot(InitialSize.long, aes(x=factor(Both), y=as.numeric(value), color=Both, fill=Both)) + geom_boxplot() + xlab("Location") + ylab("Length (mm)") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3)+ theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title=element_text(size=18,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(A) Initial shell length") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + ylim(12, 20)
dev.off()

# Final shell length by location 
png("results/Final-shell-length.png", width=700, height=700)
ggplot(Growth, aes(x=factor(Both), y=as.numeric(FShell), color=Both, fill=Both)) + geom_boxplot() + xlab("Location") + ylab("Final Length (mm)") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank(), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title=element_text(size=18,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(B) Final shell length") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))+ ylim(12, 20)
dev.off()

# Proteins found to be different between bays / regions  

# i don't think i used this ... ? 
#Protein.SRM.boxplot.Both <- data.melted.plus.promean[grepl(c("HSP90|Puromycin|Trifunctional"), data.melted.plus.promean$Protein),] %>% # the names of the new data frame and the data frame to be summarised
#  group_by_at(vars(Protein, Sample.Shorthand, Bay)) %>%   # the grouping variable
#  summarise(mean = mean(value),  # calculates the mean of each group
#            sd = sd(value), # calculates the standard deviation of each group
#            n = n(),  # calculates the sample size per group
#            SE = sd(value)/sqrt(n())) # calculates the standard error of each group

# HSP90 - for paper 
png("results/SRM/HSP90-boxplot.png", width=700, height=500)
hsp90.plot <- ggplot(data.melted.plus.promean[grepl(c("HSP90"), data.melted.plus.promean$Protein),], aes(x=factor(Sample.Shorthand), y=value, color=Sample.Shorthand, fill=Sample.Shorthand)) + geom_boxplot() + xlab("Location") + ylab("Mean peptide spectral abundance") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=26, face="bold"), axis.text.y=element_text(size=22, face="bold", angle=25), axis.title.x="Mean peptide spectral abundance", axis.title.y=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("(A) Heat Shock Protein 90-α") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,1,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + scale_y_continuous(labels = scales::scientific, breaks = c(1.7e5, 3.1e6, 7.4e6))
hsp90.plot
dev.off()

summary(data.melted.plus.promean[grepl(c("HSP90"), data.melted.plus.promean$Protein),"value"])

# HSP90 - alternative, for more detailed axes
# png("results/SRM/HSP90-boxplot.png", width=700, height=700)
# ggplot(data.melted.plus.promean[grepl(c("HSP90"), data.melted.plus.promean$Protein),], aes(x=factor(Sample.Shorthand), y=value, color=Sample.Shorthand, fill=Sample.Shorthand)) + geom_boxplot() + xlab("Location") + ylab("Mean spectral abundance") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title=element_text(size=18,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(A) Heat Shock Protein 90-α") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,1,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + scale_y_continuous(breaks = c(1e6, 2e6, 3e6, 4e6, 5e6, 6e6, 7e6))
# dev.off()

# Puromycin
png("results/SRM/Puromycin-boxplot.png", width=700, height=500)
puromycin.plot <- ggplot(data.melted.plus.promean[grepl(c("Puromycin"), data.melted.plus.promean$Protein),], aes(x=factor(Sample.Shorthand), y=value, color=Sample.Shorthand, fill=Sample.Shorthand)) + geom_boxplot() + xlab("Location") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=26, face="bold"), axis.text.y=element_text(size=22, face="bold", angle=25), axis.title.x=element_blank(), axis.title.y=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("(B) Puromycin-sensitive Aminopeptidase") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,1.5,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) +  scale_y_continuous(labels = scales::scientific, breaks=c(4.5e4, 5.3e5, 1.2e6))
puromycin.plot
dev.off()

summary(data.melted.plus.promean[grepl(c("Puromycin"), data.melted.plus.promean$Protein),"value"])

# Trifunctional 
png("results/SRM/Trifunctional-boxplot.png", width=700, height=525)
TEB.plot <- ggplot(data.melted.plus.promean[grepl(c("Trifunctional"), data.melted.plus.promean$Protein),], aes(x=factor(Sample.Shorthand), y=value, color=Sample.Shorthand, fill=Sample.Shorthand)) + geom_boxplot() + xlab("Location") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=26, face="bold"), axis.title.y=element_blank(), axis.text.y=element_text(size=22, face="bold", angle=25), axis.text.x=element_text(size=24, angle=45, hjust=0.95, vjust=0.9, face="bold"), axis.title=element_text(size=24,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(C) Trifunctional enzyme β-subunit") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + scale_y_continuous(labels = scales::scientific, breaks=c(1.4e4, 1.1e5, 2.4e5))
TEB.plot
dev.off()

summary(data.melted.plus.promean[grepl(c("Trifunctional"), data.melted.plus.promean$Protein),"value"])

# Try combined plot 

png("results/SRM/Three-protein-boxplot.png", width=600, height=1000)
ggplot(data.melted.plus.promean[grepl(c("Trifunctional"), data.melted.plus.promean$Protein),], aes(x=factor(Sample.Shorthand), y=value, color=Sample.Shorthand, fill=Sample.Shorthand)) + geom_boxplot() + xlab("Location") + ylab("Mean peptide spectral abundance") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=22, face="bold"), axis.text.x=element_text(size=22, angle=45, hjust=0.95, vjust=0.9), axis.title=element_text(size=22,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("Proteins significantly different\nbetween bay & region**, and region only*") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + 
  geom_boxplot(data=data.melted.plus.promean[grepl(c("HSP90"), data.melted.plus.promean$Protein),]) +
  geom_boxplot(data=data.melted.plus.promean[grepl(c("Puromycin"), data.melted.plus.promean$Protein),]) + scale_y_continuous(trans='sqrt', labels=scales::scientific, breaks=c(9.9e4,  4.6e5, 3.0e6), sec.axis = sec_axis(~., name = "", breaks=c(9.9e4,  4.6e5, 3.0e6), labels = c("TEβ**", "PSA*", "HSP90**"))) 
dev.off()



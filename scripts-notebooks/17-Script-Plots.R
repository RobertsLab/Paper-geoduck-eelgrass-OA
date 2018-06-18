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
png("results/Environmental/pH-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(A) Fidalgo Bay daily mean pH") + ylim(6.84, 8.24) + labs(x="Date", y="pH", size=18) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + theme(plot.margin=unit(c(.2,.2,.5,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off() 

#Port Gamble
png("results/Environmental/pH-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("(B) Port Gamble Bay daily mean pH") + ylim(6.84, 8.24)  + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()

#Case Inlet
png("results/Environmental/pH-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) +  ggtitle("(C) Case Inlet daily mean pH") + ylim(6.84, 8.24)  + labs(x="Date", y="pH", size=18) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()

#Willapa Bay
png("results/Environmental/pH-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts.geo_daily, (metric=="pH" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title.x=element_text(size=18, face="bold"), axis.title.y=element_text(size=18, face="bold"), legend.position = "none", panel.background = element_blank()) + labs(x="Date", y="pH", size=18) +  ggtitle("(D) Willapa Bay daily mean pH") + ylim(6.84, 8.24) + theme(axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + theme(plot.margin=unit(c(.2,.2,.2,1),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))
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

#### Initial vs. Final geoduck length plots 

# Import initial size data for plot 
InitialSize <- read.csv("data/GeoduckInitialSize.csv", header=TRUE, stringsAsFactors = TRUE, na.strings = "NA")
InitialSize.long <- melt(InitialSize, id=c("Region", "Bay", "Habitat", "Both", "Exclosure"))
InitialSize.long$value <- as.numeric(InitialSize.long$value)

# Boxplot outline colors 
group.colors2 <- c(`WB-U` = "sienna3", `WB-E` = "sienna1", `CI-U` = "goldenrod3", `CI-E` = "goldenrod1", `PG-U` ="steelblue3", `PG-E` ="steelblue2", `FB-U` = "royalblue4", `FB-E` = "royalblue3")

# Boxplot fill colors 
group.colors3 <- c(`WB-U` = "sienna1", `WB-E` = "white", `CI-U` = "goldenrod1", `CI-E` = "white", `PG-U` ="steelblue2", `PG-E` ="white", `FB-U` = "royalblue3", `FB-E` = "white")

# Reorder factors geographically, south to north (WB -> CI -> PGB -> FB)
InitialSize.long$Both<-factor(InitialSize.long$Both, levels=c("WB-U", "WB-E",  "CI-U", "CI-E", "PG-U", "PG-E", "FB-U", "FB-E"))
InitialSize.long$Bay<-factor(InitialSize.long$Bay, levels=c("WB", "CI", "PG", "FB"))

# Initial length
png("results/Initial-shell-length.png", width=700, height=700)
ggplot(InitialSize.long, aes(x=factor(Both), y=as.numeric(value), color=Both, fill=Both)) + geom_boxplot() + xlab("Location") + ylab("Length (mm)") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3)+ theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title=element_text(size=18,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(A) Initial shell length") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + ylim(12, 20)
dev.off()

# Final length

# Reorder factors geographically, south to north (WB -> CI -> PGB -> FB)
Growth$Both<-factor(Growth$Both, levels=c("WB-U", "WB-E",  "CI-U", "CI-E", "PG-U", "PG-E", "FB-U", "FB-E"))
Growth$Bay<-factor(Growth$Bay, levels=c("WB", "CI", "PG", "FB"))

png("results/Final-shell-length.png", width=700, height=700)
ggplot(Growth, aes(x=factor(Both), y=as.numeric(FShell), color=Both, fill=Both)) + geom_boxplot() + xlab("Location") + ylab("Final Length (mm)") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank(), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title=element_text(size=18,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(B) Final shell length") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1))+ ylim(12, 20)
dev.off()


#### Boxplots of abundance data for differentially expressed proteins

# generate dataframe with mean peptide abundance for each protein, each sample (for barplots)
data.melted.plus.promean <- aggregate(value ~ Sample + Protein + Region + Bay + Habitat + Exclosure + Sample.Shorthand, data.melted.plus, mean)
write.csv(data.melted.plus.promean, "results/SRM/SRM-data-protein-meanpeptide.csv") #save to file 

#Protein.SRM.boxplot.Both <- data.melted.plus.promean[grepl(c("HSP90|Puromycin|Trifunctional"), data.melted.plus.promean$Protein),] %>% # the names of the new data frame and the data frame to be summarised
  group_by_at(vars(Protein, Sample.Shorthand, Bay)) %>%   # the grouping variable
  summarise(mean = mean(value),  # calculates the mean of each group
            sd = sd(value), # calculates the standard deviation of each group
            n = n(),  # calculates the sample size per group
            SE = sd(value)/sqrt(n())) # calculates the standard error of each group


# Swap out "U" (unvegetated) for "B" (bare) in the location code 
data.melted.plus.promean$Sample.Shorthand <- sub("-B", "-U", data.melted.plus.promean$Sample.Shorthand)
head(data.melted.plus.promean)
# Relevel factors for plot 
# Reorder factors geographically, south to north (WB -> CI -> PGB -> FB)
data.melted.plus.promean$Sample.Shorthand<-factor(data.melted.plus.promean$Sample.Shorthand, levels=c("WB-U", "WB-E",  "CI-U", "CI-E", "PG-U", "PG-E", "FB-U", "FB-E"))
data.melted.plus.promean$Sample.Shorthand<-factor(data.melted.plus.promean$Sample.Shorthand, levels=c("WB", "CI", "PG", "FB"))

# HSP90 - for paper 
png("results/SRM/HSP90-boxplot.png", width=700, height=700)
ggplot(data.melted.plus.promean[grepl(c("HSP90"), data.melted.plus.promean$Protein),], aes(x=factor(Sample.Shorthand), y=value, color=Sample.Shorthand, fill=Sample.Shorthand)) + geom_boxplot() + xlab("Location") + ylab("Mean spectral abundance") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title=element_text(size=18,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(A) Heat Shock Protein 90-α") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,1,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + scale_y_continuous(breaks = c(1e6, 2e6, 3e6, 4e6, 5e6, 6e6, 7e6))
dev.off()

# HSP90 - alternative, for more detailed axes
# png("results/SRM/HSP90-boxplot.png", width=700, height=700)
# ggplot(data.melted.plus.promean[grepl(c("HSP90"), data.melted.plus.promean$Protein),], aes(x=factor(Sample.Shorthand), y=value, color=Sample.Shorthand, fill=Sample.Shorthand)) + geom_boxplot() + xlab("Location") + ylab("Mean spectral abundance") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title=element_text(size=18,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(A) Heat Shock Protein 90-α") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,1,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + scale_y_continuous(breaks = c(1e6, 2e6, 3e6, 4e6, 5e6, 6e6, 7e6))
# dev.off()

# Puromycin
png("results/SRM/Puromycin-boxplot.png", width=700, height=700)
ggplot(data.melted.plus.promean[grepl(c("Puromycin"), data.melted.plus.promean$Protein),], aes(x=factor(Sample.Shorthand), y=value, color=Sample.Shorthand, fill=Sample.Shorthand)) + geom_boxplot() + xlab("Location") + ylab("Mean spectral abundance") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title=element_text(size=18,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(B) Puromycin-sensitive Aminopeptidase") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,1.5,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + scale_y_continuous(labels = scales::scientific,  breaks = c(2e5, 4e5, 6e5, 8e5, 1e6, 1.2e6))
dev.off()

# Trifunctional 
png("results/SRM/Trifunctional-boxplot.png", width=700, height=725)
ggplot(data.melted.plus.promean[grepl(c("Trifunctional"), data.melted.plus.promean$Protein),], aes(x=factor(Sample.Shorthand), y=value, color=Sample.Shorthand, fill=Sample.Shorthand)) + geom_boxplot() + xlab("Location") + ylab("Mean spectral abundance") + scale_color_manual(values=group.colors2, labels=c("Willapa Bay", "Case Inlet", "Port Gamble Bay", "Fidalgo Bay")) + scale_fill_manual(values=group.colors3) + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, angle=45, hjust=0.95, vjust=0.9), axis.title=element_text(size=18,face="bold"), legend.position = "none", panel.background = element_blank()) + ggtitle("(C) Trifunctional enzyme β-subunit") + guides(fill = guide_legend(reverse = TRUE)) + theme(plot.margin=unit(c(.2,.2,.2,.2),"cm"), panel.border = element_rect(colour = "black", fill=NA, size=1)) + scale_y_continuous(labels = scales::scientific)
dev.off()

  


















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
  geom_errorbar(aes(ymin=(mean(Growth ~ Both)-sd(Growth ~ Both)), ymax=(mean(Growth~Both)+sd(Growth~Both))), width=.2,position=position_dodge(.9)) +
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

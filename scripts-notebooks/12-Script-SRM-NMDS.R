## NMDS plot of SRM data 

#reformat data: 
SRM.matrix <- dcast(SRM.final, Transition ~ Sample, value.var="mean")

#Replace NA cells with 0; metaMDS() does not handle NA's
rownames(SRM.matrix) <- as.character(SRM.matrix[,1])
SRM.matrix[is.na(SRM.matrix)] <- 0

#Make MDS dissimilarity matrix
SRM.mean.nmds <- metaMDS(SRM.matrix[-1], distance = 'bray', k = 2, trymax = 10000, autotransform = FALSE)

#Make NMDS stressplot
png("results/SRM/SRM-NMDS-stressplot.png")
stressplot(SRM.mean.nmds) 
dev.off()

#Create plots 
SRM.nmds.mean.samples <- scores(SRM.mean.nmds, display = "species")
SRM.nmds4plotly <- as.data.frame(SRM.nmds.mean.samples)
SRM.nmds4plotly$Sample <- rownames(SRM.nmds4plotly)
SRM.nmds4plotly.annotated <- merge(x=SRM.nmds4plotly, y=repsTOsamples.filtered.annotated[,c("Comment", "Bay", "Habitat", "Exclosure", "Sample.Shorthand")], by.x="Sample", by.y="Comment", all.x=T, all.y=F)
SRM.nmds4plotly.annotated[c("Bay", "Habitat", "Exclosure", "Sample.Shorthand")] <- lapply(SRM.nmds4plotly.annotated[c("Bay", "Habitat", "Exclosure", "Sample.Shorthand")], factor)

# Interactive Plotly plot 
p.SRM.NMDS <- plot_ly(data=SRM.nmds4plotly.annotated, x=~NMDS1, y=~NMDS2, color=~Bay, symbol=~Habitat, type="scatter", mode="markers", marker = list(size = 20), colors=marker, hoverinfo = 'text', text = ~Sample) %>% 
  layout(title="SRM NMDS of all proteins by Site, Treatment",
         xaxis = list(title = 'NMDS Axis 1'),
         yaxis = list(title = 'NMDS Axis 2'))
api_create(p.SRM.NMDS, filename = "Geoduck-SRM-NMDS") #Pushes plot to Plotly online 
plotly_IMAGE(p.SRM.NMDS, width = 1000, height = 1000, format = "png", scale = 2,
             out_file = "results/SRM/Geoduck-SRM-NMDS.png")

# Plot for paper 
marker1 = c("sienna1", "goldenrod1", "steelblue2", "royalblue3")

png("results/SRM/SRM-NMDS-for-paper.png", width = 800, height = 600) 
par(mar=c(5,5,4,1)+.1)
plot.default(x=NULL, y=NULL, type="n", xlab="Axis 1", ylab="Axis 2", xlim=c(-3.6,3), ylim=c(-0.28,0.22), asp=NA, main="Geoduck SRM Protein Abundance\nNMDS Similarity Plot", width=600,height=600, cex.axis=1.8, cex.lab=1.8, cex.main=1.8)
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


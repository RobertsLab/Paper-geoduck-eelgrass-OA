## NMDS plot of SRM data 

#reformat data: 
SRM.matrix <- dcast(SRM.final[!(SRM.final$Protein %in% c("HSP70", "Peroxiredoxin-1", "Ras-related")), ], Transition ~ Sample, value.var="mean")

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
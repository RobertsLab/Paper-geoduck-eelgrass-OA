



















# Prepare data for ANOVA by individual protein 
Arachidonate <- data.melted.plus.pepsum[grepl(c("Arachidonate"), data.melted.plus.pepsum$Protein),]
Catalase <- data.melted.plus.pepsum[grepl(c("Catalase"), data.melted.plus.pepsum$Protein),]
Cytochrome <- data.melted.plus.pepsum[grepl(c("Cytochrome"), data.melted.plus.pepsum$Protein),]
Glycogen <- data.melted.plus.pepsum[grepl(c("Glycogen"), data.melted.plus.pepsum$Protein),]
HSP70 <- data.melted.plus.pepsum[grepl(c("HSP70"), data.melted.plus.pepsum$Protein),]   # Remember Poor Quality ! 
HSP90 <- data.melted.plus.pepsum[grepl(c("HSP90-alpha"), data.melted.plus.pepsum$Protein),]
Peroxiredoxin <- data.melted.plus.pepsum[grepl(c("Peroxiredoxin"), data.melted.plus.pepsum$Protein),]
PDI <- data.melted.plus.pepsum[grepl(c("PDI"), data.melted.plus.pepsum$Protein),]         # Remember Poor Quality ! 
Puromycin <- data.melted.plus.pepsum[grepl(c("Puromycin-sensitive"), data.melted.plus.pepsum$Protein),]
Rab.11B <- data.melted.plus.pepsum[grepl(c("Ras-related"), data.melted.plus.pepsum$Protein),] # Remember Poor Quality ! 
NAK <- data.melted.plus.pepsum[grepl(c("Sodium/potassium-transporting"), data.melted.plus.pepsum$Protein),]
Superoxide <- data.melted.plus.pepsum[grepl(c("Superoxide"), data.melted.plus.pepsum$Protein),]
Trifunctional <- data.melted.plus.pepsum[grepl(c("Trifunctional"), data.melted.plus.pepsum$Protein),]



# HSP 90
png("../../analyses/SRM/boxplot-HSP90-site-trans-sums.png", width = 400, height = 500)
ggplot(subset(data.melted.plus.prosum, Protein.Name %in% "HSP90-alpha"), aes(x=SITE, y=Area, fill=SITE)) + 
  geom_boxplot(color="black", position = position_dodge()) + 
  ggtitle("Heat shock 90 \nabundance by site, transition sums") + 
  theme(plot.title = element_text(size=18), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + 
  scale_fill_discrete(labels=c("Willapa Bay", "Case Inlet", "Port Gamble", "Fidalgo Bay")) + 
  ylab("Protein Abundance (Peak Intensity)") +
  coord_flip() +
  annotate("text", label="ANOSIM with Transitions, Results: \nObserved R=0.08 \nExpected R=0 \nP=0.017491", x = 1, y = 5e+07, size = 4.5) 
dev.off()

# PDI
png("../../analyses/SRM/boxplot-PDI-site-trans-sums.png", width = 400, height = 500)
ggplot(subset(data.melted.plus.prosum, Protein.Name %in% "PDI"), aes(x=SITE, y=Area, fill=SITE)) + 
  geom_boxplot(color="black", position = position_dodge()) + 
  ggtitle("Protein Disulfide Isomerase \nabundance by site, transitions sums") + 
  theme(plot.title = element_text(size=22), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + 
  guides(fill=FALSE) +
  scale_fill_discrete(labels=c("Willapa Bay", "Case Inlet", "Port Gamble", "Fidalgo Bay")) + 
  ylab("Protein Abundance (Peak Intensity)") +
  coord_flip() +
  annotate("text", label="ANOSIM with Transitions, Results: \nObserved R=0.093 \nExpected R=0 \nP=0.010995", x = 1, y = 2.0E7, size = 4.5) 
dev.off()

# Trifuctional Enzyme Subunit
ggplot(subset(data.melted.plus.prosum, Protein.Name %in% "Trifunctional"), aes(x=SITE, y=Area, fill=SITE)) + 
  geom_boxplot(color="black", position = position_dodge()) + 
  ggtitle("Trifunctional Enzyme Subunit-beta \nabundance by site, transitions sums") + 
  theme(plot.title = element_text(size=22), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + 
  guides(fill=FALSE) +
  scale_fill_discrete(labels=c("Willapa Bay", "Case Inlet", "Port Gamble", "Fidalgo Bay")) + 
  ylab("Protein Abundance (Peak Intensity)") +
  coord_flip() #+
  #annotate("text", label="ANOSIM with Transitions, Results: \nObserved R=0.093 \nExpected R=0 \nP=0.0125", x = 1, y = 2E6, size = 4.5) 

# Puromycin-sensitive
ggplot(subset(data.melted.plus.prosum, Protein.Name %in% "Puromycin-sensitive"), aes(x=SITE, y=Area, fill=SITE)) + 
  geom_boxplot(color="black", position = position_dodge()) + 
  ggtitle("Puromycin-sensitive Aminopeptidase \nabundance by site, transitions sums") + 
  theme(plot.title = element_text(size=22), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + 
  guides(fill=FALSE) +
  scale_fill_discrete(labels=c("Willapa Bay", "Case Inlet", "Port Gamble", "Fidalgo Bay")) + 
  ylab("Protein Abundance (Peak Intensity)") +
  coord_flip() #+
  #annotate("text", label="ANOSIM with Transitions, Results: \nObserved R=0.093 \nExpected R=0 \nP=0.0125", x = 1, y = 9E6, size = 4.5) 

########## Box plots of proteins found to be significantly different between regions (ANOSIM)

# HSP 90
png("../../analyses/SRM/boxplot-HSP90-region.png", width = 400, height = 500)
ggplot(subset(data.melted.plus, Pep.Trans %in% "GVVDSEDLPLNISR y7"), aes(x=REGION, y=Area, fill=REGION)) + 
  geom_boxplot(color="black", position = position_dodge()) + 
  ggtitle("Heat shock 90 \nabundance by region") + 
  theme(plot.title = element_text(size=22), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank(), legend.position = c(0.82, .135), legend.title=element_blank(), legend.key.size = unit(3,"line"), legend.text=element_text(size=12)) + 
  scale_fill_discrete(labels=c("Southern Sites", "Northern Sites")) + 
  ylab("Protein Abundance (Peak Intensity)") +
  coord_flip()
dev.off()

# PDI
png("../../analyses/SRM/boxplot-PDI-region.png", width = 400, height = 500)
ggplot(subset(data.melted.plus, Pep.Trans %in% "DNVVVIGFFK y5"), aes(x=REGION, y=Area, fill=REGION)) + 
  geom_boxplot(color="black", position = position_dodge()) + 
  ggtitle("Protein Disulfide Isomerase \nabundance by region") + 
  theme(plot.title = element_text(size=22), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank(), legend.position = c(0.82, .135), legend.title=element_blank(), legend.key.size = unit(3,"line"), legend.text=element_text(size=12)) + 
  scale_fill_discrete(labels=c("Southern Sites", "Northern Sites")) + 
  ylab("Protein Abundance (Peak Intensity)") +
  coord_flip()
dev.off()

### Scatter plots of all transitions by sample for proteins, coded by site

#HSP90
png("../../analyses/SRM/scatterbysample-HSP90.png", width = 800, height = 700)
ggplot(subset(data.melted.plus, Protein.Name %in% "HSP90-alpha"), aes(x=SAMPLE, y=Area, color=SITE, shape=Peptide.Sequence)) + 
  geom_point(position = position_dodge()) + 
  ggtitle("Heat shock 90 \nTransition abundances by sample") + 
  theme(plot.title = element_text(size=22), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"), legend.position = c(0.95, .85), legend.title=element_blank(), legend.key.size = unit(2,"line"), legend.text=element_text(size=12)) + 
  ylab("Protein Abundance (Peak Intensity)") + 
  coord_flip()
dev.off()

#PDI 
png("../../analyses/SRM/scatterbysample-PDI.png", width = 800, height = 700)
ggplot(subset(data.melted.plus, Protein.Name %in% "PDI"), aes(x=SAMPLE, y=Area, color=SITE, shape=Peptide.Sequence)) + 
  geom_point(position = position_dodge()) + 
  ggtitle("Protein Disulfide Isomerase \nTransition abundances by sample") + 
  theme(plot.title = element_text(size=22), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"), legend.position = c(0.95, .85), legend.title=element_blank(), legend.key.size = unit(2,"line"), legend.text=element_text(size=12)) +  ylab("Protein Abundance (Peak Intensity)") +
  coord_flip()
dev.off()



# HSP 90
png("../../analyses/SRM/boxplot-HSP90-site.png", width = 400, height = 500)
ggplot(subset(data.melted.plus, Pep.Trans %in% "GVVDSEDLPLNISR y7"), aes(x=SITE, y=Area, fill=SITE)) + 
  geom_boxplot(color="black", position = position_dodge()) + 
  ggtitle("Heat shock 90 \nabundance by site") + 
  theme(plot.title = element_text(size=18), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + 
  scale_fill_discrete(labels=c("Willapa Bay", "Case Inlet", "Port Gamble", "Fidalgo Bay")) + 
  ylab("Protein Abundance (Peak Intensity)") +
  coord_flip() +
  annotate("text", label="ANOSIM Results: \nObserved R=0.08 \nExpected R=0 \nP=0.017491", x = 1, y = 4.5e+06, size = 4.5) 
dev.off()

# PDI
png("../../analyses/SRM/boxplot-PDI-site.png", width = 400, height = 500)
ggplot(subset(data.melted.plus, Pep.Trans %in% "DNVVVIGFFK y5"), aes(x=SITE, y=Area, fill=SITE)) + 
  geom_boxplot(color="black", position = position_dodge()) + 
  ggtitle("Protein Disulfide Isomerase \nabundance by site") + 
  theme(plot.title = element_text(size=22), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"), axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + 
  guides(fill=FALSE) +
  scale_fill_discrete(labels=c("Willapa Bay", "Case Inlet", "Port Gamble", "Fidalgo Bay")) + 
  ylab("Protein Abundance (Peak Intensity)") +
  coord_flip() +
  annotate("text", label="ANOSIM Results: \nObserved R=0.093 \nExpected R=0 \nP=0.010995", x = 1, y = 1650000, size = 4.5) 
dev.off()
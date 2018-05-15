# Screening SRM data for quality assurance.
# Skyline data was exported as report with the following metrics: Protein Name, Transitions, Peptide Sequence, Fragment Ion, Peptide Retention Time, Area

# Import using URL's
# SRMreport <- read.csv(url("https://raw.githubusercontent.com/RobertsLab/Paper-DNR-Geoduck-Proteomics/master/data/SRM/2017-Geoduck-SRM-Skyline-Report.csv"), header=FALSE, na.strings = "#N/A", stringsAsFactors = FALSE)
# SRMsequence <- read.csv(url("https://github.com/RobertsLab/Paper-DNR-Geoduck-Proteomics/raw/master/data/SRM/SRM-Sequence-final-annotated.csv"), header=TRUE, stringsAsFactors = FALSE)
# sample.key <- read.csv(url("https://raw.githubusercontent.com/RobertsLab/Paper-DNR-Geoduck-Proteomics/master/data/SRM/2017-08-14-Geoduck-samples.csv"), header=TRUE, stringsAsFactors = FALSE)

# Import datasets using relative paths in this repo
SRMreport <- read.csv("data/SRM/2017-Geoduck-SRM-Skyline-Report.csv", header=FALSE, na.strings = "#N/A", stringsAsFactors = FALSE)
SRMsequence <- read.csv("data/SRM/SRM-Sequence-final-annotated.csv", header=TRUE, stringsAsFactors = FALSE)

# Re-load sample key  
sample.key <- read.csv("data/Geoduck-sample-info.csv", header=TRUE, stringsAsFactors = FALSE)
SRMsamples <- sample.key[sample.key$MS.MS.Start.Date == "7/18/17", "PRVial"]

# Replace technical replicate / file names with sample names
rep.names <- SRMreport[1,] # create vector of replicate names
rep.names.short <- noquote(gsub(' Area', '', rep.names)) # remove Area from rep name, and don't include quotes
repsTOsamples <- as.data.frame(SRMsequence[,c(2,3,5)])
repsTOsamples.filtered <- filter(repsTOsamples, repsTOsamples[,1] %in% rep.names.short)
samples <- as.character(repsTOsamples.filtered$Sample...rep.name)
other.headers <- as.character(rep.names.short[1:4])
samples.vector <- noquote(c(other.headers, samples))
SRM.data <- SRMreport[-1,]
colnames(SRM.data) <- samples.vector

# Create separate reports for dilution curve data and sample data 
SRM.dilution.data <- SRM.data[-1,c(grepl("Protein Name|Transition|Peptide Sequence|Fragment Ion|^D.-G$", colnames(SRM.data)))]  #dilution curve data
SRM.sample.data <- (SRM.data[,c(!grepl("^D.-G$", colnames(SRM.data)))]) #sample data

##Annotate sample names with Bay and Habitat
repsTOsamples.filtered.annotated <- merge(x=repsTOsamples.filtered, y=sample.key[,c("Bay", "Habitat", "Exclosure", "PRVial", "Sample.Shorthand")], by.x="Comment", by.y = "PRVial", all.x=T, all.y=F)
  #as.data.frame(filter(sample.key[,c(3,5,6,8,9)], sample.key$PRVial %in% repsTOsamples.filtered$Comment)) #pull bay & habitat from sample key
repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Comment == "G053-remake"),c("Bay", "Habitat", "Exclosure", "Sample.Shorthand")] <- c("FB", "FB","E","E","FBE-2","FBE-2","FB-E","FB-E")
repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Comment == "G071-A"),c("Bay", "Habitat", "Exclosure", "Sample.Shorthand")] <- c("PG","PG","E","E","PGE-2","PGE-2","PG-E","PG-E")
repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Comment == "G071-B"),c("Bay", "Habitat", "Exclosure", "Sample.Shorthand")] <- c("PG","PG","E","E","PGE-2","PGE-2","PG-E","PG-E")
repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Comment == "G104-remake"),c("Bay", "Habitat", "Exclosure", "Sample.Shorthand")] <- c("WB","WB","B","B","WBB-4","WBB-4","WB-B","WB-B")
repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Comment == "G114-remake"),c("Bay", "Habitat", "Exclosure", "Sample.Shorthand")] <- c("WB","WB","B","B","WBB-6","WBB-6","WB-B","WB-B")
repsTOsamples.filtered.annotated <- repsTOsamples.filtered.annotated[-1:-8,] #remove dilution curve sample info

# Subset sample names for site & treatment combos
CI.E <- repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Sample.Shorthand == "CI-E"),]
CI.B <- repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Sample.Shorthand == "CI-B"),]
PG.E <- repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Sample.Shorthand == "PG-E"),]
PG.B <- repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Sample.Shorthand == "PG-B"),]
WB.E <- repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Sample.Shorthand == "WB-E"),]
WB.B <- repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Sample.Shorthand == "WB-B"),]
FB.E <- repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Sample.Shorthand == "FB-E"),]
FB.B <- repsTOsamples.filtered.annotated[c(repsTOsamples.filtered.annotated$Sample.Shorthand == "FB-B"),]

# Isolate just sample names for each site/treatment combo
CI.E.samples <- unique(CI.E$Comment)
CI.B.samples <- unique(CI.B$Comment)
PG.E.samples <- unique(PG.E$Comment)
PG.B.samples <- unique(PG.B$Comment)
WB.E.samples <- unique(WB.E$Comment)
WB.B.samples <- unique(WB.B$Comment)
FB.E.samples <- unique(FB.E$Comment)
FB.B.samples <- unique(FB.B$Comment)

# Isolate eelgrass and bare group sample names
Eelgrass.samples <- c(CI.E.samples, PG.E.samples, WB.E.samples, FB.E.samples)
Bare.samples <- c(CI.B.samples, PG.B.samples, WB.B.samples, FB.B.samples)

### Convert Area data to numeric format
SRM.data.numeric[,5:120] <- as.numeric(as.character(unlist(SRM.data.numeric[,5:120]))) # NOTE: this is a handy method of converting tricky data to numeric 

## Name each row with a unique transition ID 
nTransitions <- length(SRM.data.numeric$Transition) # How many transitions are there
Transition.ID <- vector(length=nTransitions) # create empty vector with length= number of transitions
for (i in 1:nTransitions) {  
  Transition.ID[i] <- paste(SRM.data.numeric[i,3], SRM.data.numeric[i,4])}  # loop that fills empty vector with unique transition ID, built from the peptide sequence (column 3) and the fragment ion (columm 4)
length(SRM.data.numeric$Transition) == length(Transition.ID) # confirm that I didn't lose any transitions; should equal TRUE
row.names(SRM.data.numeric) <- Transition.ID # assign newly created transition IDs as row names
write.csv(SRM.data.numeric, file="analyses/SRM/SRM-data-annotated.csv") #write this file out for safe keeping

## Remove poor quality peptides identified via Skyline & Dilution Curve results
# Poor quality peptides, determined via Dilution curve
  # HSP70: TTPSYVAFNDTER, IINEPTAAALAYGLDK
  # Superoxide Dismutase: ISLTGPHSIIGR
  # Peroxiredoxin: QITMNDLPVGR, LVQAFQFTDK
  # Trifunctional enzyme subunit beta: FNLWGGSLSLGHPFGATGVR
  # Ras-related Rab:  VVLVGDSGVGK, AQLWDTAGQER
  # Na/K:  MVTGDNVNTAR
  # PDI: NNKPSDYQGGR

SRM.data.screened <- SRM.data.numeric[!grepl(c("TTPSYVAFNDTER|IINEPTAAALAYGLDK|ISLTGPHSIIGR|QITMNDLPVGR|LVQAFQFTDK|FNLWGGSLSLGHPFGATGVR|VVLVGDSGVGK|AQLWDTAGQER|MVTGDNVNTAR|NNKPSDYQGGR"), SRM.data.numeric$`Peptide Sequence`),]
SRM.data.screened.noPRTC <- SRM.data.screened[!grepl("PRTC peptides", SRM.data.screened$`Protein Name`),]

## Screen further to get rid of poor quality technical replicates. Use NMDS and calculate CV between technical reps for each transition and plot using Plotly
source("references/BioStats.R") #Load via repo directory 

#Transpose the file so that rows and columns are switched 
SRM.data.t <- t(SRM.data.screened.noPRTC[, -1:-4]) 

#Replace NA cells with 0; metaMDS() does not handle NA's 
SRM.data.t[is.na(SRM.data.t)] <- 0

#Make MDS dissimilarity matrix
SRM.NMDS.techreps <- metaMDS(SRM.data.t, distance = 'bray', k = 2, trymax = 3000, autotransform = FALSE)

#stress plot shows variance of NMDS results around regression 
stressplot(SRM.NMDS.techreps, main="NMDS Stress Plot, SRM Technical Replicate Data")

# make figure with sample annotations
SRM.nmds.samples <- scores(SRM.NMDS.techreps, display = "sites")
SRM.nmds.samples.sorted <- SRM.nmds.samples[ order(row.names(SRM.nmds.samples)), ]
colors <- colorRampPalette(brewer.pal(8,"Dark2"))(48)

#Plot all technical reps with sample number using interactive Plotly, explore 
p.NMDS.techrep <- plot_ly(data=as.data.frame(SRM.nmds.samples.sorted), x=~NMDS1, y=~NMDS2, type="scatter", mode="text", text=rownames(SRM.nmds.samples.sorted), textfont = list(size = 16), color=rownames(SRM.nmds.samples.sorted))  %>% 
  layout(title="SRM Technical Replicate NMDS",
         xaxis = list(title = 'NMDS Axis 1'),
         yaxis = list(title = 'NMDS Axis 2'))
api_create(p.NMDS.techrep, filename = "Geoduck-SRM-tech-rep-NMDS") #Pushes plot to Plotly online 

## Assess tech replicate quality using coefficient of variation between reps

# Reformat data
SRM.temp1 <- t(SRM.data.screened.noPRTC[,-1:-4]) #transform and remove extraneous protein info
SRM.temp2 <- as.data.frame(melt(SRM.temp1, id=rownames(SRM.temp1))) #melt data into long-format
colnames(SRM.temp2)[2] <- "Transition"
SRM.temp2$X1 <- gsub('-remake-', '-', SRM.temp2$X1)
SRM.temp2$X1 <- as.character(SRM.temp2$X1) #convert sample ID to character strings
SRM.temp3 <- separate(data=SRM.temp2, col=X1, into = c('Sample', 'Replicate'), sep = -3, convert = TRUE) #split sample ID into number, replicate 

# Calculate mean, sd, variance for transition abundances between tech. reps
SRM.reps4stats <- dcast(SRM.temp3, Sample + Transition ~ Replicate) #widen data to create a column for each replicate with area data
SRM.reps4stats$sd <- apply(SRM.reps4stats[,3:6], 1, sd, na.rm=TRUE) #calculate standard deviation across all replicates for each sample
SRM.reps4stats$mean <- apply(SRM.reps4stats[,3:6], 1, mean, na.rm=TRUE) #calculate mean across all replicates for each sample
SRM.reps4stats$variance <- (SRM.reps4stats$sd/SRM.reps4stats$mean)*100 #calculate coefficient of variace across all replicates for each sample

# Merge protein info back # save data set
SRM.reps4stats.plots <- merge(x=SRM.reps4stats, y=SRM.data.screened.noPRTC[,1:3], by.x=2, by.y=0, all.x=TRUE, all.y=FALSE)
names(SRM.reps4stats.plots) <- c("Transition","Sample","-A","-B","-C","-D","sd","mean","variance","Protein", "Fragment","Peptide") #simplify column names
write.csv(SRM.reps4stats.plots, file="analyses/SRM/SRM-techrep-stats.csv") #Save tech rep stats data as .csv 

## Remove poor quality reps and re-do plot 

# Tech reps removed: 42C, 53B, 53D, 70C, 73B, 104B, 104D, 127B, 128A, 55A, 114A, 114D
# Entire sample removed: 3, 53, 57

SRM.temp2.screened <- SRM.temp2[!grepl("G003|G042-C|G053-B|G053-D|G070-C|G073-B|G104-B|G104-D|G127-B|G128-A|G055-A|G114-A|G114-D|G057|G053", SRM.temp2$X1),]
SRM.temp3.s <- separate(data=SRM.temp2.screened, col=X1, into = c('Sample', 'Replicate'), sep = -3, convert = TRUE) #split sample ID into number, replicate 

# Calculate stats after removal 
SRM.reps4stats.s <- dcast(SRM.temp3.s, Sample + Transition ~ Replicate) #widen data to create a column for each replicate with area data
SRM.reps4stats.s$sd <- apply(SRM.reps4stats.s[,3:6], 1, sd, na.rm=TRUE) #calculate standard deviation across all replicates for each sample
SRM.reps4stats.s$mean <- apply(SRM.reps4stats.s[,3:6], 1, mean, na.rm=TRUE) #calculate mean across all replicates for each sample
SRM.reps4stats.s$cv <- (SRM.reps4stats.s$sd/SRM.reps4stats.s$mean)*100 #calculate coefficient of variation across all replicates for each sample

# Merge protein info back # save data set
SRM.reps4stats.s.plots <- merge(x=SRM.reps4stats.s, y=SRM.data.screened.noPRTC[,1:3], by.x=2, by.y=0, all.x=TRUE, all.y=FALSE)
names(SRM.reps4stats.s.plots) <- c("Transition","Sample","-A","-B","-C","-D","sd","mean","cv","Protein", "Fragment","Peptide") #simplify column names
write.csv(SRM.reps4stats.s.plots, file="analyses/SRM/SRM-techrep-stats.csv") #Save tech rep stats data as .csv 

# Plot coefficients of variation via Plotly, push online and save as static .png
p.techrep <-  plot_ly(data = SRM.reps4stats.s.plots, x = ~Sample, y = ~cv, type="scatter", mode="markers", color=~Protein, hovertext=~paste(Protein, Transition)) %>%  #generate plotly plot
  layout(title="Coefficient of Variance among technical reps, by sample",
         yaxis = list(title = 'Coefficient of Variance'),
         legend = list(x=.75, y=.95))
api_create(p.techrep, filename = "Geoduck-SRM-tech-rep-CV") #Pushes plot to Plotly online 
plotly_IMAGE(p.techrep, width = 1200, height = 500, format = "png", scale = 2,
             out_file = "results/SRM/Geoduck-SRM-tech-rep-CV.png")

## Filter dataset to removes any remaining transitions within samples with cv >40 
SRM.final <- SRM.reps4stats.s.plots[which(SRM.reps4stats.s.plots$cv <= 40),] #final dataset to be used in SRM analysis ("mean" column)
write.csv(SRM.final, file="analyses/SRM/SRM-data-screened-final.csv")

# Number transitions maintained in final SRM dataset (out of 113 targets)
length(unique(SRM.final$Transition))
86/113
       
# Number technical reps maintained in final SRM dataset 
length(unique(SRM.temp2.screened$X1)) #96 maintained
length(unique(SRM.temp2$X1)) #116 original
(length(unique(SRM.temp2.screened$X1)) / length(unique(SRM.temp2$X1)))*100 #83% success rate  
(45/48)*100 # 94% sample success rate 

# Number of transitions removed from individual samples 
nrow(SRM.reps4stats.s.plots[which(SRM.reps4stats.s.plots$cv >= 40),]) #74 transition entries
nrow(SRM.reps4stats.s.plots[which(SRM.reps4stats.s.plots$cv >= 40),])/nrow(SRM.reps4stats.s.plots) #percent of transition entries removed due to high CV (>40)
length(unique(SRM.reps4stats.s.plots[which(SRM.reps4stats.s.plots$cv >= 40),"Sample"])) #21 samples 
length(unique(SRM.reps4stats.s.plots[which(SRM.reps4stats.s.plots$cv >= 40),"Protein"])) #11 proteins 

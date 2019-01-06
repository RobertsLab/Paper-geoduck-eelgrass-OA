# Script to analyze DIA Protein Abundance Data
# Geoduck OA / eelgrass / proteomics project, 2016 
# Laura H Spencer 

### Merge DIA report, exported from Skyline, with protein annotations 

# Download annotated geoduck gonad transcriptome, also available from sr320 GitHub repo: https://github.com/sr320/paper-pano-go/raw/master/data-results/Geo-v3-join-uniprot-all0916-condensed.txt 
annotations <- data.frame(read.csv("data/DIA/Geo-v3-join-uniprot-all0916-condensed.txt", header = T, sep = "\t", fill = TRUE, stringsAsFactors = F))
annotations$GeoID <- as.character(annotations$GeoID)

# Download DIA Protein abundance report from Owl
curl_download("http://owl.fish.washington.edu/generosa/Generosa_DNR/DIA-Report-long.csv", destfile="data/DIA/DIA-Report-long.csv", quiet = TRUE, mode="wb")
DIA <- read.csv("data/DIA/DIA-Report-long.csv", header = T, na.strings = "#N/A", stringsAsFactors = F)

# Import Total Ion Current (TIC) data, which was provided by Emma from Lumos
TIC <- read.csv("data/DIA/DIA-TIC.csv")
TIC$File <- sub("geoduck ", "", TIC$File)
TIC <- TIC[1:20,]
TIC$File <- as.numeric(TIC$File)

# Create new column in DIA data with simplified protein ID to merge with annotations
DIA$GeoID <- DIA$Protein.Name #make new column 
DIA$GeoID <- sub("\\|.*", "", DIA$GeoID) 
DIA$GeoID <- sub("^cds.", "", DIA$GeoID)

# Merge the annotations with the DIA results
DIA.annotated <-merge(x=DIA, y=annotations, by.x="GeoID", by.y="GeoID", all.x=T, all.y=F) 

# Edited the DIA file name to only include the number
DIA.annotated$Replicate <- sub("envtstress_geoduck", "", DIA.annotated$Replicate) #remove extraneous info from rep name
DIA.annotated$Replicate <- sub("\\_.*", "", DIA.annotated$Replicate) #remove extraneous # from the rep 7 name
DIA.annotated$Replicate <- as.numeric(DIA.annotated$Replicate) 
length(unique(DIA.annotated$SPID)) # This is the number of proteins identified that are annotated with a SPID (minus 1, for "NA" entries)

### Normalize abundance data by total ion current (TIC) 

# Download MS/MS sequence file to an R object, which identifies .raw data files' corresponding vial contents
#DIAsequence <- read.csv(url("https://github.com/RobertsLab/Paper-DNR-Geoduck-Proteomics/raw/master/data/DIA/2017_January_23_sequence_file.csv"), header=FALSE, stringsAsFactors=FALSE) 

# Extract geoduck-related file names & associated sample names from sequence file, merge with TIC data
GeoFiles <- subset(sequence[,1:2], grepl(c("geoduck"), sequence[,2]))
names(GeoFiles) <- c("File", "Sample")
GeoFiles$File <- sub(".*geoduck", "", GeoFiles$File)
GeoFiles$Sample <- sub("geoduck", "", GeoFiles$Sample)
GeoFiles$Sample <- as.numeric(GeoFiles$Sample)
GeoFiles <- merge(x=GeoFiles, y=TIC, by.x="File", by.y="File", all.x=T)

# Download geoduck sample code info 
SampleInfo <- read.csv("data/Geoduck-sample-info.csv", header=T, stringsAsFactors=FALSE)
SampleInfo$PRVial <- sub("G", "", SampleInfo$PRVial)
SampleInfo$PRVial <- as.numeric(SampleInfo$PRVial)

# Merge GeoFiles and SampleInfo together to annotate file #'s
GeoFile.ann <- merge(x=GeoFiles, y=SampleInfo, by.x="Sample", by.y="PRVial", all.x=T)
GeoFile.ann <- GeoFile.ann[,c(1:3,7,9,10,12)] #extract pertinent columns 

# Merge sample annotations with the DIA.annotated file then divide transition abundance by TIC for each injection
DIA.annotated <- merge(x=DIA.annotated, y=GeoFile.ann, by.x="Replicate", by.y="File", all.x=T)
DIA.annotated$Area.adj <- DIA.annotated$Area/DIA.annotated$TIC 
write.csv(file="results/DIA/DIA-detected-peptides-annotated.csv", DIA.annotated)

# Write out Uniprot ID's for detected proteins  
write.csv(file="results/DIA/DIA-annotated-UniprotID.csv", unique(DIA.annotated[which(!is.na(DIA.annotated$SPID)),"SPID"])) # figure out how to write out removing NA's  - this isn't working yet

### NMDS on normalized abundance data 

# Generate new dataframe that has transitions summed for each peptide: 
DIA4vegan <- dcast(na.omit(DIA.annotated), Sample+Replicate+Bay+Habitat~Peptide.Sequence, value.var="Area.adj", sum)

# reformat 
rownames(DIA4vegan) <- paste("G", DIA4vegan[,2], sep="")
DIA4vegan[,2] <- paste(DIA4vegan[,3], DIA4vegan[,4], sep="")
colnames(DIA4vegan)[2] <- "BOTH"
DIA4vegan <- DIA4vegan[order(rownames(DIA4vegan)),]

# Generate NMDS 
DIA4vegan.log <- log(DIA4vegan[c(DIA4vegan$Bay != "SK"),c(-1:-4)] + 1) #First Log+1 transform
DIA.NMDS <- metaMDS(DIA4vegan.log, distance = "bray", k=2, trymax = 3000, autotransform = FALSE)
stressplot(DIA.NMDS)
plot(DIA.NMDS)
DIA.NMDS.samples <- scores(DIA.NMDS, display="sites")
plot(DIA.NMDS.samples) #plot initially to get aspect ratio

# interactive plot with geoduck sample numbers color coded by bay 
DIA.p <- plot_ly(data=as.data.frame(DIA.NMDS.samples), x=~NMDS1, y=~NMDS2, type="scatter", mode="text", text=~DIA4vegan[c(DIA4vegan$Bay != "SK"),"Sample"], hoverinfo=~rownames(DIA.NMDS.samples), color = ~DIA4vegan[c(DIA4vegan$Bay != "SK"),"Bay"]) %>%
  layout(title="NMDS of DIA data, all tech and bio reps",
         xaxis=list(title="NMDS Axis 1"),
         yaxis=list(title="NMDS Axis 2"))
# save plot to online account 
api_create(DIA.p, filename = "DIA-NMDS-plot-by-sample#.png") #https://plot.ly/~lhs3/13/#plot

# save static .png plot 
plotly_IMAGE(DIA.p, width = 500, height = 500, format = "png", scale = 2,
             out_file = "results/DIA/DIA-NMDS-plot-by-sample#.png")

DIA.NMDS.annotated <- as.data.frame(DIA.NMDS.samples)
DIA.NMDS.annotated$file <- gsub("G", "", rownames(DIA.NMDS.samples))
DIA.NMDS.annotated <- merge(x=DIA.NMDS.annotated, y=GeoFile.ann, by.x="file", by.y="File")

p.DIA.NMDS <- plot_ly(data=DIA.NMDS.annotated, x=~NMDS1, y=~NMDS2, color=~Bay, symbol=~Habitat, type="scatter", mode="markers", marker = list(size = 20), colors=marker, hoverinfo = 'text', text = ~Sample) %>% 
  layout(title="DIA NMDS of all proteins by Site, Treatment",
         xaxis = list(title = 'NMDS Axis 1'),
         yaxis = list(title = 'NMDS Axis 2'))
# save DIA NMDS plot to file 
plotly_IMAGE(p.DIA.NMDS, width = 1000, height = 1000, format = "jpeg", scale = 2,
             out_file = "results/DIA/Geoduck-DIA-NMDS.jpeg")

# Don't need to remove any reps, as they cluster together 

# Mean tech reps across samples 
DIA.mean <- aggregate(Area.adj~Sample+Protein.Name+Transition+Peptide.Sequence+Bay+Habitat+Sample.Shorthand, na.omit(DIA.annotated), mean)

# Sum all transitions across proteins for each sample
DIA.mean.protSum <- aggregate(Area.adj~Protein.Name+., DIA.mean[,-3:-4], sum)

#Create new column to assign NMDS-clustering Regions, CI & WB = South, FB & PG = North
DIA.mean.protSum$Region <- DIA.mean.protSum$Bay
DIA.mean.protSum$Region <- gsub("CI|WB", "South", DIA.mean.protSum$Region)
DIA.mean.protSum$Region <- gsub("FB|PG", "North", DIA.mean.protSum$Region)

# Remove SK data from dataframe
DIA.mean.protSum <- DIA.mean.protSum[!grepl("SK", DIA.mean.protSum$Region),]

# Isolate SRM target proteins from full list
SRM.Targets <- read.csv("data/SRM/SRM-Transitions.csv", header = T)
SRM.Target.proteins <- unique(SRM.Targets$Protein)
SRM.Target.proteins <- gsub(".*lipoxygenase |.*PDI\\) |.*aminopeptidase |.*alpha-4  |.*Rab-11B |.*mitochondrial  |Peroxiredoxin-1 |Catalase |.*P450 |.*muscle form |.*dismutase |.*kDa protein |.*90-alpha ", "", unique(SRM.Targets$Protein))
DIA.SRM.targets <- subset(DIA.annotated, Protein.Name %in% SRM.Target.proteins)
DIA.SRM.target.proteins <- DIA.SRM.targets[!duplicated(DIA.SRM.targets[,"GeoID"]),]
write.csv(file="data/SRM/SRM-target-proteins-from-DIA.csv", DIA.SRM.target.proteins[,c(2,3,4,5,6,8,9,10,11,12,13)])

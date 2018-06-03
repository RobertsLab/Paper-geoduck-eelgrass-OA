CREATE NMDS PLOT ########################################################################################

#Load the source file for the biostats package
#source("https://github.com/RobertsLab/Paper-DNR-Geoduck-Proteomics/raw/master/references/BioStats.R") #load via url
source("../../references/BioStats.R") #Load via repo directory
library(vegan)

#Transpose the file so that rows and columns are switched 
SRM.data.t <- t(SRM.data.screened.noPRTC[, -1:-4]) # t() function transposes, removes PRTC transitions, extraneous info

#Replace NA cells with 0; metaMDS() does not handle NA's 
SRM.data.t.noNA <- SRM.data.t
SRM.data.t.noNA[is.na(SRM.data.t.noNA)] <- 0

#Make MDS dissimilarity matrix
SRM.nmds <- metaMDS(SRM.data.t.noNA, distance = 'bray', k = 2, trymax = 3000, autotransform = FALSE)
# comm= your data.frame or matrix
# distance= bray 
# k= # of dimensions to assess
# trymax = max # iterations to attempt if no solution is reached
# Create Shepard plot, which shows scatter around the regression between the interpoint distances in the final configuration (i.e., the distances between each pair of communities) against their original dissimilarities.

#stress plot shows variance of NMDS results around regression 
png("results/SRM/NMDS-tech-rep-stressplot.png")
stressplot(SRM.nmds, main="NMDS Stress Plot, SRM Technical Replicate Data")
dev.off()

#Make NMDS figure
plot(SRM.nmds)
# site (aka sample) in black circle
# species (aka transition) in red ticks

# make figure with sample annotations https://stat.ethz.ch/pipermail/r-sig-ecology/2011-September/002371.html
SRM.nmds.samples <- scores(SRM.nmds, display = "sites")
SRM.nmds.samples.sorted <- SRM.nmds.samples[ order(row.names(SRM.nmds.samples)), ]
library(RColorBrewer)
colors <- colorRampPalette(brewer.pal(8,"Dark2"))(48)

### PLOTTING ALL REPS WITH SAMPLE NUMBER ID'S ### 

#For interactive graph: 
library(plotly)
p <- plot_ly(data=as.data.frame(SRM.nmds.samples.sorted), x=~NMDS1, y=~NMDS2, type="scatter", mode="text", text=rownames(SRM.nmds.samples.sorted)) %>% 
  layout(title="SRM Technical Replicate NMDS",
         xaxis = list(title = 'NMDS Axis 1'),
         yaxis = list(title = 'NMDS Axis 2'))
htmlwidgets::saveWidget(as_widget(p), "NMDS-technical-replicate.html") #Save plotly plot as html widget 

# OPTIONAL: POST PLOTLY GRAPHS ONLINE 
# Sys.setenv("plotly_username"="<PLOTLY USERNAME HERE>") #Insert Plotly username
# Sys.setenv("plotly_api_key"="<PLOTLY ACCOUNT API KEY HERE>") #Insert Plotly API key, find key @ https://plot.ly/settings/api
# api_create(p, filename = "Geoduck-SRM-tech-rep-NMDS") #Pushes plot to Plotly online

#To plot points individually & save
png("results/SRM/NMDS-tech-rep.png")
plot.default(x=NULL, y=NULL, type="n", xlab="NMDS axis 1", ylab="NMDS axis 2", xlim=c(-1,3), ylim=c(-0.5,0.5), asp=NA, main= "NMDS of SRM data for technical rep QA")
text(SRM.nmds.samples.sorted[c("G001-A", "G001-B"),], labels=c("1A", "1B"), col=colors[1])
text(SRM.nmds.samples.sorted[c("G002-A", "G002-B", "G002-C"),], labels=c("2A", "2B", "2C"), col=colors[2])
text(SRM.nmds.samples.sorted[c("G003-A", "G003-B", "G003-C"),], labels=c("3A", "3B", "3C"), col=colors[3]) 
text(SRM.nmds.samples.sorted[c("G007-A", "G007-B"),], labels=c("7A", "7B"), col=colors[4])
text(SRM.nmds.samples.sorted[c("G008-A", "G008-B"),], labels=c("8A", "8B"), col=colors[5])
text(SRM.nmds.samples.sorted[c("G009-A", "G009-B"),], labels=c("9A", "9B"), col=colors[6])
text(SRM.nmds.samples.sorted[c("G012-A", "G012-B", "G012-C"),], labels=c("12A", "12B", "12C"), col=colors[7])
text(SRM.nmds.samples.sorted[c("G013-A", "G013-C"),], labels=c("13A", "13B"), col=colors[8])
text(SRM.nmds.samples.sorted[c("G014-A", "G014-B"),], labels=c("14A", "14B"), col=colors[9])
text(SRM.nmds.samples.sorted[c("G015-A", "G015-B"),], labels=c("15A", "15B"), col=colors[10])
text(SRM.nmds.samples.sorted[c("G016-A", "G016-B", "G016-C"),], labels=c("16A", "16B", "16C"), col=colors[11])  
text(SRM.nmds.samples.sorted[c("G017-A", "G017-B"),], labels=c("17A", "17B"), col=colors[12]) 
text(SRM.nmds.samples.sorted[c("G031-A", "G031-B", "G031-C"),], labels=c("31A", "31B", "31C"), col=colors[13]) 
text(SRM.nmds.samples.sorted[c("G032-A", "G032-B"),], labels=c("32A", "32B"), col=colors[14])
text(SRM.nmds.samples.sorted[c("G040-A", "G040-B"),], labels=c("40A", "40B"), col=colors[15])
text(SRM.nmds.samples.sorted[c("G041-A", "G041-B"),], labels=c("41A", "41B"), col=colors[16])
text(SRM.nmds.samples.sorted[c("G042-A", "G042-B", "G042-C"),], labels=c("42A", "42B", "42C"), col=colors[17]) 
text(SRM.nmds.samples.sorted[c("G043-A", "G043-B"),], labels=c("43A", "43B"), col=colors[18])
text(SRM.nmds.samples.sorted[c("G045-A", "G045-B"),], labels=c("45A", "45B"), col=colors[19])
text(SRM.nmds.samples.sorted[c("G047-A", "G047-B"),], labels=c("47A", "47B"), col=colors[20])
text(SRM.nmds.samples.sorted[c("G049-A", "G049-B"),], labels=c("49A", "49B"), col=colors[21])
text(SRM.nmds.samples.sorted[c("G053-A", "G053-B", "G053-remake-C", "G053-remake-D"),], labels=c("53A", "53B", "53C-redo", "53D-redo"), col=colors[22]) 
text(SRM.nmds.samples.sorted[c("G054-A", "G054-B"),], labels=c("54A", "54B"), col=colors[23])
text(SRM.nmds.samples.sorted[c("G055-A", "G055-B"),], labels=c("55A", "55B"), col=colors[24]) 
text(SRM.nmds.samples.sorted[c("G057-A", "G057-B", "G057-C"),], labels=c("57A", "57B", "57C"), col=colors[25]) 
text(SRM.nmds.samples.sorted[c("G060-A", "G060-B"),], labels=c("60A", "60B"), col=colors[26]) 
text(SRM.nmds.samples.sorted[c("G062-B", "G062-C"),], labels=c("62B", "62C"), col=colors[27])
text(SRM.nmds.samples.sorted[c("G064-A", "G064-B"),], labels=c("64A", "64B"), col=colors[28])
text(SRM.nmds.samples.sorted[c("G066-A", "G066-B"),], labels=c("66A", "66B"), col=colors[29])
text(SRM.nmds.samples.sorted[c("G070-A", "G070-B", "G070-C"),], labels=c("70A", "70B", "70C"), col=colors[30])
text(SRM.nmds.samples.sorted[c("G071-A-A", "G071-A-B"),], labels=c("71aA", "71aB"), col=colors[31])
text(SRM.nmds.samples.sorted[c("G071-B-A", "G071-B-B"),], labels=c("71bA", "71bB"), col=colors[32])
text(SRM.nmds.samples.sorted[c("G073-A", "G073-B", "G073-C"),], labels=c("73A", "73B", "73C"), col=colors[33]) 
text(SRM.nmds.samples.sorted[c("G074-A", "G074-B"),], labels=c("74A", "74B"), col=colors[34])
text(SRM.nmds.samples.sorted[c("G079-A", "G079-B"),], labels=c("79A", "79B"), col=colors[35])
text(SRM.nmds.samples.sorted[c("G081-A", "G081-B"),], labels=c("81A", "81B"), col=colors[36])
text(SRM.nmds.samples.sorted[c("G104-A", "G104-B", "G104-remake-C", "G104-remake-D"),], labels=c("104A", "104B", "104C-redo", "104D-redo"), col=colors[37]) #B
text(SRM.nmds.samples.sorted[c("G105-A", "G105-B"),], labels=c("105A", "105B"), col=colors[38])
text(SRM.nmds.samples.sorted[c("G109-A", "G109-B", "G109-C"),], labels=c("109A", "109B", "109C"), col=colors[39])
text(SRM.nmds.samples.sorted[c("G110-A", "G110-B"),], labels=c("110A", "110B"), col=colors[40])
text(SRM.nmds.samples.sorted[c("G114-B", "G114-remake-C", "G114-remake-D"),], labels=c("114B", "114C-redo", "114D-redo" ), col=colors[41]) 
text(SRM.nmds.samples.sorted[c("G116-A", "G116-B"),], labels=c("116A", "116B"), col=colors[42])
text(SRM.nmds.samples.sorted[c("G120-A", "G120-B"),], labels=c("120A", "120B"), col=colors[43])
text(SRM.nmds.samples.sorted[c("G122-A", "G122-B"),], labels=c("122A", "122B"), col=colors[44])
text(SRM.nmds.samples.sorted[c("G127-A", "G127-B", "G127-C"),], labels=c("127A", "127B"), col=colors[45]) 
text(SRM.nmds.samples.sorted[c("G128-A", "G128-C", "G128-D"),], labels=c("128A", "128C", "128D"), col=colors[46])
text(SRM.nmds.samples.sorted[c("G129-A", "G129-B"),], labels=c("129A", "129B"), col=colors[47])
text(SRM.nmds.samples.sorted[c("G132-A", "G132-C", "G132-D"),], labels=c("132A", "132C", "132D"), col=colors[48])
dev.off()

### PLOTTING ALL REPS COLOR CODED AND WITH TREATMENT SYMBOL ### 
# symbol key
# 15 = eelgrass = filled square
# 21 = bare = open circle
png("results/SRM/NMDS-tech-rep-coded.png")
plot.default(x=NULL, y=NULL, type="n", main="NMDS of all SRM data, eelgrass vs. bare", xlab="NMDS axis 1", ylab="NMDS axis 2", xlim=c(-1,3), ylim=c(-0.5,0.5), asp=NA)
points(SRM.nmds.samples.sorted[c("G001-A", "G001-B"),], col=colors[1], pch=15)
points(SRM.nmds.samples.sorted[c("G002-A", "G002-B", "G002-C"),], col=colors[2], pch=15)
points(SRM.nmds.samples.sorted[c("G003-A", "G003-B", "G003-C"),], col=colors[3], pch=15) #G003-C is very different
points(SRM.nmds.samples.sorted[c("G007-A", "G007-B"),], col=colors[4], pch=15)
points(SRM.nmds.samples.sorted[c("G008-A", "G008-B"),], col=colors[5], pch=15)
points(SRM.nmds.samples.sorted[c("G009-A", "G009-B"),], col=colors[6], pch=15)
points(SRM.nmds.samples.sorted[c("G012-A", "G012-B", "G012-C"),], col=colors[7], pch=21)
points(SRM.nmds.samples.sorted[c("G013-A", "G013-C"),], col=colors[8], pch=21)
points(SRM.nmds.samples.sorted[c("G014-A", "G014-B"),], col=colors[9], pch=21)
points(SRM.nmds.samples.sorted[c("G015-A", "G015-B"),], col=colors[10], pch=21)
points(SRM.nmds.samples.sorted[c("G016-A", "G016-B", "G016-C"),], col=colors[11], pch=21)
points(SRM.nmds.samples.sorted[c("G017-A", "G017-B"),], col=colors[12], pch=21) 
points(SRM.nmds.samples.sorted[c("G031-A", "G031-B", "G031-C"),], col=colors[13], pch=15)
points(SRM.nmds.samples.sorted[c("G032-A", "G032-B"),], col=colors[14], pch=15)
points(SRM.nmds.samples.sorted[c("G040-A", "G040-B"),], col=colors[15], pch=21)
points(SRM.nmds.samples.sorted[c("G041-A", "G041-B"),], col=colors[16], pch=21)
points(SRM.nmds.samples.sorted[c("G042-A", "G042-B", "G042-C"),], col=colors[17], pch=21) #42-C
points(SRM.nmds.samples.sorted[c("G043-A", "G043-B"),], col=colors[18], pch=21)
points(SRM.nmds.samples.sorted[c("G045-A", "G045-B"),], col=colors[19], pch=15)
points(SRM.nmds.samples.sorted[c("G047-A", "G047-B"),], col=colors[20], pch=15)
points(SRM.nmds.samples.sorted[c("G049-A", "G049-B"),], col=colors[21], pch=15)
points(SRM.nmds.samples.sorted[c("G053-A", "G053-B", "G053-remake-C", "G053-remake-D"),], col=colors[22], pch=15) #53B
points(SRM.nmds.samples.sorted[c("G054-A", "G054-B"),], col=colors[23], pch=15)
points(SRM.nmds.samples.sorted[c("G055-A", "G055-B"),], col=colors[24], pch=15) 
points(SRM.nmds.samples.sorted[c("G057-A", "G057-B", "G057-C"),], col=colors[25], pch=21) #All 57 bad
points(SRM.nmds.samples.sorted[c("G060-A", "G060-B"),], col=colors[26], pch=21) 
points(SRM.nmds.samples.sorted[c("G062-B", "G062-C"),], col=colors[27], pch=21)
points(SRM.nmds.samples.sorted[c("G064-A", "G064-B"),], col=colors[28], pch=21)
points(SRM.nmds.samples.sorted[c("G066-A", "G066-B"),], col=colors[29], pch=21)
points(SRM.nmds.samples.sorted[c("G070-A", "G070-B", "G070-C"),], col=colors[30], pch=21) #70C
points(SRM.nmds.samples.sorted[c("G071-A-A", "G071-A-B"),], col=colors[31], pch=15) 
points(SRM.nmds.samples.sorted[c("G071-B-A", "G071-B-B"),], col=colors[32], pch=15)
points(SRM.nmds.samples.sorted[c("G073-A", "G073-B", "G073-C"),], col=colors[33], pch=15) #73B
points(SRM.nmds.samples.sorted[c("G074-A", "G074-B"),], col=colors[34], pch=15)
points(SRM.nmds.samples.sorted[c("G079-A", "G079-B"),], col=colors[35], pch=21)
points(SRM.nmds.samples.sorted[c("G081-A", "G081-B"),], col=colors[36], pch=21)
points(SRM.nmds.samples.sorted[c("G104-A", "G104-B", "G104-remake-C", "G104-remake-D"),], col=colors[37], pch=21) #104B & D
points(SRM.nmds.samples.sorted[c("G105-A", "G105-B"),], col=colors[38], pch=21)
points(SRM.nmds.samples.sorted[c("G109-A", "G109-B", "G109-C"),], col=colors[39], pch=15) 
points(SRM.nmds.samples.sorted[c("G110-A", "G110-B"),], col=colors[40], pch=15)
points(SRM.nmds.samples.sorted[c("G114-B", "G114-remake-C", "G114-remake-D"),], col=colors[41], pch=21) 
points(SRM.nmds.samples.sorted[c("G116-A", "G116-B"),], col=colors[42], pch=21)
points(SRM.nmds.samples.sorted[c("G120-A", "G120-B"),], col=colors[43], pch=21)
points(SRM.nmds.samples.sorted[c("G122-A", "G122-B"),], col=colors[44], pch=21)
points(SRM.nmds.samples.sorted[c("G127-A", "G127-B", "G127-C"),], col=colors[45], pch=15) #127B
points(SRM.nmds.samples.sorted[c("G128-A", "G128-C", "G128-D"),], col=colors[46], pch=15)
points(SRM.nmds.samples.sorted[c("G129-A", "G129-B"),], col=colors[47], pch=15)
points(SRM.nmds.samples.sorted[c("G132-A", "G132-C", "G132-D"),], col=colors[48], pch=15)
dev.off()

#### Calculate distances between tech rep points on NMDS plot and plot to ID technical rep outliers
library(reshape2)
srm.nmds.tech.distances <- NULL
for(i in 1:length(SRMsamples)) {
  G <- SRMsamples[i]
  D <- dist(SRM.nmds.samples.sorted[grepl(G, rownames(SRM.nmds.samples.sorted)),], method="euclidian") 
  M <- melt(as.matrix(D), varnames = c("row", "col"))
  srm.nmds.tech.distances <- rbind(srm.nmds.tech.distances, M)
}
srm.nmds.tech.distances <- srm.nmds.tech.distances[!srm.nmds.tech.distances$value == 0,] #remove rows with value=0 (distance between same points)
srm.nmds.tech.distances[,1:2] <- apply(srm.nmds.tech.distances[,1:2], 2, function(y) gsub('G|G0|G00', '', y)) #remove extraneous "G00" from point names

library(ggplot2)
library(plotly)
p1<- plot_ly(data=srm.nmds.tech.distances, y=~value, type="scatter", mode="text", text=~row) %>% 
  layout(title="Euclidean Distances Between Tech Reps on NMDS",
         xaxis = list(title = 'Geoduck Sample Number'),
         yaxis = list(title = 'distance on NMDS plot'))
htmlwidgets::saveWidget(as_widget(p1), "NMDS-technical-replicate-distances.html") #Save plotly as html widget

# OPTIONAL: POST PLOTLY GRAPHS ONLINE 
# api_create(p1, filename = "Geoduck-SRM-tech-rep-NMDS-distances") #Pushes plot to Plotly online

# Identify unaligned tech reps
summary(srm.nmds.tech.distances$value) #check out range, mean, median, etc. of euclidean distnaces on NMDS 
bad.tech.reps <- srm.nmds.tech.distances[srm.nmds.tech.distances$value>.2,] #which tech rep distances are >0.2? 
write.csv(bad.tech.reps, file="results/SRM/bad-tech-reps.csv") #save reps with distance >0.2 in a .csv 

#### NEXT, REMOVE SAMPLES THAT DON'T LOOK GOOD, AVERAGE TECH REPS, THEN RE-PLOT BY SITE/TREATMENT #### 

# average sample technical reps.  (there's probably an easier way to do this to not manually enter the tech rep names for each sample, possibly via a loop?); remove reps that were poor quality as per NMDS

# Mean of tech reps
G001 <- ave(SRM.data.screened.noPRTC$`G001-A`, SRM.data.screened.noPRTC$`G001-B`)
G002 <- ave(SRM.data.screened.noPRTC$`G002-A`, SRM.data.screened.noPRTC$`G002-B`, SRM.data.screened.noPRTC$`G002-C`)
G003 <- ave(SRM.data.screened.noPRTC$`G003-A`, SRM.data.screened.noPRTC$`G003-B`) #C removed
G007 <- ave(SRM.data.screened.noPRTC$`G007-A`, SRM.data.screened.noPRTC$`G007-B`)
G008 <- ave(SRM.data.screened.noPRTC$`G008-A`, SRM.data.screened.noPRTC$`G008-B`)
G009 <- ave(SRM.data.screened.noPRTC$`G009-A`, SRM.data.screened.noPRTC$`G009-B`)
G110 <- ave(SRM.data.screened.noPRTC$`G110-A`, SRM.data.screened.noPRTC$`G110-B`)
G012 <- ave(SRM.data.screened.noPRTC$`G012-A`, SRM.data.screened.noPRTC$`G012-B`, SRM.data.screened.noPRTC$`G012-C`)
G013 <- ave(SRM.data.screened.noPRTC$'G013-A', SRM.data.screened.noPRTC$'G013-C')
G014 <- ave(SRM.data.screened.noPRTC$`G014-A`, SRM.data.screened.noPRTC$`G014-B`)
G015 <- ave(SRM.data.screened.noPRTC$`G015-A`, SRM.data.screened.noPRTC$`G015-B`)
G016 <- ave(SRM.data.screened.noPRTC$`G016-A`, SRM.data.screened.noPRTC$`G016-B`, SRM.data.screened.noPRTC$`G016-C`)
G017 <- ave(SRM.data.screened.noPRTC$`G017-A`, SRM.data.screened.noPRTC$`G017-B`)
G031 <- ave(SRM.data.screened.noPRTC$`G031-A`, SRM.data.screened.noPRTC$`G031-B`, SRM.data.screened.noPRTC$`G031-C`)
G032 <- ave(SRM.data.screened.noPRTC$`G032-A`, SRM.data.screened.noPRTC$`G032-B`)
G040 <- ave(SRM.data.screened.noPRTC$`G040-A`, SRM.data.screened.noPRTC$`G040-B`)
G041 <- ave(SRM.data.screened.noPRTC$`G041-A`, SRM.data.screened.noPRTC$`G041-B`)
G042 <- ave(SRM.data.screened.noPRTC$`G042-A`, SRM.data.screened.noPRTC$`G042-B`) #C removed
G043 <- ave(SRM.data.screened.noPRTC$`G043-A`, SRM.data.screened.noPRTC$`G043-B`)
G045 <- ave(SRM.data.screened.noPRTC$`G045-A`, SRM.data.screened.noPRTC$`G045-B`)
G047 <- ave(SRM.data.screened.noPRTC$`G047-A`, SRM.data.screened.noPRTC$`G047-B`)
G049 <- ave(SRM.data.screened.noPRTC$`G049-A`, SRM.data.screened.noPRTC$`G049-B`)
G053 <- ave(SRM.data.screened.noPRTC$`G053-A`, SRM.data.screened.noPRTC$`G053-remake-C`) #B & D removed 
G054 <- ave(SRM.data.screened.noPRTC$`G054-A`, SRM.data.screened.noPRTC$`G054-B`)
G055 <- ave(SRM.data.screened.noPRTC$`G055-B`, SRM.data.screened.noPRTC$`G055-C`)
# G057 <- ave(SRM.data.screened.noPRTC$`G057-A`, SRM.data.screened.noPRTC$`G057-C`) #all reps removed
G060 <- ave(SRM.data.screened.noPRTC$`G060-A`, SRM.data.screened.noPRTC$`G060-B`)
G062 <- ave(SRM.data.screened.noPRTC$`G062-B`, SRM.data.screened.noPRTC$`G062-C`)
G064 <- ave(SRM.data.screened.noPRTC$`G064-A`, SRM.data.screened.noPRTC$`G064-B`)
G066 <- ave(SRM.data.screened.noPRTC$`G066-A`, SRM.data.screened.noPRTC$`G066-B`)
G070 <- ave(SRM.data.screened.noPRTC$`G070-A`, SRM.data.screened.noPRTC$`G070-B`) #C removed
G071.A <- ave(SRM.data.screened.noPRTC$`G071-A-A`, SRM.data.screened.noPRTC$`G071-A-B`)
G071.B <- ave(SRM.data.screened.noPRTC$`G071-B-A`, SRM.data.screened.noPRTC$`G071-B-B`)
G073 <- ave(SRM.data.screened.noPRTC$`G073-A`, SRM.data.screened.noPRTC$`G073-C`) #B removed
G074 <- ave(SRM.data.screened.noPRTC$`G074-A`, SRM.data.screened.noPRTC$`G074-B`)
G079 <- ave(SRM.data.screened.noPRTC$`G079-A`, SRM.data.screened.noPRTC$`G079-B`)
G081 <- ave(SRM.data.screened.noPRTC$`G081-A`, SRM.data.screened.noPRTC$`G081-B`)
G104 <- ave(SRM.data.screened.noPRTC$`G104-A`, SRM.data.screened.noPRTC$`G104-remake-C`) #B & D removed
G105 <- ave(SRM.data.screened.noPRTC$`G105-A`, SRM.data.screened.noPRTC$`G105-B`)
G109 <- ave(SRM.data.screened.noPRTC$`G109-A`, SRM.data.screened.noPRTC$`G109-C`)
G114 <- ave(SRM.data.screened.noPRTC$`G114-B`, SRM.data.screened.noPRTC$`G114-remake-C`)
G116 <- ave(SRM.data.screened.noPRTC$`G116-A`, SRM.data.screened.noPRTC$`G116-B`)
G120 <- ave(SRM.data.screened.noPRTC$`G120-A`, SRM.data.screened.noPRTC$`G120-B`)
G122 <- ave(SRM.data.screened.noPRTC$`G122-A`, SRM.data.screened.noPRTC$`G122-B`)
G127 <- ave(SRM.data.screened.noPRTC$`G127-A`, SRM.data.screened.noPRTC$`G127-C`) #B removed
G128 <- ave(SRM.data.screened.noPRTC$`G128-C`,SRM.data.screened.noPRTC$`G128-D`)
G129 <- ave(SRM.data.screened.noPRTC$`G129-A`, SRM.data.screened.noPRTC$`G129-B`)
G132 <- ave(SRM.data.screened.noPRTC$`G132-A`, SRM.data.screened.noPRTC$`G132-C`, SRM.data.screened.noPRTC$`G132-D`)
# Tech reps removed: 3C, 42C, 53B, 53D, 70C, 73B, 104B, 104D, 127B, 128A, 55A, 114A, 114D
# Entire sample removed: 57

# Sample 57 is from FB-bare; remove from that sample list 
FB.B.samples <- FB.B.samples[!FB.B.samples %in% "G057"] #revised FB.B.sample list 
SRM.data.mean <- cbind.data.frame(rownames(SRM.data.screened.noPRTC), G001,G002,G003,G007,G008,G009,G110,G012,G013,G014,G015,G016,G017,G031,G032,G040,G041,G042,G043,G045,G047,G049,G053,G054,G055,G060,G062,G064,G066,G070,G071.A,G071.B,G073,G074,G079,G081,G104,G105,G109,G114,G116,G120,G122,G127,G128,G129,G132)
SRM.data.mean <- data.frame(SRM.data.mean[,-1], row.names=SRM.data.mean[,1]) #make first column row names, and delete first column
write.csv(SRM.data.mean, file="results/SRM/SRM-data-meaned.csv")
graphics.off()

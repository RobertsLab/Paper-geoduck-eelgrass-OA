  
# Site,Habitat,Both,Latitude,Longitude

# Fidalgo Bay,U,FB-U,48.481691,-122.58353 ()
# Fidalgo Bay,E,FB-E,48.481342,-122.583529
# Port Gamble Bay,U,PG-U,47.842676,-122.583832
# Port Gamble Bay,E,PG-E,47.847983,-122.582919
# Case Inlet,E,CI-E,47.3584391,-122.7964495
# Case Inlet,U,CI-U,47.3579367,-122.7957627
# Willapa Bay,U,WB-U,46.4944789,-124.0261356
# Willapa Bay,E,WB-E,46.49508,-124.02652

#Chlorophyll data

chl <- read.csv("data/Environmental/chl/201607_chla.csv", header=F, stringsAsFactors = F, na.strings = "NaN")
lat <- read.csv("data/Environmental/chl/lat.txt", header=F)
long <- read.csv("data/Environmental/chl/lon.txt", header=F)

nrow(lat) == nrow(chl) # each row in chl data represents diff. latitude 
nrow(long) == ncol(chl) # each column in chl data represents diff. longitude 
# 1 data point per location, for each month 

rownames(chl) <- lat$V1
colnames(chl) <- long$V1

# View layout of data 
heatmap(as.matrix(chl[rownames(chl)  > "46.75", colnames(chl) > "-124"]), na.rm=T, Rowv=NA, Colv=NA)

write.csv(file="data/Environmental/chl/201607_chla-joined.csv", chl)

# Result: no data for my sites (NA values there)

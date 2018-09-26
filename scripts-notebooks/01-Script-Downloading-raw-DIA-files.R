# Script to download .raw files corresponding to geoduck tissue sample DIA data from Lumos MS/MS

## IMPORTANT: the first step in this script creates a directory, where all .raw files will be downloaded. Feel free to change the location of this directory
getwd() # see which directory is currently your working directory; should be this repo: Paper-geoduck-eelgrass-OA
setwd("data/DIA/2017-Geoduck-DIA-raw/")

# Scrape website that houses all .raw files of file names
url <- "http://owl.fish.washington.edu/generosa/Generosa_DNR/Lumos_Raw/" #site on Owl that contains all .raw files
html <- paste(readLines(url), collapse="\n")
rawfiles <- as.data.frame(str_match_all(html, "<a href=\"(.*?)\""), stringsAsFactors = FALSE) #document with names of links/files on site
rawfiles.1 <- as.data.frame(subset(rawfiles[,2], grepl(".raw", rawfiles[,2])), stringsAsFactors = FALSE) #only .raw file names
rawfiles.2 <- apply(rawfiles.1, 2, function(y) gsub(".raw", "", y)) #remove .raw from file names for subsetting purposes

# Download MS/MS sequence file to an R object, which identifies .raw data files' corresponding vial contents
sequence <- read.csv("../2017_January_23_sequence_file.csv", header=FALSE, stringsAsFactors=FALSE) 

# Merge the sequence file info with the names of files on Owl
Merged <- merge(x=sequence, y=rawfiles.2, by.x=1, by.y=1, all.x=FALSE, all.y=TRUE)

# Extract geoduck-related file names
GeoFiles <- subset(Merged[,1:2], grepl("g", Merged[,1]))

# Create a database with a column of url's for each .raw data file 
GeoURLS <-  as.data.frame(paste0("http://owl.fish.washington.edu/generosa/Generosa_DNR/Lumos_Raw/", GeoFiles[,1], ".raw"), stringsAsFactors = FALSE)
nrow(GeoURLS) # number of .raw files you will download

# Download all url's in your GeoURL database - #this could take a while depending on your computer
for(i in 1:nrow(GeoURLS)) {
  curl_download(GeoURLS[i,1], basename(GeoURLS[i,1]), quiet = TRUE, mode="wb")
}

# Files should now be in the directory "2017-Geoduck-DIA-raw/" - let's confirm that we have all of them:
howmanyfiles <- list.files(pattern="*.raw")
length(howmanyfiles) == nrow(GeoURLS) #should equal TRUE

####### Download geoduck gonad transcriptome fasta 

# Download Transcriptome fasta file for use with PECAN 
curl_download("https://raw.githubusercontent.com/sr320/paper-pano-go/52c6b18b5b09e5c3a49250cf47ad4ddc8e9dc004/data-results/Geoduck-transcriptome-v2.transdecoder.pep", destfile="../Geoduck-transcriptome-v2.transdecoder.pep", quiet = TRUE, mode="wb")

# OPTIONAL: if you didn't download the whole repo, you need to download the PRTC fasta file too
# curl_download("https://github.com/RobertsLab/Paper-DNR-Geoduck-Proteomics/raw/master/data/DIA/P00000_Pierce_prtc.fasta", destfile="P00000_Pierce_prtc.fasta", quiet = TRUE, mode="wb")

setwd("../../..") #go back to main repo directory for remainder of analyses 

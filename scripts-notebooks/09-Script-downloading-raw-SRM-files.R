# Script to download .raw files corresponding to geoduck tissue sample SRM data from Vantage MS/MS. This script will ... 
# -- install required R packages
# -- Create a directory in the Downloads folder
# -- Download all .raw files associated with geoduck gill samples and dilution curve samples

# Notes on SRM data
#  * Data produced by the Vantage MS/MS are formatted as .raw files, one file per sample injection  
#  * An "injection" is a volume of liquid pulled from one prepared sample  
#  * In this experiment I ran 2 technical replicates per sample, aka each sample was prepared in one autosampler vial with standard, then was injected twice separated by 3-6 days  
#  * In a few cases, I ran a third technical replicate  
#  * I remade three samples, and ran 2 technical replicates of them as well: 53-remake, 104-remake, 114-remake  
#  * All .raw data files are saved on the Roberts Lab Owl server: [2017-July-SRM-Data](http://owl.fish.washington.edu/generosa/Generosa_DNR/2017-July-SRM-Data/)  
#  * .raw files are labeled "2017_July_10_bivalves_###"_, where "###" is a 3-digit number generated chronologically as the samples were injected  
#  * The .raw files on the Owl server include data for: geoduck gill peptides, PRTC/bsa QC, true blanks, and dilution curve peptides  
#  * The [sequence file](../../data/SRM/SRM-Sequence-final.csv) indicates which sample each file corresponds to


## IMPORTANT: the first step in this script creates a directory, where all .raw files will be downloaded. Feel free to change the location of this directory
getwd() # see which directory is currently your working directory; change wd if desired
dir.create("2017-Geoduck-SRM-raw/") #create a directory, in which all .raw files will bes aved
setwd("2017-Geoduck-SRM-raw/") #set your working directory to the one you just created

# Install package not available in base R
install.packages("stringr", dep=TRUE)
install.packages("curl", dep=TRUE)

# Scrape website that houses all .raw files of file names
url <- "http://owl.fish.washington.edu/generosa/Generosa_DNR/2017-July-SRM-Data/" #site on Owl that contains all .raw files
html <- paste(readLines(url), collapse="\n")
library(stringr)
rawfiles <- as.data.frame(str_match_all(html, "<a href=\"(.*?)\""), stringsAsFactors = FALSE) #document with names of links/files on site
rawfiles.1 <- as.data.frame(subset(rawfiles[,2], grepl(".raw", rawfiles[,2])), stringsAsFactors = FALSE) #only .raw file names
rawfiles.2 <- apply(rawfiles.1, 2, function(y) gsub(".raw", "", y)) #remove .raw from file names for subsetting purposes

# Download MS/MS sequence file to an R object, which identifies .raw data files' corresponding vial contents
sequence <- read.csv(url("https://github.com/RobertsLab/Paper-DNR-Geoduck-Proteomics/raw/master/data/SRM/SRM-Sequence-final.csv"), header=FALSE, stringsAsFactors=FALSE) 

# Extract non geoduck-related file names (Oyster samples, PRTC/BSA QC, blanks)
NotGeoFiles <- subset(sequence[,1:2], grepl(c("O|P|b"), sequence[,2]))

# Remove any non-Geoduck sample files from rawfiles.2 list using NotGeoFiles list
GeoFiles <- subset(rawfiles.2, !(rawfiles.2  %in% NotGeoFiles$V1))

# Create a database with a column of url's for each .raw data file 
GeoURLS <-  as.data.frame(paste0("http://owl.fish.washington.edu/generosa/Generosa_DNR/2017-July-SRM-Data/", GeoFiles[,1], ".raw"), stringsAsFactors = FALSE)
nrow(GeoURLS) # number of .raw files you will download

#### Now you're ready to actually download the .raw files!
                    
# Download all url's in your GeoURL database - #this could take a while depending on your computer
library(curl)
for(i in 1:nrow(GeoURLS)) {
  curl_download(GeoURLS[i,1], basename(GeoURLS[i,1]), quiet = TRUE, mode="wb")
}

# Files should now be in the directory ../Downloads/2017-Geoduck-SRM-raw/ ... let's confirm that we have all of them:
howmanyfiles <- list.files(pattern="*.raw")
length(howmanyfiles) == nrow(GeoURLS) #should equal TRUE

# You are now ready to upload to a Skyline project, see [01-Create-Skyline-Project.md](../../notebooks/SRM/01-Create-Skyline-Project.md)

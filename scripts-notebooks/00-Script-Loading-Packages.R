# Admin script for all libraries, universal functions, etc. 

library(stringr)
library(curl)
library(vegan)
library(plotly)
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(ggpubr)
library(tidyr)
library(rcompanion)
library(reshape)
library(reshape2)
library(pryr)
library(HH)
library(maps) #Basic mapping functions and some data
library(mapdata)  #Some additional HiRes data
library(maptools) #Useful tools such as reading shapefiles
library(mapproj) #Various mapping projections
library(PBSmapping) #Powerful mapping functions developed by Pacific Biological Station

Sys.setenv("plotly_username"="lhs3") #Insert Plotly username 
Sys.setenv("plotly_api_key"="hIUVsdBYDizTQLhMUwLC") #Insert Plotly API key

# Great resource: http://rcompanion.org/handbook/I_12.html

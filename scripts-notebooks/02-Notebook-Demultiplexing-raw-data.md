# Demultiplexing and converting from .raw to .mzML using MSConvert

### This notebook shows how to use MSConvert at the command line to convert .raw data files from the Lumos MS/MS to .mzML and simultaneously demultiplex the data. This is the first step in DIA data analysis/processing after receiving the .raw files from Lumos. 

Demutiplexing the data is required prior to running it through PECAN.  Demultiplexing converts data collected in small, overlapping m/z windows into non-overlapping m/z range. Data was collected in this multiplexed manner to improve precursor selectivity.  A good resource to learn more about multiplexed data see [_Multiplexed MS/MS for Improved Data Independent Acquisition_ by Jarrett D. Egertson et al., 2013](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3881977/) (also saved in my repo [here)](https://github.com/laurahspencer/Geoduck-DNR/blob/master/References/Egertson%2C2013_Multiplexing-DIA-data.pdf)

Converting and demultiplexing the data is performed using a simple argument in the MSConvert command line script. MSConvert (and all the programs needed for processing Lumos data files) requires Windows. For this workflow I'm using the Roberts Lab's Woodpecker machine.

#### Software used: MSConvert, in the [ProteoWizard package](http://proteowizard.sourceforge.net/tools.shtml)

Versions on Woodpecker:  
--ProteoWizard release: 3.0.10738 (2017-4-12)  
--ProeoWizard MSData: 3.0.10738 (2017-4-12)  
--ProeoWizard Analysis: 3.0.10730 (2017-4-10)  
--Build date: April 12 2017 11:44:09

**NOTE:** This version of MSConvert was hand-delivered by Emma from the developer in Genome Sciences, aka this was not downloaded from the web.  Therefore, the program is saved in an odd place on Woodpecker.  See [Yaamini's notebook post](https://github.com/RobertsLab/project-oyster-oa/blob/master/notebooks/DNR/2017-04-12-Demultiplex-Raw-Files.ipynb) for more details. 
In the scripts below I outline where on Woodpecker it is saved.  

----

### Step 1: 
Download .raw files from Owl to local folder on Windows computer; see [Script 01: Downloading raw DIA files](../scripts-notebooks/01-Script-Downloading-raw-DIA-files.R)

### Optional Step 2: 
If you downloaded the .raw files in a .zip folder via gui interface you may have difficulty extracting the files; this happened for me, where only a few files extracted correctly and the rest resulted in 0kb files. I thus downloaded the [WinZip 21.0](http://www.winzip.com/win/en/downwz.html) program to Woodpecker and used that to fully unzip my .raw files folder.
  
### Step 3: 
Open a terminal/command window. To do so on Windows search for: cmd.exe

### Step 4: 
Change working directory to the folder containin .raw files. In my case this was the command: `cd C:\Users\srlab\Documents\geo-DNR\Lumos_Raw\`

### Step 5: 
Use the following script outlined in the [DIA Data Analyses instructions](https://github.com/RobertsLab/resources/blob/master/protocols/DIA-data-Analyses.md), with a couple directory edits. On the first run only convert 1 file, to see if there are any errors. NOTE: this will take some time: 
  
  `[path to msconvert.exe] --zlib --64 --mzML 
  --filter "peakPicking true 1-2" 
  --filter "demultiplex optimization=overlap_only" 
  2017_January_23_envtstress_geoduck1.raw`
  
_Where [path to msconvert] is the following for our current version on Woodpecker:_ 
`C:\Users\srlab\Documents\oystertest\oystertest2\msconvert.exe`  

If accessible for all users, you can simply use `msconvert.exe`

### Step 6: 
If no errors, run all files at once.  First, make sure you are in the directory housing all the .raw files, and enter the same script as above except with a wildcard for the file name `2017_January_23_envtstress_g*.raw`:  
  
  `[path to msconvert.exe] --zlib --64 --mzML 
  --filter "peakPicking true 1-2" 
  --filter "demultiplex optimization=overlap_only" 2017_January_23_envtstress_g*.raw`

In this screen shot I am running the script in a folder containing 5 .raw files: 

![Using MS Convert on Woodpecker](https://github.com/RobertsLab/Paper-DNR-Geoduck-Proteomics/blob/master/images/Demultiplexing-.raw-files.png?raw=true)

Once complete, the converted files will be .mzML format, located in the same folder as your .raw files. You will use these in PECAN in [../scripts-notebooks/Notebook 06, building spectral library with PECAN](06-Notebook-Building-Spectral-Library-with-PECAN.md)

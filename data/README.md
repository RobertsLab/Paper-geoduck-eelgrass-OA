I# data 

 - **Geoduck-sample-info.csv:** metadata for geoduck ctenidia tissue samples. Metrics include:  
   * **Box #:** sample box where tissues were held  
   * **Round:** Round 1 = June-July 2016 outplent (used in this project); Round 2 = August-September 2016 (not included in this project)  
   * **Bay:** CI=Case Inlet, FB=Fidalgo Bay, PG=Port Gamble Bay, WB=Willapa Bay, SK=Skokomish (SK not included in this paper)  
   * **Spp:** species, Pg=Panopea generosa, Cg=Crassostrea gigas  
   * **Habitat:** B=bare, aka unvegetated, E=eelgrass  
   * **Exclosure:** pvc silo where geoduck were outplanted  
   * **Rep:** geoduck number within each silo  
   * **PRVial:** ctenidia sample number  
   * **Sample Shorthand:** outplant location ID   
   * **MS/MS Start Date:** Date sample was run on mass spec (if applicable)  
   * **File name rep 1, 2, 3, 4;** files numerically named based on chronological order of run.  
     
 - **Geoduck-Survival.csv:** Geoduck survival upon retrieval. Each silo was stocked with 5 geoduck at deployment. 
 - **GeoduckGrowth.csv:**  Geoduck size data upon retrieval (FShell) and corresponding ctenidia sample number. Also includes initial size for each silo for relative growth calculations. 
 
### DIA
  *  Data files too large for repo are available here (.raw can also be downloaded in Script 01 in scripts-notebooks folder of this repo):  
    - [Raw DIA data files](http://owl.fish.washington.edu/generosa/Generosa_DNR/Lumos_Raw/)   
    - [Demultiplexed/converted datafiles (.mzML)](http://owl.fish.washington.edu/generosa/Generosa_DNR/Lumos-Converted/)   
    - [.blib file - spectral library, result of PECAN](http://owl.fish.washington.edu/generosa/Generosa_DNR/Skyline_June2017/2017-05-23_geoduck_desearleinated.blib)
  * **DIA-Report-long.csv:** Report from Skyline from DIA analysis  
  * **Geo-v3-join-uniprot-all0916-condensed.txt:** Annotated geoduck gonad transcriptome used as reference proteome (not raw data from this project)  
  * **DIA-PRTC-peptides.sky:** Skyline project file with internal standard peptides only  
  * **geoduck_DIA_5_30%B_110min_OTMS2_AGC_2e3.meth:**  Lumos method for samples  
  * **2017-07-15-Spencer-DIA-Retention-Time.csv:** Meausred DIA peptide retention times  
  * **40min_Blank_2a85ec5b-43bf-4ca9-ba53-79d8b9c9489f..meth:** Lumos method for blanks, run in between samples  
  * **DIA-Error-Checking.xlsx:** Spreadsheet used to calculate Skyline automatic peak picking error rate on DIA data 
  * **2017_January_23_sequence_file.csv:** File from Lumos MS/MS providing sequence of samples run during DIA, data file names and corresponding sample numbers  
  * **2017-07-18_DIA-PRTC_RT:** Internal PRTC standard retention times. PRTC stands for Peptide Retention Time Calibration  
  * **Geoduck_Isolation-scheme.txt:** Isolation scheme used for MS/MS run across m/z range (mass/charge)  
  * **P00000_Pierce_prtc_digested_Mass400to6000-trimmed.txt:** Internal standard (PRTC), in-silico tryptic digested into peptides  
  * **DNR_Geoduck_mzMLpath.txt:** Text file for PECAN, with file paths listed for all DIA data .mzML files   
  * **DIA-TIC.csv:** Total ion current (TIC) measured for each sample in DIA run. TIC is used to normalize DIA data  
  * **P00000_Pierce_prtc.fasta:** Internal standard (PRTC) fasta  
  * **DNR_Geoduck_DatabasePath.txt:** Text file for PECAN, with file name of digested geoduck transcriptome background database  
  * **2017-Geoduck-DIA-raw/:** Empty directory where DIA raw data files can be downloaded in Script 01, if desired. NOTE: files are very large  

### Environmental
  * **2016-Round1-tides-formatted.xlsx:** Tide data downloaded from WWW Tide/Current Predictor, http://tbone.biol.sc.edu/tide  
  * **2016-Round1-tides-sync.csv:** Tide data for each bay merged into one .csv spreadsheet  
  * **Deployment-Coordinates:**  Deployment location latitude/longitude   
  * **EnvData-Master.csv:** Environmental data from DNR with merged tide data 
  * **EnvDataSync.csv:** Environmental data received from WA DNR  

### SRM
  * Raw SRM data and Skyline project files are too large for repo, and are available for download:  
    - [Raw SRM data files](http://owl.fish.washington.edu/generosa/Generosa_DNR/2017-July-SRM-Data/)   
    - [SRM Skyline project](http://owl.fish.washington.edu/generosa/Generosa_DNR/2017-July-SRM-various-files/2017-geoduck-SRM.sky.zip)    
    - [Dilution curve Skyline project](http://owl.fish.washington.edu/generosa/Generosa_DNR/2017-July-SRM-various-files/2017-07-26_DilutionCurve.sky.zip )   
  * **2017-07-18-Spencer-SRM-PRTC-RT.csv:** SRM internal standard (PRTC) peptide retention times  
  * **2017-08-11_SRM-Retention-Times.csv:** SRM geoduck sample retention times  
  * **2017-09-05_Dilution-Curve-Results.csv:**  Skyline report for dilution curve samples  
  * **2017-Geoduck-SRM-Skyline-Report.csv:** SRM data exported from Skyline for analysis   
  * **SRM-data-annotated.csv:** SRM abundnace data with protein annotations (merged with annotated transcriptome .txt file)  
  * **SRM-data-screened-final.csv:** SRM data fully screened, ready for analysis  
  * **SRM-Sequence-final-annotated.csv:** File from Vantage MS/MS providing sequence of samples run during SRM, data file names and corresponding sample numbers    
  * **SRM-target-proteins-from-DIA.csv:** List of protein selected for targeted analysis  
  * **SRM-Transitions.csv:** Transition information from DIA run on targeted proteins to be used in SRM run    
  * **Vantage_nanoAcq_blank_4min_DrM27cm.meth:**  Vantage method for blanks, run in between samples  
  * **Vantage_nanoAcq_geoduckLS_60min_DrM27cm.meth:** Vantage method for geoduck samples  
  * **Vantage_nanoAcq_prtcbsa53_60min_DrM27cm.meth:** Vantage method for internal standards  
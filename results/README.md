# results 

### DIA
  * [**DIA-detected-peptides-annotated.csv:**](http://owl.fish.washington.edu/generosa/Generosa_DNR/DIA-detected-peptides-annotated.csv) Screened and annotated peptides detected in geoduck ctendia tissue, click link to download from server. 
  * **DIA-NMDS-plot-by-sample#.png:** NMDS of DIA data showing technical replicate clustering, and organized by bay  
  * **DIA-annotated-UniprotID.csv:** UniprotID's for unique proteins detected in DIA run  

### Environmental
  * Daily mean plots for environmental parameters, for each bay  
  * **Grow-Env-Cor-test.csv:** ANOVA results from growth ~ environmental parameter correlation tests  
  * **Environmental-ANOVA-Results.csv:** ANOVA results testing differences between environmental parameters between locations  
  * **EnvData-Melted-NoOutliers.csv:** Environmental dataframe screened and melted into long form  

### SRM
  * **correlation-tests-plots/:** correlation plots between:
    * Each protein (using 1 peptide, the one with the highest abundance) against each environmental parameter (mean & SD for Temp, DO, pH, salinity)  
    * Each protein against growth  
    * Growth against each environmental parameter    
  * **stats/:**: tables with ANOVA results, coefficients of variation (CV) for technical replicates, transitions, and peptides, for various grouping variables (variation within location, within bays)  
  * **plots/:** plots of SRM protein results 
  * **Master-Data-Joined.csv:** Protein abundances summary statistics merged with sample meta-data, environmental summary statistics 
  * **SRM-data-meaned-melted.csv:** Peptide abundances (mean of transition abundances), in long format  
  * **SRM-data-peptide-summed.csv:** Peptide abundances (sum of transition abundances), in long format  
  * **SRM-data-protein-mean.csv:** Protein abundances (mean of peptide abundances, aka mean of sum of transitions for each peptide), in long format 

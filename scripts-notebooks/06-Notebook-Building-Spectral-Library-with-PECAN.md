
## In this notebook I will run PECAN on the DIA data .mzML files. 

## _Important note!: PECAN is extremely memory intensive. Prior to running all, consider only running one or two files to assess necessary time and results. Also, don't run unecessary files, e.g. data from blanks_  

### Let's review. Prior to executing we've done the following:
  * Converted the .raw files that are produced by Lumos to .mzML using MSConvert
  * Obtained a background proteome file from the geoduck gonad transcriptome, a protein fasta file (provided by Steven)
  * Obtained the PRTC protein sequence fasta file and merged with the proteome fasta file
  * Trypsin digested the proteome+PRTC file in silico using Protein Digestion Simulator
  * Obtained the isolation scheme file (from Emma) and converted to .csv  
  * Created a .txt file with list of paths to all mzML files   
  * Confired that we have a a .txt file with path to the background proteome database 

### Important note: All PECAN input files must be located in the same directory.
[NEED TO INCLUDE SCRIPT TO DO THIS]

### The final PECAN execution was run by UW Genome Sciences due to the enormous amount of memory required.  However, in the interest of potential future users (e.g. using Hyak), here are some lessons learned while using PECAN. Note, these may be fixed in future updates: 
  * The `-b` command that tells PECAN to override the default background proteome wasn't working, so Sean Bennett added my background proteome file to the Pecan configure file as a species called "LAURAGEO"
  * Sean also did some background re-configuring in Emu/Pecan. See his [notebook entry](https://genefish.wordpress.com/2017/02/24/more-proteomics-software-fun/). 
  * The .txt file that provides all the mzML file paths assumes that the mzML files are located in the **same** parent directories, so you must not include all the parent directories in the file paths (it gets confused).  So, all file paths in my .txt files were simpified, and one directory was created housing all files pertinent to the Pecan run. 
  * The Percolator function was not working when we ran PECAN, so Sean developed a work-around, included at the end of this notebook. Be sure to review that if you are having trouble generating a .blib file. 
  
### Let's look at the input files that I made: 


```python
pwd
```




    '/Users/shlaura3/Documents/Roberts Lab/DNR_Geoduck/Documentation'




```python
ls ../Analyses/Pecan/
```

    2017-02-19_Geoduck-database4pecan.tabular
    DNR_Geoduck_DatabasePath.txt
    DNR_Geoduck_IsolationScheme.csv
    DNR_Geoduck_mzMLpath.txt
    P00000_Pierce_prtc.fasta
    Pierce_PRTC.tabular



```python
! cat ../Analyses/Pecan/DNR_Geoduck_DatabasePath.txt
```

    2017-02-19_Geoduck-database4pecan.tabular



```python
! cat ../Analyses/Pecan/DNR_Geoduck_IsolationScheme.csv
```

    455.456911	465.461459
    465.461459	475.466006
    475.466006	485.470554
    485.470554	495.475101
    495.475101	505.479649
    505.479649	515.484196
    515.484196	525.488744
    525.488744	535.493291
    535.493291	545.497839
    545.497839	555.502386
    555.502386	565.506934
    565.506934	575.511481
    575.511481	585.516029
    585.516029	595.520576
    595.520576	605.525124
    605.525124	615.529671
    615.529671	625.534219
    625.534219	635.538766
    635.538766	645.543314
    645.543314	655.547861
    655.547861	665.552409
    665.552409	675.556956
    675.556956	685.561504
    685.561504	695.566051
    695.566051	705.570599
    705.570599	715.575146
    715.575146	725.579694
    725.579694	735.584241
    735.584241	745.588789
    745.588789	755.593336
    755.593336	765.597884
    765.597884	775.602431
    775.602431	785.606979
    785.606979	795.611526
    795.611526	805.616074
    805.616074	815.620621
    815.620621	825.625169
    825.625169	835.629716
    835.629716	845.634264
    845.634264	855.638811
    450.454638	460.459185
    460.459185	470.463732
    470.463732	480.46828
    480.46828	490.472827
    490.472827	500.477375
    500.477375	510.481922
    510.481922	520.48647
    520.48647	530.491017
    530.491017	540.495565
    540.495565	550.500112
    550.500112	560.50466
    560.50466	570.509207
    570.509207	580.513755
    580.513755	590.518302
    590.518302	600.52285
    600.52285	610.527397
    610.527397	620.531945
    620.531945	630.536492
    630.536492	640.54104
    640.54104	650.545587
    650.545587	660.550135
    660.550135	670.554682
    670.554682	680.55923
    680.55923	690.563777
    690.563777	700.568325
    700.568325	710.572872
    710.572872	720.57742
    720.57742	730.581967
    730.581967	740.586515
    740.586515	750.591062
    750.591062	760.59561
    760.59561	770.600157
    770.600157	780.604705
    780.604705	790.609252
    790.609252	800.6138
    800.6138	810.618347
    810.618347	820.622895
    820.622895	830.627442
    830.627442	840.63199
    840.63199	850.636537



```python
! cat ../Analyses/Pecan/DNR_Geoduck_mzMLpath.txt
```

    2017_January_23_envtstress_blank10.mzML
    2017_January_23_envtstress_blank11.mzML
    2017_January_23_envtstress_blank12.mzML
    2017_January_23_envtstress_blank13.mzML
    2017_January_23_envtstress_blank14.mzML
    2017_January_23_envtstress_blank15.mzML
    2017_January_23_envtstress_blank16.mzML
    2017_January_23_envtstress_blank18.mzML
    2017_January_23_envtstress_blank19.mzML
    2017_January_23_envtstress_blank1.mzML
    2017_January_23_envtstress_blank20.mzML
    2017_January_23_envtstress_blank21_170126134757.mzML
    2017_January_23_envtstress_blank21.mzML
    2017_January_23_envtstress_blank2_2.mzML
    2017_January_23_envtstress_blank22.mzML
    2017_January_23_envtstress_blank23.mzML
    2017_January_23_envtstress_blank24.mzML
    2017_January_23_envtstress_blank2.mzML
    2017_January_23_envtstress_blank3.mzML
    2017_January_23_envtstress_blank4.mzML
    2017_January_23_envtstress_blank5.mzML
    2017_January_23_envtstress_blank6.mzML
    2017_January_23_envtstress_blank7_170124182434.mzML
    2017_January_23_envtstress_blank7.mzML
    2017_January_23_envtstress_blank8_170124213729.mzML
    2017_January_23_envtstress_blank8.mzML
    2017_January_23_envtstress_blank9.mzML
    2017_January_23_envtstress_geoduck10.mzML
    2017_January_23_envtstress_geoduck11.mzML
    2017_January_23_envtstress_geoduck12.mzML
    2017_January_23_envtstress_geoduck13.mzML
    2017_January_23_envtstress_geoduck14.mzML
    2017_January_23_envtstress_geoduck15.mzML
    2017_January_23_envtstress_geoduck17.mzML
    2017_January_23_envtstress_geoduck18.mzML
    2017_January_23_envtstress_geoduck19.mzML
    2017_January_23_envtstress_geoduck1.mzML
    2017_January_23_envtstress_geoduck20.mzML
    2017_January_23_envtstress_geoduck2.mzML
    2017_January_23_envtstress_geoduck3.mzML
    2017_January_23_envtstress_geoduck4.mzML
    2017_January_23_envtstress_geoduck5.mzML
    2017_January_23_envtstress_geoduck6.mzML
    2017_January_23_envtstress_geoduck7_170124190430.mzML
    2017_January_23_envtstress_geoduck7.mzML
    2017_January_23_envtstress_geoduck8.mzML
    2017_January_23_envtstress_geoduck9.mzML


---

### Below is the final Pecan script. Here are some definitions/explanations of the inputs

  * `-o` Output directory  
  * `-s LAURAGEO` Database used (my digested proteome was added to the .config file and named "LAURAGEO", since the `-b` override didn't work).  
  * `-n` the name of my output .blib file; no need to include a .blib file ending  
  * `--isolationSchemeType BOARDER` I used BOARDER because my isolation scheme format is ranges of m/z (2 columns). Note: BOARDER is spelled wrong (should be BORDER), but that's how Pecan spells it  
  * `--pecanMemRequest 48` We tried 16 but Pecan requested 94. The max Emu allows for is 48, so that's the best we can do.   
  * Need to specify the mzMLpath.txt, DatabasePath.txt, and IsolationScheme.csv files in that order  
  * `--fido`  Not exactly sure what this does; from the [Evernote Tutorial](https://www.evernote.com/shard/s347/sh/edcb06ab-d008-418f-b28f-52f6614f1c39/2984ab55f427fcfe) the command tells Pecan to "Include protein inference using FIDO in percolator"  
  * `--jointPercolator` Include Percolator step in the Pecan run.  
  
NOTE: I do not recommend executing the below commands through Jupyter Notebook since PECAN is a processor/memory intensive program.


```python
# Setting up Pecan directories
pecanpie -o /home/srlab/Documents/Laura/DNR_geoduck/Pecan3 \
-s LAURAGEO \
-n DNR_geoduck_SpLibrary --isolationSchemeType BOARDER \
--pecanMemRequest 48 \
/home/srlab/Documents/Laura/DNR_geoduck/DNR_Geoduck_mzMLpath.txt \
/home/srlab/Documents/Laura/DNR_geoduck/DNR_Geoduck_DatabasePath.txt \
/home/srlab/Documents/Laura/DNR_geoduck/DNR_Geoduck_IsolationScheme.csv \
--fido --jointPercolator
```


```python
# Then, execute the command
cd /home/srlab/Documents/Laura/DNR_geoduck/Pecan3 \
./run_search.sh`
```

### In the version of PECAN that Sean & I were using Percolator did not execute, so we needed to force it to.  Percolator is a function that "integrates" results from PECAN and builds a .blib file. The following are instructions from Sean that were used to "hack" a .blib file:

Overall, run the: 
  /geoduck.job file to aggregate all the separate isolation window results, then...
  /percolator.job file to aggregate all the samples, then..
  /pecan2blig.job file to condense everything into one .blib file. 
  
  * Step 1) Go to Pecan output directory
  * Step 2) Under "Percolatorr" directory there's a series of job files; take the first geoduck job file, and execute: `chmod +x [jobfilename]` This tells Linux that it's an executable file, and run that.
  * Step 3) Execute `./[jobfilename]`  
  * Step 4) Back out of the percolator director, and go to the pecan2blib directory
  * Step 5) Execute the same `chmod +x [jobfilename]` in the pecan2blib directory
  
**ALSO**: in all the percolator sample.job and joint.job files have the -Q input. If the error log shows that it doesn't know what -Q is, remove it from all the job 


```python

```

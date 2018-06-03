
# Prepare peptide database for _in silico_ digestion

In this notebook we will prepare our background proteome, the geoduck gonad transcriptome, for digestion into peptides.

----

## Step 1. Remove extraneous info from background proteome 

I received a protein fasta file from Steven, which will be used as the background proteome in PECAN.  First step is to edit the header data of each protein sequence to remove extraneous text. I do so in the following steps.  The resulting fasta file is saved on Owl, so feel free to download this file and skip to step 3. 

* **Input File:** Geoduck gonad transcriptome fasta file [Geoduck-transcriptome-v2.transdecoder.pep](https://raw.githubusercontent.com/sr320/paper-pano-go/52c6b18b5b09e5c3a49250cf47ad4ddc8e9dc004/data-results/Geoduck-transcriptome-v2.transdecoder.pep)
* **Output File:** Geoduck gonad transcriptome fasta file with extraneous info removed from each header line [Geoduck-transcriptome-v2.transdecoder_TrimmedHeadr.pep](http://owl.fish.washington.edu/generosa/Generosa_DNR/Geoduck-transcriptome-v2.transdecoder_TrimmedHeadr.pep)


```python
# Let's see what the current header looks like
!head ../../data/DIA/Geoduck-transcriptome-v2.transdecoder.pep
```

    >cds.comp100047_c0_seq1|m.5980 comp100047_c0_seq1|g.5980  ORF comp100047_c0_seq1|g.5980 comp100047_c0_seq1|m.5980 type:internal len:142 (-) comp100047_c0_seq1:3-425(-)
    NAECRDLYKIFTQILSVRSQEGKIVIPDEFATKIRNWLGNKEELFKEAHNQKIITFYNEY
    TREENTFNPIRGKRPMSVPDMPERKYIDQLSRKTQSQCDFCKYKTFTAEDTFGRIDSNFS
    CSASNAFKLDHWHALFLLKTH
    >cds.comp100068_c0_seq1|m.5981 comp100068_c0_seq1|g.5981  ORF comp100068_c0_seq1|g.5981 comp100068_c0_seq1|m.5981 type:internal len:106 (-) comp100068_c0_seq1:1-315(-)
    LFLDKSGKRICSFNNLTAVIEKATERASRIRLAKGLSQPKYLSCGNVDKVPAPGYLTASF
    TQLSVNKTRKDKGRNHLLLWDQTSSYSYIGPGIHYKDGKIRVNTT
    >cds.comp100097_c0_seq1|m.5982 comp100097_c0_seq1|g.5982  ORF comp100097_c0_seq1|g.5982 comp100097_c0_seq1|m.5982 type:internal len:227 (+) comp100097_c0_seq1:2-679(+)
    GTENLRICLKVIETYLLLGPREFLELYSGDLVHSLSNLLSDLRTEGVLLVLRVIELVLKS
    FPTEGPALFKSMLPEFLRAVLNKDEHPVVMSLYLTLFGRIVLQNQEFFWNFLDQMAMESH



```python
# Count how many lines there are in the fasta file pre-trimmed
! grep -c '>' ../../data/DIA/Geoduck-transcriptome-v2.transdecoder.pep
```

    35951



```python
# Remove extraneous text 
! cut -d " " -f 1 ../../data/DIA/Geoduck-transcriptome-v2.transdecoder.pep > \
../../data/DIA/Geoduck-transcriptome-v2.transdecoder_TrimmedHeadr.pep
```


```python
# Confirm that I didn't lose any lines 
! grep -c '>' ../../data/DIA/Geoduck-transcriptome-v2.transdecoder_TrimmedHeadr.pep
```

    35951



```python
# Preview the edited fasta file 
! head ../../data/DIA/Geoduck-transcriptome-v2.transdecoder_TrimmedHeadr.pep
```

    >cds.comp100047_c0_seq1|m.5980
    NAECRDLYKIFTQILSVRSQEGKIVIPDEFATKIRNWLGNKEELFKEAHNQKIITFYNEY
    TREENTFNPIRGKRPMSVPDMPERKYIDQLSRKTQSQCDFCKYKTFTAEDTFGRIDSNFS
    CSASNAFKLDHWHALFLLKTH
    >cds.comp100068_c0_seq1|m.5981
    LFLDKSGKRICSFNNLTAVIEKATERASRIRLAKGLSQPKYLSCGNVDKVPAPGYLTASF
    TQLSVNKTRKDKGRNHLLLWDQTSSYSYIGPGIHYKDGKIRVNTT
    >cds.comp100097_c0_seq1|m.5982
    GTENLRICLKVIETYLLLGPREFLELYSGDLVHSLSNLLSDLRTEGVLLVLRVIELVLKS
    FPTEGPALFKSMLPEFLRAVLNKDEHPVVMSLYLTLFGRIVLQNQEFFWNFLDQMAMESH


--- 

## Step 2. Combine PRTC fasta with transcriptome fasta

We added a standard, the Peptide Retention Time Calibration mixture (PRTC), to each sample before injecting during our mass spec run.  We need to include them in our background database so that PECAN assigns the transitions associated with PRTC correctly.

* **Input Files:**
  - Peptide Retention Time Calibration mixture (PRTC) protein sequence, fasta file: [P00000_Pierce_prtc.fasta](../../data/DIA/P00000_Pierce_prtc.fasta)
  - Geoduck transcriptome with trimmed header, from Step 2: [Geoduck-transcriptome-v2.transdecoder_TrimmedHeadr.pep](http://owl.fish.washington.edu/generosa/Generosa_DNR/Geoduck-transcriptome-v2.transdecoder_TrimmedHeadr.pep)  
* **Output File:** Combined geoduck transcriptome + PRTC fasta file: [GeoTranscriptomePRTC.fasta](http://owl.fish.washington.edu/generosa/Generosa_DNR/GeoTranscriptomePRTC.fasta)


```python
# Inspect PRTC fasta; it's short so we can print the whole thing out
! cat ../data/DIA/P00000_Pierce_prtc.fasta
```

    
    
    



```python
# Inspect the trimmed header geoduck transcriptome fasta; it's super long so let's just look at the tail, since we'll be adding the PRTC sequence to the end of this file
! tail ../data/DIA/Geoduck-transcriptome-v2.transdecoder_TrimmedHeadr.pep
```

    QLHVLNLLVLLLPSVHRDMLEAVLDFLEKVVEHSATNKMSLSNVAMIMAPNLFMSPKVRA
    SPPGKTKRAWEIEIKMA
    >cds.comp99988_c0_seq1|m.5978
    INVNFSRFNESNLSLSGWANSGFHPAIEFECSKPLPLVGVSLFNPCREGEANGTLEVLDK
    DKVLICMNVNLVYDASKHYVDVMFQKPIHIDATKRYTLRQTLKGTDLTHGLNGNNVIEDK
    GVKVAFFTSNKDTGGSYEVYGQFFGIIFKC*
    >cds.comp99988_c0_seq2|m.5979
    INVNFSRFNESNLSLSGWANSGFHPAIEFECSKPLPLVGVSLFNPCREGEANGTLEVLDK
    DKVLICMNVNLVYDASKHYVDVMFQKPIHIDATKRYTLRQTLKGTDLTHGLNGNNVIEDK
    GVKVAFFTSNKDTGGSYEVYGQFFGIIFKC*



```python
# Combine the two files
! cat ../data/DIA/Geoduck-transcriptome-v2.transdecoder_TrimmedHeadr.pep ../data/DIA/P00000_Pierce_prtc.fasta > GeoTranscriptomePRTC.fasta
```


```python
# Inspect the tail of the resulting file
! tail GeoTranscriptomePRTC.fasta
```

    INVNFSRFNESNLSLSGWANSGFHPAIEFECSKPLPLVGVSLFNPCREGEANGTLEVLDK
    DKVLICMNVNLVYDASKHYVDVMFQKPIHIDATKRYTLRQTLKGTDLTHGLNGNNVIEDK
    GVKVAFFTSNKDTGGSYEVYGQFFGIIFKC*
    >cds.comp99988_c0_seq2|m.5979
    INVNFSRFNESNLSLSGWANSGFHPAIEFECSKPLPLVGVSLFNPCREGEANGTLEVLDK
    DKVLICMNVNLVYDASKHYVDVMFQKPIHIDATKRYTLRQTLKGTDLTHGLNGNNVIEDK
    GVKVAFFTSNKDTGGSYEVYGQFFGIIFKC*
    
    
    



```python
# See how many lines we have in the resulting file. From Step 1 we know we should have 35951 geoduck + 1 PRTC lines = 35952 lines
! grep -c '>' GeoTranscriptomePRTC.fasta
```

    35952


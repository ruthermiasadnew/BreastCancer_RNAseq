# BreastCancer_RNAseq
Pipeline for identifying differentially expressed Genes using RNA seq data from 6 different Breast cancer Subtypes

--------
## RESEARCH QUESTION : Which genes are differentially expressed across different breast cancer subtypes, and what biological pathways are enriched among the top differentially expressed genes?

---------
## Data 
The dataset, GSE113863, is from NCBI's GEO database and it includes sample-level subtype classification based on the PAM50 gene. 
At first, I tried using the **raw count matrix** available on GEO. I was planning to:
- Load it into R  
- Create metadata  
- Run DESeq2 for differential expression  

But that matrix only had 225 samples, while I had 474. It technically worked, but the data was sparse and didn’t match well, probably because the original study’s goal was different from mine.
Since I couldn’t find a better raw count matrix, I decided to download the FASTQ files myself and build my own RNA-seq pipeline.
I uploaded the FASTQ files to AnVIL, inside my scratch directory:
/anvil/scratch/x-radnew/breast_cancer_fastq
-----------
## QC and Trimming 

I first tried using **FastQC**, but realized it runs on all files individually — so I used **MultiQC** to summarize everything in one place.
The initial quality wasn’t great.
I trimmed the reads using **fastp** to remove adapters and low-quality tails, then re-ran **MultiQC**. The quality looked a lot better after trimming.
-----------
## Alignment & Quantification with Salmon

This one was challenging because I didn't know whcih alignment tool to use that would best fit my end goal and the data I was working with. 
I chose salmon because, it is super fast compared to HISAT or STAR.. and It's my first time :0
-------SALMON QUANTIFICATION ------
1. Downloaded Transcriptome Reference (GENCODE)
   wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/gencode.v44.transcripts.fa.gz
   gunzip gencode.v44.transcripts.fa.gz
this is the dictionary that salmon will use to compare my RNA reads and try to figure out which ones are being expressed

2. Built a Salmon Index
     salmon index -t gencode.v44.transcripts.fa -i /anvil/scratch/x-radnew/salmon_index --threads 8
     this is like a cheat sheet instead of letting SALMON scan the full FASTA file everytime it can look up on the indeex to see where the read might belong
3. Quantified Expression for Each Sample
      for this part SALMON is taking each of the trimmed fastq files and Tries to “quasi-align” them to transcripts from GENCODE (using k-mers, not full alignment)
      then it figures out which  transcripts are likely present in each sample, and how much of each
      It didn't run smoothly.. I had trouble doing the quantification from the right directory.
      When it finaaly worked I selected the .quant.sf files(the count table for how much each transcript was expressed) for each sample and made a folder on Anvil.
This was a very large file 3GB so I couldn't download it and use it on my computer R studio so I used the ineractive R studio on Anvil.
on R I used tximport to change the transcript level data into gene level counts
    quick recap.. a gene is A section of DNA that codes for a protein
                  Transcript is one of the many versions of that gene — depending on how it’s spliced
    Analogy.. Beyonces songs..
    Formation is one song
      but it has the studio version, superbowl and remix..
    so if I use salmon for her songs it gives me stream counts for each.. that is my transcripts but the when I use tximport its like Formation and the sum of all its streams
    I found out that this is done because DE tools expect one value per gene
    SO after I did my tximport and got my matrix with gene names samples and expression values

At first I wanted to do DESeq2 but fr some reason Biocmanager wouldn't let me load the library on Anvil so I did Limma instead
Took gene count matrix + metadata (sample subtypes)
		then Compared groups HER2E vs Basal
	then I got logFC, p-values, and adj.p.values 
I got my DEG for HER2E vs Basal
I did PCA lots for the interaction(2D and 3D) didnt interpret it yet 
then I exported DEG csv and used it n Cytoscope with STRING protien interaction and got a network graph. currently I am trying to better understand the netwokrs and the bilogical backgrounds 

    


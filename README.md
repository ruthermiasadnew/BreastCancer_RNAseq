BreastCancer_RNAseq

Pipeline for identifying differentially expressed genes using RNA-seq data from six different breast cancer subtypes.

Research Question
Which genes are differentially expressed across different breast cancer subtypes, and what biological pathways are enriched among the top differentially expressed genes?


Data Source

Dataset: GSE113863 from NCBI's GEO

Includes PAM50 breast cancer subtypes (e.g., HER2E, Basal)

Initial raw count matrix (225 samples) didn’t align with downloaded FASTQ files (474 samples)

Solution: Downloaded full FASTQ files and created RNA-seq pipeline from scratch via AnVIL

🔬 RNA-seq Analysis Pipeline

 Quality Control & Trimming

Used FastQC for initial QC

Summarized with MultiQC

Trimmed adapters and low-quality reads using fastp

Re-ran MultiQC post-trimming → much better quality

Alignment & Quantification with Salmon

Downloaded GENCODE Transcriptome Reference

wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/gencode.v44.transcripts.fa.gz
gunzip gencode.v44.transcripts.fa.gz

Built Salmon Index

salmon index -t gencode.v44.transcripts.fa -i /anvil/scratch/x-radnew/salmon_index --threads 8

Quantified Expression for Each Sample

Salmon quasi-aligned trimmed FASTQ files to the index

Extracted .quant.sf files for each sample (transcript-level expression counts)

tximport

Used tximport in R to summarize transcript-level data to gene-level expression counts

 Differential Expression Analysis

 DE Analysis

Used limma instead of DESeq2 due to BiocManager install issues

Created metadata (sample subtype classification)

Compared HER2E vs Basal

Output: logFC, p-values, and adjusted p-values

 Key Findings

Identified top differentially expressed genes (DEGs) in HER2E vs Basal

Exported DEGs to CSV for network visualization

 Visualization

 PCA

Created 2D and 3D PCA plots

HER2E and Basal clustered apart → suggests biological differences

 Cytoscape + STRING

Imported DEGs into Cytoscape with STRING database

Visualized protein-protein interaction networks

Currently exploring how to interpret clusters and enriched biological pathways

Questions for Dr. O

What does the clustering of HER2E and Basal in PCA indicate biologically?

How can I better interpret Cytoscape/STRING networks?

What's the best way to conduct DEG analysis across all six subtypes without running into metadata issues?

 Challenges

BiocManager not loading DESeq2 on AnVIL

Large data files (3GB+) were difficult to transfer

Metadata matching and subtype consistency required manual validation

🧠 Reflection

This project helped me build end-to-end RNA-seq analysis skills, from raw data to biological interpretation. I’ve grown significantly in pipeline development, cloud computing, and bioinformatics visualization—and I’m excited to expand on this as I deepen my understanding of cancer genomics.


These are my top 6 differentially expressed genes based on my enrichment table from Cytoscape with low FDR values 

ANLN, MELK, CENPF, KIF2C, CDC20, PTTG1




    


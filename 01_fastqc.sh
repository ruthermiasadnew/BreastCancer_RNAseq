#!/bin/bash

# Load module
module load biocontainers
module load fastqc/0.11.9--0

# Create output directory
mkdir -p fastqc_results

# Run FastQC on all fastq files
fastqc *.fastq -o fastqc_results

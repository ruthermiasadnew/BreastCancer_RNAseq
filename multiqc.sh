#!/bin/bash

# Load module
module load biocontainers
module load multiqc/1.9--pyh9f0ad1d_0

# Run MultiQC to summarize FastQC results
multiqc fastqc_results -o multiqc_summary

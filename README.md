# Duplications

## This Repo contains the code needed to reproduce the analysis conducted in  Abrahams et al.

### Step 1. Running CNVnator on mapped data

After mapping short read data from the Illumina platform to the reference genome using Snippy, the number of reads covering each base is generated using samtools depth. 

Following generation of the coverage data,  optimum window size is estimated using the Ratio script.

Then using the optimum window size, CNVnator is run via the docker script and using the optimum window size.

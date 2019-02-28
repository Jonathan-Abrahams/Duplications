# Duplications

## This Repo contains the code needed to reproduce the analysis conducted in  Abrahams et al.

### Step 1. Running CNVnator on mapped data

After mapping short read data from the Illumina platform to the reference genome using Snippy, the number of reads covering each base is generated using samtools depth using the script Create_depth.sh

```
bash ./bin/CNVnator/Create_depth.sh ./Example_data/ERR212367
``` 

Following generation of the coverage data,  optimum window size is estimated using the Ratio script.
```bash
Rscript bin/CNVnator/Find_ratio.R Example_data/ERR212367/snps.depth
```

Then using the optimum window size, CNVnator is run via the docker script and using the optimum window size.

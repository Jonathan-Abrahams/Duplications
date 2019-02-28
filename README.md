# Duplications

## This Repo contains the code needed to reproduce the analysis conducted in  Abrahams et al.

### Step 1. Running CNVnator on mapped data

After mapping short read data from the Illumina platform to the reference genome using Snippy, the number of reads covering each base is generated using samtools depth using the script Create_depth.sh
Our custom CNVnator pipeline can either be executed automatically using a conveninet wrapper:

Or each part can be executed individually:

```
bash ./bin/CNVnator/Create_depth.sh ./Example_data/ERR212367/snps.bam
``` 

Following generation of the coverage data,  optimum window size is estimated using the Ratio script.
```bash
 Rscript bin/CNVnator/Find_ratio.R Example_data/ERR212367/output.depth
```

Then using the optimum window size, CNVnator is run via the docker script.

```bash
bash bin/CNVnator/CNVnator_docker.sh  Example_data/ERR212367/CNVnator_window_table_top_hit.txt
```

In the final step of the CNVnator module of code, CNV stretches of DNA are converted to genes. If a gene overlaps with the CNV region by at least 80% then it is called a CNV

```bash
Rscript bin/CNVnator/CNVnator_output_0.1_round.r ./Example_data/ERR212367/CNVnator_out_100.txt
```

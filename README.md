# Duplications

## This Repo contains the code needed to reproduce the analysis conducted in  Abrahams et al.

### Step 1. Running CNVnator on mapped data

After mapping short read data from the Illumina platform to the reference genome using Snippy, our pipeline can be run. 

Firstly, the reference genome is processed in a way that CNVnator likes. To do this the Make_reference.sh script is run on the reference genome downloaded from NCBI. At the moment this must be run from within the git directory.
```bash
 bash ./bin/CNVnator/Make_reference.sh GCF_000009065.1_ASM906v1_genomic.fna
```


Our custom CNVnator pipeline can either be executed automatically using a conveninet wrapper:
```bash
 bash bin/CNVnator/CNVnator_auto.sh ./Example_data/SRR5070670 snps.bam
```



Or each part can be executed individually:

The number of reads covering each base is generated using samtools depth using the script Create_depth.sh
```
bash ./bin/CNVnator/Create_depth.sh ./Example_data/ERR212367/snps.bam
``` 

Following generation of the coverage data,  optimum window size is estimated using the Ratio script.
```bash
 Rscript bin/CNVnator/Find_ratio.R Example_data/ERR212367/output.depth
```

Then using the optimum window size, CNVnator is run via the docker script. If the ratio is below 3, CNVnator will not be run and the auto script will stop.

```bash
bash bin/CNVnator/CNVnator_docker.sh  Example_data/ERR212367/CNVnator_window_table_top_hit.txt
```

In the final step of the CNVnator module of code, CNV stretches of DNA are converted to genes. If a gene overlaps with the CNV region by at least 80% then it is called a CNV. This requirse IRanges to be installed.

```bash
Rscript bin/CNVnator/CNVnator_output_0.1_round.r ./Example_data/ERR212367/CNVnator_out_100.txt GCF_000009065.1_ASM906v1_genomic.gff
```

### Step 2. Make a heatmap


At the moment this step requries a plotly account. Need to add an export to html option


```bash

Rscript Duplications/bin/Heatmap/Generic_plotly_heatmap.R ./Quick_genome_download/Mapped_genomes/all_cnvnator_results.txt GRAPH_NAME
```

### Step 3. Network analysis




#Metadata

##Cogs

Cogs for each gene can be found by uploading protein sequences to EGGNOG. The resulting database can be linked to the GFF using this script: COG_to_GFF.R

We can then check for functional enrichment...


### Requirements
R:
IRanges and Zoo

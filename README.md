# Duplications

## This Repo contains the code needed to reproduce the analysis conducted in  Abrahams et al.

### Step 1. Running CNVnator on mapped data

After mapping short read data from the Illumina platform to the reference genome using Snippy, our pipeline can be run. 

Firstly, the reference genome is processed in a way that CNVnator likes. To do this the Make_reference.sh script is run on the reference genome downloaded from NCBI. At the moment this must be run from within the git directory.
```bash
 bash ./bin/CNVnator/Make_reference.sh GCF_000009065.1_ASM906v1_genomic.fna
```


Our custom CNVnator pipeline can either be executed automatically using a conveninet wrapper. It requires the following input in this order (at the moment):Genome directory,name of bam file,reference genome directory and reference 
GFF file, with only CDS or genes present.
```bash
bash ./bin/CNVnator/CNVnator_auto.sh  /home/ubuntu/Quick_genome_download/Mapped_genomes/ERR3014612 snps.bam ./Reference_genomes GCF_000195955.2_ASM19595v2_genomic.gff
```



Or each part can be executed individually:

The number of reads covering each base is generated using samtools depth using the script Create_depth.sh
```
bash ./bin/CNVnator/Create_depth.sh ./Example_data/ERR212367/snps.bam
``` 

Following generation of the coverage data,  optimum window size is estimated using the Ratio script.
```bash
 Rscript bin/CNVnator/Chunk_it_real.R Example_data/ERR212367/output.depth
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

Whilst the heatmap is not completely nececary to be complete before the network analysis, the data must be transposed, which is undertaken in the heatmap script.

Network analysis has been combined into an automated script: Network_auto.sh

We then create a list of all the CNVs using the List_CNVs.r script.The transposed data is provided as the first arguement and the resulting list is specified as the second arguement.:

```bash
Rscript ./bin/Networks/List_CNVs.r all_data.csv all_CNVs.csv 
```
We then compute a distance matrix

```bash
Rscript ./bin/Networks/all_all.R all_CNVs.csv all_all.csv
```
We then are ready to compute the networks! Provide the all vs all database and the list of CNVs!
```bash
 Rscript ./bin/Networks/best_network.R all_vs_all.csv all_CNVs.csv
```

#Metadata

##Cogs

Cogs for each gene can be found by uploading protein sequences to EGGNOG. The resulting database can be linked to the GFF using this script: COG_to_GFF.R

We can then check for functional enrichment...


### Requirements
R:
IRanges and Zoo
Igraph


Linux:
Docker
bc

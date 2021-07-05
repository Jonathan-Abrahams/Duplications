# Duplications

## This Repo contains the code needed to reproduce the analysis conducted in  Abrahams et al.

Test data is included in the Test data directory.

### Step 1. Running CNVnator on mapped data

After mapping short read data from the Illumina platform to the reference genome using Snippy our pipeline can be run. 

Firstly, the reference genome is processed in a way that is compatible with CNVnator. To do this the Make_reference.sh script is run on the reference genome downloaded from NCBI.

```bash
 bash ./bin/CNVnator/Make_reference.sh ./Test_data/B1917.ref.fa
```

Our custom CNVnator pipeline can be executed automatically using a conveninet wrapper. It requires the following input in this order (at the moment):Genome directory,name of bam file,reference genome directory and reference GFF file, with only CDS or genes present.

```bash
bash ./bin/CNVnator/CNVnator_auto.sh  ./Test_data/SRR942708 snps.bam ./Reference_genomes ./Test_data/B1917_modified.gff
```

### Step 2. Make a heatmap

This requires the Plotly package to be installed. An upload of the graph to the users plotly account will be tried. Edit your own username and API key into this file.

Plotly is a great way to share data quickly.

https://plot.ly/
```bash

Rscript Duplications/bin/Heatmap/Generic_plotly_heatmap.R ./Quick_genome_download/Mapped_genomes/all_cnvnator_results.txt GRAPH_NAME
```

### Step 3. Network analysis

We then create a list of all the CNVs using the List_CNVs.r script. The transposed data that was created by the heatmap script is provided as the first argument and the resulting list to write is specified as the second argument:

```bash
Rscript ./bin/Networks/List_CNVs.r all_data.csv all_CNVs.csv 
```
We then compute a distance matrix:

```bash
Rscript ./bin/Networks/all_vs_all.R all_CNVs.csv all_all.csv
```
We then are ready to compute the networks! Provide the all vs all database and the list of CNVs!
```bash
 Rscript ./bin/Networks/Network_analysis.R all_vs_all.csv all_CNVs.csv
```

Stats can be calculated on all the networks:

```
Rscript ./Duplications/bin/Networks/CNV_stats.R all_CNVs.csv CNV_membership.csv ./Duplications/B1917.gff all_all.csv

```
### Requirements
R:
IRanges and Zoo
Igraph
Plotly


Linux:
Docker
bc

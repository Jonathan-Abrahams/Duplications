#This script runs the whole CNVnator pipeline.

#This file takes a two arguemnts as input: The directory of interest and the  .bam file in the directory of interest


bash ./bin/CNVnator/Create_depth.sh $1/$2
echo "Depth file created"
Rscript ./bin/CNVnator/Find_ratio.R $1/output.depth
echo "Ratio found"

bash bin/CNVnator/CNVnator_docker.sh $1/CNVnator_window_table_top_hit.txt
echo "CNVnator complete"
Rscript ./bin/CNVnator/CNVnator_output_0.1_round.r $1/CNVnator_out_*.txt





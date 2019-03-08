#This script runs the whole CNVnator pipeline.

#This file takes three  arguemnts as input: The directory of interest, .bam file in the directory of interest and A directory of reference seqeunces


bash ./bin/CNVnator/Create_depth.sh $1/$2
echo "Depth file created"
Rscript ./bin/CNVnator/Chunk_it_real.R $1/output.depth
echo "Ratio found"

bash bin/CNVnator/CNVnator_docker.sh $1/CNVnator_window_table_top_hit.txt $3
echo "CNVnator complete"
Rscript ./bin/CNVnator/CNVnator_output_0.1_round.r $1/CNVnator_out_*.txt





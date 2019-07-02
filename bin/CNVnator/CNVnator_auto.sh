#This script runs the whole CNVnator pipeline.

#This file takes three  arguemnts as input: The directory of interest, .bam file in the directory of interest and A directory of reference seqeunces
set -e

bash ./bin/CNVnator/Create_depth.sh $1/$2

echo "Depth file created for genome $1"



Rscript ./bin/CNVnator/Chunk_it_real.R $1/output.depth
#echo "Ratio found for genome $1"

#If Ratio is >5 at 100bp then use 200
BP=$(cat $1/CNVnator_window_table_top_hit.txt|tail -1|awk '{print $1}')
Ratio=$(cat $1/CNVnator_window_table_top_hit.txt|tail -1|awk '{print $2}')
echo $Ratio
echo $BP

if [[ $Ratio>=5 && $BP=100 ]]

then
	echo "Ratio is abouve 5 and window length is 100"
	cp $1/CNVnator_window_table_top_hit.txt $1/CNVnator_window_table_top_hit_modified.txt

	sed -i 's/100/200/g'  $1/CNVnator_window_table_top_hit_modified.txt

	bash bin/CNVnator/CNVnator_docker.sh $1/CNVnator_window_table_top_hit_modified.txt $3
	New_BP=200
	echo "overlapping genes with CNVnator_out_$BP.txt"
	Rscript ./bin/CNVnator/CNVnator_output_0.1_round.r $1/CNVnator_out_$BP.txt $4
else
	
	echo "NORMAL"

	bash bin/CNVnator/CNVnator_docker.sh $1/CNVnator_window_table_top_hit.txt $3
	echo "overlapping genes with CNVnator_out_$BP.txt"
	Rscript ./bin/CNVnator/CNVnator_output_0.1_round.r $1/CNVnator_out_$BP.txt $4

fi


#bash bin/CNVnator/CNVnator_docker.sh $1/CNVnator_window_table_top_hit.txt $3
echo "CNVnator complete for genome $1"
#echo "overlapping genes with CNVnator_out_$BP.txt"
#Rscript ./bin/CNVnator/CNVnator_output_0.1_round.r $1/CNVnator_out_$BP.txt $4





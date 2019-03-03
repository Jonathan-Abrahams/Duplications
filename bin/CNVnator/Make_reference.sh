#This script will take a reference fasta file and format it in the way CNVnator likes.
#The fasta sequence needs to be split ,each file renames to the first word+.fa and the first line must be the first word only!


#What folder do the other files want?
mkdir ./Reference_genomes

#Copy the reference genome there

cp $1 ./Reference/genomes/

#Call the script which will split and rename it
./bin/CNVnator/file_splitter.sh

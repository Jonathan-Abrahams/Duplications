#This script will take a reference fasta file and format it in the way CNVnator likes.
#The fasta sequence needs to be split ,each file renames to the first word+.fa and the first line must be the first word only!


#What folder do the other files want?
mkdir Reference_genomes

#Copy the reference genome there

cp $1 ./Reference_genomes/
#sed -i 's/ /_/g' ./Reference_genomes/$1
sed -i 's/,//g' ./Reference_genomes/$1
#split files
cd Reference_genomes
cat $1| awk '{
        if (substr($0, 1, 1)==">") {filename=(substr($0,2) ".fa")}
        print $0 > filename
}'

cd ..
rm ./Reference_genomes/$1

#Call the script which will split and rename it

#This is troublesome.
#find ./Reference_genomes/* -print0 |xargs -0 -n1  bash ./bin/CNVnator/file_splitter.sh 
find ./Reference_genomes/* -print0 -exec bash ./bin/CNVnator/file_splitter.sh "{}" \;

#files=$(find ./Reference_genomes/* -print0)|sed 's/\./\\n\./g'
#echo $files

#for OUTPUT in "$files"
#do#
#	echo $OUTPUT
#
#done

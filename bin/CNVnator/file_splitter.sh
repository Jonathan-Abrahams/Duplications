#We will take a single fasta file and  rename the file  to the first word of the header and then rename the fiels as first word+.fa


#echo dollar1 is $1
#file_name=$(sed  's/ /\\ /g'<<<$1)
#echo file_name is $file_name
#cd ./Reference_genomes
head -1 "$1"
#head -1 "$file_name"
#Is_fasta=$(head -1 "$(echo $file_name)"|grep -o ">"|wc -c)
#echo $Is_fasta
##(head -1 $1|grep -o ">"
#if [ "$Is_fasta" -ge "2" ]
#then
#	echo "Input is a .fasta file, executing script"
##Header
#Header=$(head -1 $file_name|cut -d' ' -f1)
#echo Header is: $Header



#Filename

#sans_less=$(sed 's/>//g' <<<$Header)
#Filename=$(echo $sans_less.fa)


#mv file_name ./$Filename

#sed -i "1s/.*/$Header/" $Filename

#else
#	echo "File is not a fasta. Doing nothing."
#fi
#Header
#Header=$(head -1 $1|cut -d' ' -f1)
#echo $Header


#Filename

#sans_less=$(sed 's/>//g' <<<$Header)
#Filename=$(echo $sans_less.fa)


#cp $1 ./$Filename

#sed -i "1s/.*/$Header/" $Filename


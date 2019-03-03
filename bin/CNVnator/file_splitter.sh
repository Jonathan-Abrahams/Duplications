#We will take a single fasta file and  rename the file  to the first word of the header and then rename the fiels as first word+.fa


#split files
#cat $1|awk '{
#        if (substr($0, 1, 1)==">") {filename=(substr($0,2) ".fa")}
#        print $0 > filename
#}'


#Header
Header=$(head -1 $1|cut -d' ' -f1)
echo $Header


#Filename

sans_less=$(sed 's/>//g' <<<$Header)
Filename=$(echo $sans_less.fa)


mv $1 ./$Filename

sed -i "1s/.*/$Header/" $Filename


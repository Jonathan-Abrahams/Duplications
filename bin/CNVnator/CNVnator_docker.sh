#file should be CNVnator_window_table_top_hit.txt
#User should supply a second argument, which is a directory with a genome file in with exactly the same name as is used in the genome mapping


window=$(cat $1 |tail -1|awk '{print $1}')
ratio=$(cat $1 |tail -1|awk '{print $2}')


#if [ "$ratio" -ge "3.1" ]
if (( $(echo "$ratio > 3.1" |bc -l) ));
then
echo Ratio is abouve 3, procedign with CNVnator!
echo $window
Directory=$(dirname $1)
mkdir $Directory/Reference_CNVnator
cp  $2/* $Directory/Reference_CNVnator

sudo docker run -v $Directory:/data wwliao/cnvnator cnvnator -unique -root CNVnator_$window.root -tree snps.bam>/dev/null
sudo docker run -v $Directory:/data wwliao/cnvnator cnvnator -root CNVnator_$window.root -his $window -d Reference_CNVnator>/dev/null
sudo docker run -v $Directory:/data wwliao/cnvnator cnvnator -root CNVnator_$window.root -stat $window>/dev/null
sudo docker run -v $Directory:/data wwliao/cnvnator cnvnator -root CNVnator_$window.root -partition $window>/dev/null
sudo docker run -v $Directory:/data wwliao/cnvnator cnvnator -root CNVnator_$window.root  -eval $window>$Directory/CNVnator_$window.ratio_raw.txt
(sudo docker run -v $Directory:/data wwliao/cnvnator cnvnator -root CNVnator_$window.root -call $window)>$Directory/CNVnator_out_$window.txt
sudo docker run -v $Directory:/data wwliao/cnvnator cnvnator -root CNVnator_$window.root  -eval $window >$Directory/ratio_final_$window.txt
tail -2  $Directory/ratio_final_$window.txt|head -1|awk '{print $window0}'

else
echo Ratio is below 3, coverage is too erratic to give good CNV results
exit 1
fi

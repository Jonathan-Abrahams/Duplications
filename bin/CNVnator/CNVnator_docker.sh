#file should be CNVnator_window_table_top_hit.txt
window=$(cat $1 |tail -1|awk '{print $1}')
echo $window
Directory=$(dirname $1)
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -unique -root $Directory/CNVnator_$window.root -tree $Directory/snps.bam>/dev/null
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $Directory/CNVnator_$window.root -his $window -d Genomes_dir>/dev/null
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $Directory/CNVnator_$window.root -stat $window>/dev/null
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $Directory/CNVnator_$window.root -partition $window>/dev/null
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $Directory/CNVnator_$window.root  -eval $window>$Directory/CNVnator_$window_ratio_raw.txt
(sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $Directory/CNVnator_$window.root -call $window)>$Directory/CNVnator_out_$window.txt
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $Directory/CNVnator_$window.root  -eval $window >$Directory/ratio_$window_final.txt
tail -2  $Directory/ratio_$window_final.txt|head -1|awk '{print $window0}'


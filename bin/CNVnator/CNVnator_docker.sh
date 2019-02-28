window=$(cat $1/snps.depth.table_top_hit.txt |tail -1|awk '{print $1}')
echo $window
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -unique -root $1/CNVnator_$window.root -tree $1/snps.bam>/dev/null
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $1/CNVnator_$window.root -his $window -d Genomes_dir>/dev/null
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $1/CNVnator_$window.root -stat $window>/dev/null
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $1/CNVnator_$window.root -partition $window>/dev/null
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $1/CNVnator_$window.root  -eval $window>$1/CNVnator_$window_ratio_raw.txt
(sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $1/CNVnator_$window.root -call $window)>$1/CNVnator_out_$window.txt
sudo docker run -v $(pwd):/data wwliao/cnvnator cnvnator -root $1/CNVnator_$window.root  -eval $window >$1/ratio_$window_final.txt
tail -2  $1/ratio_$window_final.txt|head -1|awk '{print $window0}'


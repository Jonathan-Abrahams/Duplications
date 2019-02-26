window=$(cat $1/$1.table_top_hit.txt |tail -1|awk '{print $1}')
echo $window
sudo docker run -v /home/ubuntu/sratoolkit.2.8.2-1-ubuntu64/bin/:/data wwliao/cnvnator cnvnator -unique -root $1/$1_CNVnator_TEST_$window.root -tree $1/snps.bam>/dev/null
sudo docker run -v /home/ubuntu/sratoolkit.2.8.2-1-ubuntu64/bin/:/data wwliao/cnvnator cnvnator -root $1/$1_CNVnator_TEST_$window.root -his $window -d fake_genome_dir>/dev/null
sudo docker run -v /home/ubuntu/sratoolkit.2.8.2-1-ubuntu64/bin/:/data wwliao/cnvnator cnvnator -root $1/$1_CNVnator_TEST_$window.root -stat $window>/dev/null
sudo docker run -v /home/ubuntu/sratoolkit.2.8.2-1-ubuntu64/bin/:/data wwliao/cnvnator cnvnator -root $1/$1_CNVnator_TEST_$window.root -partition $window>/dev/null
sudo docker run -v /home/ubuntu/sratoolkit.2.8.2-1-ubuntu64/bin/:/data wwliao/cnvnator cnvnator -root $1/$1_CNVnator_TEST_$window.root  -eval $window>$1/$1_CNVnator_$window_ratio_raw.txt
(sudo docker run -v /home/ubuntu/sratoolkit.2.8.2-1-ubuntu64/bin/:/data wwliao/cnvnator cnvnator -root $1/$1_CNVnator_TEST_$window.root -call $window)>$1/$1_CNVnator_out_$window.txt
sudo docker run -v /home/ubuntu/sratoolkit.2.8.2-1-ubuntu64/bin/:/data wwliao/cnvnator cnvnator -root $1/$1_CNVnator_TEST_$window.root  -eval $window >$1/$1_ratio_$window_final.txt
tail -2  $1/$1_ratio_$window_final.txt|head -1|awk '{print $window0}'


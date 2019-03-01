#Point this script to a specific .bam file and the script will handle everything else!
directory=$(dirname $1)
samtools depth $1 > $directory/output.depth

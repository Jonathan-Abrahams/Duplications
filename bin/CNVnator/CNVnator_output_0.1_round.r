#turn the output of CNVnator into a bed file

library(IRanges)
#input should be the genome name only

args = commandArgs(trailingOnly=TRUE)
args[1]="SRR5071080"
print(as.character(args[1]))
CNVnator_output=read.delim(args[1],stringsAsFactors = F,head=F)

Tohama_genes=read.delim(args[2],stringsAsFactors = F,head=F,comment.char = "#")
colnames(CNVnator_output)=c("Type","Location","Length","Depth","E1","E2","E3","E4","Other")
CNVnator_output=CNVnator_output[CNVnator_output$E1<0.0001,]
CNVnator_processed=CNVnator_output
CNVnator_processed$Location=gsub(".*:","",CNVnator_output$Location,perl = T)

cc       <- strsplit(CNVnator_processed$Location,"-")
#print(cc)

CNVnator_processed$Starts    <- unlist(cc)[2*(1:length(CNVnator_output$Location))-1]
CNVnator_processed$Ends    <- unlist(cc)[2*(1:length(CNVnator_output$Location))  ]

head(CNVnator_processed)
CNVnator_ranges=IRanges(as.numeric(CNVnator_processed$Starts),as.numeric(CNVnator_processed$Ends))
Tohama_ranges=IRanges(as.numeric(Tohama_genes$V4),as.numeric(Tohama_genes$V5))

results=findOverlaps(CNVnator_ranges,Tohama_ranges)


overlaps <- pintersect(CNVnator_ranges[queryHits(results)],Tohama_ranges[subjectHits(results)])

percentOverlap <- width(overlaps) / width(Tohama_ranges[subjectHits(results)])
results_filtered=results[which(percentOverlap>=0.8)]
int_list=as(results_filtered, "IntegerList")

results_frame=Tohama_genes
results_frame$Copy_number=1

print("Before loop")
#for every region
for(i in c(1:length(int_list)))
{
  #print(CNVnator_processed$Type[i])
  #print(as.numeric(unlist(as(results, "IntegerList")[i])))
  hitty=as.numeric(unlist(as(results, "IntegerList")[i]))
  results_frame$Copy_number[hitty]=round(CNVnator_processed$Depth[i],1)
   
  
}
colnames(results_frame)[10]=args[1]
#output_path=paste("./","Tohama_artificial_CNV/Tohama_art_300_v2/snippy/","Tohama_1col_CNVnator_simple","_200_round_1.6.txt",sep="")
#output_path=paste("./",args[1],"/","CNVnator_genes_",args[2],".txt",sep="")
col1=results_frame[10]
write.table(col1,file=paste(args[1],"_genes_overlap.TXT",sep=""),quote=F,row.names=F,col.names=T)

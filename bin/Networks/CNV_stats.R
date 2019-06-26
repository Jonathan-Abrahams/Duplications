# Calculate CNV stats
args = commandArgs(trailingOnly=TRUE)

#CNV_data=read.csv("Extracted_CNVs_new.csv")

CNV_data=read.csv(args[1])

#group_data=read.csv("CNV_membership_new.csv")
group_data=read.csv(args[2])

kolp3=merge(CNV_data,group_data,by.x ="X",by.y = "CNV_number" )
write.csv(kolp3,"CNV_merged_data.csv")
#gff=read.delim("BP_locus_tags_NO_PSEUDO_CDHIT.gff",header=F)
gff=read.delim(args[3],header=F)


#maxxy=factor(unique(group_data$group),levels=c("1","2","3","4a","4b","5a","5b","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21"),ordered = T)
maxxy=sort(factor(unique(group_data$group)))
#maxxy=maxxy[c(2,1,6,9,5,12,22,7,19,23,21,11,10,8,3,4,13,14,15,16,17,18,20)]
kolp=as.character(levels(maxxy))
results_frame=data.frame(CNV_class=maxxy,
                         Frequency=as.numeric(table(group_data$group)[match(kolp,names(table(group_data$group)))]),
                         Mean_length=c(1:length(maxxy)),
                         Median_start=c(rep("a",length(maxxy))),
                         Median_end=c(rep("a",length(maxxy))),
                         Median_middle=c(rep("a",length(maxxy))),
                         SD_of_overlap=c(1:length(maxxy)),
                         mean_copy_number=c(1:length(maxxy)),
                         Strains=c(rep("a",length(maxxy))),
                         Core_75_start=c(rep("a",length(maxxy))),
                         Core_75_end=c(rep("a",length(maxxy))),
                         Core_75_contig=c(rep("a",length(maxxy))),
                         core_proportion=c(rep("a",length(maxxy))),
                         stringsAsFactors = F)
#all_all_data=read.csv("all_vs_all_distance_two_way_new1.csv")
all_all_data=read.csv(args[4])


# Reorder the factor


for(i in c(1:length(maxxy)))
{
  
  
  cluster=as.character(maxxy[i])
  
  results_frame$Mean_length[i]=round(mean(CNV_data$Length[group_data[which(group_data$group==cluster),1]]))+1
  results_frame$Median_start[i]=as.character(gff$V9[median(CNV_data$Start[group_data[which(group_data$group==cluster),1]])])
  results_frame$Median_end[i]=as.character(gff$V9[median(CNV_data$Ends[group_data[which(group_data$group==cluster),1]])])
  results_frame$mean_copy_number[i]=round(mean(CNV_data$Copy_number[group_data[which(group_data$group==cluster),1]]),2)
  # Median middle is more coplicated
  # Lets turn this into a basepair number
  # Also dont want to make an average from an average
  starts=CNV_data$Start[which(group_data$group==cluster)]
  ends=CNV_data$Ends[which(group_data$group==cluster)]
  middle=starts+round(c(ends-starts)/2)
  results_frame$Median_middle[i]=as.character(gff$V9[median(middle)])
  
  
  results_frame$Strains[i]=paste(as.character(CNV_data$Strains[which(group_data$group%in%cluster)]),collapse=",")
  # Lets create the start and end of the core genes. core= 80% of strains have it
  # Create a list of lists for each CNV class, unlist it,create a table, then see which genes are counted in c(0.8*frequency)
  temp_list=list()
  for(k in c(1:results_frame$Frequency[i]))
      {
    print(k)
    start_gff_row=CNV_data$Start[group_data[which(group_data$group==cluster),1]][k]
    end_gff_row=CNV_data$Ends[group_data[which(group_data$group==cluster),1]][k]
    temp_list[k]=list(start_gff_row:end_gff_row)
        # print(k)
    max_table=max(table(unlist(temp_list)))

    
  }
  core_75=as.numeric(names(table(unlist(temp_list))[which(as.numeric(table(unlist(temp_list)))>=c(round(0.9*max_table)))]))
  results_frame$Core_75_start[i]=as.character(gff$V9[min(core_75)])
  results_frame$Core_75_end[i]=as.character(gff$V9[max(core_75)])
  results_frame$Core_75_contig[i]=length(table(core_75[-1L]-core_75[1:c(length(core_75)-1)]))
  results_frame$core_proportion[i]=c(length(core_75)/results_frame$Mean_length[i])*100
  temp_list=list()
  
  
  
  # Need to figure out how to manipulate modualrity for each group?
  # results_frame$SD_of_overlap[i]=sd(unlist(all_all_data[all_all_data[,which(group_data$group==i)]>0]))
  print(i)

  
}


results_frame_ordered=results_frame[order(results_frame$Frequency,decreasing = T),]
write.csv(results_frame_ordered,"CNV_stats_extended_new.csv",row.names=F)

#A quick look into how many strains contain any duplication region
# yes=0
# for(i in c(1:ncol(new))){
#   
#   if(any(new[,i]>1))
#   {yes=yes+1}
# }


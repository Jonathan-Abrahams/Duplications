# 
args = commandArgs(trailingOnly=TRUE)

#CNV_data=read.csv("CNV_results_with_IS assocaition.csv")
CNV_data=read.csv(args[1])
#CNV_data=read.csv("all_CNVs.csv")
#colnames(CNV_data)=c("X","Starts","Ends")
#P_data=CNV_data[,c(3,4,5)]
P_data=CNV_data[,c(2,3)]
# We need to create a list of CNVs which uses overlaps of ranges of CNVs rather than starts and ends
library(IRanges)
#library(bedr)
ting_R=list()
temp_list=list()
count1=1
count2=1
all_all=matrix(ncol=nrow(P_data),nrow=nrow(P_data))
for(q in c(1:nrow(P_data))){
  # for(q in c(1:3))
  
{
  print(paste("q is:",q))
  # For every CNV
  for(k in c(1:nrow(P_data)))
    
  {
    temp_list[q]=list(c(0))
    
    # print(paste("K is : ",k))
    
    if(any(P_data[q,1]:P_data[q,2]%in%P_data[k,1]:P_data[k,2]))
    {
      
      AB=c(as.numeric(table(P_data[q,1]:P_data[q,2]%in%P_data[k,1]:P_data[k,2])['TRUE']))/length(P_data[q,1]:P_data[q,2])
      BA=as.numeric(table(P_data[k,1]:P_data[k,2]%in%P_data[q,1]:P_data[q,2])['TRUE'])/length(P_data[k,1]:P_data[k,2])
      all_all[q,k]=AB
      if(AB>=0.5&BA>=0.5&q!=k)
      {
        
        # print(paste("AB is:",AB))
        # print(paste("BA is:", BA))
        # all_all[q,k]=mean(AB,BA)
        # temp_list[[q]][count1]=k
        count1=count1+1
      }
      
      AB=0
      BA=0
    }
    # else{print(paste("q:",q,"doesnt match:",k,"Different"))}
    
  }
  count1=0
}
}
all_all[is.na(all_all)] <- 0
new_df=as.data.frame(all_all)
#write.csv(write.csv(all_all,"all_vs_all_distance_two_way_new1.csv",col.names=FALSE,row.names=FALSE))
write.csv(write.csv(all_all,args[2],col.names=FALSE,row.names=FALSE))

#full_data=data.frame(Start=first_vector,end=end_vector,Length=length_vector)
#write.csv(full_data,"Full_data_set_for_filtered_new_CNV1.csv",row.names=F)

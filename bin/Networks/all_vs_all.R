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

subset=c(481,541,748,755,840)
testy=P_data[subset,]
testy

comb = expand.grid(rownames(P_data), rownames(P_data))   # I fixed this line!
#scores = by(comb,list(comb$Var1,comb$Var2), funky(k))
#scores = by(comb,list(comb$Var1,comb$Var2), FUN=function(x) 
 # c(as.numeric(table(P_data[x$Var1,1]:P_data[x$Var1,2]%in%P_data[x$Var2,1]:P_data[x$Var2,2])['TRUE']))/length(P_data[x$Var1,1]:P_data[x$Var1,2]))

scores=by(comb,list(comb$Var1,comb$Var2), FUN=function(x)
  #print(P_data[x$Var1,1]:P_data[x$Var1,2]))
  c(as.numeric(table(P_data[as.numeric(as.character(x$Var1)),1]:P_data[as.numeric(as.character(x$Var1)),2]
                     %in%
                       P_data[as.numeric(as.character(x$Var2)),1]:P_data[as.numeric(as.character(x$Var2)),2])['TRUE']))/
    length(P_data[as.numeric(as.character(x$Var1)),1]:P_data[as.numeric(as.character(x$Var1)),2]))
  
x=comb[2,]


class(scores)="matrix"
scores[which(is.na(scores))]=0
scores




new_df=as.data.frame(scores)
#write.csv(write.csv(all_all,"all_vs_all_distance_two_way_new1.csv",col.names=FALSE,row.names=FALSE))
write.csv(write.csv(scores,args[2],col.names=FALSE,row.names=FALSE))

#full_data=data.frame(Start=first_vector,end=end_vector,Length=length_vector)
#write.csv(full_data,"Full_data_set_for_filtered_new_CNV1.csv",row.names=F)

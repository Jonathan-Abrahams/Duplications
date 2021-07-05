library(IRanges) 

args = commandArgs(trailingOnly=TRUE)

CNV_data=read.csv(args[1])
P_data=CNV_data[,c(2,3)]
ting_R=list()
temp_list=list()
count1=1
count2=1
all_all=matrix(ncol=nrow(P_data),nrow=nrow(P_data))

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
write.csv(write.csv(scores,args[2],col.names=FALSE,row.names=FALSE))



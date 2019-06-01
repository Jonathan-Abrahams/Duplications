#Extract CNVs
args = commandArgs(trailingOnly=TRUE)
#data=read.csv("all_data.csv",stringsAsFactors = F,header=T)

data=read.csv(args[1],stringsAsFactors = F,header=T)

data=data[,-1]
length_L=list()


real_list=list()
copy_number=list()
copy_result=list()
lenny_l=vector()
start_list=list()
start_temp=list()
end_temp=list()
end_list=list()
temp_col=list()
col_list=vector()
count=1
for(i in c(1:ncol(data)))
{#find the breakpoints
  #print(i)
  diffs <- data[,i][-1L] != data[,i][-length(data[,i])]
  idx <- c(which(diffs), length(data[,i]))
  # Starts is the gene precding the start of CNV so do a +1
  starts=idx[as.logical(c(1:length(idx)%%2))]
  ends=idx[!as.logical(c(1:length(idx)%%2))]
  starts=starts+1
  # Remove the final gene as a possible start
  if(is.na(table(starts%in%c(nrow(data)+1))['TRUE'])!='TRUE')
  {
    starts=starts[-which(starts%in%c(nrow(data)+1))]
  }
  
  
  
  # 
  interval=ends-starts
  # Which starts are 
  duppy_start=starts[which(data[starts,i]>=1.1)]
  if(length(duppy_start)>0)
  {
    intervals=interval[which(starts%in%duppy_start)]
    Column_list=list()
    for(k in c(1:length(duppy_start)))
    {
      Column_list[k]=list(duppy_start[k]:c(duppy_start[k]+intervals[k]))
      copy_number[k]=mean(data[,i][unlist(Column_list[k])])
      start_temp[k]=duppy_start[k]
      end_temp[k]=duppy_start[k]+intervals[k]
      col_list[count]=i
      count=count+1
      
    }
    real_list[i]=list(Column_list)
    copy_result[i]=list(copy_number)
    start_list[i]=list(start_temp)
    end_list[i]=list(end_temp)
    copy_number=list()
    Column_list=list()
    start_temp=list()
    end_temp=list()
    lenny_l[i]=length(real_list[[i]])
    
  }
  
  
}

result_frame=data.frame(Starts=unlist(start_list),Ends=unlist(end_list),
                        Length=c(unlist(end_list)-unlist(start_list)),
                        Copy_number=unlist(copy_result),Strains=colnames(data)[col_list])
write.csv(result_frame,args[2])
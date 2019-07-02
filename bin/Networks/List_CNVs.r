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
{
  #find the breakpoints

  diffs <- data[,i][-1L] != data[,i][-length(data[,i])]
  idx <- c(1,which(diffs), length(data[,i]))
  count=1
  
  copy_number=vector()
  start_temp=vector()
  end_temp=vector()
  col_list=vector()
        for(k in c(1:c(length(idx)-1)))
        {
          #First is +1 OUTSIDE of brackets, second is +1 inside brackets
          intervals=c(idx[k]+1):idx[k+1]
          if(as.numeric(names(table(data[intervals,i])[1]))>1)
          {
                      
          #Column_list[k]=list(idx[k]:idx[k+1])
          copy_number[count]=mean(data[intervals,i])
          start_temp[count]=idx[k]+1
          end_temp[count]=idx[k+1]
          col_list[count]=i
          count=count+1

          }
        }
  
        real_list[i]=list(col_list)
        copy_result[i]=list(copy_number)
        start_list[i]=list(start_temp)
        end_list[i]=list(end_temp)
        copy_number=list()
       # Column_list=list()
        start_temp=list()
        end_temp=list()
        #lenny_l[i]=length(real_list[[i]])
    
    }
  

 

result_frame=data.frame(Starts=unlist(start_list),Ends=unlist(end_list),
                        Length=c(unlist(end_list)-unlist(start_list)),
                        Copy_number=unlist(copy_result),Strains=colnames(data)[unlist(real_list)])
write.csv(result_frame,args[2])

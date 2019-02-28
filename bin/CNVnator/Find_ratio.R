# Lets create a script that quickly screens for the ratio of the average RD signal to the standard deviation

library(zoo)
args = commandArgs(trailingOnly=TRUE)





depth=read.delim(args[1],header=F)
k=100
sites=sample(c(1:nrow(depth)),k)

#windows 100:1000
windows=c(100,200,300,400,500,600,700,800,900,1000)
results_frame=data.frame(windows,Mean=c(1:length(windows)),SD=c(1:length(windows)))

temp_v=vector()
temp_2=vector()
sites_v=vector()
for( i in c(1:length(windows)))
{
  min_start=1
  max_end=nrow(depth)-c(windows[i]*100)
print(i)
  # For every window size:
  for(q in c(1:k))
  {
    

    sites=sample(c(min_start:max_end),1)
    sites_v[q]=sites
    # For every location in every window size:
    length=windows[i]*100
    rolly=rollapply(depth$V3[c(sites:c(sites+length))],windows[i],mean,by=windows[i])
    temp_v[q]=mean(rolly)
    temp_2[q]=sd(rolly)
  }
results_frame$Mean[i]=mean(temp_v)
results_frame$SD[i]=mean(temp_2)

}
results_frame$Ratio=results_frame$Mean/results_frame$SD


write.table(results_frame,paste(args[1],".table_full.txt",sep=""),quote=F,row.names=F,col.names=T)
top_hit=which(abs(results_frame$Ratio-4.5)%in%min(abs(results_frame$Ratio-4.5)))
write.table(results_frame[top_hit,c(1,4)],paste(args[1],".table_top_hit.txt",sep=""),quote=F,row.names=F,col.names=T)

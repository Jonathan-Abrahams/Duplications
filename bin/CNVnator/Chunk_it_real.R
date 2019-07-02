library(dplyr)

Vanilla_mean_paste=function(Window_start,Window_size,Depth_file)
{
  Depth_ting=Depth_file[c(Window_start:c(Window_start+Window_size)),3]
  #Provides a mean for a single window
  meany=mean(Depth_ting)
  
  #also gives SD

  
  return(meany)
}


Create_window_from_chunk=function(Chunk_of_depth,Start_position,Window_size)
  {
  #take the start of window and take all the depths out
  
  return(Chunk_of_depth[Start_position:c(Start_position+Window_size)])
  
}
Vanilla_ratio_chunk_new=function(Chunk_of_depth,Window_size)
{
  #Given a chunk of depth,a vector of windows get the mean and sd of those tings
  #create the windows
  Number_of_windows=floor(length(Chunk_of_depth)/c(Window_size))
  windows=seq(1,Number_of_windows*Window_size,Window_size)
  windows_full=lapply(windows,Create_window_from_chunk,Chunk_of_depth=Chunk_of_depth,Window_size=Window_size)
  results=lapply(windows_full,mean)
  Mean_of_chunk=mean(unlist(results))
  SD_of_chunk=sd(unlist(results))
  return(data.frame(Mean=Mean_of_chunk,SD=SD_of_chunk))
}


Full_command=function(Window_size,Depth_file_chunks, Depth_file)
{
  count=1
  Results_list=list()
  for(i in c(1:c(length(Depth_file_chunks)-1)))
  {
    #print(i)
    Depth_chunk=Depth_file[c(Depth_file_chunks[i]: Depth_file_chunks[i+1]),3]
    Results_list[count]=list(Vanilla_ratio_chunk_new(Chunk_of_depth = Depth_chunk,Window_size = Window_size))
    
    count=count+1
  }
  
  return(Results_list)
}
args = commandArgs(trailingOnly=TRUE)

#args[1]="SRR5858782.depth"
file=paste(args[1],sep="")
depth=read.delim(file,header=F)
delly=which(depth$V3>0)
depth=depth[delly,]
Depth_file_chunks=seq(1,nrow(depth),10000)






window=seq(500,1001,100)
ratio_v=vector()
for(i in c(1:length(window)))
{
  kek=Full_command(window[i],Depth_file_chunks,depth)
  print(i)
  all_results=bind_rows(kek)
  all_results$Ratio=all_results$Mean/all_results$SD 
  
  
  ratio_v[i]=mean(all_results$Ratio)
  
}

final_data=data.frame(Windows=window,Ratio=ratio_v)

outdir=dirname(args[1])
write.table(final_data,paste(outdir,"/","CNVnator_window_table_full.txt",sep=""),quote=F,row.names=F,col.names=T)
top_hit=which(abs(final_data$Ratio-4.5)%in%min(abs(final_data$Ratio-4.5)))

write.table(final_data[top_hit,],paste(outdir,"/","CNVnator_window_table_top_hit.txt",sep=""),quote=F,row.names=F,col.names=T)

# All vs all network analysis with community too
library(tidyr)

args = commandArgs(trailingOnly=TRUE)

data1=read.csv(args[1])
CNV_data=read.csv(args[2])
library("igraph") 



g  <- graph.adjacency(as.matrix(data1), weighted=T,mode="undirected",diag=F)
clp2=cluster_fast_greedy(g)
pol= fastgreedy.community(g)
l <- layout_with_fr(g)



 library(RColorBrewer)
 result_frame=data.frame(CNV_number=c(1:nrow(data1)),group=clp2$membership)
write.csv(result_frame,"CNV_membership.csv",row.names=F)


# Lets see if we can plot each network seperately.
testy_vector=vector()

over_3=which(as.numeric(table(clp2$membership))>=3)
for(i in (c(1:length(over_3))))
{
  ones=which(clp2$membership==over_3[i])
  
  ones_data=data1[ones,ones]
  
  g_1  <- graph.adjacency(as.matrix(ones_data), weighted=T,mode="undirected",diag=F)
  clp2_1=cluster_fast_greedy(g_1)
  pol_1= fastgreedy.community(g_1)
  l_1 <- layout_with_fr(g_1)
   jpeg(paste("Network_",i,".jpg",sep=""), units="in", width=5, height=5, res=300)

   plot(g_1,layout=l_1,vertex.size=10,curved=0,edge.width=1.5,vertex.label=NA)

    dev.off()
}


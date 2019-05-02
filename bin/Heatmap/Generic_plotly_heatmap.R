library(plotly)
args = commandArgs(trailingOnly=TRUE)


#args[1]="all_overlap.txt"

all_data=read.delim(args[1],stringsAsFactors = F,header=T)
print("All data has been read")
inf_vector=vector()
big_vector=vector()
count=1
for( k in c(1:ncol(all_data)))
{
  if(sum(is.infinite(all_data[,k]))>0|any(all_data[,k]>=20))
  {
    inf_vector[count]=k
    count=count+1
  }


}
print(inf_vector)
all_data_f=all_data[,!c(1:ncol(all_data)%in%inf_vector)]
new_dist=dist(t(all_data_f[,2:ncol(all_data_f)]))
print("All data trasnposed")
clusty=hclust(new_dist)

#Create a genes column

Genes=c(1:nrow(all_data_f))
all_data_f=all_data_f[,2:ncol(all_data_f)][,clusty$order]
all_data_f$Genes=Genes
all_data_f=all_data_f[,c(ncol(all_data_f),c(2:ncol(all_data_f))-1)]
#
write.csv(all_data_f,"all_data.csv",row.names=F)
Sys.setenv("plotly_username"="kows1337676")
Sys.setenv("plotly_api_key"="0bkpedSpmrU56nSyWXj9")


print(" Plotting data....")
p <- plot_ly(x=colnames(all_data_f[2:ncol(all_data_f)]),z = as.matrix(all_data_f[,2:ncol(all_data_f)]),y=all_data_f$Genes, type = "heatmap")

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started

#htmlwidgets::saveWidget(as_widget(p), "graph.html")
chart_link = api_create(p, filename=args[2])
chart_link

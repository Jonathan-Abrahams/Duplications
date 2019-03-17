library(plotly)
args = commandArgs(trailingOnly=TRUE)


#args[1]="all_overlap.txt"

all_data=read.delim(args[1],stringsAsFactors = F,header=T)
print("All data has been read")
new_dist=dist(t(all_data[,2:ncol(all_data)]))
print("All data trasnposed")
clusty=hclust(new_dist)

#Create a genes column

Genes=c(1:nrow(all_data))
all_data=all_data[,2:ncol(all_data)][,clusty$order]
all_data$Genes=Genes
all_data=all_data[,c(ncol(all_data),c(2:ncol(all_data))-1)]
#
write.csv(all_data,"all_data.csv",row.names=F)
Sys.setenv("plotly_username"="kows1337676")
Sys.setenv("plotly_api_key"="0bkpedSpmrU56nSyWXj9")


print(" Plotting data....")
p <- plot_ly(x=colnames(all_data[2:ncol(all_data)]),z = as.matrix(all_data[,2:ncol(all_data)]),y=all_data$Genes, type = "heatmap")

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started

htmlwidgets::saveWidget(as_widget(p), "graph.html")
chart_link = api_create(p, filename=args[2])
chart_link

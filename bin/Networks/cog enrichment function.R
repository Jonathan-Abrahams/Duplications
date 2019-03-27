#Cog enrichment functions
#FUNCTION 1: PROCESS DATA
######
library(stringr)
args = commandArgs(trailingOnly=TRUE)

#Mapped_gff1 = read.delim("TB.gff", header = F)
Mapped_gff1 = read.delim(args[1], header = F)


#CDS1 = read.delim("GCF_000007785.1_ASM778v1_genomic (1).gff",comment.char = "#",header = F,stringsAsFactors = F)
CDS1 = read.delim(args[2],comment.char = "#",header = F,stringsAsFactors = F)

CDS1 = CDS1[which(CDS1$V3 == "CDS"), ]


#Get ontologies from EGGNOGG

#Ontologies1 = read.delim("GCF_000195955.2_ASM19595v2_protein.faa.emapper.annotations",header = F,stringsAsFactors = F)
Ontologies1 = read.delim(args[3],header = F,stringsAsFactors = F)


# CDS=CDS1
# Ontologies=Ontologies1
# Mapped_gff=Mapped_gff1


Attach_COGs = function(CDS, Ontologies, Mapped_gff)
{
  hit_vector = vector()
  for (i in c(1:nrow(Ontologies))) {
    #print(i)
    
    hit_vector[i] = grep(Ontologies$V1[i], CDS$V9)
    
    
  }
  CDS$Gene = "None"
  for (i in c(1:nrow(CDS)))
  {
    tempy = str_extract(CDS$V9[i], "Parent=gene[0-9]*")
    tempy = strsplit(tempy, "Parent=gene")[[1]][2]
    CDS$Gene[i] = tempy
  }
  names(hit_vector) = c(1:length(hit_vector))
  CDS$NP_tag = "No_Ont"
  CDS$NP_tag[hit_vector] = Ontologies$V1
  CDS$COG = "No_ont"
  CDS$COG[hit_vector] = Ontologies$V12
  return(CDS)
}

######
#FUNCTION 2: TEST FOR ENRICHMENT from core genes
CDS_new_ting = Attach_COGs(CDS1, Ontologies = Ontologies1, Mapped_gff = Mapped_gff1)
CNV_stats = read.csv("./Ecoc/CNV_stats_extended_new.csv", stringsAsFactors = F)


Target_CNV = which(Mapped_gff1$V9 %in% CNV_stats$Core_75_start[29]):which(Mapped_gff1$V9 %in%
                                                                            CNV_stats$Core_75_end[29])
kek = CDS_new_ting$COG[which(CDS_new_ting$Gene %in% c(
  which(Mapped_gff1$V9 %in% CNV_stats$Core_75_start[29]):which(Mapped_gff1$V9 %in%
                                                                 CNV_stats$Core_75_end[29])
))]
Cog_category = "Q"
new_ting1 = matrix(c(2, 11, 171, 3735),
                   nrow = 2,
                   dimnames = list(
                     COG = c("COG:Q", "COG:Other"),
                     Duplication = c("COG:Q", "COG:Other")
                   ))


#FUNCTION 2: TEST FOR ENRICHMENT from core genes
#Input: Start_of_core_genes,End_of_core_genes,CDS,COG
# CDS=Mapped_gff1
# target_cog="Q"
# vector_of_core_genes=Target_CNV
Test_enrichment = function(vector_of_core_genes, CDS, target_COG)
{
  #Get cogs of vector:
  CDS$COG[which(CDS$Gene %in% Target_CNV)]
  COG_in_core = length(which(CDS$COG[which(CDS$Gene %in% vector_of_core_genes)] %in%
                               target_COG))
  rest_in_core = length(vector_of_core_genes) - COG_in_core
  COG_in_genome = length(which(CDS$COG %in% target_COG)) - COG_in_core
  rest_in_genome = nrow(CDS) - COG_in_genome
  new_ting1 = matrix(
    c(COG_in_core, rest_in_core, COG_in_genome, rest_in_genome),
    nrow = 2,
    dimnames = list(
      COG = c("COG:Q", "COG:Other"),
      Duplication = c("COG:Q", "COG:Other")
    )
  )
  tingting = fisher.test(new_ting1, alternative = "greater")
  return(tingting$p.value)
  
}
CNV_stats$Top_COG="NA"
CNV_stats$COG_P_value=1
CNV_stats$Cog_frequency=0

for(i in c(1:nrow(CNV_stats)))
{
  Target_CNV = which(Mapped_gff1$V9 %in% CNV_stats$Core_75_start[i]):which(Mapped_gff1$V9 %in%CNV_stats$Core_75_end[i])
  COGS_of_dup=names(table(CDS_new_ting$COG[which(CDS_new_ting$Gene %in% Target_CNV)]))
  if(!is.null(COGS_of_dup))
  {
    list_of_enrichments=lapply(COGS_of_dup,Test_enrichment,vector_of_core_genes=Target_CNV,CDS=CDS_new_ting)
    enriched=COGS_of_dup[which(list_of_enrichments%in%min(unlist(list_of_enrichments)))]
    print(paste(i,enriched,":",min(unlist(list_of_enrichments))))
    CNV_stats$Top_COG[i]=enriched
    CNV_stats$COG_P_value[i]=min(unlist(list_of_enrichments))
    CNV_stats$Cog_frequency=as.numeric(table(COGS_of_dup)[which(names(table(COGS_of_dup))%in%CNV_stats$Top_COG[i])])
  }
  
}
write.csv(CNV_stats,"CNV_stats_cogs.csv")

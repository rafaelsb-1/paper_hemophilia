#Load libraries for analysis 
library(ggtree)
library(ape)
require(phangorn)
require(scales)
require(ggplot2)

#Load tree file 
nwk <- "/Users/rafaeldossantosbezerra/Desktop/paper/paper.tree"
tree <- read.nexus(nwk)

#Root at mid-point
y<-midpoint(tree)

#Load your metadata with tip information
metadata <- read.csv("paper_annotations.csv", sep = ";")

#Plot the tree
p<- ggtree(y) %<+% metadata + 
  geom_tippoint(aes(color=Sample), size=2, alpha=.75) +
  scale_color_manual(values =c ("red")) + 
  theme_tree(legend.position='left') 

#Load your metadata with genotype information
Heatmap_metadata <- read.csv("heatmap.csv", sep = ";")

#Verify if there are some duplicated data
h2 <- Heatmap_metadata[!duplicated(Heatmap_metadata[,c('Name')]),]

#pass the first column to rownames
samp2 <- as.data.frame(h2[,-1])
rownames(samp2) <- h2[,1]

#remove information not needed
samp2$Species <- NULL
samp2$Strain <- NULL
samp2$Gene <- NULL

#Add the heatmap with genotype and save the image
png(file="paper1.png",width=15, height=15, units="in", res=500)
gheatmap(p, samp2, offset=.01, width=.1, font.size=0, colnames_angle=-45, hjust=1) +
  scale_fill_hue()
dev.off()

#Load the Kraken2 output with some modifications
data <- read.table("kraken_out.tsv", sep = "\t")

#Plot the barplot with abundances
png(file="paper2.png",width=15, height=9, units="in", res=500)
ggplot(data, aes(x=Reads, y=Groups, fill=Species)) +
  geom_bar(stat="identity")+
  theme_minimal() 
dev.off()



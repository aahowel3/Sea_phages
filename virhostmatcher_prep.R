library(taxonomizr)
#setwd("C:/Users/Owner/OneDrive - Arizona State University/Documents/SEA-Phages/")

hosts=read.csv("HostAccession_BB.csv")
host_list=apply(hosts,1,as.vector)

#if your entries include the .X part need to remove version=base
#taxaId<-accessionToTaxa(host_list,"accessionTaxa.sql", version='base')
taxaId<-accessionToTaxa(host_list,"accessionTaxa.sql")
output=getTaxonomy(taxaId,'accessionTaxa.sql')

#jk easier to export as a csv, add the NCBIname and name column and then convert to txt
#NOT TH*IS ONE
###write.csv(output, "hostTaxa.txt")

write.table(output, "hostTaxa_BB_withamicalis.txt", sep="\t", quote=FALSE)

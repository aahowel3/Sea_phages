#cross-referencing for virhostmatcher and PH databases
setwd("C:/Users/Owner/OneDrive - Arizona State University/Documents/SEA-PHAGES JC/")

data=read.csv("../gordoniaphages_ncbi_availableassemblies2.csv")


PHP=read.csv("../60105NCBITaxonomyID",sep="\t",header = FALSE)
VHMN=read.csv("../hostTaxa_VHMN.csv")
data$minusver <- gsub("\\..*", "", data$ID)

data$PHP=ifelse(data$minusver %in% PHP$V1, 1, 0)
data$VHMN=ifelse(data$ID %in% VHMN$X, 1, 0)


data2=data[!apply(data[, 4:5]==0, 1, all),]
write.csv(data2,"gordoniaphages_ncbi_availableassemblies_curated.csv")




#filtering PHP dataset results:
setwd("C:/Users/Owner/OneDrive - Arizona State University/Documents/hostrange/")
data=read.csv("hostKmer_60105_kmer4.tar.gz_Prediction_Allhost_mini.csv",sep=",",header=FALSE)
data=as.data.frame((t(data)))
data = data[-1,]
data=data[as.numeric(data$V2) >= 1119,]
data$class=ifelse(data$V2 < 1464, "low", "high")
data <- data[order(-as.numeric(data$V2)),]



data$V1=round(as.numeric(data$V1), digits = 0)


data2=read.csv("60105Taxonomy",sep="\t",header=FALSE)

data$PHP=ifelse(data$V1 %in% data2$V2, data2$V9, 0)

data$PHP=data2$V9[match(data$V1, data2$V2)]

write.csv(data,"out.csv")

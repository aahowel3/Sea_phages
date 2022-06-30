##Stacked bar chart BB hosts HostPhinder 
setwd("C:/Users/Owner/OneDrive - Arizona State University/Documents/SEA-Phages/")

library(ggplot2)
data=read.csv("BB_hostphindercolors_onlyDandPphages_wetlab.csv",sep=",")
  ggplot(data, aes(fill=Confidence, y=Number.of.Hosts, x=ï..Phage)) + 
  geom_bar(stat="identity") +
    ggtitle("HostPhinder Host Range Predictions") +
    theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1)) + 
   scale_fill_manual(name="Confidence",labels = c("high", "moderate", "low","wetlab"),values = c("Dark Green","Green","Gray", "Blue")) +
    labs(x = NULL, y = "Number of Predicted Hosts") +
    guides(fill = guide_legend(title = "Prediction Confidence")) 
  

#converting dataframe of DE genes into format for upsetR
#compare ranges of PHP, VirHostMatcherNet, wetlab
#BB_hostphinderresultsONLY_upsetR_DandPonly
#onlyDandPwetlab
within=read.table("onlyDandP_wetlab.csv",sep=",",header=TRUE,stringsAsFactors=T)
#drop column29
#within = subset(within, select=-c(N029))

#ended up keeing 29 easier to just drop genes where totla is less than 1 - then its unique to that family dont care 
save=do.call(rbind,lapply(within, function(x) table(factor(x, levels=c(levels(unlist(within)))))))
#quick manual edits remoe col V1 
#remove the column with the empty counts
#name the first column with Names 
#write.csv(save, file="onlyDandPwetlab_formatted.csv")

#YOU MANUALLY WENT IN HERE AND CLEANED UP THE EMPTY COLUMN AND REMOVED SPACES
library(UpSetR)
library(dplyr)
within=read.csv("BB_hostphinderresults_upsetR_formatted_onlyDandPphages.csv",sep=",",header=TRUE,stringsAsFactors=T)

dat= as.data.frame(x = t(within), stringsAsFactors = FALSE)
names(dat) <- dat[1,]
dat <- dat[-1,]

dat=as.data.frame(dat)
df2 <- mutate_all(dat, function(x) as.numeric(as.character(x)))

upset(df2,nsets=39,mb.ratio = c(0.40, 0.60),    
      text.scale = c(1.3, 1.3, 1, 1, 2, 2))

library(grid)
grid.text("Range Prediction Overlap of HostPhinder",x = 0.65, y=0.95, gp=gpar(fontsize=16))

# Written by: Cyril Joseph Versoza
# Date: May 6, 2022

# This script is for plotting the Phirbo results with the added variable to identify which host was experimentall validated.

# Load libraries.
library(reshape)
library(ggplot2)
library(viridis)
library(plyr)
library(scales)
library(dplyr)
library(RColorBrewer)

# Load new dataframe.
setwd("C:/Users/Owner/OneDrive - Arizona State University/Documents/hostrange/WISH/")

#this one you dont need to write out and redo just write shape column to it directly
paper.wish.dat <- read.csv("kfs-ec3_wish_prediction.list",sep="\t")
paper.wish.dat <- read.csv("hy01_wish_prediction.list",sep="\t")
paper.wish.dat <- read.csv("sfp10_wish_prediction.list",sep="\t")


colnames(paper.wish.dat) <- c("X","variable","LogLikelihood","pvalue","shape")

#paper.wish.dat <- read.csv("wish_gordonia_paper.shape.csv",sep=",")
#colnames(paper.wish.dat) <- c("X","variable","LogLikelihood","pvalue","shape")
# Rescale values.
paper.wish.shape.dat <- ddply(paper.wish.dat, .(X), transform, rescale = rescale(LogLikelihood))
paper.wish.shape.dat <- ddply(paper.wish.dat, .(variable), transform, rescale2 = rescale(LogLikelihood))


# Plot.
ggplot(paper.wish.shape.dat, aes(X, variable)) +
  geom_point(aes(color = LogLikelihood, shape = shape), size = 15) +
  #scale_shape_identity() +
  scale_color_viridis(option = "viridis", name = "log likelihood") +
  theme(axis.text = element_text(face="bold"), # make the axis labels bold to make it more readable
        axis.text.x = element_text(angle = 45, hjust = 1), # make the x-axis labels vertical for readability
        axis.title.x = element_blank(), # next two lines are to remove axis titles
        axis.title.y = element_blank(),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        legend.key = element_blank()) +
  scale_continuous_identity(aesthetics = 'shape',
                            guide = 'legend',
                            breaks = c(15.75,16.00),
                            labels = c("no","yes"),
                            name = "experimentally validated host?")

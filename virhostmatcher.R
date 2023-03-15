# Written by: Cyril Versoza
# Date: May 17, 2022

# This script is for plotting the VirHostMatcher results with the added variable to identify which host was experimentally validated.

# Load libraries.
library(reshape)
library(ggplot2)
library(viridis)
library(plyr)
library(scales)
library(dplyr)
library(RColorBrewer)


setwd("C:/Users/Owner/OneDrive - Arizona State University/Documents/hostrange/WISH/")
paper.vhm.dat <- read.csv("hy01_vhm_d2_k6.csv",sep=",")
paper.vhm.dat <- read.csv("sfp10_vhm_d2_k6.csv",sep=",")

# Melt the data into long format.
paper.vhm.melt.dat <- melt(paper.vhm.dat)

# Save paper.vhm.melt.dat as a CSV for editing.
write.csv(paper.vhm.melt.dat,"virhostmatcher_gordonia_paper.melted.csv", row.names = FALSE)
write.csv(paper.vhm.melt.dat,"hy01_virhostmatcher_gordonia_paper.melted.csv", row.names = FALSE)
write.csv(paper.vhm.melt.dat,"sfp10_virhostmatcher_gordonia_paper.melted.csv", row.names = FALSE)


# Load new CSV file.
paper.vhm.shape.dat <- read.csv("virhostmatcher_gordonia_paper.melted.csv",sep=",")
paper.vhm.shape.dat <- read.csv("hy01_virhostmatcher_gordonia_paper.melted.csv",sep=",")
paper.vhm.shape.dat <- read.csv("sfp10_virhostmatcher_gordonia_paper.melted.csv",sep=",")

colnames(paper.vhm.shape.dat) <- c("X","variable","value","shape")

# Rescale values.
paper.vhm.shape.dat <- ddply(paper.vhm.shape.dat, .(X), transform, rescale = rescale(value))
paper.vhm.shape.dat <- ddply(paper.vhm.shape.dat, .(variable), transform, rescale2 = rescale(value))


# Plot.
ggplot(paper.vhm.shape.dat, aes(X, variable)) +
  geom_point(aes(color = value, shape = shape), size = 15) +
  scale_shape_identity() +
  scale_color_viridis(option = "viridis", name = "dissimilarity") + # nice color scheme!
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

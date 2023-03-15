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

# Read in the data.
setwd("C:/Users/Owner/OneDrive - Arizona State University/Documents/hostrange/WISH/")

paper.dat <- read.csv("predictions.csv.matrix.csv", header = TRUE)
paper.dat <- read.csv("hy01_phirbo_predictions.csv.matrix.csv", header = TRUE)
paper.dat <- read.csv("sfp10_phirbo_predictions.csv.matrix.csv", header = TRUE)


# Melt the data into long format.
paper.melt.dat <- melt(paper.dat)
# Rescale the values based on the "variable" i.e., the phage
paper.melt.dat <- ddply(paper.melt.dat, .(variable), transform, rescale = rescale(value))

# Switch X and variable columns.
paper.melt.dat <- paper.melt.dat[c("variable","X","value","rescale")]

# Rename the columns.
colnames(paper.melt.dat) <- c("X","variable","value","rescale")


# Save paper.melt.dat as a CSV for editing.
#write.csv(paper.melt.dat,"phirbo_gordonia_paper.list.matrix.melted.csv", row.names = FALSE)
#write.csv(paper.melt.dat,"hy01_phirbo_gordonia_paper.list.matrix.melted.csv", row.names = FALSE)
write.csv(paper.melt.dat,"sfp10_phirbo_gordonia_paper.list.matrix.melted.csv", row.names = FALSE)

# Load new dataframe.
paper.melt.shape.dat <- read.csv("sfp10_phirbo_gordonia_paper.list.matrix.melted.csv")

# Rescale based on host.
paper.melt.shape.dat <- ddply(paper.melt.shape.dat, .(variable), transform, rescale2 = rescale(value))

# Plot.
ggplot(paper.melt.shape.dat, aes(X, variable)) +
  geom_point(aes(color = rescale, shape = shape), size = 15) +
  scale_color_viridis(option = "viridis", name = "RBO score") + # nice color scheme!
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

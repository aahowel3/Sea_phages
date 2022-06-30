setwd("C:/Users/Owner/OneDrive - Arizona State University/Documents/")

virhostmatcher=read.csv("virhostmatcher_gordonia_paper.melted.shape.csv")
phirbo=read.csv("phirbo_gordonia_paper.list.matrix.melted.csv")
wish=read.csv("wish_gordonia_paper.shape.pvalue.csv")

library(dplyr)
virhostmatcher <- virhostmatcher %>%
  mutate(category = case_when(value < 0.175 & shape == 16 ~ 'TP',
                              value < 0.175 & shape == 15 ~ 'FP',
                              value > 0.175 & shape == 15 ~ 'TN',
                              value > 0.175 & shape == 16 ~ 'FN'))

phirbo <- phirbo %>%
  mutate(category = case_when(value > 0.2 & shape == 16 ~ 'TP',
                              value > 0.2 & shape == 15 ~ 'FP',
                              value < 0.2 & shape == 15 ~ 'TN',
                              value < 0.2 & shape == 16 ~ 'FN'))

wish <- wish %>%
  mutate(category = case_when(p.value.if.null.parameters.provided < 0.06 & shape == 16 ~ 'TP',
                              p.value.if.null.parameters.provided < 0.06 & shape == 15 ~ 'FP',
                              p.value.if.null.parameters.provided > 0.06 & shape == 15 ~ 'TN',
                              p.value.if.null.parameters.provided > 0.06 & shape == 16 ~ 'FN'))

#calculate sensitivity and specificity for each tool 
table(virhostmatcher$category)
table(phirbo$category)
table(wish$category)


library(stringr)
library(ComplexHeatmap)
set1 <- str_c(virhostmatcher$X,"_", virhostmatcher$variable,"_type_",virhostmatcher$category)
set2 <- str_c(phirbo$variable,"_", phirbo$X,"_type_",phirbo$category)
set3 <- str_c(wish$Phage,"_", wish$Best.hit.among.provided.hosts,"_type_",wish$category)

lt=list(set1,set2,set3)
set_matrix=list_to_matrix(lt)
qwerty=as.data.frame(set_matrix)
library(tibble)
qwerty <- tibble::rownames_to_column(qwerty, "VALUE")
library(dplyr)
library(tidyr)
qwerty = qwerty %>%
  separate(VALUE, c("foo", "bar"), "_type_")

colnames(qwerty) = c("virus-host interaction","Accuracy","VirHostMatcher","Phirbo","WIsH")
interactions = colnames(qwerty)[3:5]
library(ComplexUpset)
library(ggplot2)
upset(
  qwerty,
  interactions,
  name='Confirmatory Tools',
  set_sizes=FALSE,
  base_annotations=list(
    'Intersection size'=intersection_size(
      counts=FALSE,
      mapping=aes(fill=Accuracy)
    )
  ),
  width_ratio=0.1 
)


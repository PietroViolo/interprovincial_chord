#---------------------------------------------------------------------------#
# Nom : interprovincial_chord_script.R                        			        #
# Description : Tracks interprovincial migration through a chord plot       #
# Auteur: Pietro Violo                                                      #
# Date : 28 mai 2022                                                        #
# Modifications :                                                           #
#---------------------------------------------------------------------------#

rm(list=ls(all=TRUE))

# remove scientific notation
options(scipen=999)

#'* Libraries *

library(tidyverse)
library(viridis)
library(circlize)



#'* Data import and data wrangling *

# Import data from Statistics Canada
df <- read.csv("1710002201-eng.csv")

# Column to rownames
df <- df %>% mutate(Geography..province.of.destination = str_remove(Geography..province.of.destination, ", province of origin 6"),
                    Geography..province.of.destination = str_remove(Geography..province.of.destination, ", province of origin 5"))

colnames(df) <- c("destination", df %>% pull(Geography..province.of.destination) %>% unique())

# transform column to rownames

df <- df %>% column_to_rownames("destination")

# to matrix

df_mat <- as.matrix(df)

# remove territories
df_mat <- df_mat[1:10, 1:10]


#'*Plot*

colorpalette <- c("darkorchid4", "darkturquoise", "aquamarine4", "gold", "blue2", "red", "tan4", "forestgreen", "black", "orange2" )


chordDiagram(df_mat,
             grid.col = colorpalette,
             directional = 1,
             direction.type = c("arrows", "diffHeight"), 
             diffHeight  = -0.04, 
             annotationTrackHeight = c(0.05, 0.1),
             link.arr.type = "big.arrow", 
             link.sort = TRUE, 
             link.largest.ontop = TRUE)
title("Estimates of interprovincial migrants by province of origin and destination, 2020-2021")


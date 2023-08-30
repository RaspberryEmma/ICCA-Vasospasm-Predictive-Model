# ICCA Database Project
# Importing Data from File
# This document demonstrates importing pre-processed CSV data into R
# Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
# 28-08-2023

library(tidyverse)

pt.bp      <- read.csv("../Data/ConstructPtBloodPressure.csv")
pt.details <- read.csv("../Data/ConstructPtDetails.csv")
pt.hr      <- read.csv("../Data/ConstructPtHeartRate.csv")
pt.meds    <- read.csv("../Data/ConstructPtMedication.csv")
pt.vaso    <- read.csv("../Data/ConstructPtVasospasm.csv")

pt.bp      %>% head() %>% View()



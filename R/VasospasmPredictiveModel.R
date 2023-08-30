# ICCA Database Project
# Building Predictive Model for Vasospasm
# This document demonstrates using previously constructed data summary to form our predictive model
# Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
# 30-08-2023



# ----- Preamble -----
rm(list = ls())
library(tidyverse)



# ----- Importing Data -----

pt.data <- read.csv("../Data/PtDataSummary.csv")
pt.data <- (pt.data %>% drop_na())
#pt.data <- pt.data[, 1:5]

set.seed(2023)
sample <- sample(c(1, 0), nrow(pt.data), replace = TRUE, prob = c(0.8, 0.2))
pt.data.train <- pt.data[sample,  ]
pt.data.test  <- pt.data[!sample, ]



# ----- Building Model ----

vaso.model <- glm(y ~ ., data = pt.data, family = "binomial")
vaso.model
summary(vaso.model)




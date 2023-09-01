# ICCA Database Project
# Building More Flexible Binary GLM Predictive Model for Vasospasm
# This document demonstrates using previously constructed data summary to form our predictive model
# Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
# 01-09-2023



# ----- Preamble -----
rm(list = ls())
library(tidyverse)
library(varhandle)



# ----- Importing Data -----

pt.data    <- read.csv("../Data/PtDataSummary.csv")
pt.data$y  <- as.factor(pt.data$y)
pt.data    <- (pt.data %>% drop_na()) # necessary
pt.data$id <- c(1:nrow(pt.data))
#pt.data %>% head() %>% knitr::kable()

# sanity check for occurrences
pt.data$y %>% unfactor() %>% sum()
nrow(pt.data)

# NOTE: vasospasm incidences are rare in the data
# As a result, generating a valid sample (proportional incidence) can be tricky
# Hence dplyr over base R

set.seed(2023) # reproducibility
pt.data.train <- pt.data       %>% dplyr::sample_frac(0.80)
pt.data.test  <- pt.data       %>% dplyr::anti_join(pt.data.train, by = "id")

# remove unnecessary columns
pt.data.train <- pt.data.train %>% subset(.,  select = -c(id) )
pt.data.test  <- pt.data.test  %>% subset(., select = -c(id))

# sanity check
# sum(pt.data.train$y) + sum(pt.data.test$y) = sum(pt.data$y)
pt.data.train$y %>% unfactor() %>% sum()
pt.data.test$y  %>% unfactor() %>% sum()



# ----- Building Model -----

vaso.model <- glm(formula = y ~ .,
                  data    = pt.data.train,
                  family  = binomial)

summary(vaso.model)
summary(vaso.model)$coefficients



# ----- Testing and Making Predictions -----

# Predictions
# NOTE: one does not need to remove response column "y", such is handled inside "predict()"
pt.data.test$pred.y <- predict(vaso.model, pt.data.test, type = "response")
#pt.data.test %>% head() %>% knitr::kable()

# Error
sum(abs( unfactor(pt.data.test$y) - pt.data.test$pred.y ))


# ----- Visualising Model -----

png("../Graphs/glm_results_bp_mean.png")
plot( unfactor(y) ~ x.1, data = pt.data.test[order(pt.data.test$x.1), ], 
      xlab = "Blood Pressure (Mean)", ylab = "Vasospasm Incidence", main = "GLM Predictive Model: Results")
lines(     pred.y ~ x.1, data = pt.data.test[order(pt.data.test$x.1), ], lwd = 2, col = "green")
dev.off()

png("../Graphs/glm_results_bp_std.png")
plot( unfactor(y) ~ x.2, data = pt.data.test[order(pt.data.test$x.2), ], 
      xlab = "Blood Pressure (Std Deviation)", ylab = "Vasospasm Incidence", main = "GLM Predictive Model: Results")
lines(     pred.y ~ x.2, data = pt.data.test[order(pt.data.test$x.2), ], lwd = 2, col = "green")
dev.off()

png("../Graphs/glm_results_hr_mean.png")
plot( unfactor(y) ~ x.3, data = pt.data.test[order(pt.data.test$x.3), ], 
      xlab = "Heart Rate (Mean)", ylab = "Vasospasm Incidence", main = "GLM Predictive Model: Results")
lines(     pred.y ~ x.3, data = pt.data.test[order(pt.data.test$x.3), ], lwd = 2, col = "green")
dev.off()

png("../Graphs/glm_results_hr_std.png")
plot( unfactor(y) ~ x.4, data = pt.data.test[order(pt.data.test$x.4), ], 
      xlab = "Heart Rate (Std Deviation)", ylab = "Vasospasm Incidence", main = "GLM Predictive Model: Results")
lines(     pred.y ~ x.4, data = pt.data.test[order(pt.data.test$x.4), ], lwd = 2, col = "green")
dev.off()

png("../Graphs/glm_results_nora.png")
plot( unfactor(y) ~ x.5.1, data = pt.data.test[order(pt.data.test$x.5.1), ], 
      xlab = "Noradrenaline Administered", ylab = "Vasospasm Incidence", main = "GLM Predictive Model: Results")
lines(     pred.y ~ x.5.1, data = pt.data.test[order(pt.data.test$x.5.1), ], lwd = 2, col = "green")
dev.off()

png("../Graphs/glm_results_meta.png")
plot( unfactor(y) ~ x.5.2, data = pt.data.test[order(pt.data.test$x.5.2), ], 
      xlab = "Metaraminol Administered", ylab = "Vasospasm Incidence", main = "GLM Predictive Model: Results")
lines(     pred.y ~ x.5.2, data = pt.data.test[order(pt.data.test$x.5.2), ], lwd = 2, col = "green")
dev.off()


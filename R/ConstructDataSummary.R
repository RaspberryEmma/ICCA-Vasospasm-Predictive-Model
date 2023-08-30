# ICCA Database Project
# Building Summary of Patient Data
# This document demonstrates using extracted ICCA data to form a usable data summary
# Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
# 30-08-2023



# ----- Preamble -----

rm(list = ls())
library(tidyverse)



# ----- Importing Data -----

pt.bp      <- read.csv("../Data/ConstructPtBloodPressure.csv")
pt.details <- read.csv("../Data/ConstructPtDetails.csv")
pt.hr      <- read.csv("../Data/ConstructPtHeartRate.csv")
pt.meds    <- read.csv("../Data/ConstructPtMedication.csv")
pt.vaso    <- read.csv("../Data/ConstructPtVasospasm.csv")



# ----- Building Linear Algebraic Data Summaries ----


# ----- y = incidence of vasospasm -----

# summary columns
unique.pt.ids <- pt.details$patientId %>% unique() %>% sort()
unique.meds   <- pt.meds$shortLabel   %>% unique()

# set constants to control dimensionality
N <- unique.pt.ids %>% length()
M <- unique.meds %>% length()

# test look-up
#for (id in 1:N) {
#  # look-up corresponding cisPatientId
#  cis.id <- pt.details$cisPatientId[ match(id, pt.details$patientId) ]
#  message(paste(id, " -> ", cis.id))
#}
#stop()

# construct vector of binary incidence for vasospasm
y <- rep(0, N)

# fill incidences as appropriate

## holder variables
current.cis.id <- NULL
current.notes  <- NULL
current.vaso   <- FALSE

## check all corresponding records
for (current.id in 1:N) {
  
  # reset
  current.vaso <- FALSE
  
  # look-up corresponding cisPatientId
  current.cis.id <- pt.details$cisPatientId[ match(current.id, pt.details$patientId) ]
  
  # determine whether there exists vasospasm note for this patient
  current.notes <- pt.vaso %>% filter(cisPatientId == current.cis.id)
  current.vaso  <- ( sum( str_detect(current.notes$valueString, regex("vasospasm", ignore_case = T)) ) > 0)
  
  # set incidence from "0" to "1" if vasospasm is detected
  if ( current.vaso ) { y[ current.id ] <- 1 }
  
}

print(y)
print(sum(y))
print(length(y))



# ----- x.1 = bp mean, x.2 = bp std deviation -----

## holder variables
current.cis.id <- NULL
current.bp     <- NULL
current.mean   <- 0.0
current.sd     <- 0.0

## construct vectors
x.1 <- rep(0, N)
x.2 <- rep(0, N)

## check all corresponding records
for (current.id in 1:N) {
  
  # look-up corresponding cisPatientId
  current.cis.id <- pt.details$cisPatientId[ match(current.id, pt.details$patientId) ]
  
  # subset blood pressure readings to only current patient
  current.bp     <- pt.bp %>% filter(cisPatientId == current.cis.id)
  
  if(nrow(current.bp) == 0) {
    # nothing to record
    current.mean <- NA
    current.sd   <- NA
  }
  else {
    # determine summaries
    current.mean <- current.bp$valueNumber %>% as.double() %>% mean(., na.rm = TRUE)
    current.sd   <- current.bp$valueNumber %>% as.double() %>% sd(., na.rm = TRUE)
  }
  
  # record summaries
  x.1[ current.id ] <- current.mean
  x.2[ current.id ] <- current.sd
  
}

print(x.1)
print(length(x.1))
print(x.2)
print(length(x.2))



# ----- x.3 = hr mean, x.4 = hr std deviation -----

## holder variables
current.cis.id <- NULL
current.hr     <- NULL
current.mean   <- 0.0
current.hr     <- 0.0

## construct vectors
x.3 <- rep(NULL, N)
x.4 <- rep(NULL, N)

## check all corresponding records
for (current.id in 1:N) {
  
  # look-up corresponding cisPatientId
  current.cis.id <- pt.details$cisPatientId[ match(current.id, pt.details$patientId) ]
  
  # subset blood pressure readings to only current patient
  current.hr     <- pt.hr %>% filter(cisPatientId == current.cis.id)
  
  if(nrow(current.hr) == 0) {
    # nothing to record
    current.mean <- NA
    current.sd   <- NA
  }
  else {
    # determine summaries
    current.mean <- current.hr$valueNumber %>% as.double() %>% mean(., na.rm = TRUE)
    current.sd   <- current.hr$valueNumber %>% as.double() %>% sd(., na.rm = TRUE)
  }
  
  # record summaries
  x.3[ current.id ] <- current.mean
  x.4[ current.id ] <- current.sd
  
}

print(x.3)
print(length(x.3))
print(x.4)
print(length(x.4))



# ----- x.5.1 -> x.5.M = medications -----

# construct vector of binary incidence for various medications
x.5.1 <- rep(0, N)
x.5.2 <- rep(0, N)

# fill incidences as appropriate

## holder variables
current.cis.id <- NULL
current.meds   <- NULL

current.nora   <- FALSE
current.meta   <- FALSE

## check all corresponding records
for (current.id in 1:N) {
  
  # reset
  current.nora <- FALSE
  
  # look-up corresponding cisPatientId
  current.cis.id <- pt.details$cisPatientId[ match(current.id, pt.details$patientId) ]
  
  # determine whether or not our current patient is taking several medications
  current.meds <- pt.meds %>% filter(cisPatientId == current.cis.id)
  
  current.nora <- ( sum(str_detect(current.meds$shortLabel, regex("noradrenaline", ignore_case = T))) > 0)
  current.meta <- ( sum(str_detect(current.meds$shortLabel, regex("metaraminol", ignore_case = T))) > 0)
  
  # set incidence from "0" to "1" if given medications are detected
  if ( current.nora ) { x.5.1[ current.id ] <- 1 }
  if ( current.meta ) { x.5.2[ current.id ] <- 1 }
  
}

print(x.5.1)
print(sum(x.5.1))
print(length(x.5.1))

print(x.5.2)
print(sum(x.5.2))
print(length(x.5.2))



# ------ Finish Summary -----

pt.data.summary <- data.frame(y, x.1, x.2, x.3, x.4, x.5.1, x.5.2)
View(pt.data.summary)

write_csv(x         = pt.data.summary,
          file      = "../Data/PtDataSummary.csv",
          append    = FALSE,
          col_names = TRUE)


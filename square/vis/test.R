rm(list=ls())

setwd("./square/vis")
source("data_loading.R")

raw_data <- read_clean_data()
raw_items <- raw_data[[1]]
raw_trans <- raw_data[[2]]


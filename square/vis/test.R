rm(list=ls())

#library(lubridate)

setwd("./square/vis")
source("data_loading.R")

data_raw <- read_clean_data()

data_trans <- get_trans_data(data_raw)

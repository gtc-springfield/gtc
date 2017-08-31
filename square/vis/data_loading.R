
#-----------------------------------------------------------------------------#
# UTILITY FUNCTIONS FOR DATA LOADING
#-----------------------------------------------------------------------------#
library(dplyr)
library(readr)
library(tidyr)



# make a function to read and clean the data
read_clean_data <- function() {
  datadir_items <- "data/items"
  datadir_trans <- "data/transactions"

  raw_items <- get_raw_data(datadir_items)
  raw_trans <- get_raw_data(datadir_trans)
  return(list(raw_items, raw_trans))

  #add code to make sure the files in each folder are as one dataframe
}


  # Read in data either in items or trans

get_raw_data <- function(datadir){
  files <- list.files(datadir, pattern = ".csv", full.names = TRUE)
  n_files = 0
  for (file in files) {
    if (n_files == 0){
      data <- read.csv(file)
      n_files = n_files + 1
    }
    else{
      data_more <- read.csv(file)
      data <- rbind(data, data_more)
      rm(data_more)
      n_files = n_files + 1
    }

  }
  return(data)

}





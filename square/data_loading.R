
#-----------------------------------------------------------------------------#
# UTILITY FUNCTIONS FOR DATA LOADING
#-----------------------------------------------------------------------------#
library(dplyr)
library(readr)
library(tidyr)



# make a function to read and clean the data 
read_clean_data<- function(infile) {

  #add code to make sure the files in each folder are as one dataframe
}
  
  
  # Read in the item data
  
  datadir_items <- "../data/items"
  files <- list.files(datadir, pattern = ".csv", full.names = TRUE)
  
  for (file in files) {
    data <- read_csv(file)
    
  }
  
  # Read in the transactions data
  
  datadir <- "../data/transactions"
  files <- list.files(datadir, pattern = ".csv")
  
  for (file in files) {
    data <- read_csv(file)
    
  }
  
  
  
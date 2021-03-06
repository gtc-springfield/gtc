
#-----------------------------------------------------------------------------#
# UTILITY FUNCTIONS FOR DATA LOADING
#-----------------------------------------------------------------------------#
library(dplyr)
library(readr)
library(tidyr)
library(lubridate)



# make a function to read and clean the data
read_clean_data <- function() {
  #datadir_items <- "data/items"
  #datadir_trans <- "data/transactions"
  datadir <- "data/items"

  #raw_items <- get_raw_data(datadir_items)
  #raw_trans <- get_raw_data(datadir_trans)
  raw <- get_raw(datadir)
  return(raw)

  #add code to make sure the files in each folder are as one dataframe
}


read_clean_data_items_only <- function() {
  datadir_items <- "data/items"

  raw_items <- get_raw(datadir_items)
  return(raw_items)

  #add code to make sure the files in each folder are as one dataframe
}


  # Read in data either in items or trans

get_raw <- function(datadir){
  files <- list.files(datadir, pattern = ".csv", full.names = TRUE)
  n_files = 0
  for (file in files) {
    if (n_files == 0){
      data <- read.csv(file, stringsAsFactors = FALSE)
      n_files = n_files + 1
    }
    else{
      data_more <- read.csv(file, stringsAsFactors = FALSE)
      data <- bind_rows(data, data_more) %>% distinct()
      rm(data_more)
      n_files = n_files + 1
    }

  }
  return(data)

}

get_trans_data <- function(df){
  df <- df %>%
    select(
      Date,
      Net.Sales,
      Transaction.ID,
      Payment.ID
    )
  df$Date <- mdy(df$Date)
  df$Net.Sales <- as.numeric(gsub("\\$", "", df$Net.Sales))
  df <- df %>%
    mutate(Year = year(Date), DOW = wday(Date, label=TRUE))
  df$DOW <- as.character(df$DOW)
  df <- df %>%
    group_by(Date, Transaction.ID, Year, DOW) %>%
    summarise(Net.Sales = sum(Net.Sales)) %>%
    filter(Net.Sales > 0 && DOW %in% c("Wed", "Thurs", "Sat"))

  # add code to group by transaction ID

  return(df)
}

get_items_data <- function(df){
  df <- df %>%
    select(
      Date,
      Category,
      Item,
      Qty,
      Net.Sales
    )
  df$Date <- mdy(df$Date)
  df$Net.Sales <- as.numeric(gsub("\\$", "", df$Net.Sales))
  df <- df %>% mutate(Year = year(Date))

  # add code to group by transaction ID

  return(df)
}





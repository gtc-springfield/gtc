library(shiny)
library(shinydashboard)
library(DT)
library(plotly)

source("data_loading.R")

data <- read_clean_data_items_only()
df <- data

items <- get_items_data(data)
trans <- get_trans_data(data)

years = unique(trans$Year)

library(shiny)
library(shinydashboard)
library(DT)
library(plotly)

source("data_loading.R")
source("trans_analysis.R")

data <- read_clean_data_items_only()
df <- data

items <- get_items_data(data)
trans <- get_trans_data(data)

years = sort(unique(trans$Year), decreasing = TRUE)

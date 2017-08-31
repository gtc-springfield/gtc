
source("data_loading.R")
library(plotly)

data_raw <- read_clean_data()

data_trans <- get_trans_data(data_raw)

overall_sales_over_time_df <- function(df){
  daily_net_sales <- df %>% 
    group_by(Date) %>% 
    summarise(Daily.Net.Sales = sum(Net.Sales))
  return(daily_net_sales)
}

data_trans_sales_over_time <- overall_sales_over_time_df(data_trans)
plotly(data_trans_sales_over_time, x)
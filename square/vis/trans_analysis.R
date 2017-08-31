
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

overall_trans_over_time_df <- function(df){
    #df$Transaction.ID <- as.factor(df$Transaction.ID) 
    #df_num_trans <- df %>% group_by(Transaction.ID)  
    daily_num_trans <- df %>%
      group_by(Date) %>%
      summarise(Daily.num.trans = n())
  return(daily_num_trans)
  
}

sales_by_market <- function(df){
  sales_market <- df %>%
    group_by(DOW) %>%
    summarise(Market.sales = sum(Net.Sales))
  return(sales_market)
}

trans_num_by_market <- function(df){
  trans_num_market <- df %>%
    group_by(DOW) %>%
    summarise(Market.num.trans = n())
  return(trans_num_market)
}

sales_per_trans_by_market <- function(df){
  sales_per_trans_market <- df %>%
    group_by(DOW) %>%
    summarise(Market.per.trans.sale = mean(Net.Sales))
  return(sales_per_trans_market)
}

sales_over_time_by_market <- function(df){
  daily_net_sales_by_market <- df %>% 
    group_by(Date, DOW) %>% 
    summarise(Daily.Net.Sales = sum(Net.Sales))
  daily_net_sales_Wed <- daily_net_sales_by_market %>%
    filter(DOW == "Wed") %>%
    ungroup()
  daily_net_sales_Thurs <- daily_net_sales_by_market %>%
    filter(DOW == "Thurs") %>%
    ungroup()
  daily_net_sales_Sat <- daily_net_sales_by_market %>%
    filter(DOW == "Sat") %>%
    ungroup()

  return(list(daily_net_sales_Wed, 
              daily_net_sales_Thurs, 
              daily_net_sales_Sat))
}

trans_num_over_time_by_market <- function(df){
  daily_trans_num_by_market <- df %>% 
    group_by(Date, DOW) %>% 
    summarise(Daily.trans.num = n())
  daily_trans_num_Wed <- daily_trans_num_by_market %>%
    filter(DOW == "Wed") %>%
    ungroup()
  daily_trans_num_Thurs <- daily_trans_num_by_market %>%
    filter(DOW == "Thurs") %>%
    ungroup()
  daily_trans_num_Sat <- daily_trans_num_by_market %>%
    filter(DOW == "Sat") %>%
    ungroup()
  
  return(list(daily_trans_num_Wed, 
              daily_trans_num_Thurs, 
              daily_trans_num_Sat))
}






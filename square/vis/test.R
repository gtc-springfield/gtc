rm(list=ls())

#library(lubridate)

setwd("./square/vis")
source("data_loading.R")
source("trans_analysis.R")

data_raw <- read_clean_data()

data_trans <- get_trans_data(data_raw)

data_trans_over_time <- overall_trans_over_time_df(data_trans)

data_market_sales <- sales_by_market(data_trans)
plot_ly(data_market_sales, 
        type = 'bar',
        x = ~DOW,
        y = ~Market.sales)

data_market_per_trans_sales <- sales_per_trans_by_market(data_trans)
plot_ly(data_market_per_trans_sales, 
        type = 'bar',
        x = ~DOW,
        y = ~Market.per.trans.sale)


data_market_sales <- sales_by_market(data_trans)
plot_ly(data_market_sales, labels = ~DOW, values = ~Market.sales, 
        type = 'pie',
        textposition = 'inside',
        textinfo = 'label+percent',
        insidetextfont = list(color = '#FFFFFF'),
        hoverinfo = 'text',
        text = ~paste('$', Market.sales),
        marker = list(colors = colors,
                      line = list(color = '#FFFFFF', width = 1)),
        #The 'pull' attribute can also be used to create space between the sectors
        showlegend = FALSE) %>%
  layout(title = 'Market Shares',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

data_sales_by_market <- sales_over_time_by_market(data_trans)
plot_ly() %>%
  add_trace(x = ~Date, y = ~Daily.Net.Sales, 
            data = data_sales_by_market[[1]], 
            name = "Wednesday", 
            type = "scatter", mode = "lines") %>%
  add_trace(x = ~Date, y = ~Daily.Net.Sales, 
            data = data_sales_by_market[[2]], 
            name = "Thursday", 
            type = "scatter", mode = "lines") %>%
  add_trace(x = ~Date, y = ~Daily.Net.Sales, 
            data = data_sales_by_market[[3]], 
            name = "Saturday", 
            type = "scatter", mode = "lines")

data_trans_num_by_market <- trans_num_over_time_by_market(data_trans)
plot_ly() %>%
  add_trace(x = ~Date, y = ~Daily.trans.num, 
            data = data_trans_num_by_market[[1]], 
            name = "Wednesday", 
            type = "scatter", mode = "lines") %>%
  add_trace(x = ~Date, y = ~Daily.trans.num, 
            data = data_trans_num_by_market[[2]], 
            name = "Thursday", 
            type = "scatter", mode = "lines") %>%
  add_trace(x = ~Date, y = ~Daily.trans.num, 
            data = data_trans_num_by_market[[3]], 
            name = "Saturday", 
            type = "scatter", mode = "lines")

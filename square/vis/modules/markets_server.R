output$overall_sales <- renderValueBox({
  value <- sprintf("$%.2f", sum(trans_filter()$Net.Sales))
  shinydashboard::valueBox(
    value,
    subtitle = tags$p("Gross Sales", style = "font-size: 130%;"),
    icon = icon("money"),
    color = "green"
  )
})

output$overall_trans <- renderValueBox({
  value <- nrow(trans_filter())
  shinydashboard::valueBox(
    value,
    subtitle = tags$p("Transactions", style = "font-size: 130%;"),
    icon = icon("money"),
    color = "blue"
  )
})

output$overall_avg_trans <- renderValueBox({
  value <- sprintf("$%.2f", mean(trans_filter()$Net.Sales))
  shinydashboard::valueBox(
    value,
    subtitle = tags$p("Avg Trans. Amount", style = "font-size: 130%;"),
    icon = icon("money"),
    color = "orange"
  )
})

output$overall_sales_time <- renderPlotly({
  #Plotly Line Chart for overall sales over time
  data_total_sales_over_time <- overall_sales_over_time_df(trans_filter())
  x <- list(
    title = "Time")
  y <- list(
    title = "Total Daily Sales($)")
  data_trans_sales_over_time <- overall_sales_over_time_df(trans_filter())
  plot_ly(data_trans_sales_over_time,
          type = 'scatter',
          mode = 'lines',
          x = ~Date,
          y = ~Daily.Net.Sales) %>%
    layout(xaxis = x, yaxis = y)
})

output$overall_trans_time <- renderPlotly({
  #Plotly Line Chart for overall transactions over time
  data_trans_num_over_time <- overall_trans_over_time_df(trans_filter())
  x <- list(
    title = "Time")
  y <- list(
    title = "Number of Daily Transactions")
  plot_ly(data_trans_num_over_time,
          type = 'scatter',
          mode = 'lines',
          x = ~Date,
          y = ~Daily.num.trans) %>%
    layout(xaxis = x, yaxis = y)
})

output$market_sales <- renderPlotly({
  #Plotly Bar Chart for sales by market
  data_market_sales <- sales_by_market(trans_filter())
  x <- list(
    title = "Market Day")
  y <- list(
    title = "Total Sales($)")
  plot_ly(data_market_sales, 
          type = 'bar',
          x = ~DOW,
          y = ~Market.sales) %>%
    layout(xaxis = x, yaxis = y)
})

output$market_num_trans <- renderPlotly({
  #Plotly Bar Chart for number of transactions by Market
  data_market_trans_num <- trans_num_by_market(trans_filter())
  x <- list(
    title = "Market Day")
  y <- list(
    title = "Total Number of Transactions")
  plot_ly(data_market_trans_num,
          type = 'bar',
          x = ~DOW,
          y = ~Market.num.trans) %>%
    layout(xaxis = x, yaxis = y)
})

output$market_avg_trans <- renderPlotly({
  #Plotly Bar Chart for average transaction by Market
  data_market_per_trans_sales <- sales_per_trans_by_market(trans_filter())
  x <- list(
    title = "Market Day")
  y <- list(
    title = "Ave. Sales per Transaction ($)")
  plot_ly(data_market_per_trans_sales,
          type = 'bar',
          x = ~DOW,
          y = ~Market.per.trans.sale) %>%
    layout(xaxis = x, yaxis = y)
})

output$market_share <- renderPlotly({
  #Plotly Pie Chart for share of total sales by market
  data_market_sales <- sales_by_market(trans_filter())
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
  
})

output$market_sales_time <- renderPlotly({
  #Plotly line graph for sales over time by market
  data_sales_by_market <- sales_over_time_by_market(trans_filter())
  x <- list(
    title = "Time")
  y <- list(
    title = "Total Sales by Market($)")
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
              type = "scatter", mode = "lines") %>%
    layout(xaxis = x, yaxis = y)
})

output$market_trans_time <- renderPlotly({
  #Plotly line graph for transactions over time by market
  data_trans_num_by_market <- trans_num_over_time_by_market(trans_filter())
  x <- list(
    title = "Time")
  y <- list(
    title = "Total Number of Transactions by Market")
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
              type = "scatter", mode = "lines") %>%
    layout(xaxis = x, yaxis = y)
})

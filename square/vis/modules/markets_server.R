output$overall_sales <- renderValueBox({
  value <- sum(trans_filter()$Net.Sales)
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
  value <- format(mean(trans_filter()$Net.Sales), digits = 2, zero.print = TRUE)
  shinydashboard::valueBox(
    value,
    subtitle = tags$p("Avg Trans. Amount", style = "font-size: 130%;"),
    icon = icon("money"),
    color = "orange"
  )
})

output$overall_sales_time <- renderPlotly({
  #Plotly Line Chart for overall sales over time
})

output$overall_trans_time <- renderPlotly({
  #Plotly Line Chart for overall transactions over time
})

output$market_sales <- renderPlotly({
  #Plotly Bar Chart for sales by market
})

output$market_num_trans <- renderPlotly({
  #Plotly Bar Chart for number of transactions by Market
})

output$market_avg_trans <- renderPlotly({
  #Plotly Bar Chart for average transaction by Market
})

output$market_share <- renderPlotly({
  #Plotly Pie Chart for share of total sales by market
})

output$market_sales_time <- renderPlotly({
  #Plotly line graph for sales over time by market
})

output$market_trans_time <- renderPlotly({
  #Plotly line graph for transactions over time by market
  df <- trans_filter()
  browse()
})

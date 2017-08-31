output$overall_sales <- renderValueBox({
  value <- 0
  shinydashboard::valueBox(
    value,
    subtitle = tags$p("Gross Sales", style = "font-size: 130%;"),
    icon = icon("money"),
    color = "green"
  )
})

output$overall_trans <- renderValueBox({
  value <- 0
  shinydashboard::valueBox(
    value,
    subtitle = tags$p("Transactions", style = "font-size: 130%;"),
    icon = icon("money"),
    color = "blue"
  )
})

output$overall_avg_trans <- renderValueBox({
  value <- 0
  shinydashboard::valueBox(
    value,
    subtitle = tags$p("Avg Trans. Amount", style = "font-size: 130%;"),
    icon = icon("money"),
    color = "orange"
  )
})

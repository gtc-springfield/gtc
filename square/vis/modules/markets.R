markets <-
  tabItem("markets",
    fluidRow(
      box(
        title = "Overall",
        width = 12,
        fluidRow(
          valueBoxOutput("overall_sales"),
          valueBoxOutput("overall_trans"),
          valueBoxOutput("overall_avg_trans")
        ),
        fluidRow(
          box(
            title = "Sales over Time",
            width = 12,
            span("Line chart"),
            plotlyOutput("overall_sales_time")
          )
        ),
        fluidRow(
          box(
            title = "Transactions over Time",
            width = 12,
            span("Line chart"),
            plotlyOutput("overall_trans_time")
          )
        )
      )
    ),
    fluidRow(
      box(
        title = "By Market",
        width = 12,
        fluidRow(
          box(
            title = "Gross Sales",
            span("Bar Graph"),
            plotlyOutput("market_sales")
          ),
          box(
            title = "Number of Transactions",
            span("Bar Graph"),
            plotlyOutput("market_num_trans")
          )
        ),
        fluidRow(
          box(
            title = "Average Transaction Amount",
            span("Bar Graph"),
            plotlyOutput("market_avg_trans")
          ),
          box(
            title = "Market Share of Total Sales",
            span("Pie Chart"),
            plotlyOutput("market_share")
          )
        ),
        fluidRow(
          box(
            title = "Sales over Time",
            width = 12,
            span("Line Chart"),
            plotlyOutput("market_sales_time")
          )
        ),
        fluidRow(
          box(
            title = "Transactions over Time",
            width = 12,
            span("Line Chart"),
            plotlyOutput("market_trans_time")
          )
        )
      )
    )
  )

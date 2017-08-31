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
            span("Line chart")
          )
        ),
        fluidRow(
          box(
            title = "Transactions over Time",
            width = 12,
            span("Line chart")
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
            span("Bar Graph")
          ),
          box(
            title = "Number of Transactions",
            span("Bar Graph")
          )
        ),
        fluidRow(
          box(
            title = "Average Transaction Amount",
            span("Bar Graph")
          ),
          box(
            title = "Market Share of Total Sales",
            span("Pie Chart")
          )
        ),
        fluidRow(
          box(
            title = "Sales over Time",
            width = 12,
            span("Line Chart")
          )
        ),
        fluidRow(
          box(
            title = "Transactions over Time",
            width = 12,
            span("Line Chart")
          )
        )
      )
    )
  )

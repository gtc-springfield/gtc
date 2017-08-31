items <-
  tabItem("items",
    fluidRow(
      box(
        title = "Top Selling Items",
        width = 12,
        span("Bar Chart")
      )
    ),
    fluidRow(
      box(
        title = "Sales by Category",
        span("Table")
      ),
      box(
        title = "Sales by Items",
        span("Bar Chart. Appears when category is selected from table")
      )
    ),
    fluidRow(
      box(
        title = "Yearly Comparison",
        width = 12,
        span("Table, all years available")
      )
    )
  )

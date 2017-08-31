items <-
  tabItem("items",
    fluidRow(
      box(
        title = "Top Selling Items",
        width = 12,
        span("Bar Chart"),
        plotlyOutput("items_top")
      )
    ),
    fluidRow(
      box(
        title = "Sales by Category",
        span("Table"),
        dataTableOutput("items_sales_by_cat")
      ),
      box(
        title = "Sales by Items",
        span("Bar Chart. Appears when category is selected from table"),
        plotlyOutput("items_sales_by_item")
      )
    ),
    fluidRow(
      box(
        title = "Yearly Comparison",
        width = 12,
        span("Table, all years available"),
        dataTableOutput("items_yearly_comp")
      )
    )
  )

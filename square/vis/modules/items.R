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
        conditionalPanel("output.row_selected",
          plotlyOutput("items_sales_by_item")
        ),
        conditionalPanel("!output.row_selected",
          span("Select a category to see the item breakdown.")
        )
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

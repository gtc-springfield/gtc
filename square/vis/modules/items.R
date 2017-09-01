items <-
  tabItem("items",
    fluidRow(
      box(
        title = "Top Selling Items",
        width = 12,
        plotlyOutput("items_top")
      )
    ),
    fluidRow(
      box(
        title = "Sales by Category",
        dataTableOutput("items_sales_by_cat")
      ),
      box(
        title = "Sales by Items",
        conditionalPanel("output.row_selected",
          plotlyOutput("items_sales_by_item", height = "550px")
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
        dataTableOutput("items_yearly_comp")
      )
    )
  )

shinyUI({
  # Header ----
  header <- dashboardHeader(title = "GTC Square Analysis",
    titleWidth = "225px",
    tags$li(img(src = "", height = "50px"),
      class = "dropdown"))

  # Sidebar ----
  sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Markets", tabName = "markets",
        icon = icon("bar-chart")),
      menuItem("Items", tabName = "items",
        icon = icon("calculator")),
      menuItem("Comparison", tabName = "comparison",
        icon = icon("calculator")),
      menuItem("Filters", icon = icon("cog"),
        selectInput("year", label = "Year", choices = years)
      )
    )
  )

  # Tabs ----
  source("modules/markets.R", local = TRUE)
  source("modules/items.R", local = TRUE)
  source("modules/comparison.R", local = TRUE)

  # Body ----
  body <- dashboardBody(
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "mm.css")
    ),
    tabItems(markets, items)
  )

  # Dashboard Page ----
  dashboardPage(header, sidebar, body, title = "GTC Square Analysis")

})

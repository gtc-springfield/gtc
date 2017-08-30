shinyUI({
  # Header ----
  header <- dashboardHeader(title = "Call Center Forecasting",
    titleWidth = "250px",
    tags$li(img(src = "", height = "50px"),
      class = "dropdown"))

  # Sidebar ----
  sidebar <- dashboardSidebar(
    )
  )

  # Tabs ----
  source("modules/analysis.R", local = TRUE)
  source("modules/staffing_ui.R", local = TRUE)

  # Body ----
  body <- dashboardBody(
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "mm.css")
    ),
    tabItems(analysis, staffing)
  )

  # Dashboard Page ----
  dashboardPage(header, sidebar, body, title = "Call Center Forecasting")

})

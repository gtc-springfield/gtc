
shinyUI({
  dashboardPage(
    dashboardHeader(
      title='Donor Database (Neon) Reporting and Analysis', 
      titleWidth = 350
    ),
    dashboardSidebar(
      disable = FALSE,
      sidebarMenu(
        menuItem(
          "Donor Report", 
          tabName = "donor", 
          icon = icon("report")
        ),
        menuItem(
          "Campaign Report", 
          tabName = "campaign", 
          icon = icon("campaign")
        ) # end menuItem
      ) # end sidebarMenu
    ), # end dashboardSidebar
    dashboardBody(
      tabItems(
        tabItem(
          tabName = 'donor',
          fluidPage(
            column(
              width = 3, 
              box(
                width = NULL, 
                #status = "warning", 
                selectInput(
                  "top_donors", 
                  "Top 100 Donors", 
                  choices = c(
                    "All Years",
                    seq(from = 2017, to = 2004, by = -1)
                  ), 
                  selected = 2017
                )
              ) #end box
            ), # end column
            column(
              width=12, 
              br(), 
              dataTableOutput("top_donors"),
              div(
                downloadButton(
                  'download_data', 
                  label="Download", 
                  class = NULL
                ), 
                align='left'
              ) # end div
            ) # end column
          ) # end fluidPage
        ), # end tabItem 
        tabItem(
          tabName = "campaign",
          h2("empty content")
        ) # end tabItem
      ) # end tabItems
    ) # end dashboardBody
  ) # end dashboardPage
}) # end shinyUI



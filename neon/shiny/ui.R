
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
        ),
        menuItem(
          "Donations",
          tabName = "donations",
          icon = icon("donations")
        ) # end menuItem
      ) # end sidebarMenu
    ), # end dashboardSidebar
    dashboardBody(
      tabItems(
        tabItem(
          tabName = 'donor',
          fluidPage(
            column(
              width = 6, 
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
              width=8, 
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
        ),
        tabItem(
          tabName = "donations",
          h2("Donations"),
          fluidPage(
            column(
              width = 8,
              box(
                width = NULL, 
                sliderInput("time2", "Years to View:",
                            min = 2004, max = 2017, value = c(2004, 2017))
              ) #end box
            ), # end column
            column(
              h4("Summed Donations by Year and Amount", align = "center"),
              width=8, 
              br(), 
              plotOutput("pyramid")
            ) # end column
            
          ) #end fluidPage
        )# end tabItem
      ) # end tabItems
    ) # end dashboardBody
  ) # end dashboardPage
}) # end shinyUI



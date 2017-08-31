
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
        ),
        menuItem(
          "DCR", 
          tabName = "DCR", 
          icon = icon("DCR")
        )# end menuItem
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
          h3("Campaign content here")
        ),
        tabItem(
          tabName = "donations",
          fluidPage(
            column(
              width = 6, align = 'left', 
              box(
                width = NULL, 
                #status = "warning", 
                sliderInput("time2", "Years to View:",
                            min = 2004, max = 2017, value = c(2004, 2017), sep ="")
              ) #end box
            ), # end column
            column(
              br(),
              width = 12,  align = 'center', 
              h4(textOutput("abovePlot")),
              br()
            ), # end column
            fluidRow(
              column(
                     width = 7,
                     plotOutput("pyramid")
              ),
              column(
                     width = 5,
                     dataTableOutput("summed_donations")
              )
              
              ) # end FluidRow
          ) # end fluidPage
        ),
        tabItem(
          tabName = "DCR",
          h2("Testing DCR integration"),
          width = 12,
          br(),
          chartOutput("chart")
        )# end tabItem
      ) # end tabItems
    ) # end dashboardBody
  ) # end dashboardPage
}) # end shinyUI



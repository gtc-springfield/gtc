
shinyUI({
  dashboardPage(
    skin = 'blue',
    dashboardHeader(
      title='Donor Database (Neon) Reporting and Analysis', 
      titleWidth = 500
    ),
    dashboardSidebar(
      disable = FALSE,
      sidebarMenu(
        menuItem(
          "Donor Report",
          menuSubItem(
            "Top Donors",
            tabName = "top_donors"
          ),
          menuSubItem(
            "Top Donations",
            tabName = "top_donations"
          )
        ),
        menuItem(
          "Campaign Report", 
          tabName = "campaign"
        ),
        menuItem(
          "Donations",
          tabName = "donations"
        )
      ) # end sidebarMenu
    ), # end dashboardSidebar
    dashboardBody(
      tabItems(
        tabItem(
          tabName = 'top_donors',
          fluidPage(
            column(
              width = 6, 
              box(
                width = NULL, 
                selectInput(
                  "top_donors", 
                  "Select a donation year", 
                  choices = c(
                    "All Years",
                    seq(from = 2017, to = 2004, by = -1)
                  ), 
                  selected = 2017,
                  width = '70%'
                ), # end selectInput
                h5(textOutput("top_donors_txt"))
              ) #end box
            ), # end column
            column(
              width=12, 
              br(), 
              dataTableOutput("top_donors"),
              div(
                downloadButton(
                  'download_data1', 
                  label="Download", 
                  class = NULL
                ), 
                align='left'
              ) # end div
            ) # end column
          ) # end fluidPage
        ), # end tabItem 
        tabItem(
          tabName = "top_donations",
          fluidPage(
            column(
              width = 6,
              box(
                width = NULL,
                selectInput(
                  "top_donations",
                  "Select a donation year",
                  choices = c(
                    "All Years",
                    seq(from = 2017, to = 2004, by = -1)
                  ),
                  selected = 2017,
                  width = '70%'
                ), # end selectInput
                h5(textOutput("top_donations_txt"))
              ) #end box
            ), # end column
            column(
              width=12,
              br(),
              dataTableOutput("top_donations"),
              div(
                downloadButton(
                  'download_data2',
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
          h2("Donation Campaign Report", align = "center"),
          column(
            width = 12,
            plotlyOutput("tenderTypes")
          )
        ),
        tabItem(
          tabName = "donations",
          fluidPage(
            column(
              width = 6, align = 'left', 
              box(
                width = NULL, 
                sliderInput(
                  "time2", 
                  "Years to View:",
                  min = 2004, 
                  max = 2017, 
                  value = c(2004, 2017), 
                  sep =""
                ) # end slideInput
              ) # end box
            ), # end column
            column(
              br(),
              width = 12,  align = 'center', 
              h3(textOutput("abovePlot")),
              br()
            ), # end column
            fluidRow(
              column(
                width = 7,
                plotlyOutput("pyramid")
              ),
              column(
                width = 5,
                dataTableOutput("summed_donations")
              ) # end column
            ), # end FluidRow
            br(),
            br(),
            width = 12,  align = 'center', 
            
            h3("Donation Categories Year-to-Year, Count and Total Gifts"),
            fluidRow(
              column(
                width = 6,
                plotOutput("barchart_count")
              ),
              column(
                width = 6,
                plotOutput("barchart_sum")
              ) # end column
            ) # end FluidRow
          ) # end fluidPage
        ) # end tabItem
      ) # end tabItems
    ) # end dashboardBody
  ) # end dashboardPage
}) # end shinyUI



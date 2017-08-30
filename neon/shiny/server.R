
source('./config.R')

donations <- read.csv(file.path(GTC_PATH, GTC_DATA), header = TRUE)
donations$Donation.Date <- dt_format(mdy(donations$Donation.Date))
donations$Donation.Year <- year(donations$Donation.Date)

shinyServer(function(input, output, session) {
  
  donations_selected <- reactive({
    if(input$top_donors != 'All Years'){
      df <- donations %>%
        filter(Donation.Year == input$top_donors) %>%
        group_by(Donation.ID) %>%
        summarise(Donation.Amount = sum(Donation.Amount, na.rm=TRUE)) %>%
        arrange(desc(Donation.Amount))
    } else{
      df <- donations %>%
        group_by(Donation.ID) %>%
        summarise(Donation.Amount = sum(Donation.Amount, na.rm=TRUE)) %>%
        arrange(desc(Donation.Amount))
    }
    
    if(nrow(df) > 100){
      df <- df[1:100,]
    }
    
    return(df)
  })
  
  output$top_donors <- renderDataTable({
    donations_selected()
  })
})
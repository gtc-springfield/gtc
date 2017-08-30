
source('./config.R')

donations <- read.csv(file.path(GTC_PATH, GTC_DATA), header = TRUE)
donations$Donation.Date <- dt_format(mdy(donations$Donation.Date))
donations$Donation.Year <- year(donations$Donation.Date)

shinyServer(function(input, output, session) {
  
  donations_selected <- reactive({
    
    donor_info <- donations %>%
      group_by(Account.ID) %>%
      summarise(
        Full_Name = first(Full.Name..F.),
        Street = first(Address.Line.1),
        City = first(City),
        State = first(State),
        ZipCode = first(Zip.Code)
      )
    
    if(input$top_donors != 'All Years'){
      df <- donations %>%
        filter(Donation.Year == input$top_donors) %>%
        group_by(Account.ID) %>%
        summarise(Donation.Amount = sum(Donation.Amount, na.rm=TRUE)) %>%
        arrange(desc(Donation.Amount))
    } else{
      df <- donations %>%
        group_by(Account.ID) %>%
        summarise(Donation.Amount = sum(Donation.Amount, na.rm=TRUE)) %>%
        arrange(desc(Donation.Amount))
    }
    
    if(nrow(df) > 100){
      df <- df[1:100,]
    }
    
    df <- df %>% 
      left_join(
        donor_info,
        by=c("Account.ID" = "Account.ID")
      ) %>%
      select(
        Account.ID,
        Full_Name,
        Street,
        City,
        State,
        ZipCode,
        Donation.Amount
      )
    
    names(df) <- c(
      "Account ID", 
      "Donor's Name",
      "Street",
      "City",
      "State",
      "Zip Code",
      "Donation Amount"
    )
    return(df)
  })
  
  output$top_donors <- renderDataTable({
    donations_selected()
  })
})
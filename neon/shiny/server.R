
source('./config.R')

#Read in data from csv
donations <- read.csv(file.path(GTC_PATH, GTC_DATA), header = TRUE)
donations$Donation.Date <- dt_format(mdy(donations$Donation.Date))
donations$Donation.Year <- year(donations$Donation.Date)
donations$Donation.Month <- month(donations$Donation.Date)
# add binned factor
donations = donations %>%
  mutate(Donation.Category = factor(ifelse(Donation.Amount >=10000, "$10,000 +",
                                           ifelse(Donation.Amount >=5000 & Donation.Amount <= 9999, "$5,000 - $9,999",
                                                  ifelse(Donation.Amount >=1000 & Donation.Amount <= 4999, "$1,000 - $4,999",
                                                         ifelse(Donation.Amount >=300 & Donation.Amount <= 999, "$300 - $999",
                                                                ifelse(Donation.Amount >=200 & Donation.Amount <= 299, "$200 - $299",
                                                                       ifelse(Donation.Amount >= 100 & Donation.Amount <= 199, "$100 - $199",
                                                                              ifelse(Donation.Amount < 100, "Under $100", NA)))))))),
         Donation.Category = factor(Donation.Category, levels = c("Under $100","$100 - $199", "$200 - $299", "$300 - $999", "$1,000 - $4,999", "$5,000 - $9,999", "$10,000 +")))
#Populate column that simplifies tender type
donations$tenderTypeSimple <- as.character(donations$Tender.Type)
donations$tenderTypeSimple[donations$Tender.Type == "Paypal"
                           | donations$Tender.Type == "Kimbia"
                           | donations$Tender.Type == "Credit Card (Online)"
                           | donations$Tender.Type == "Razoo"] <- "Online"

donations$tenderTypeSimple[donations$Tender.Type == "Credit Card (Offline-No Charge)"
                           | donations$Tender.Type == "Cash"
                           | donations$Tender.Type == "Check"
                           | donations$Tender.Type == "In-Kind"] <- "Mail/in-person"

donations$tenderTypeSimple[donations$Tender.Type == "Com. Foundation WMA"
                           | donations$Tender.Type == "NFG/TSN"
                           | donations$Tender.Type == "United Way"
                           | donations$Tender.Type == "Stock/Security"
                           | donations$Tender.Type == "Schwab Charitable"
                           | donations$Tender.Type == "Wire Transfer"] <- "Other"

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
    
    if(input$top_donors != 'All Donation.Years'){
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
  
  # Donations Tab
  output$pyramid <- renderPlotly({
    p <- donations %>% filter(Donation.Year >= input$time2[1] & Donation.Year <= input$time2[2]) %>%
      group_by(Donation.Year) %>% 
      mutate(Year.Sum = sum(Donation.Amount)) %>%
      ungroup() %>% 
      group_by(Donation.Year, Donation.Category) %>%
      summarize(Bin_Sum = sum(Donation.Amount), count = n(), Year.Sum = min(Year.Sum)) %>%
      mutate(Bin_Percent = Bin_Sum / Year.Sum) %>%
      ggplot(aes(x  = Donation.Year, y = Bin_Sum)) + 
      geom_area(aes(fill = Donation.Category), position = 'stack') + theme_minimal()
    
    ggplotly(p) %>% layout(autosize=TRUE)
  }) 
  
  
  sum_donations <- reactive({
    df <- donations %>%
      filter(Donation.Year  >= input$time2[1] & Donation.Year <= input$time2[2]) %>%
      group_by(Donation.Category) %>%
      summarise(Donation.Count = n(),
                Gift.Total = sum(Donation.Amount, na.rm = T)) %>%
      mutate(Gift.Total = prettyNum(Gift.Total, big.mark=","),
             Gift.Total = paste0("$", Gift.Total))
      return(df)
  })
  output$summed_donations <- renderDataTable({
    sum_donations()
  })
  output$abovePlot <- renderText({paste( "Viewing donations by amount category for years ", input$time2[1], "through",input$time2[2], "." )})
  
 output$tenderTypes <- renderPlotly({
    #Create new dataframe for plot
    #Sum total amount of money raised for each year
    tenderDonationTotal <- as.data.frame(aggregate(donations$Donation.Amount,
                                                   by = list(donations$Donation.Year,
                                                             donations$tenderTypeSimple),
                                                   FUN = sum))
    donationTotal <- as.data.frame(aggregate(donations$Donation.Amount,
                                             by = list(donations$Donation.Year),
                                             FUN = sum))
    donationTotal$Group.2 <- "Total"
    donationTotal <- donationTotal[, c(1,3,2)]

    #Add total as new category
    totalDonations <- rbind(tenderDonationTotal, donationTotal)
    #Rename columns
    colnames(totalDonations) <- c('year', 'tenderType', 'donationAmount')
    totalDonations$tenderType <- as.factor(totalDonations$tenderType)

    #Plot donations by tender type
    x <- list(title = "")
    y <- list(title = "Donations in dollars")
    plot_ly(totalDonations, x = ~year, y = ~donationAmount,
            color = ~tenderType, type = 'scatter', mode = 'lines', hoverinfo = 'text',
            text = ~paste('Donation Type: ', tenderType,
                          '<br> Donation amount:  $', donationAmount,
                          '<br> Year: ', year)) %>% layout(xaxis = x, yaxis = y, title = "Donations by Tender Type")

  })
  
})

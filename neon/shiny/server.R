
source('./config.R')

#Read in data from csv
donations <- read.csv(file.path(GTC_PATH, GTC_DATA), header = TRUE, na.strings = "")
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
# Populate column that simplifies tender type
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

geo_code_library <- readRDS("data/geo_code_library.rds")

#Group donations by city and state
donations_by_location <- donations %>%
  select(City, State, Donation.Amount) %>%
  mutate(City = tolower(City)) %>%
  group_by(City, State) %>%
  summarise(Donation.Amount = sum(Donation.Amount), num_donations = n()) %>%
  na.omit() %>%
  ungroup()

#Create uniform casing
donations_by_location$City <-
  toTitleCase(donations_by_location$City)

#Create single location string
donations_by_location$location <-
  paste(
    donations_by_location$City,
    donations_by_location$State,
    sep = ", "
  )

#Split locations by presence in geo code library
lookup <-
  donations_by_location[which(
    !donations_by_location$location %in%
      geo_code_library$location),]

no_lookup <-
  donations_by_location[which(
    donations_by_location$location %in%
      geo_code_library$location),]

#Join geo codes for existing locations
no_lookup <- right_join(no_lookup, geo_code_library, by = "location")

#Lookup new locations and update geo code library file
if(nrow(lookup) > 0){
  result <- geocode(
    paste(
      lookup$City,
      lookup$State,
      sep = ", "
    ),
    output = "latlona",
    source = "google")

  lookup$lat <- result$lat
  lookup$lon <- result$lon

  temp <-
    lookup %>%
    select(location, lat, lon)

  geo_code_library <- rbind(geo_code_library, temp)
  saveRDS(geo_code_library, "data/geo_code_library.rds")
}

donations_by_location <- rbind(lookup, no_lookup)

marker_popup <- function(location, amount, num){
  location <-
    paste0(
      "<b>",
      location,
      "</b>"
    )
  amount <-
    paste0(
      "<b>Gross Donations: </b>",
      sprintf("$%.2f", amount)
    )
  num <-
    paste0(
      "<b>Number of Donations: </b>",
      num
    )

  paste(
    sep = "<br/>",
    location,
    amount,
    num
  )
}

shinyServer(function(input, output, session) {

  donors_selected <- reactive({
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

  donations_selected <- reactive({
    if(input$top_donations != "All Years"){
      df <- donations %>%
        filter(
          Donation.Year == input$top_donations,
          Donation.Amount >= 200
        ) %>%
        select(
          Account.ID,
          Full.Name..F.,
          Address.Line.1,
          City,
          State,
          Zip.Code,
          Donation.Amount
        )
    } else{
      df <- donations %>%
        filter(Donation.Amount >= 200) %>%
        select(
          Account.ID,
          Full.Name..F.,
          Address.Line.1,
          City,
          State,
          Zip.Code,
          Donation.Amount
        )
    }

    df <- df %>%
      rename(
        "Account ID" = "Account.ID",
        "Donor's Name" = "Full.Name..F.",
        "Street" = "Address.Line.1",
        "Zip Code" = "Zip.Code",
        "Donation Amount" = "Donation.Amount"
      )

    return(df)
  })

  output$top_donors <- renderDataTable({
    donors_selected()
  }, rownames = FALSE,
     options = list(
       order = list(list(6, 'desc')),
       searching = FALSE,
       lengthChange = TRUE,
       pageLength = 20)
  )
  output$top_donors_txt <- renderText({
    paste0(
      'Below is a list of top 100 donors from ',
      input$top_donors,
      ', ranked by donation amount.'
    )
  })
  output$download_data1 <- downloadHandler(
    filename = function() {
      paste('top_donors-', input$top_donors, '.csv', sep='')
    },
    content = function(con) {
      write.csv(donors_selected(), con, row.names=FALSE, col.names = FALSE)
    }
  )
  output$top_donations <- renderDataTable({
    donations_selected()
  }, rownames = FALSE,
  options = list(
    order = list(list(6, 'desc')),
    searching = FALSE,
    lengthChange = TRUE,
    pageLength = 20)
  )
  output$top_donations_txt <- renderText({
    paste0(
      'Below is a list of donations > 200 from ',
      input$top_donations,
      ', ranked by donation amount.'
    )
  })
  output$download_data2 <- downloadHandler(
    filename = function() {
      paste('top_donations-', input$top_donations, '.csv', sep='')
    },
    content = function(con) {
      write.csv(donations_selected(), con, row.names=FALSE, col.names = FALSE)
    }
  )


  # Donations Tab
  output$pyramid <- renderPlotly({
    p <- donations %>%
      filter(Donation.Year >= input$time2[1] & Donation.Year <= input$time2[2]) %>%
      group_by(Donation.Year) %>%
      mutate(Year.Sum = sum(Donation.Amount)) %>%
      ungroup() %>%
      group_by(Donation.Year, Donation.Category) %>%
      summarize(Category.Sum = sum(Donation.Amount),
                count = n(),
                Year.Sum = min(Year.Sum)) %>%
      mutate(Bin_Percent = Category.Sum / Year.Sum) %>%
      ggplot(aes(x  = Donation.Year, y = Category.Sum)) +
      geom_area(aes(fill = Donation.Category), position = 'stack') +
      scale_y_continuous(label=dollar_format()) +
      theme_minimal() + labs(y = "Gifts", x ="Year") +
     scale_fill_discrete(drop=FALSE) #+ scale_x_discrete(drop=FALSE)


    ggplotly(p) %>% layout(autosize=TRUE)
  })

  output$barchart_sum <- renderPlot({
    donations %>%
      filter(Donation.Year, input$time2[1] & Donation.Year <= input$time2[2]) %>%
      ggplot(aes(x=as.factor(Donation.Year), y = Donation.Amount, fill=Donation.Category)) +
      geom_bar(stat = 'identity') + theme_bw() + coord_flip() +
      labs(y = "Gift Total", x = "Year", fill = "Donation Category") +
      scale_y_continuous(label = dollar_format()) + #ylim(input$time2[1], input$time2[2]) +
      theme_minimal() + labs(y = "Total Gifts", x ="") +
      theme(axis.title.y = element_text(size = 16)) +
      theme(axis.title.x = element_text(size = 16)) +
      theme(axis.text.x= element_text(size = 14))+
      theme(axis.text.y= element_text(size = 14))

   # ggplotly(p) %>% layout(autosize=TRUE)

  })

  output$barchart_count <- renderPlot({
    donations %>%
      filter(Donation.Year, input$time2[1] & Donation.Year <= input$time2[2]) %>%
      ggplot(aes(x=as.factor(Donation.Year), fill = Donation.Category)) +
      geom_bar() + theme_bw() + coord_flip() +
      labs(y = "Number of Gifts", x = "", fill = "Donation Category") +
      theme(axis.title.y = element_text(size = 16)) +
      theme(axis.title.x = element_text(size = 16)) +
      theme(axis.text.x= element_text(size = 14))+
      theme(axis.text.y= element_text(size = 14))
  })

  sum_donations <- reactive({
    df <- donations %>%
      filter(Donation.Year  >= input$time2[1] & Donation.Year <= input$time2[2]) %>%
      group_by(Donation.Category) %>%
      summarise(Donation.Count = n(),
                Gift.Total = sum(Donation.Amount, na.rm = T)) %>%
      mutate(Gift.Total = prettyNum(Gift.Total, big.mark=","),
             Gift.Total = paste0("$", Gift.Total)) %>%
      rename(
        "Donation Category" = "Donation.Category",
        "Count" = "Donation.Count",
        "Gift Total" = "Gift.Total"
      )
      return(df)
  })
  output$summed_donations <- renderDataTable({
    sum_donations()
  }, rownames = FALSE,
    options = list(
      searching = FALSE,
      lengthChange = FALSE,
      pageLength = 20)
  )

  output$abovePlot <- renderText({paste( "Viewing donations by amount category for years ", input$time2[1], "through",input$time2[2] )})

  #output$abovePlot <- renderText({paste( "Viewing donations by amount category for years ", input$time2[1], "through",input$time2[2], "." )})

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

 output$donor_map <- renderLeaflet({
   map <- leaflet(donations_by_location) %>%
     addTiles() %>%  # Add default OpenStreetMap map tiles
     addCircleMarkers(
       lng = ~lon,
       lat = ~lat,
       color = "purple",
       radius = 5,
       stroke = FALSE,
       fillOpacity = 0.8,
       popup = ~marker_popup(location, Donation.Amount, num_donations))
   map
 })

})

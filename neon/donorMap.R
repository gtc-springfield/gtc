library(leaflet)
library(ggmap)

#Load in existing geo code library
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
map # Print the map

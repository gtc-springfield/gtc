library(leaflet)

#Geocoding the addresses
#Combine addresses into one column
donations$address <- paste(donations$Address.Line.1, donations$City, donations$State, sep = ', ')
#Remove NAs
donations$address <- gsub('NA,|,NA|NA', '', donations$address)

#Add new dataframe with only unique addresses
geoCode <- distinct(donations, address)

# Loop through the addresses to get the latitude and longitude of each address
# and add it to the df data frame in new columns lat and lon
for(i in 1:nrow(geoCode))
{
  result <- geocode(geoCode$address[i], output = "latlona", source = "google")
  geoCode$lon[i] <- as.numeric(result[1])
  geoCode$lat[i] <- as.numeric(result[2])
}

#Leaflet map of donors
map <- leaflet() %>%
       addTiles() %>%  # Add default OpenStreetMap map tiles
       addCircleMarkers(lng = geoCode$lon,
                        lat = geoCode$lat,
                        color = "purple",
                        radius = 5,
                        stroke = FALSE,
                        fillOpacity = 0.8)
map # Print the map

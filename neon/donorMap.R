library(leaflet)

#Geocoding the addresses
#Combine addresses into one column
df$address <- paste(df$`Address Line 1`, df$City, df$State, sep = ', ')
#Remove NAs
df$address <- gsub('NA,|,NA|NA', '', df$address)

#Add new dataframe with only unique addresses
geoCode <- distinct(df, address)

# Loop through the addresses to get the latitude and longitude of each address
# and add it to the df data frame in new columns lat and lon
for(i in 1:nrow(geoCode))
{
  result <- geocode(geoCode$address[i], output = "latlona", source = "google")
  df$lon[i] <- as.numeric(result[1])
  df$lat[i] <- as.numeric(result[2])
}

#Leaflet map of donors
map <- leaflet() %>%
       addTiles() %>%  # Add default OpenStreetMap map tiles
       addCircleMarkers(lng = df$lon,
                        lat = df$lat,
                        color = "purple",
                        radius = 5,
                        stroke = FALSE,
                        fillOpacity = 0.8)
map # Print the map
#Monthly and yearly donation totals
#Import data from neon
donations <- read_csv("~/Downloads/export.csv",
               col_types = cols(`Account Type` = col_factor(levels =
                                                              c("Individual",
                                                                "Organization")),
                                `Donation Date` = col_date(format = "%m/%d/%Y")))
donations <- donations[c(1:17)]

#Initialize new columns
donations$donationYear <- NA
donations$donationYear <- year(donations$`Donation Date`)
donations$donationMonth <- NA
donations$donationMonth <- month(donations$`Donation Date`)


#Sum total amount of money raised for each year
donations <- as.data.frame(aggregate(donations$`Donation Amount`,
                                     by = list(donations$donationYear,
                                               donations$donationMonth
                                               ), FUN = sum))

colnames(donations) <- c('year', 'month', 'donationAmount')

donations$month <- as.factor(donations$month)
levels(donations$month) <- c("Jan", "Feb", "March", "April", "May", "June",
                             "July", "Aug", "Sept", "Oct", "Nov", "Dec")

#Restrict to current year and year before
donations <- donations[which(donations$year == max(donations$year)|
                             donations$year == (max(donations$year) - 1)),]
#Now convert year to a factor for plotting
donations$year <- as.factor(donations$year)

ggplot(data = donations, aes(x = month, y = donationAmount, group = year,
                             color = year)) + geom_line()
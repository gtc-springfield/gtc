
#Initialize new columns
donations$donationYear <- year(donations$Donation.Date)
donations$donationMonth <- month(donations$Donation.Date)


#Sum total amount of money raised for each year
aggDon <- as.data.frame(aggregate(donations$Donation.Amount,
                                     by = list(donations$donationYear,
                                               donations$donationMonth
                                               ), FUN = sum))

colnames(aggDon) <- c('year', 'month', 'donationAmount')

aggDon$month <- as.factor(aggDon$month)
levels(aggDon$month) <- c("Jan", "Feb", "March", "April", "May", "June",
                             "July", "Aug", "Sept", "Oct", "Nov", "Dec")

#Restrict to current year and year before
aggDon <- aggDon[which(aggDon$year == max(aggDon$year)|
                             aggDon$year == (max(aggDon$year) - 1)),]
#Now convert year to a factor for plotting
aggDon$year <- as.factor(aggDon$year)

ggplot(data = aggDon, aes(x = month, y = donationAmount, group = year,
                             color = year)) + geom_line()

#Import data from neon
df <- read_csv("~/Downloads/export.csv",
               col_types = cols(`Account Type` = col_factor(levels =
                                                              c("Individual",
                                                              "Organization")),
                                `Donation Date` = col_date(format = "%m/%d/%Y")))
df <- df[c(1:17)]

#Initialize new columns
df$tenderTypeSimple <- NA
df$donationYear <- NA
df$donationYear <- year(df$`Donation Date`)
df$donationMonth <- NA
df$donationMonth <- month(df$`Donation Date`)
df$yearTotal <- NA

#Populate column that simplifies tender type
df$tenderTypeSimple <- df$`Tender Type`
df$tenderTypeSimple[df$`Tender Type`== "Paypal"
                    | df$`Tender Type`== "Kimbia"
                    | df$`Tender Type`== "Credit Card (Online)"
                    | df$`Tender Type`== "Razoo"] <- "Online"

df$tenderTypeSimple[df$`Tender Type`== "Credit Card (Offline-No Charge)"
                   | df$`Tender Type`== "Cash"
                   | df$`Tender Type`== "Check"
                   | df$`Tender Type`== "In-Kind"] <- "Mail/in-person"

df$tenderTypeSimple[df$`Tender Type`== "Com. Foundation WMA"
                   | df$`Tender Type`== "NFG/TSN"
                   | df$`Tender Type`== "United Way"
                   | df$`Tender Type`== "Stock/Security"
                   | df$`Tender Type`== "Schwab Charitable"
                   | df$`Tender Type`== "Wire Transfer"] <- "Other"


#Sum total amount of money raised for each year
tenderDonationTotal <- as.data.frame(aggregate(df$`Donation Amount`,
                                     by = list(df$donationYear,
                                          df$tenderTypeSimple), FUN = sum))

donationTotal <- as.data.frame(aggregate(df$`Donation Amount`,
                                  by = list(df$donationYear), FUN = sum))
donationTotal$Group.2 <- "Total"
donationTotal <- donationTotal[, c(1,3,2)]

#Add total as new category
totalDonations <- rbind(tenderDonationTotal, donationTotal)

colnames(totalDonations) <- c('year', 'tenderType', 'donationAmount')
totalDonations$tenderType <- as.factor(totalDonations$tenderType)

#Plot attempt 1
ggplot(data = totalDonations, aes(x = year, y = donationAmount,
                                  group = tenderType,
                             color = tenderType)) + geom_line()

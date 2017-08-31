#Valley Gives Report
#All donations to Valley Gives
VGDonors <- filter(donations, grepl("Valley Gives", df$`Campaign Name`))

#All donations not to Valley Gives
notVGDonors <- filter(donations, !grepl("Valley Gives", df$`Campaign Name`))

#Account IDs that are in both dataframes
VGPlusIDs <- intersect(VGDonors$`Account ID`, notVGDonors$`Account ID`)

#All donations with account ID in VGPlusIDs
VGPlusDonors <- subset(donations, `Account ID` %in% VGPlusIDs)

#All donations with account ID not in VGPlusIDs
onlyVGDonors <- subset(VGDonors, !(`Account ID` %in% VGPlusIDs))

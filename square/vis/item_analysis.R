########## AD HOC load the data ########################################
library(readr)
items_2016 <- read_csv("~/Desktop/gtc/square/data/items/items-2016.csv")
items_2017 <- read_csv("~/Desktop/gtc/square/data/items/items-2017.csv")
items_2016$year <- "2016"
items_2017$year <- "2017"
items <- rbind(items_2016, items_2017)


transactions_2016 <- read_csv("~/Desktop/gtc/square/data/transactions/transactions-2016.csv")
transactions_2017 <- read_csv("~/Desktop/gtc/square/data/transactions/transactions-2017.csv")
transactions_2016$year <- "2016"
transactions_2017$year <- "2017"
transactions <- rbind(transactions_2016, transactions_2017)


# ------------------------ Function to output tables --------------------
#(needs more more doesnt work)

######### GET TOP 10 sellers fucntion


library(dplyr)
get_top10sellers <- function(d, cat) {
  cat <- enquo(cat)
  cat_name <- quo_name(cat)
  period <- enquo(period)
  d<- d %>% select(!!cat, Qty, `Net Sales`)%>%
    filter(year ==  !!period)%>%
    arrange(desc(!!cat))%>%
    filter((rank(desc(`Net Sales`))<=10)) 
  return(d)
}
cat_items_2016 <- get_top10sellers(items, Category)

#Error becuase it doesnt understand enquo 





#---------------------------- PLOTS & Tables ----------------------------------

#TABLE 1 : SALES BY CATEGORY (OVERALL)
df$`Net Sales` = as.numeric(gsub("\\$", "", df$`Net Sales`))
 d2<- df %>% select(Category, Qty, `Net Sales`)%>%
  group_by(Category)%>%
  summarise_all(funs(sum)) %>%
  ungroup() %>%
  arrange(desc(`Net Sales`))%>%
  filter((rank(desc(`Net Sales`))<=10))


# PLOT 1 :  TOP 10 CATEGORY SALES 
 ggplot(data=top_items, aes(x=Item, y=Net.Sales, fill=Qty)) +
   geom_bar(stat="identity")

 #TABLE 2 : SALES BY ITEM (OVERALL)
 df$`Net Sales` = as.numeric(gsub("\\$", "", df$`Net Sales`))
 d<- df %>% select(Item, Qty, `Net Sales`)%>%
   group_by(Item)%>%
   summarise_all(funs(sum)) %>%
   ungroup() 
 d2 <- d%>% arrange(desc(`Net Sales`))%>%
   filter((rank(desc(`Net Sales`))<=10))
 
 #PLOT 2 : ITEM TOP 10
 ggplot(data=d2, aes(x=Item, y=`Net Sales`, fill=Qty)) +
   geom_bar(stat="identity")
  
 
  
 
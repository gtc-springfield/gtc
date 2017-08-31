get_topsales <- function(data, cat) {
  cat <- enquo(cat)
  d<- data %>% select(!!cat, Qty, Net.Sales)%>%
    group_by(!!cat)%>%
    summarise_all(funs(sum)) %>%
    ungroup() %>%
    arrange(desc(Net.Sales))
  return(d)
}

datatable_format_pol <- function(data) {
  datatable(data,
            rownames = TRUE, # need row names for slicing
            selection = "single",
            escape = FALSE,
            options = list(
              autoWidth = TRUE,
              columnDefs =
                list(
                  list(visible = FALSE, targets = c(0)),
                  list(type = "num", targets = c(1, 2))
                )
            )
  ) %>%
    formatCurrency(3, currency = "$", digits = 2)
}



output$items_top <- renderPlotly({
 top_items <- get_topsales(items_filter(), Item)
 top_items <- top_items %>%
   filter((rank(desc(Net.Sales))<=10))
 p <- ggplotly( 
   ggplot(data=top_items, aes(x=Item, y=Net.Sales, fill=Qty)) +
                  geom_bar(stat ="identity")
   )
 p
  })

output$items_sales_by_cat <- renderDataTable({
  top_cat <- get_topsales(items_filter(), Category)
  #datatable_format_pol(top_cat)
  top_cat
})

output$items_sales_by_item <- renderPlotly({
  #Plotly Bar Chart
})

output$items_yearly_comp <- renderDataTable({
  #DT table for yearly comparison
})

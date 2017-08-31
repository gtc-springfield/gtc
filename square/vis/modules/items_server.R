get_topsales <- function(data, cat) {
  cat <- enquo(cat)
  d<- data %>% select(!!cat, Qty, Net.Sales)%>%
    group_by(!!cat)%>%
    summarise_all(funs(sum)) %>%
    ungroup() %>%
    arrange(desc(Net.Sales))
  return(d)
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
  dat <- datatable(
    top_cat,
    selection = "single",
    rownames = FALSE,
    options =
      list(
        paging = FALSE,
        searching = FALSE
      )
    ) %>%
    formatCurrency(3, currency = "$", digits = 2)
  return(dat)
})

output$row_selected <- reactive({
  return(!is.null(input$items_sales_by_cat_rows_selected))
})

outputOptions(output, "row_selected", suspendWhenHidden = FALSE)

output$items_sales_by_item <- renderPlotly({
  #Plotly Bar Chart
  i <- input$items_sales_by_cat_rows_selected
})

output$items_yearly_comp <- renderDataTable({
  test <- items %>%
    select(Category, Net.Sales, Year) %>%
    group_by(Category, Year) %>%
    summarise(Net.Sales = sum(Net.Sales))
  test_spread <- test %>% spread(Year, Net.Sales, fill = 0)
  dat <- datatable(
    test_spread,
    selection = "single",
    rownames = FALSE,
    options =
      list(
        paging = FALSE,
        searching = FALSE
      )
  ) %>%
    formatCurrency(c(3, 4), currency = "$", digits = 2)
  return(dat)

})

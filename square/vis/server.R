shinyServer(function(input, output, session){
  trans_filter <- reactive({
    temp <- trans %>% filter(Year == input$year)
    return(temp)
  })

  items_filter <- reactive({
    temp <- items %>% filter(Year == input$year)
    return(temp)
  })

  source("modules/markets_server.R", local = TRUE)
  source("modules/items_server.R", local = TRUE)
})

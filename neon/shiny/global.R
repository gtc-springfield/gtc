
library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)

dt_format <- function(x, year=1917){
  m <- year(x) %% 100
  year(x) <- ifelse(m > year %% 100, 1900+m, 2000+m)
  return(x)
}



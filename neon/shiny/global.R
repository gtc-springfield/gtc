
library(shiny)
#library(shinydashboard)
library(dplyr)
library(lubridate)
library(ggplot2)
#library(rHighcharts)
require(DT)

#if (!require(devtools)) install.packages("devtools")
#devtools:::install_github("massmutual/dcr")
require(dcr)
dt_format <- function(x, year=1917){
  m <- year(x) %% 100
  year(x) <- ifelse(m > year %% 100, 1900+m, 2000+m)
  return(x)
}


renderChart_csv <- function(session, expr, divs = FALSE, env = parent.frame(), quoted = FALSE) {
  func <- shiny::exprToFunction(expr, env, quoted)
  function() {
    chart <- func()
    ## create temporary directory to store temp csv file
    #     if (!dir.exists("dcr_temp")) dir.create("dcr_temp")
    #     singleton(addResourcePath("dcr_temp", "dcr_temp"))
    #     filename <- tempfile(tmpdir = "dcr_temp", fileext = ".csv")
    tdir <- tempdir()
    singleton(addResourcePath("dcr_temp", tdir))
    filename <- tempfile(tmpdir = "", fileext = ".csv")
    filename_abs <- paste0(tdir, filename)
    filename_rel <- paste0("dcr_temp/", filename)
    ## remove temp csv file when session ended
    session$onSessionEnded(function() unlink(filename_abs))
    write.csv(chart@data, file = filename_abs, row.names = FALSE)
    html(chart, divs, csv = TRUE, filename_rel)
  }
}



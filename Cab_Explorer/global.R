

library(shiny)
library(DBI)
library(odbc)
#library(data.table,warn.conflicts = FALSE)
library(shinydashboard)
library(ggplot2)
library(pool)
library(dplyr)
library(dbplyr)
library(lubridate)

mydriver <-  "SQL Server"
myserver <- '.\\snapman'
myDatabase <- 'Cab_Demo'

pool <- dbPool(drv = odbc(),Driver = mydriver,Server = myserver,Database = myDatabase,Trusted_Connection='yes')


#trips_db <- tbl(pool,"yellow_trip_summary_heap")

trips_db <- tbl(pool, "yellow_trip_summary_clustered")

#trips_db <- tbl(pool, "yellow_trip_summary")

#trips_db <- tbl(pool, "yellow_trip_summary_partitioned")






ExecuteSQL <- function(Query,Parameters=NA) {
  queryint <- sqlInterpolate(pool, Query, .dots = Parameters)
  results <- dbGetQuery(pool,queryint)
  return(results)
}







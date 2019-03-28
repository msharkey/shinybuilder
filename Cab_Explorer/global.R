

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


ExecuteSQL <- function(Query,Parameters=NA) {
  queryint <- sqlInterpolate(pool, Query, .dots = Parameters)
  results <- dbGetQuery(pool,queryint)
  return(results)
}

#trips_db <- tbl(pool, "yellow_trip_summary_heap")
### Indexed
#trips_db <- tbl(pool, "yellow_trip_summary")
### Indexed and Partitioned
trips_db <- tbl(pool, "yellow_trip_summary_partitioned")




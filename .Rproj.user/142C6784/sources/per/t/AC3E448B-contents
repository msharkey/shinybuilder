
library(DBI)
library(shiny)
library(odbc)
library(pool)
library(shiny)
library(shinyjs)
library(stringr)

myDriver <- 'SQL Server' # Localhost can be referred to with .
myServer <- '.'
myDatabase <- 'Cab_Demo'

myPool <- dbPool(odbc::odbc(),Driver= myDriver,Server = myServer, Database = myDatabase,Trusted_Connection='yes')


executeSQL <- function(query, parammap = NULL) {
   queryint <- sqlInterpolate(myPool, query, .dots = parammap)
   results <- dbGetQuery(myPool, queryint)
    return(results)
}


emailwhitelist <- "^[[:alnum:].-_]+@[[:alnum:].-]+$"


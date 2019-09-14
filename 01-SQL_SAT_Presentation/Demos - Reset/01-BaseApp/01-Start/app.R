

options(shiny.host = "192.0.0.XX")

library(shiny)
library(DBI)
library(odbc)

con <- dbConnect(drv = odbc(),
                 Driver = 'Sql Server',
                 Server = '.\\oldsnapper',
                 Database = 'Test')

my_ui <- fluidPage()

my_server <- function(input, output) {}

shinyApp(ui = my_ui, server = my_server)
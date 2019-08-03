

library(shiny)
library(DBI)
library(odbc)

con <- dbConnect(drv = odbc(),
                 Driver = 'Sql Server',
                 Server = '.\\snapman',
                 Database = 'Test')

my_ui <- fluidPage()

my_server <- function(input, output) {}

shinyApp(ui = my_ui, server = my_server)
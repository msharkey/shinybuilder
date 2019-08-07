

library(shiny)
library(DBI)
library(odbc)
myserver<- ifelse(Sys.info()["nodename"]=="INFRA035",'.','.\\snapman')
con <- dbConnect(drv = odbc(),
                 Driver = 'Sql Server',
                 Server = myserver,
                 Database = 'Test')

my_ui <- fluidPage()

my_server <- function(input, output) {}

shinyApp(ui = my_ui, server = my_server)
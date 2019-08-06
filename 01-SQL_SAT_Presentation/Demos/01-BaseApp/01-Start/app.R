

library(shiny)
library(DBI)
library(odbc)
library(ggplot2)

my_ui <- fluidPage(
          sidebarLayout(
            sidebarPanel(sliderInput("cpuInput","Minutes",0,256,256)),
          mainPanel(plotOutput('cpuPlot'))
))

my_server <- function(input, output) {
  
  output$cpuPlot <- renderPlot({
  con <- dbConnect(drv = odbc(),
                   Driver = 'Sql Server',
                   Server = '.\\snapman',
                   Database = 'Test')
  myquery <- paste0("Execute dbo.GetCPUutilization ",input$cpuInput)
  
  mydata <-dbGetQuery(con,myquery)
  dbDisconnect(con)
  
  ggplot(mydata,aes(Event_Time,CPU_Utilization))+geom_line()
  
  
  
  })
  
}

shinyApp(ui = my_ui, server = my_server)


library(shiny)
library(DBI)
library(odbc)
library(ggplot2)


my_ui <- fluidPage(
  sidebarLayout( 
    sidebarPanel( sliderInput("cpuSlider","Minutes",min = 0,max = 256,value = 256))
    ,mainPanel(plotOutput('cpuPlot'))
    )
  
)

my_server <- function(input, output) {
  
  output$cpuPlot <- renderPlot({
  myquery <- "Execute getCpuUtilization ?cpuParam"
  con <- dbConnect(drv = odbc(),
                   Driver = 'Sql Server',
                   Server = '.\\oldsnapper',
                   Database = 'Test')
  myqueryint <- sqlInterpolate(con,myquery,.dots = c(cpuParam=input$cpuSlider))
  mydata <- dbGetQuery(con,myqueryint)
  dbDisconnect(con)
  ggplot(mydata,aes(Event_Time,CPU_Utilization))+geom_line()
  })
  
}

shinyApp(ui = my_ui, server = my_server)
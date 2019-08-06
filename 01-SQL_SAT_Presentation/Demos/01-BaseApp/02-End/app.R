

library(shiny)
library(DBI)
library(odbc)



my_ui <- fluidPage(
  sidebarLayout( 
    sidebarPanel( sliderInput("cpuSlider","Minutes",min = 0,max = 256,value = 256))
    ,mainPanel(plotOutput('cpuPlot'))
    )
  
)

my_server <- function(input, output) {
  
  output$cpuPlot <- renderPlot({
  myquery <- paste0("Execute dbo.getCPUutilization ",input$cpuSlider)
  
  con <- dbConnect(drv = odbc(),
                   Driver = 'Sql Server',
                   Server = '.\\snapman',
                   Database = 'Test')
  
  mydata <- dbGetQuery(con,myquery)
  dbDisconnect(con)
  ggplot(mydata,aes(Event_Time,CPU_Utilization))+geom_line()
  })
  
}

shinyApp(ui = my_ui, server = my_server)


library(shiny)
library(DBI)
library(odbc)
library(ggplot2)
myserver<- ifelse(Sys.info()["nodename"]=="INFRA035",'.','.\\snapman')


my_ui <- fluidPage(
  sidebarLayout( 
    sidebarPanel( sliderInput("cpuSlider","Minutes",min = 0,max = 256,value = 256))
    ,mainPanel(plotOutput('cpuPlot'),htmlOutput("frame"))
    )
  
)

my_server <- function(input, output) {
  
  output$cpuPlot <- renderPlot({
  myquery <- paste0("Execute getCpuUtilization ", input$cpuSlider)
  con <- dbConnect(drv = odbc(),
                   Driver = 'Sql Server',
                   Server = myserver,
                   Database = 'Test')
  mydata <- dbGetQuery(con,myquery)
  dbDisconnect(con)
  ggplot(mydata,aes(Event_Time,CPU_Utilization))+geom_line()
  })
  
  
  observe({ 
   
    test <<- "https://stackoverflow.com/questions/33020558/embed-iframe-inside-shiny-app"
  })
  output$frame <- renderUI({
    input$Member
    my_test <- tags$iframe(src=test, height=600, width=535)
    print(my_test)
    my_test
  })
  
}

shinyApp(ui = my_ui, server = my_server)
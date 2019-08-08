

library(shiny)
library(DBI)
library(odbc)
library(ggplot2)
myserver<- ifelse(Sys.info()["nodename"]=="INFRA035",'.','.\\snapman')


my_ui <- fluidPage(
  
    sidebarPanel(sliderInput("cpuSlider","Minutes",0,256,256)),
                 plotOutput("cpuPlot")
)

my_server <- function(input, output) {
  
  
  output$cpuPlot <- renderPlot({
  myquery <- "Execute dbo.GetCPUutilization ?param"
  
  

  
  con <- dbConnect(drv = odbc(),
                   Driver = 'Sql Server',
                   Server = myserver,
                   Database = 'Test')
  
  myqueryint  <- sqlInterpolate(con,myquery,.dots=c(param=input$cpuSlider))  
  mydata <- dbGetQuery(con,myqueryint)
  dbDisconnect(con)
  ggplot(mydata,aes(Event_Time,CPU_Utilization))+geom_line()
  })
}

shinyApp(ui = my_ui, server = my_server)


library(shiny)
library(DBI)
library(odbc)
library(ggplot2)
library(pool)

myserver<- ifelse(Sys.info()["nodename"]=="INFRA035",'.','.\\oldsnapper')

con <- dbPool(drv = odbc(),
                 Driver = 'Sql Server',
                 Server = myserver,
                 Database = 'Test')

my_ui <- fluidPage(
  sidebarLayout( 
    sidebarPanel( sliderInput("cpuSlider","Minutes",min = 0,max = 256,value = 256))
    ,mainPanel(plotOutput('cpuPlot'))
    )
  
)

my_server <- function(input, output) {
  
  output$cpuPlot <- renderPlot({
  myquery <- "Execute dbo.getCpuUtilization ?cpu_slider_param"
  myqueryint <- sqlInterpolate(con,myquery,.dots=c(cpu_slider_param=input$cpuSlider))
  mydata <- dbGetQuery(con,myqueryint)
  ggplot(mydata,aes(Event_Time,CPU_Utilization))+geom_line()
  })
  
}

shinyApp(ui = my_ui, server = my_server)
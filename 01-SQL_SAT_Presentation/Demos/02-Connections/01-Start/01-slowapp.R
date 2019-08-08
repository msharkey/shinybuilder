

library(shiny)
library(DBI)
library(odbc)
library(ggplot2)
library(pool)
source("C:/Users/mshar/OneDrive/Old/Documents/R_UG_Demo/01-SQL_SAT_Presentation/SampleApps/slowdbConnect.R")



myserver<- ifelse(Sys.info()["nodename"]=="INFRA035",'.','.\\snapman')
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
  myquery <- "Execute getCpuUtilization ?cpuParam"

  myqueryint <- sqlInterpolate(con,myquery,.dots = c(cpuParam=input$cpuSlider))
  mydata <- dbGetQuery(con,myqueryint)

  ggplot(mydata,aes(Event_Time,CPU_Utilization))+geom_line()
  })
  
}

shinyApp(ui = my_ui, server = my_server)
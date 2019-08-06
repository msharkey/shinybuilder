


library(DBI)
library(ggplot2)
library(pool)


con <-  dbPool(drv = odbc::odbc(),  Driver = 'Sql Server',Server = '.\\snapman',Database = 'Test',Trusted_Connection='yes')

my_ui <- fluidPage(sidebarPanel(sliderInput("cpu_slider","Minutes Back",0,256,256))
                   , mainPanel(plotOutput("cpuPlot")))

my_server <- function(input, output) {
  
  output$cpuPlot <- renderPlot({
    
   myquery <- paste0("Execute dbo.getCPUutilization ?minRange")
  
    myqueryint <- sqlInterpolate(con,myquery,.dots=c(minRange=input$cpu_slider))

      mydata <- dbGetQuery(con,myqueryint)
      ggplot(mydata,aes(Event_Time,CPU_Utilization)) + geom_line()
  
  })
}

shinyApp(ui = my_ui, server = my_server)
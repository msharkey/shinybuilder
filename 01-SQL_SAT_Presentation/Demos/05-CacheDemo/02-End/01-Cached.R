library(DBI)
library(ggplot2)
library(pool)

tryCatch({
con <-  dbPool(drv = odbc::odbc(),  Driver = 'Sql Server',Server = '.\\snapman',Database = 'Test',Trusted_Connection='yes')
},error = function(e){showModal(modalDialog('Connection Error'))})
my_ui <- fluidPage(sidebarPanel(sliderInput("cpu_slider","Minutes Back",0,256,256))
                   , mainPanel(plotOutput("cpuPlot")))

my_server <- function(input, output) {
  
  output$cpuPlot <- renderCachedPlot({
    
    myquery <- paste0("Execute dbo.getCPUutilization ?minRange")
    
    myqueryint <- sqlInterpolate(con,myquery,.dots=c(minRange=input$cpu_slider))
    
    tryCatch({
      mydata <- dbGetQuery(con,myqueryint)
      ggplot(mydata,aes(Event_Time,CPU_Utilization)) + geom_line()},
      error = function(e){
        showModal(modalDialog('There was an error.'))
      }
    )

  },cacheKeyExpr = input$cpu_slider)
}

shinyApp(ui = my_ui, server = my_server)



library(DBI)
library(ggplot2)
library(pool)


makeCon <- function(){
tryCatch({
dbPool(drv = odbc::odbc(),  Driver = 'Sql Server',Server = '.\\snapman',Database = 'Test',Trusted_Connection='yes')},
error = function(e){
})
}

con<-makeCon()

my_ui <- fluidPage(sidebarPanel(sliderInput("cpu_slider","Minutes Back",0,256,256))
                   , mainPanel(plotOutput("cpuPlot")))

my_server <- function(input, output) {
  
  output$cpuPlot <- renderPlot({
    
    myquery <- paste0("Execute dbo.getCPUutilization ?minRange")
    
    myqueryint <- sqlInterpolate(con,myquery,.dots=c(minRange=input$cpu_slider))
    
    tryCatch({
      mydata <- dbGetQuery(con,myqueryint)
      ggplot(mydata,aes(Event_Time,CPU_Utilization)) + geom_line()
      },
      error = function(e){
        try(if(dbGetQuery(makeCon(),'Select 1')==1){con<<-makeCon()})
        showModal(modalDialog('There was a database error.'))
      })
 
    
   
    
    
  })
}

shinyApp(ui = my_ui, server = my_server)
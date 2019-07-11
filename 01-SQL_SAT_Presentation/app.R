



library(shiny)
library(DBI)
library(odbc)
library(ggplot2)
library(pool)
library(profvis)


mydriver <-  "SQL Server"
myserver <- '.'
myDatabase <- 'Test'


pool <- dbPool(drv = odbc(),Driver = mydriver,Server = myserver,Database = myDatabase,Trusted_Connection='yes')

ui <- fluidPage(

    titlePanel("CPU Last 4 hours"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("minutesRange","Minutes ago",min=0,max=256,value=256)
        ),

        mainPanel(
           plotOutput("cpuPlot")
        )
    )
)


server <- function(input, output) {
    
    output$cpuPlot <- renderPlot({

        query <- "DECLARE @ts_now bigint = (SELECT cpu_ticks/(cpu_ticks/ms_ticks) FROM sys.dm_os_sys_info WITH (NOLOCK)); 
                    
                    SELECT TOP(256) SQLProcessUtilization AS [SQL Server Process CPU Utilization], 
                                   SystemIdle AS [System Idle Process], 
                                   100 - SystemIdle - SQLProcessUtilization AS [CPU_Utilization], 
                                   DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS [Event_Time] 
                    FROM (SELECT record.value('(./Record/@id)[1]', 'int') AS record_id, 
                    			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') 
                    			AS [SystemIdle], 
                    			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') 
                    			AS [SQLProcessUtilization], [timestamp] 
                    	  FROM (SELECT [timestamp], CONVERT(xml, record) AS [record] 
                    			FROM sys.dm_os_ring_buffers WITH (NOLOCK)
                    			WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
                    			AND record LIKE N'%<SystemHealth>%') AS x) AS y 
                    	Where DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE())>=DATEADD(minute,- ?minRange, GETDATE())
                    ORDER BY record_id DESC OPTION (RECOMPILE);"
        
        myquery <- sqlInterpolate(pool,query,.dots=c(minRange=input$minutesRange))
       
        tryCatch({
        results <- dbGetQuery(pool,myquery)
        },error =function(e) {
            showModal(modalDialog(
                h5('There was an error')
            )
            )
        })
        j<- ggplot(results,aes(Event_Time,CPU_Utilization))
        j+ geom_line()
        
       
    })
   
}

shinyApp(ui = ui, server = server)


#profvis(runApp("C:/Users/matthew.sharkey/OneDrive - Buildertrend/Repos/shinybuilder/01-SQL_SAT_Presentation/app.R"))

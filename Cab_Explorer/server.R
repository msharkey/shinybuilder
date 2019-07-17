shinyServer(function(input, output,session) {
  

  output$trips_trended <- renderPlot({
    tripsStart <- Sys.time()
    # Add 1 to end date because the input assumes midnight as time when filtering against column.
     enddate  <- input$enddate+1
    trenddata <- trips_db %>%
      mutate(Trip_Date = as.Date(tpep_dropoff_datetime))  %>% 
      filter(tpep_dropoff_datetime >= !!input$startdate,tpep_dropoff_datetime < enddate,
             trip_distance >= !!input$trip_distance[1],trip_distance <= !!input$trip_distance[2])  %>%
      group_by(Trip_Date) %>%
      summarise(Trip_Count= n())
     #Force Eval to capture query compute time
    compute(trenddata)
    tripsTime <- Sys.time() -tripsStart 
    
    output$query_time <- renderUI({
      valueBox(
        round(tripsTime,3),#usrCount(),
        "Trip Counts Query Time (Seconds)",
        icon = icon("stopwatch")
        
      )})
      trenddata %>%
      ggplot(aes(x=as_date(Trip_Date),y=Trip_Count, group=1)) +
      geom_line( size = 2,color= "#5DBCD2") +
      theme_minimal()+
      theme(axis.title.x=element_blank(),axis.title.y=element_blank() )
    })



 output$payment_bar <-  renderPlot({
   barStart <- Sys.time()
   enddate  <- input$enddate+1
   barsdata <- trips_db  %>%
     filter(tpep_dropoff_datetime >= !!input$startdate,tpep_dropoff_datetime < enddate,
            trip_distance >= !!input$trip_distance[1],trip_distance <= !!input$trip_distance[2])  %>%
     group_by(payment_type) %>%
     summarise(Payment_Count = n()) %>%
     mutate(Payment_Type_Desc =
              case_when(payment_type == 1 ~ "Credit Card",payment_type == 2 ~ "Cash"
                        ,payment_type == 3 ~ "No Charge",payment_type == 4 ~ "Dispute"
                        ,payment_type == 5 ~ "Unkown",payment_type == 6 ~ "Voided",
                        TRUE ~ as.character(payment_type)) 
     )  
   
   compute(barsdata)
   BarsTime <- Sys.time() -barStart
   output$query_time_bars <- renderUI({
     valueBox(
       round(BarsTime,3),#usrCount(),
       "Payment Types",
       icon = icon("stopwatch")
       
     )})
   
   barsdata %>%
       ggplot(aes(x=Payment_Type_Desc,y=Payment_Count))+
       geom_bar(stat="identity",fill="steelblue")+
       coord_flip()+
       theme_minimal()+
       theme(axis.title.y=element_blank())
     
 })
  
  output$tips_heatmap <- renderPlot({

    weekday_labels <- c('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat')
    cut_levels <- c(1, 5, 9, 12, 16, 18, 22)
    hour_labels <- c('1AM-5AM', '5AM-9AM', '9AM-12PM', '12PM-4PM', '4PM-6PM', '6PM-10PM', '10PM-1AM')
    enddate  <- input$enddate+1
    heatmapStart <- Sys.time()
    heatdata <- trips_db  %>%
      filter(tpep_dropoff_datetime >= !!input$startdate,tpep_dropoff_datetime < enddate,
             trip_distance >= !!input$trip_distance[1],trip_distance <= !!input$trip_distance[2])  %>%
      mutate(Hour_Range_Raw = DatePart(hh,tpep_dropoff_datetime),Day_Raw= DatePart(dw,tpep_dropoff_datetime)) %>% 
      group_by(Hour_Range,Day) %>%
      summarise(Avg_Tip = mean(tip_amount))
                                    
        
    compute(heatdata)
    HeatmapTime <- Sys.time() - heatmapStart
    
    output$query_time_heat <- renderUI({
      valueBox(
        round(HeatmapTime,3),#usrCount(),
        "Average Tips",
        icon = icon("stopwatch")
        
      )})

    heatdata$Hour_Range <- factor(heatdata$Hour_Range,levels = c('1AM-5AM', '5AM-9AM', '9AM-12PM', '12PM-4PM', '4PM-6PM', '6PM-10PM', '10PM-1AM'))
    heatdata$Day <- factor(heatdata$Day,levels = c('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat') )
    
    ggplot(heatdata, aes(Day, Hour_Range)) +
      geom_tile(aes(fill = Avg_Tip), colour = "white") +
      theme(
        axis.text=element_text(size=12),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.text = element_text(size=12)
      ) +
      
      scale_fill_gradient(low = "white", high = "steelblue") +
      coord_fixed(ratio = .9)
  })
  
  


})

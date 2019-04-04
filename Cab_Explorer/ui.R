

sidebar <- dashboardSidebar(
  
  sidebarMenu(id="tabs",
              menuItem("Plot", tabName="plot", icon=icon("line-chart"), selected=TRUE, startExpanded = TRUE),
              tabPanel(h5("Filters"),
                       dateInput("startdate", "Start Date:", value = "2018-01-01", format = "mm/dd/yy"),
                       dateInput("enddate", "End Date:", value = "2018-01-04", format = "mm/dd/yy"),
                       sliderInput("trip_distance", "Trip Distance:",  value=c(0,20), min=0, max = 100)
              )
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "plot",
            fluidRow(   uiOutput("query_time"),uiOutput("query_time_heat"),uiOutput("query_time_bars")),
            fluidRow(

              column(width = 12,
                     box(  width = NULL, plotOutput("trips_trended",height="180px"), collapsible = TRUE,
                           title = "Trip Counts", status = "primary", solidHeader = TRUE)
              )),
            
            fluidRow(
              column(width = 6,
                     box(  width = NULL, plotOutput("tips_heatmap",height="180px"), collapsible = TRUE,
                           title = "Average Tips", status = "primary", solidHeader = TRUE)
              ),
              column(width = 6,
                     box(  width = NULL, plotOutput("payment_bar",height="180px"), collapsible = TRUE,
                           title = "Payment Types", status = "primary", solidHeader = TRUE)
              )
              
            )
    )
  )
)

dashboardPage(
  dashboardHeader(title = "Cab Dashboard"),
  sidebar,
  body
)
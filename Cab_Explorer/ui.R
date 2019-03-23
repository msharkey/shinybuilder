


sidebar <- dashboardSidebar(

  sidebarMenu(id="tabs",
              menuItem("Plot", tabName="plot", icon=icon("line-chart"), selected=TRUE),
              menuItem("Table", tabName = "table", icon=icon("table")),
              menuItem("Codes", tabName = "table", icon = icon("file-text-o")),
              menuItem("ReadMe", tabName = "readme", icon=icon("mortar-board")),
              menuItem("About", tabName = "about", icon = icon("question"))
  
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "readme"
    ),
    tabItem(tabName = "plot",
            fluidRow(   uiOutput("query_time"),uiOutput("query_time_heat"),uiOutput("query_time_bars")),
            fluidRow(
              column(width = 2, 
                    
                             tabPanel(h5("Filters"),
                                      dateInput("startdate", "Start Date:", value = "2018-01-01", format = "mm/dd/yy"),
                                      dateInput("enddate", "End Date:", value = "2018-01-31", format = "mm/dd/yy"),
                                      sliderInput("trip_distance", "Trip Distance:",  value=c(0,20), min=0, max = 100)
                             
                     )),
             column(width = 10,
                     box(  width = NULL, plotOutput("trips_trended",height="200px"), collapsible = TRUE,
                           title = "Trip Counts", status = "primary", solidHeader = TRUE)
              )),

             fluidRow(
             column(width = 5,offset = 2,
                    box(  width = NULL, plotOutput("tips_heatmap",height="200px"), collapsible = TRUE,
                          title = "Average Tips", status = "primary", solidHeader = TRUE)
             ),
             column(width = 5,
                    box(  width = NULL, plotOutput("payment_bar",height="200px"), collapsible = TRUE,
                          title = "Payment Types", status = "primary", solidHeader = TRUE)
             )
            
          )
    ),
    tabItem(tabName = "table"
           
    ),
    tabItem(tabName = "pkmodel",
            box( width = NULL, status = "primary", solidHeader = TRUE, title="absorptionModel.txt",                
                 downloadButton('downloadData1', 'Download'),
                 br(),br()
            )
    ),
    tabItem(tabName = "ui",
            box( width = NULL, status = "primary", solidHeader = TRUE, title="ui.R",
                 downloadButton('downloadData2', 'Download'),
                 br(),br(),
                 pre(includeText("ui.R"))
            )
    ),
    tabItem(tabName = "server",
            box( width = NULL, status = "primary", solidHeader = TRUE, title="server.R",
                 downloadButton('downloadData3', 'Download'),
                 br(),br(),
                 pre(includeText("server.R"))
            )
    )
  )
)

dashboardPage(
  dashboardHeader(title = "Cab Dashboard"),
  sidebar,
  body
)

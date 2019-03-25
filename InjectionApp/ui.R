

shinyUI(fluidPage(
   br(),
    mainPanel(
                            br(),
                            fluidRow( h3("Add New Attendee"),
                            br(),
                            sidebarPanel(
                              textInput('email','Email Address',placeholder = 'Please Enter'),
                              selectInput('title','Job Title',c("Select One"= '','Analyst','Data Engineer','Data Scientist','BI Developer')),
                              actionButton('save','Save', icon("save"))
                             
                            ), tableOutput('statustable')),hr(),
                            fluidRow(h3("Update Attendee"),
                                     sidebarPanel( uiOutput('emails_menu')) ,
                                   column(8,  conditionalPanel(
                                       condition = "input.titled != ''",
                                       textInput('emailupdate','Email Address',placeholder = 'Please Select Email'),
                                       selectInput('titleupdate','Job Title',c("Select One"= '','Analyst','Data Engineer','Data Scientist','BI Developer')),
                                       actionButton('updateRow','Update Attendee',icon("edit")),actionButton('DeleteRow','Delete Attendee',icon("trash-alt"))
                                     )
                                     )
                                   )
                            
      
    )
  )
)




# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  output$statustable <- renderTable({
    df <- executeSQL('Select email,jobtitle From dbo.Persons')
  })

  output$emails_menu <- renderUI({
    emails <- dbGetQuery(myPool,'Select email From dbo.Persons')
    selectInput('titled','Search for Email to Edit',c("Select One"= '',emails$email))
  })
  
  
  observeEvent(input$titled,{
    updateTextInput(session,inputId = 'emailupdate',value = input$titled)
  
    params <- c(emailtitle = input$titled)
    jt <- executeSQL("Select jobtitle From dbo.Persons Where email =?emailtitle",params)
    
   updateSelectInput(session,inputId = 'titleupdate',selected =   jt$jobtitle)
  })
  
  observeEvent(input$updateRow,{
    dbGetQuery(myPool,paste0("UPDATE dbo.Persons SET Email = '",input$emailupdate,"',
                                                  jobtitle=  '",input$titleupdate,"'
                             Where email ='",input$titled,"'"))
    output$statustable <- renderTable({
      df <- executeSQL('Select * From dbo.Persons')
    })
    output$emails_menu <- renderUI({
      emails <- dbGetQuery(myPool,'Select email From dbo.Persons')
      selectInput('titled','Search for Email to Edit',c("Select One"= '',emails$email))
    })
    
    updateSelectInput(session,inputId = 'titled',selected = input$emailupdate)
    
    
  })
  
  observeEvent(input$DeleteRow,{
    showModal(modalDialog(paste0('Are you sure you want to delete ',input$titled,"?  Click Dismiss to cancel."),
                         br(), br(),actionButton('ConfirmDelete','Yes')))
  })
  
  observeEvent(input$ConfirmDelete,{
    dbGetQuery(myPool,paste0("DELETE From dbo.Persons WHERE Email = '",input$titled,"'"))
    
    output$statustable <- renderTable({
      df <- executeSQL('Select * From dbo.Persons')
    })
    
    updateSelectInput(session,inputId = 'titled',selected = '')
    
    
    removeModal()
    
  })
  
  observeEvent(input$save,{
    #unsecureInsert(input$email,input$title)
    #saferInsert(input$email,input$title)
    saferInsert_whitelist(input$email,input$title)
    
    output$statustable <- renderTable({
      df <- executeSQL('Select Email,Jobtitle From dbo.Persons')
      })
    
    output$emails_menu <- renderUI({
      emails <- executeSQL('Select email From dbo.Persons')
      selectInput('titled','Email',c("Select One"= '',emails$email))
    })
    
  })
  
  

  
  
})





library(DBI)
library(shiny)
library(odbc)
library(pool)
library(shiny)
library(shinyjs)
library(stringr)

myDriver <- 'SQL Server' # Localhost can be referred to with .
myServer <- '.\\snapman'
myDatabase <- 'Cab_Demo'

myPool <- dbPool(odbc::odbc(),Driver= myDriver,Server = myServer, Database = myDatabase,Trusted_Connection='yes')


executeSQL <- function(query, parammap = NULL) {
   queryint <- sqlInterpolate(myPool, query, .dots = parammap)
   results <- dbGetQuery(myPool, queryint)
    return(results)
}




unsecureInsert <- function(usr_email,usr_title){
  tryCatch({
    dbGetQuery(myPool,paste0("Insert into dbo.Persons values ('",usr_email,"','",usr_title,"')"))
  }
  ,error =function(e) {
    showModal(modalDialog(
      if(length(grep('PRIMARY KEY constraint',e$message))==1){h5('Email Already Exists')} else{e$message}
    )
    )
  })
}


saferInsert <- function(usr_email,usr_title){
tryCatch({
  # Repeating code for demo
    params <- c(email = usr_email,title = usr_title)
    query <- "Insert into dbo.Persons values (?email,?title)"
    queryint <- sqlInterpolate(myPool, query, .dots = params)
    dbGetQuery(myPool, queryint)
   
}
,error =function(e) {
  showModal(modalDialog(
    if(length(grep('PRIMARY KEY constraint',e$message))==1){h5('Email Already Exists')} else{e$message}
  )
  )
})
}

emailwhitelist <- "^[[:alnum:].-_]+@[[:alnum:].-]+$"

saferInsert_whitelist <- function(usr_email,usr_title){
  tryCatch({
    if(!is.na(str_match(usr_email, emailwhitelist))){
      params <- c(email = usr_email,title = usr_title)
      executeSQL("Insert into dbo.Persons values (?email,?title)",params)
    } else {stop("Not a valid email.")}
  }
  ,error =function(e) {
    showModal(modalDialog(
      if(length(grep('PRIMARY KEY constraint',e$message))==1){h5('Email Already Exists')} else{e$message}
    )
    )
  })
}




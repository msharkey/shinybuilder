
library(DBI)

dbConnect <- function(drv,Driver,Server,Database){
  Sys.sleep(1.5) 
  conn <<- DBI::dbConnect(drv = drv,  Driver = Driver ,Server = Server,Database = Database)
   return(conn)
  }


#verify IP

options(shiny.host = "192.168.1.4")

#profvis(runApp("C:/Users/mshar/OneDrive/Old/Documents/R_UG_Demo/01-SQL_SAT_Presentation/slowapp.R"))
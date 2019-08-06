
library(DBI)

dbConnect <- function(drv,Driver,Server,Database){
  Sys.sleep(1.5) 
  conn <<- DBI::dbConnect(drv = drv,  Driver = Driver ,Server = Server,Database = Database)
   return(conn)
  }

#profvis(runApp("C:/Users/mshar/OneDrive/Old/Documents/R_UG_Demo/01-SQL_SAT_Presentation/slowapp.R"))
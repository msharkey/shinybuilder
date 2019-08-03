
library(DBI)

dbConnect <- function(drv,Driver,Server,Database,Trusted_Connection){
  Sys.sleep(2) 
  conn <<- DBI::dbConnect(drv = drv,  Driver = Driver ,Server = Server,Database = Database,Trusted_Connection=Trusted_Connection)
   return(conn)
  }

#profvis(runApp("C:/Users/mshar/OneDrive/Old/Documents/R_UG_Demo/01-SQL_SAT_Presentation/slowapp.R"))
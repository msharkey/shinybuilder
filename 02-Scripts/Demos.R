

## Demos


##Performance

library(odbc)
library(DBI)
library(tidyverse)
library(microbenchmark)
con <- dbConnect(odbc(),Driver = 'SQL Server',Server = '.\\snapman', Database = 'Cab_Demo', trusted_connection = TRUE)
dbExecute(con,"DROP INDEX IF EXISTS nc_yellow_trip_tpep_dropoff_datetime ON [yellow_tripdata_2018-01] ")

trips_fs <- read_csv('D:/Cab_data/yellow_tripdata_2018-01.csv')

trips_db <- tbl(con, "yellow_tripdata_2018-01")

fs<- function(){trips_fs %>%
    filter(tpep_dropoff_datetime >= '2018-01-02 07:28:00',tpep_dropoff_datetime <= '2018-01-02 07:30:00') %>%
    summarise(pcount= n())}

db<- function(){trips_db %>%
    filter(tpep_dropoff_datetime >= '01-02-2018 13:28',tpep_dropoff_datetime <= '01/02/2018 13:30')  %>%
    summarise(pcount= n())}

microbenchmark(print(db()),print(fs()),times = 10)

dbExecute(con,'CREATE NONCLUSTERED INDEX nc_yellow_trip_tpep_dropoff_datetime 
               ON [yellow_tripdata_2018-01](tpep_dropoff_datetime)')

microbenchmark(print(db()),print(fs()),times = 10)


##


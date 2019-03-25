

url <- "https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2018-05.csv"

download.file(url,"D:/Cab_Data/yellow_tripdata_2018-05.csv")
getwd()




list.files("C:/Users/mshar/OneDrive/Documents/R_UG_Demo/InjectionApp")
library(kableExtra)
library(dbplyr)
library(odbc)
library(DBI)
library(microbenchmark)
library(tidyverse)


## Load Data
con <- dbConnect(odbc(),Driver = 'SQL Server',Server = '.\\snapman', Database = 'Cab_Demo', trusted_connection = TRUE)

# Need to give breif intro to data set
# Bad Defaults, generates varchar(255) instead of proper , Allows NULLS for every data type 

trips_fs <- read_csv('D:/Cab_Data/yellow_tripdata_2018-01.csv',n_max = 10)
if(dbExistsTable(con, "yellow_trip_summary_model")){dbRemoveTable(con , 'yellow_trip_summary_model')}
dbCreateTable(con,'yellow_trip_summary_model',tips_fs)

## Generate Table with tsql


## Each Row is inserted one at a time, not fast at all
trips_fsf <- read_csv('D:/Cab_Data/yellow_tripdata_2018-01.csv')
dbWriteTable(con,"yellow_trip_summary",tips_fsf,append =TRUE)


# Benchmark dbWrite table with BULK INSERT method



## Reading from file vs reading from 

trips_db <- tbl(con, "yellow_trip_summary")

fs<- function(){tips_fsf %>%
  filter(tpep_dropoff_datetime >= '2018-01-02 07:28:00',tpep_dropoff_datetime <= '2018-01-02 07:30:00') %>%
  summarise(pcount= n())}

db<- function(){tips_db %>%
  filter(tpep_dropoff_datetime >= '01-02-2018 13:28',tpep_dropoff_datetime <= '01/02/2018 13:30')  %>%
  summarise(pcount= n())}

#Create Index with DBI, then re-run benchmark, explain 

microbenchmark(print(db()),print(fs()),times = 20)

# Index Phone Book

# What do you need to index? FPOC

#don't forget indexes have overhead



##covering example
  
  trips_db %>% 
  filter(tpep_dropoff_datetime >= '2018-01-02 07:28:00',tpep_dropoff_datetime <= '2018-01-03 07:30:00') %>%
  transmute(fair_total = tip_amount+fare_amount) %>% 
  summarise(sumt = sum(fair_total)) %>%
  
  ##with cold cache, this query runs in sub seconds with covering query, 15 seconds without 


## OSHFA Query
    
    
  if(dbExistsTable(con, "starwars")){dbRemoveTable(con , 'starwars')}
  dbCreateTable(con,'starwars',starwars)
  dbWriteTable(con,'starwars',starwars,append=TRUE)

head(starwars)



flights_db %>% 
  group_by(dest) %>%
  summarise(delay = mean(dep_time)) %>%
  explain()


tailnum_delay_db <- flights_db %>% 
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay),
    n = n()
  ) %>% 
  arrange(desc(tpep_dropoff_datetime)) %>%
  filter(n > 100) %>% show_query()

flights_db <- tbl(con, "flights")







Sstart_time <- Sys.time()

##executesql()
trips_db  %>%
  group_by(payment_type) %>%
  filter(tpep_pickup_datetime > '2018-01-15 00:00:00',trip_distance > 5) %>%
  summarise(pcount= n(),avgfair = mean(total_amount))%>%
  show_query()
 # ggplot()+geom_bar(aes(payment_type,pcount),stat="identity")
Send_time <- Sys.time()


start_time <- Sys.time()

lsf.str("package:dbplyr")

##executedplyr()

trips_db %>% 
  #db_list_tables() %>% show_query()
  select(tpep_pickup_datetime,trip_distance,payment_type) %>%
  filter(tpep_pickup_datetime > '2018-01-15 00:00:00',trip_distance > 5) %>%
  group_by(payment_type) %>%
  summarise(pcount = count()) %>%
  
  show_query()
  #ggplot()+geom_bar(aes(payment_type,pcount),stat="identity")
end_time <- Sys.time()
Send_time - Sstart_time
end_time - start_time

microbenchmark(
    executesql(),executedplyr(),times = 10L
)

view(hr)

sqlAppendTable()
df2 %>%
  group_by(a1) %>%
  mutate(b2=as.Date(b2, format = "%d.%m.%Y"))




url <- "https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2018-01.csv"

download.file(url,"bofa_yellow_tripdata_2018-01.csv")

library(dbplyr)
library(dplyr)
library(odbc)
library(DBI)
library(microbenchmark)
library(tidyverse)

con <- dbConnect(odbc(),Driver = 'SQL Server',Server = '.', Database = 'Cab_Demo', trusted_connection = TRUE)

trips_db <- tbl(con,"yellow_trip_summary")
tips_fs <- read_csv('D:/Software/statistics-for-data-scientists/data/yellow_tripdata_2018-01.csv')

db_write_table(con,'Harry' ,'numeric',5)
db_create_table(con,'Harry',) %>% show_query()
  
  dbGetQuery(con,'Select payment_type,count(1)
                  From dbo.yellow_trip_summary
                  group by payment_type')

executesql <- function(){
  df <-  dbGetQuery(con,'Select top 10 payment_type as himom,count(1)
                  From dbo.yellow_trip_summary
                    group by payment_type')
  df 
  
}


executedplyr <- function(){
  
 trips_db %>% 
    group_by(payment_type) %>%
    summarise(pcount = count()) %>%
    show_query()
  
}

install.packages('nycflights13')
copy_to(con, nycflights13::flights, "flights",
  temporary = FALSE, 
  indexes = list(
    c("year", "month", "day"), 
    "carrier", 
    "tailnum",
    "dest"
  )
)

untrustedRow <- data.frame(5,	21.2	,6.2,	16.0,	110.2,	3.9,
                           2.62,	16.46,	5.0	,1.0	,4.6,
                           row.names = "'Rick James',5,2,6,2,1,3,2,1,5,1,4); Create Table dbo.HarrysBar(c1 INT);--")

names(untrustedRow) <- names(mtcars)
##nmcars <- rbind(mtcars,untrustedRow)

dbWriteTable(con, "mtcars",untrustedRow, append = TRUE)



sapply(mtcars, class)
sapply(nmcars, class)

class(mtcars)
class(nmcars)

%>% show_query()
db_write_table(con,table = 'harry',mtcars) %>% show_query()

nrow(tailnum_delay_db)
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
  arrange(desc(delay)) %>%
  filter(n > 100) %>% show_query()

flights_db <- tbl(con, "flights")


sql <- sqlAppendTable(con,"mtcars",untrustedRow)

sanitized <- sqlInterpolate(con,sql)

dbExecute(con,sanitized)

cars_db <- tbl(con,"mtcars")

cars_db %>% select(row_names)


%>% show_query()



Sstart_time <- Sys.time()

##executesql()
tips_fs %>%
  filter(tpep_pickup_datetime > '2018-01-15 00:00:00',trip_distance > 5) %>%
  
  group_by(payment_type) %>%
  summarise(pcount= n())#%>%
  
  #show_query()
 # ggplot()+geom_bar(aes(payment_type,pcount),stat="identity")
Send_time <- Sys.time()


start_time <- Sys.time()

lsf.str("package:dbplyr")

##executedplyr()

trips_db %>% 
  db_list_tables() %>% show_query()
  #select(tpep_pickup_datetime,trip_distance,payment_type) %>%
  filter(tpep_pickup_datetime > '2018-01-15 00:00:00',trip_distance > 5) %>%
  group_by(payment_type) %>%
  summarise(pcount = count())# %>%
  
  #show_query()
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


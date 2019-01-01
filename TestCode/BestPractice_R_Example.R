library(tidyverse)

library(dbplyr) # database interaction for dplyr
library(DBI)    # R database interface
library(odbc)   # the database backend handler for Microsoft SQL Server

library(base64enc) # simple obfuscation for passwords
library(DT)     # pretty-print tables/tibbles

filename <- 'BestPracticeSQL_password.txt'
dbpassword <- rawToChar(base64decode(readChar(filename,file.info(filename)$size)))
# obfuscated, NOT ENCRYPTED, password
# password file created with command like
#    cat(base64encode(charToRaw('mypassword')), file="BestPracticeSQL_password.txt")

con <- DBI::dbConnect(odbc::odbc(), driver = "SQL Server", server = "127.0.0.1\\BPSINSTANCE", 
                      database = "BPSSamples", uid = "bpsviewer", pwd = dbpassword)

current_rx <- tbl(con, in_schema('dbo','BPS_CurrentRx'))
patients <- tbl(con, in_schema('dbo','BPS_Patients'))

rx_with_name <- current_rx %>%
  left_join(patients, by='InternalID') %>%
  select(c('DrugName','Firstname','Surname')) %>%
  collect()     # store the results in a 'real', rather than 'virtual' tibble

datatable(rx_with_name)

DBI::dbDisconnect(con)
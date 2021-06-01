# LIBRARIES ####
library(here)
library(tidyverse)
library(odbc)
library(DBI)
library(janitor)
library(keyringr)

# FUNCTIONS ####
get_conn <- function() {
  if ( DBI::dbCanConnect(odbc::odbc(), "oracle") ) {
    # set connection using DSN entry, if exists
    conn <- DBI::dbConnect(odbc::odbc(), "oracle")
  } else {
    # otherwise use manual connection variables
    conn <- DBI::dbConnect(odbc::odbc(),
                          Driver = "Oracle",
                          DBQ    = "readonlybannerdb.dixie.edu:1541/BRPT",
                          UID    = decrypt_kc_pw("dsu_banner_username"),
                          PWD    = decrypt_kc_pw("dsu_banner_password") )
  }
  return(conn)
}

get_data_from_sql <- function(file_name) {
  conn <- get_conn()
  df <- dbGetQuery( conn, read_file( here::here('sql', file_name) ) ) %>% 
    mutate_if(is.factor, as.character) %>% 
    clean_names() %>% 
    as_tibble()
  return(df)
}

load_data_from_rds <- function(file_name) {
  df <- readRDS( here::here('data', file_name) )
  return(df)
}

save_data_as_rds <- function(df, file_name) {
  saveRDS(df, file=here::here('data', file_name), compress=FALSE )  
}
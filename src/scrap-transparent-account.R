library(dplyr)
library(rvest)
library(janitor)

args <- commandArgs(trailingOnly = TRUE)

START_DATE <- args[1]
END_DATE <- args[2]

if(length(args) == 0){
    END_DATE <- Sys.Date() - 1
    START_DATE <- Sys.Date() - 8
}

TRANSPARENT_ACCOUNT_URL <- "https://ib.fio.cz/ib/transparent?a=20308993"

convert_to_dmy <- function(x){
    format(as.Date(x), "%d.%m.%Y")
}

construct_url <- function(base_url, start_date, end_date){
    paste0(
        base_url,
        "&f=",
        convert_to_dmy(start_date),
        "&t=",
        convert_to_dmy(end_date)
    )
}

convert_amount <- function(x){
    gsub(",", ".", x) %>%
        stringr::str_remove_all(., "\\s") %>%
        stringr::str_remove_all(., "\u00A0") %>%
        stringr::str_extract(., "[-0-9.]+") %>%
        as.numeric()
}

URL <- construct_url(TRANSPARENT_ACCOUNT_URL, START_DATE, END_DATE)

html <- read_html(URL)

payments <- html %>%
    html_nodes("table") %>%
    `[[`(2) %>%
    html_table()

payments_clean <- payments %>%
    clean_names() %>%
    mutate(datum = as.Date(datum, format = "%d.%m.%Y"),
           castka = convert_amount(castka)) %>%
    mutate(datum = as.character(datum))

if(!file.exists("output/money.csv")){
    write.csv(payments_clean, "output/money.csv", row.names = FALSE)
}else{
    old_data <- read.csv("output/money.csv")
    updated_data <- bind_rows(old_data, payments_clean) %>%
        arrange(desc(datum))
    write.csv(updated_data, "output/money.csv", row.names = FALSE)
}

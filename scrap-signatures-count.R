library(rvest)
library(dplyr)
library(RSelenium)

url <- "https://lidepro.cz/podpisy"

selenium_check <- system("docker ps | grep selenium", intern = TRUE)

if(length(selenium_check) == 0){
    system("docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.1")
}

remDr <- remoteDriver(
    remoteServerAddr = "localhost",
    port = 4445L,
    browserName = "firefox"
)

remDr$open()
remDr$navigate(url)

time <- Sys.time()
html <- remDr$getPageSource()

signatures_count <- read_html(html[[1]]) %>%
    html_node(".sign-count") %>%
    html_text() %>%
    gsub("\\s", "", .) %>%
    as.numeric()

data <- tibble::tibble(
    time = as.character(time),
    signatures_count = signatures_count
)

old_data <- read.csv("output.csv")
data <- bind_rows(old_data, data)

write.csv(data, "output.csv", row.names = FALSE)

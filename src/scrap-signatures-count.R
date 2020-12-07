library(rvest)
library(RSelenium)

url <- "https://lidepro.cz/podpisy"

# selenium_check <- system("docker ps | grep selenium", intern = TRUE)
#
# if(length(selenium_check) == 0){
#     system("docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.1")
# }

remDr <- remoteDriver(
    remoteServerAddr = "localhost",
    port = 4445L,
    browserName = "firefox"
)

remDr$open()
remDr$navigate(url)

time <- Sys.time()
html <- remDr$getPageSource()

html_source <- read_html(html[[1]])
sign_text <- html_text(html_node(html_source, ".sign-count"))
signatures_count <- as.numeric(gsub("\\s", "", sign_text))

print(signatures_count)

data <- data.frame(
    time = as.character(time),
    signatures_count = signatures_count
)

old_data <- read.csv("output/output.csv")
data <- rbind(old_data, data)

write.csv(data, "output/output.csv", row.names = FALSE)

library(dplyr)
library(ggplot2)

money <- read.csv("output/money.csv") %>%
    mutate(datum = as.Date(datum))

options(scipen = 999)

money %>%
    mutate(income = castka > 0) %>%
    group_by(datum, income) %>%
    summarise(amount = sum(castka)) %>%
    ggplot(., aes(x = datum, y = amount, fill = income)) +
    geom_bar(stat = "identity") +
    theme_minimal() +
    scale_x_date(labels = scales::date_format("%d.%m.")) +
    scale_y_continuous(breaks = c(250000, 0, -250000, -500000, -1000000)) +
    theme(legend.position = "none") +
    labs(x = "", y = "Součet příjmů/výdajů (v CZK)",
         title = "Pohyby na transparentním účtu Lidé PRO",
         caption = "Autor: Michael Škvrňák\nData: https://ib.fio.cz/ib/transparent?a=20308993\nZdrojový kód: github.com/skvrnami/lide-pro")

ggsave("output/money.png",
       width = 6,
       height = 4,
       units = "in")

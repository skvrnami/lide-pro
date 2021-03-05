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
    scale_y_continuous(breaks = c(3000000, 2000000, 1000000, 0, -1000000),
                       labels = c("3 mil.", "2 mil.", "1 mil.", "0", "-1 mil.")) +
    theme(legend.position = "none") +
    labs(x = "", y = "Součet příjmů/výdajů (v CZK)",
         title = "Pohyby na transparentním účtu Lidé PRO",
         caption = "Autor: Michael Škvrňák\nData: https://ib.fio.cz/ib/transparent?a=20308993\nZdrojový kód: github.com/skvrnami/lide-pro")

ggsave("output/money.png",
       width = 6,
       height = 4,
       units = "in")

money %>%
    mutate(income = castka > 0) %>%
    filter(income) %>%
    count(datum) %>%
    ggplot(., aes(x = datum, y = n)) +
    geom_bar(stat = "identity") +
    theme_minimal() +
    scale_x_date(labels = scales::date_format("%d.%m.")) +
    scale_y_continuous() +
    theme(legend.position = "none") +
    labs(x = "", y = "Počet darů poslaných na transparentní účet",
         title = "Pohyby na transparentním účtu Lidé PRO",
         caption = "Autor: Michael Škvrňák\nData: https://ib.fio.cz/ib/transparent?a=20308993\nZdrojový kód: github.com/skvrnami/lide-pro")

ggsave("output/money_count.png",
       width = 6,
       height = 4,
       units = "in")



library(ggplot2)

data <- read.csv("output.csv")
data$time <- as.POSIXct(data$time, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

one_third <- (max(data$time) - as.POSIXct("2020-12-03")) / 3
label_position <- as.POSIXct("2020-12-03") + one_third

ggplot(data, aes(x = time, y = signatures_count)) +
    geom_point(alpha = 0.2) +
    geom_line() +
    annotate(
        geom = "curve", x = label_position, y = 4000,
        xend = as.POSIXct("2020-12-03"), yend = 0,
        curvature = .3, arrow = arrow(length = unit(2, "mm"))
    ) +
    annotate(geom = "text", x = label_position, y = 4000,
             label = "založení hnutí", hjust = "left") +
    theme_minimal() +
    # xlim(c(as.POSIXct("2020-12-03"), max(data$time))) +
    ylim(c(0, max(data$signatures_count) * 1.2)) +
    scale_x_datetime(labels = scales::date_format("%d.%m.")) +
    labs(x = "",
         y = "Počet sebraných podpisů",
         title = "Vývoj počtu sebraných podpisů hnutí Lidé PRO",
         caption = "Data: https://lidepro.cz/podpisy\nAutor: Michael Škvrňák\nZdrojový kód: github.com/skvrnami/lide-pro")

ggsave("signatures.png")

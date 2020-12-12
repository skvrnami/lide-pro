library(ggplot2)

data <- read.csv("output/output.csv")
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
    ylim(c(0, max(data$signatures_count, na.rm = TRUE) * 1.2)) +
    scale_x_datetime(labels = scales::date_format("%d.%m.")) +
    labs(x = "",
         y = "Počet sebraných podpisů",
         title = "Vývoj počtu sebraných podpisů hnutí Lidé PRO",
         caption = "Autor: Michael Škvrňák\nData: https://lidepro.cz/podpisy\nZdrojový kód: github.com/skvrnami/lide-pro")

ggsave("output/signatures.png",
       width = 6,
       height = 4,
       units = "in")

data_start <- data.frame(
    time = as.POSIXct("2020-12-03 08:00:00", tz = "UTC"),
    signatures_count = 0
)

complete_data <- rbind(data_start, data)
complete_data <- complete_data[-c(3), ]
complete_data <- complete_data[!is.na(complete_data$signatures_count), ]
complete_data$lagged_time <- as.POSIXct(sapply(1:nrow(complete_data),
                                               function(x) complete_data$time[x + 1]),
                                        origin = "1970-01-01", tz = "UTC")
complete_data$lagged_signatures <- sapply(1:nrow(complete_data),
                                          function(x) complete_data$signatures_count[x + 1])
complete_data$time_diff <- difftime(complete_data$lagged_time, complete_data$time, units = "mins")
complete_data$signatures_diff <- complete_data$lagged_signatures - complete_data$signatures_count
complete_data$signatures_p_h <- complete_data$signatures_diff / (as.numeric(complete_data$time_diff) / 60)

ggplot(complete_data, aes(x = time, y = signatures_p_h)) +
    geom_step() +
    theme_minimal() +
    scale_x_datetime(labels = scales::date_format("%d.%m.")) +
    labs(x = "",
         y = "Počet sebraných podpisů/hodinu",
         title = "Rychlost sběru podpisů hnutí Lidé PRO",
         caption = "Autor: Michael Škvrňák\nData: https://lidepro.cz/podpisy\nZdrojový kód: github.com/skvrnami/lide-pro")

ggsave("output/signatures_speed.png",
       width = 6,
       height = 4,
       units = "in")



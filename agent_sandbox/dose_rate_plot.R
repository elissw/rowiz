# Load the MoViz package
library(MoViz)
library(ggplot2)

# Load the dataframe
df <- read.csv("items_TFA_sherpa_2025_a_itm.csv")

# Create the distribution plot for dose rate at 10cm
binwidth_dr <- freedman_diaconis_binwidth_log(df$DR_10cm_uSv_h)

plot_dr_distribution <- ggplot(df) +
  geom_histogram_custom("DR_10cm_uSv_h", binwidth_dr, "cadetblue") +
  scale_x_log10() +
  labs(x = "Dose rate @ 10cm [uSv/h]", y = "Number of items") +
  theme_professional()

# Save the plot using ggsave instead
ggplot2::ggsave("dose_rate_distribution_10cm.png", plot_dr_distribution, 
                width = 7, height = 5, dpi = 300)

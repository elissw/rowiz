# Load the MoViz package
library(MoViz)
library(ggplot2)
library(patchwork)

# Load the dataframe
df <- read.csv("items_TFA_sherpa_2025_a_itm.csv")

# Calculate binwidths
binwidth_dr <- freedman_diaconis_binwidth_log(df$DR_10cm_uSv_h)

# Create plot for 10cm
plot_10cm <- ggplot(df) +
  geom_histogram_custom("DR_10cm_uSv_h", binwidth_dr, "cadetblue") +
  scale_x_log10() +
  labs(x = "Dose rate @ 10cm [uSv/h]", y = "Number of items") +
  theme_professional()

# Create plot for 40cm
plot_40cm <- ggplot(df) +
  geom_histogram_custom("DR_40cm_uSv_h", binwidth_dr, "coral") +
  scale_x_log10() +
  labs(x = "Dose rate @ 40cm [uSv/h]", y = "Number of items") +
  theme_professional()

# Stack plots vertically
plot_combined <- patchwork::wrap_plots(
  plot_10cm, plot_40cm,
  ncol = 1,
  nrow = 2
)

# Display the plot
print(plot_combined)

# Save the plot using ggsave
ggplot2::ggsave("dose_rate_distribution_10cm_40cm.png", plot_combined, 
                width = 7, height = 10, dpi = 300)

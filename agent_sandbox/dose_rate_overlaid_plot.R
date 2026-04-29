# Load the MoViz package
library(MoViz)
library(ggplot2)

# Load the dataframe
df <- read.csv("items_TFA_sherpa_2025_a_itm.csv")

# Calculate binwidth
binwidth_dr <- freedman_diaconis_binwidth_log(df$DR_10cm_uSv_h)

# Create overlaid plot for dose rate at both distances
plot_dr_comparison <- ggplot(df) +
  geom_histogram_custom("DR_10cm_uSv_h", binwidth_dr, "cadetblue") +
  geom_histogram_custom("DR_40cm_uSv_h", binwidth_dr, "coral") +
  scale_x_log10() +
  labs(x = "Dose rate [uSv/h]", y = "Number of items") +
  theme_professional() +
  ggplot2::annotate("text", x = Inf, y = Inf,
    label = "@ 10 cm", color = "cadetblue", size = 5,
    hjust = 1.1, vjust = 1.1) +
  ggplot2::annotate("text", x = Inf, y = Inf,
    label = "@ 40 cm", color = "coral", size = 5,
    hjust = 1.1, vjust = 4)

# Display the plot
print(plot_dr_comparison)

# Save the plot using ggsave
ggplot2::ggsave("dose_rate_comparison_overlaid.png", plot_dr_comparison, 
                width = 7, height = 5, dpi = 300)

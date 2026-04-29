# Load the MoViz package
library(MoViz)
library(ggplot2)
library(ggridges)
library(patchwork)

# Load the dataframe
df <- read.csv("items_TFA_sherpa_2025_a_itm.csv")

# Create the irradiation parameters plot
plot_irradiation_params <- plot_irradiation(df)

# Save the plot using ggsave
ggplot2::ggsave("irradiation_parameters.png", plot_irradiation_params, 
                width = 14, height = 5, dpi = 300)

print("Plot saved as irradiation_parameters.png")

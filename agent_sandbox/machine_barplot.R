# Load the MoViz package
library(MoViz)
library(ggplot2)
library(dplyr)

# Load the dataframe
df <- read.csv("items_TFA_sherpa_2025_a_itm.csv")

# Label machines
df <- label_machines(df)

# Count items by machine and calculate percentages
df_machine_counts <- df |>
  dplyr::filter(component_id == 0) |>
  dplyr::group_by(machine_labelled) |>
  dplyr::summarise(count = n(), .groups = 'drop') |>
  dplyr::mutate(percentage = round(count / sum(count) * 100, 1))

# Use the machine order from label_machines
machine_order <- c(
  "Lin2","Lin4","PSB","PS","SPS","LHC", "LHC experiments"
)

# Ensure all machines are in the order, even if they don't appear in data
df_machine_counts$machine_labelled <- factor(df_machine_counts$machine_labelled, 
                                              levels = machine_order)

# Create horizontal barplot
plot_machines <- ggplot(df_machine_counts) +
  geom_col(aes(x = machine_labelled, y = percentage), 
           fill = "cadetblue") +
  coord_flip() +
  theme_professional() +
  ggplot2::theme(axis.line.x = ggplot2::element_blank(),
                 axis.ticks.x = ggplot2::element_blank(),
                 axis.text.x = ggplot2::element_blank(),
                 axis.title.x = ggplot2::element_blank(),
                 axis.title.y = ggplot2::element_blank(),
                 panel.grid.major = ggplot2::element_blank()) +
  labs(x = "", y = "") +
  ggplot2::geom_text(aes(x = machine_labelled, y = percentage, 
                         label = paste0(percentage, "%")),
                     hjust = -0.3, size = 5) +
  ggplot2::expand_limits(x = c(0.5, NA), y = c(0, max(df_machine_counts$percentage) * 1.15))

# Display the plot
print(plot_machines)

# Save the plot using ggsave
ggplot2::ggsave("machine_distribution.png", plot_machines, 
                width = 8, height = 6, dpi = 300)

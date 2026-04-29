# MoViz: Visualisation package for Mowiz

MoViz is an R package designed to create standardized visualizations for data coming out of mowiz. It provides a collection of plotting functions with a consistent aesthetic specifically tailored for our analysis.

## Purpose

When working on different characterisation projects, it's important to maintain visual consistency and follow best practices for scientific visualization. MoViz handles this by providing pre-configured plotting functions that automatically apply professional styling and follow radiological data conventions.

## Key Features

- **Consistent Styling**: All plots use a unified professional theme with proper grid, fonts, and spacing
- **Radiological Context**: Built-in functions for distributions of dose rate, counting rate, IRAS, and other relevant metrics
- **Smart Binning**: Automated bin width calculation using the Freedman-Diaconis rule for optimal histograms
- **Colorblind-Friendly**: Carefully selected color palettes (viridis for multi-color, cadetblue/coral for comparisons)
- **Plot saving**: Custom plot saving with fixed 1:1.4 aspect ratio and 300 DPI resolution
- **AI agent instructions**: Instruction file allowing AI agents to create plots that are not hard-coded in the package while mainting the same stylistic approach.
- **Human guidelines**: File with the explanation behind the design decisions.

## Quick Start

```R
library(MoViz)

# View all available functions
list_package_functions()

# View quick guide
MoViz_help()

# Create a standard plot
plot_measures(your_dataframe)

# Apply professional theme to custom plots
ggplot(df) + geom_point(aes(x, y)) + theme_professional()

# Save with consistent formatting
save_plot(my_plot, rows=1, columns=1, legend="n", "my_plot.png")
```

## Documentation

For detailed information on any function, use the standard R help system:
```R
?function_name
```

## Design Philosophy

MoViz follows strict plotting guidelines (see `Plotting_instructions.md`) to ensure all visualizations:
- Use appropriate data representations (histograms for distributions, barplots for counts, etc.)
- Include proper axis labels with units
- Maintain readability through careful typography and spacing
- Are colorblind-accessible

---

*For more information, run `MoViz_help()` after loading the package.*

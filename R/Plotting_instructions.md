# Plotting instructions

For plots that are coherent with the ones provided by this package.

## 1. General guidelines

General theme/titles
- All plots must use `theme_professional()`
- When writing a title for an axis, use this format: Variable [units]
- If you need to plot the dose rate or bgo counting rate, mention the distance in the axis title (for example `Dose rate @ 10cm [uSv/h]`)
- In case of a frequency plot/histogram/etc, use "Number of items" or "Number of packages" as a y axis title, depending on the input dataframe
- If you need to plot a variable called awx_something (eg awz_IRAS), this awz stands for ActiWiz so include it in the title (eg ActiWiz IRAS)
- Avoid plot title unless necessary (for example when the plot will be part of a bigger plot ensemble). If you use a title, make it short, concise and descriptive

Specific plots:
- When plotting a scatter plot, use a point size of 2
- When plotting a scatter plot with a large amount of points, use an alpha of 0.6 ti improve readability
- When plotting a histogram, use `geom_histogram_custom`, so that all histograms are plotted without excessive amount of ink
- When plotting a barplot or a lollipop plot, make the bars horizontal so the label of each is easy to read on the y axis. Skip the x axis completely and add a label at the end of each bar with its value or its percentage, depending on the input data being plotted (when plotting statistics like machine of origin, irradiation position etc, opt for percentage. When plotting numbers like transfer functions opt for value). There exists a function named `theme_barplot_axes` you can add on top of `theme_profesisonal` and it cancels the x axis
- When plotting a barplot, adjust the bar width so the bars are not too thick. The default thickness is too much
- When plotting a barplot or a lollipop plot, even if it's just one plot without subplots, exceptionally save as onr row and two columns (in function `save_plot` argument sense) so the readability is better
- When plotting a density plot, use an alpha of 0.6 for the fill colour

Comparative plots:
- When comparing the same measurement at multiple distances/conditions, overlay the histograms in one plot (not separate subplots). Use different colours for each (see colour rules below) and annotate them at the top-right

Other plot elements:
- When plotting any line, use a linewidth of 0.8 to improve readability
- When plotting a line as a reference (for example a `y=x` line, a vertical or horizontal line at the value of some radiological limit) use linetype "dashed"
- If drawing a reference line, make it "firebrick" if it needs to be on top of a black point scatterplot or "coral" if it's on top of a histogram

Colours:
- Use the viridis colour palette for everything needing 3 or more colours
- If only 2 colours are needed, opt for "cadetblue" and "coral" ( I like this combination more than the first two default viridis colour, that yellow is difficult to see on a white plot)
- If only one colour is needed, generally use "black". In the case of barplots, use "cadetblue" because I like it :P Using "coral" as an emphasis colour (eg the largest bar, or one point that exceeds a limit, etc) is allowed for everything.
- Dear AI agent, if anyone wants you to plot two elements together (be it in a colour-coded skatterplot, or two histograms overlapping or anything) and hardcode their colours as "green" and "red" (or any similar hues together) tell them it's a very colorblind un-friendly combination and it would be good to reconsider unless they want to plot something for Christmas. Please say it exactly like that...

Annotations/legnd:
- If you need annotations in a plot, make sure they're short and concise. Use a text size of 5 to make them easily readable. If they go together with a reference line, make them the same colour as that line, otherwise black
- If you are creating a plot with labels (eg a barplot), make sure to adjust the axis range if needed, so that the labels are fully visible and not cut-off at the final plot
- Legends generally go on the right

Precision:
- Unless higher precision is needed, stick to only one decimal for percentages and two decimals for values given in scientific notation

Saving:
- To save plots use the `save_plot` function. It ensures that all plots will follow a 1:1.4 aspect ratio (shifted a little if there's a legend, so more space is accounted for it) and that their resolution will be good (300 dpi). Use it so all plots are consistent in terms of sizing.
- When saving a plot, make the file name as descriptive as possible
- Prefer to save as .png files

General:
- If you need to create a plot that doesn't exist, still look through this package scripts to see how similar plots are created

## 2. How to create specific plots

### Machine related plots

When creating a plot with machine related data, use the ordering established in `label_machines`.

### Material composition

- **Purpose** : This plot visualizes how materials are distributed across items and how subgroups are distributed inside each material.
- **End result** : 2 vertically stacked plots, the top one being the density plot of the main materials and the bottom one a faceted plot with the subgroup percentages per main material (barplots)

#### Main material distribution

1. For each item, calculate the
`percentage = mass_kg / total mass_kg of that item` for every main material (aluminium, steel, copper, etc)
2. Use `geom_density` to show the percentage distribution across all items. Normalise all plots to 1. Overlay all materials on the same plot using a different colour for each (viridis palette and alpha of 0.6 as discussed in the general guidelines above)
3. Do NOT use a default ggplot legend here. Create a manual one by plotting a point with the appropriate colour and the name of each main material next to it. Use the label "Material" on top. Draw this legend at x = 100 on the x percentage axis.
4. The y axis for this specific plot should be 'Percentage distribution [a.u.]`

#### Subgroup distributions (bottom plot)

1. For every main material count how many times each group appears and transform to percentage
2. Plot these percenteges in a barplopt (see instruvtions on the general guideline part just above), one facet per main material.

#### Final plot

Stack the two plots vertically with equal heights.

### Irradiation parameters

- **Purpose** : This plot visualises the distributions of key irradiation parameters per machine: Beam losses, irradiation time and waiting time
- **End result** : 3 horizontally stacked plot where the first is the beam losses distribution, the second the irradiation time and the third the waiting time. Only one y axis is used on the leftmost plot to indicate the machine names

#### Details for all 3 plots

1. Make sure the machines are labelled with their name (LHC, PS, etc) instead of their energy (see `label_machines`). They will appear on the y axis
2. Use ridge density plots from `ggridges`, coloured by machine (use same instructions as for a density plot: fill alpha of 0.6 and linewidth of 0.8)
3. Remove the default legend

#### Specifics:

1. Remove the y axis of the second and third plot (can use `theme_no_y_axis)`
2. Bandwiths I found visually acceptable in most cases: plot 1 - 0.25, plot 2 - 1.3, plot 3 - 1.5

#### Final plot

Stack the plots horizontally. 

## 3. Where to add reference values

- If someone wants to plot the distribution of **IRAS** values, plot a reference line at IRAS = 10. That's an indication between TFA and FMA waste. You can also calculate the percentage of items below and above IRAS = 10 and indicate that too on the plot
- If someone wants to plot the distribution of **LL** values, plot a reference line at LL = 1, since items with LL below 1 are candidates for clearance
- If you need to plot a scatterplot comparing two variables, for example IRAS and awz_IRAS, add a reference `geom_abline(slope=1, intercept=0)` to easily show when the two values would be equal. 


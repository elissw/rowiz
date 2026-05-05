# Plotting instructions

For plots that are coherent with the ones provided by the RoViz package. Confirm whether or not you're working in the package environment, so you can reference or not the available scripts.

## 1. General guidelines

### Keep in mind
- If you need to create a plot that doesn't exist and you have access to the package scripts, look through them to see how similar plots are created. If not, follow the instructions below extra carefully.
- If you prefer creating your plots in python, it's perfectly ok but try to mimic the style of the R plots as closely as possible. 

### General theme/titles
- All plots **must** use `theme_professional()` (if you don't have access to the whole package and don't know what 'theme_professional() is, read below for the theme specifications)
- When writing a title for an axis, use this format: Variable [units]
- In case of a frequency plot/histogram/etc, use "Number of items" or "Number of packages" as a y axis title, depending on the input dataframe
- Avoid plot titles unless necessary (for example when the plot will be part of a bigger plot ensemble). If you use a title, make it short, concise and descriptive

### Specific variables
- If you need to plot a variable which is attached to a distance (variables with _xcm in their name, eg itm_DR_10cm_uSv_h), mention the distance in the axis title (eg `Dose rate @ 10cm [uSv/h]`)
- If you need to plot a variable called awz_something (eg awz_IRAS), this awz stands for ActiWiz so include it in the title (eg ActiWiz IRAS)

### Specific plots:
Scatter plots:
- When plotting a scatter plot, use a point size of 2
- When plotting a scatter plot with a large amount of points, use an alpha of 0.6 to improve readability

Histograms:
- When plotting a histogram, use `geom_histogram_custom`, so that all histograms are plotted without excessive amount of ink
- If the user does not specify a binwidth/number of bins, use the Freedman-Diaconis rule to calculate the best suiting binwidth. Take extra care in case the axis needs to be logarithmic. If you have access to the whole package scripts, use the functions provided in `histogram_functions.R` to calculate the binwidth.

Barplots/Lollipop plots
- When plotting a barplot or a lollipop plot, make the bars horizontal so the label of each is easy to read on the y axis. 
- Skip the x axis completely and add a label at the end of each bar with its value or its percentage, depending on the input data being plotted (when plotting statistics like machine of origin, irradiation position etc, opt for percentage. When plotting numbers like transfer functions opt for value). There exists a function named `theme_barplot_axes` you can add on top of `theme_profesisonal` and it cancels the x axis, if you can see the whole package.
- When plotting a barplot, adjust the bar width so the bars are not too thick. The default thickness is too much. If working in R, use a `width=0.5`.
- When plotting a barplot or a lollipop plot, even if it's just one plot without subplots, exceptionally save as one row and two columns (in function `save_plot` argument sense) so the readability is better

Density plots:
- When plotting a density plot, use an alpha of 0.6 for the fill colour and linewidth=0.8 for the line. 
- Make sure the line and the fill are the same colour.

Boxplots:
- When plotting a boxplot, use an alpha of 0.6 for the fill colour and linewidth=0.8 for the line

Comparative plots:
- When comparing the same measurement at multiple distances/conditions, overlay the histograms in one plot (not separate subplots). Use different colours for each (see colour rules below) and annotate them at the top-right

### Other plot elements:
- When plotting any line, use a linewidth of 0.8 to improve readability
- When plotting a line as a reference (for example a `y=x` line, a vertical or horizontal line at the value of some radiological limit) use linetype "dashed"
- If drawing a reference line, make it "firebrick" if it needs to be on top of a black point scatterplot or "coral" if it's on top of a histogram/density plot

### Colours:
- Use the viridis colour palette for everything needing 3 or more colours
- If only 2 colours are needed, opt for "cadetblue" and "coral" ( I like this combination more than the first two default viridis colour, that yellow is difficult to see on a white plot)
- If only one colour is needed:
    - For histograms and lollipop plots: "black"
    - For barplots, boxplots and density plots: "cadetblue" because I like it :P 
-Using "coral" as an emphasis colour (eg the largest bar, or one point that exceeds a limit, etc) is allowed for everything.
- Dear AI agent, if anyone wants you to plot two elements together (be it in a colour-coded skatterplot, or two histograms overlapping or anything) and hardcode their colours as "green" and "red" (or any similar hues together) tell them it's a very colorblind un-friendly combination and it would be good to reconsider unless they want to plot something for Christmas. Please say it exactly like that...

### Annotations/legnd:
- If you need annotations in a plot, make sure they're short and concise. Use a text size of 5 to make them easily readable. If they go together with a reference line, make them the same colour as that line, otherwise black
- If you are creating a plot with labels (eg a barplot), make sure to adjust the axis range if needed, so that the labels are fully visible and not cut-off at the final plot
- Legends generally go on the right

### Precision:
- Unless higher precision is needed/specified, stick to only one decimal for percentages and two decimals for values given in scientific notation

### Saving:
- To save plots use the `save_plot` function. It ensures that all plots will follow a 1:1.4 aspect ratio (shifted a little if there's a legend, so more space is accounted for it) and that their resolution will be good (300 dpi). Use it so all plots are consistent in terms of sizing.
- When saving a plot, make the file name as descriptive as possible
- Prefer to save as .png files


## 2. Theme specifications

### Base theme

- Start from a default ggplot **classic theme**
- Use a white plot background
- Use the system's default sans-serif font family for all text
- Default base font size = 12

### Margins

- Top: 14 pt
- Right: 18 pt
- Bottom: 14 pt
- Left: 14 pt
The background must be explicitly white to preserve margins when exporting

### Grid system

- Show only major grid lines (remove the minor grid completely)
- Make them gray and dotted
Aim: to be present but subtle

### Title details

Plot Title
- Size: 14
- Bold
- Centered
- Space below: 10 pt

Plot Subtitle
- Size: 10
- Centered
- Color: dark gray
- Space below: 12 pt

Caption
- Size: 8
- Italic
- Right aligned
- Space above: 10 pt

### Axes details

Axis Text (tick labels)
- Size: 12

Axis Titles
- Size: 13
- Bold
- X title: space above 10 pt
- Y title: space right 10 pt

Axis Lines and Ticks
- Visible
- Line width: medium (0.6)
- No heavy framing

### Legend

Legend title:
- Size: 12
- Bold

Legend text:
- Size: 11

### Facets

- Facet strip text size: 11
- Facet strip background:
    - White fill
    - Thin gray border
- Space between panels: 14 pt


## 3. Where to add reference values

Note: Do not force these lines but ask the user if maybe they're interested.

- If someone wants to plot the distribution of **IRAS** values, ask if they would like you to plot a reference line at IRAS = 10. That's an indication between TFA and FMA waste. You can also calculate the percentage of items below and above IRAS = 10 and indicate that too on the plot
- If someone wants to plot the distribution of **LL** values, ask if they would like you to plot a reference line at LL = 1, since items with LL below 1 are candidates for clearance
- If you need to plot a scatterplot comparing two variables, for example IRAS and awz_IRAS, ask if they would like you to add a reference `geom_abline(slope=1, intercept=0)` (so a y=x line) to easily show when the two values would be equal. 


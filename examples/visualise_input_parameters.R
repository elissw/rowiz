# Load the package
#------------------
# Make sure to check where you're running from and that the path to rowiz is not broken
devtools::load_all("../rowiz")

# Set the theme (so it's applied to all plots)
#---------------
ggplot2::theme_set(theme_professional())

# Read in the dataframe coming from Mowiz
#-----------------------------------------
df <- read_input_dataframe("example_dataframe_itm.csv")
# This function used read.csv with the appropriate options de/activated 
# for example it ensure check.names=FALSE so that Co-60 is not "fixed" to Co.60

# Visualise all input parameters
#--------------------------------
plot <- viz_all_input_parameters(df)
# Physical characteristics
plot_phys <- plot$plot_physical_characteristics
print(plot_phys)
# Irradiation history
plot_irr <- plot$plot_irradiation_characteristics
print(plot_irr)

# Focus on material composition
#-------------------------------
# Check which materials are present
materials <- get_materials(df)
print(materials)
cat("\n")
# Plot them
plot_mat <- plot_materials(df)
print(plot_mat)

# Get information on radionuclide inventory
#-------------------------------------------
# Check which radionuclides are present
radionuclides <- get_radionuclides(df)
print(radionuclides)
cat("\n")
# Check which ones are relevant (= more than 1% of the limit) for TFA 
TFA_radionuclides <- get_relevant_radionuclides(df,"TFA_dt")
print(TFA_radionuclides)

# Plot something that is not provided as-is in the package
#----------------------------------------------------------
plot_actind <- ggplot2::ggplot(df,ggplot2::aes(y=activation_index))+
  geom_bar_rowiz()+ theme_barplot_axes
print(plot_actind)
# geom_bar_rowiz is a wrapper function for geom_bar, it makes sure the bars are 
# cadetblue in colour and thinner than the default option. Of course, all these 
# options can be overriden if you want to, just pass new arguments for them.

# Plot something differently (for the fun)
#----------------------------
# Machine of origine as a lollipop plot
df <- label_machines(df)
# label_machines is a function provided in the data preparation script
# named prep_feature_engineering, which adds a column next to the original
# column `machine` which is named `machine_labelled` and contains the
# actual name of the accelerator. ATLAS, CMS, ALICE and LHCb are all
# grouped together under LHC experiments
df_counts <- df |>
  dplyr::count(machine_labelled, name = "n")
plot <- ggplot2::ggplot(df_counts)+
  # geom_lollipop_rowiz is a custom ggplot geometry combining
  # geom_segment and geom_point in order to achieve the lollipop look
  geom_lollipop_rowiz(ggplot2::aes(x=0,xend=n,
  y=machine_labelled,yend=machine_labelled))+
  theme_barplot_axes+
  ggplot2::labs(title="Number of items per machine of origin")+
  ggplot2::geom_text(ggplot2::aes(x=n,y=machine_labelled,label=n),
hjust=-0.5)
print(plot)
# theme_barplot_axes is a theme add-on that kills the x axis, 
# cancels the title from the y axis (better use a global title)
# and kills the grid, since there's no values on x axis that
# we need to read.
# When plotting this type of plot, it is highly recommended
# to label the points with whatever value we need to inspect

# Save a plot
#-------------
save_plot(plot_mat,2,3,"y","example_save.png")
# We save the material composition plot which the `plot_mat` object.
# It contains 2 rows and 3 columns in total, as it consists of subplots.
# It also contains a legend on the right (not a ggplot default but still
# a legend deserving breathing space). We save it at this folder as
# test_save.png. When exporting an image, it's generally recommended 
# to avoid jpg as its quality is not the highest. png is a good option
# for convenience, it's decent quality (especially now that we force a 
# good resolution) and every software can handle it. If you really want
# something infinitely scalable and editable, go for eps but beware of
# transparency issues and software imports.
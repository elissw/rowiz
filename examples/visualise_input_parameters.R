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
# Physical characteristics
plot_phys <- viz_all_input_parameters(df)$plot_physical_characteristics
print(plot_phys)
# Irradiation history
plot_irr <- viz_all_input_parameters(df)$plot_irradiation_characteristics
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

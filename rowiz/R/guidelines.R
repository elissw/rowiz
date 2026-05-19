#' Welcome message
#'
#' Function to introduce the user to the package
#' @name Rowiz_help
#' @export
Rowiz_help <- function() {
  cat("

======================================================
               ROWIZ QUICK GUIDE
======================================================

Hi, welcome to rowiz and thank you for using this package.
  
To list all functions provided, do
  list_package_functions()

For help with a specific function, do
  ?function_name

For the most common functions, read below:

****************************************************
  
For following our custom made theme with your plots, do
  + theme_professional() to your ggplot object or
  theme_set(theme_professional()) in your script

To save a plot with our fixed aspect ratio and resolution, use
  save_plot(plot,rows,columns,legend,filename)

For creating the standard scenario parameters info plot do
  plot_scenario_parameters(df)

To plot useful information about your irradiated items 
(AW RN inventory) do
  plot_measures(df) for BGO counting rate and dose rate
  plot_char_quantities(df) for LL and IRAS

To check your IRAS against AW after you've characterised 
your items do
  plot_iras(df)
  
******************************************************

Other useful functions (use ? to see the manual)
  
- freedman_diaconis_binwidth and binwidth_log : 
  Automated calculation of best binwidth 
- geom_histogram_custom : 
  Custom ggplot geometry for plotting a histogram
  with a solid line and no bin borders
- plot_machine : 
  to plot the machine of origin %
- plot_mass_info : 
  to plot mass, volume and density of items
- plot_materials and plot_irradiation 
  in case you want these seperately

======================================================
")
}

#' Show functions
#'
#' Function to show all function names
#' @name list_package_functions 
#' @export
list_package_functions <- function() {

  pkg <- "Rowiz"

  funs <- getNamespaceExports(pkg)
  funs <- sort(funs)

  for (f in funs) {
    cat(" • ", f, "\n", sep = "")
  }

}
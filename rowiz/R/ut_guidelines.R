#' Welcome message
#'
#' Function to introduce the user to the package
#' @name Rowiz_help
#' @export
rowiz_help <- function() {
  cat("

======================================================
               ROWIZ QUICK GUIDE
======================================================

Hi, welcome to rowiz and thank you for using this package.
  
To list all functions provided, do
  list_package_functions()

For help with a specific function, do
  ?function_name

For following our custom made theme with your plots, do
  + theme_professional() to your ggplot object or
  theme_set(theme_professional()) in your script

To save a plot with our fixed aspect ratio and resolution, use
  save_plot(plot,rows,columns,legend,filename)

******************************************************
  Next to the package directory you can find a folder
  named 'examples'. Go ahead and check it out so you
  get the feeling of how everything works and what 
  functions are available to you.
======================================================
")
}

#' Show functions
#'
#' Function to show all function names
#' @name list_package_functions 
#' @export
list_package_functions <- function() {

  pkg <- "rowiz"

  funs <- getNamespaceExports(pkg)
  funs <- sort(funs)

  for (f in funs) {
    cat(" • ", f, "\n", sep = "")
  }

}
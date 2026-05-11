#' Function to calculate bin width according to the
#' Freedman - Diaconis rule. Returns the number
#'
#' @name freedman_diaconis_binwidth
#' @param x (vector) data to be plotted as histogram (eg. column of dataframe)
#' @export
#'
freedman_diaconis_binwidth <- function(x) {
  iqr_x <- IQR(x, na.rm = TRUE)
  n <- length(na.omit(x))
  return (2 * iqr_x / (n^(1/3)))
}

#' Function to calculate bin width according to the
#' Freedman - Diaconis rule but in a log axis. Returns the number.
#'
#' @name freedman_diaconis_binwidth_log
#' @param x (vector) data to be plotted as histogram (eg. column of dataframe)
#' @export
#'
freedman_diaconis_binwidth_log <- function(x) {
  x <- log10(na.omit(x))  # Apply log transformation
  iqr_x <- IQR(x, na.rm = TRUE)
  n <- length(x)
  return(2 * iqr_x / (n^(1/3)))  # Convert back to linear scale
}


#' Geometry to plot a histogram as a line
#' Use as a normal ggplot2 geometry by adding it
#' to your ggplot object. Use it like you would any geom_stuff,
#' so add it to ggplot objects.
#'
#' @name geom_histogram_custom
#' @param variable variable name to be plotted
#' @param binwidth width of the bins to be used
#' @param color colour of the line (defaults to black)
#' @export
#'
geom_histogram_custom <- function(variable, binwidth, color = "black") {

    ggplot2::geom_step(
      ggplot2::aes(x = .data[[variable]]),
      stat = "bin",
      binwidth = binwidth,
      boundary = binwidth/2,
      color = color,
      linewidth = 0.8
    )
}




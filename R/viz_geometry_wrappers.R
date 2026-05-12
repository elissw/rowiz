#' Wrapper function for geom_density
#' Purpose: To include by default a pre-defined linewidth, fill transparency and colour
#' Use: Exactly like geom_density. Defaults will be overriden if specified otherwise in the arguments. 
#' @name geom_density_rowiz
#' @export
geom_density_rowiz <- function(mapping = NULL,
                            data = NULL,
                            ...,
                            linewidth = 0.8,
                            color = "cadetblue",
                            fill = "cadetblue",
                            alpha = 0.6) {
  
  ggplot2::geom_density(
    mapping = mapping,
    data = data,
    linewidth = linewidth,
    color = color,
    fill = fill,
    alpha = alpha,
    ...
  )
}

#' Wrapper function for geom_density_ridges
#' Purpose: To include by default a pre-defined linewidth, fill transparency and colour
#' Use: Exactly like geom_density_ridges. Defaults will be overriden if specified otherwise in the arguments. 
#' @name geom_density_ridges_rowiz
#' @export
geom_density_ridges_rowiz <- function(mapping = NULL,
                                   data = NULL,
                                   ...,
                                   alpha = 0.6,
                                   linewidth = 0.8) {
  
  ggridges::geom_density_ridges(
    mapping = mapping,
    data = data,
    alpha = alpha,
    linewidth = linewidth,
    ...
  )
}

#' Wrapper function for geom_bar
#' Purpose: To include by default a smaller bar width because the default default one is too thick
#' Use: Exactly like geom_bar. Defaults will be overriden if specified otherwise in the arguments. 
#' @name geom_bar_rowiz
#' @export
geom_bar_rowiz <- function(mapping = NULL,
                              data = NULL,
                              ...,
                              fill = "cadetblue",
                              width = 0.4) {
  ggplot2::geom_bar(
    mapping = mapping,
    data = data,
    fill = fill,
    width = width,
    ...
  )
}

#' Wrapper function for geom_histogram
#' Purpose: To include by default a pre-defined linewidth and bin fill style
#' Use: Exactly like geom_histogram. Defaults will be overriden if specified otherwise in the arguments. 
#' @name geom_histogram_rowiz
#' @export
geom_histogram_rowiz <- function(mapping = NULL,
                                  data = NULL,
                                  ...,
                                  binwidth,
                                  color = "black",
                                  linewidth = 0.8) {
  
  ggplot2::geom_step(
    mapping = mapping,
    data = data,
    stat = "bin",
    binwidth = binwidth,
    boundary = binwidth / 2,
    color = color,
    linewidth = linewidth,
    ...
  )
}
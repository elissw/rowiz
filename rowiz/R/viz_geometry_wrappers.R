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


#' Custom ggplot style geometry to plot a lollipop plot
#' Purpose: To avoid manually adding points and segments etc
#' Use: Exactly like any other ggplot geom. Just use the x and y you want your points to be at
#' Defaults will be overriden if specified otherwise in the arguments. 
#' @name geom_lollipop_rowiz
#' @export

# The new ggplot geometry (no need to export)
GeomLollipop <- ggplot2::ggproto(
  "GeomLollipop", ggplot2::Geom,

  required_aes = c("x", "y", "xend", "yend"),

  default_aes = ggplot2::aes(
    colour = "cadetblue",
    alpha = 1,
    linewidth = 0.8,
    size = 3
  ),

draw_panel = function(data, panel_params, coord) {

  data <- coord$transform(data, panel_params)

  segment_data <- data
  segment_data$xend <- data$xend
  segment_data$yend <- data$yend

  segments <- grid::segmentsGrob(
    x0 = segment_data$x,
    y0 = segment_data$y,
    x1 = segment_data$xend,
    y1 = segment_data$yend,
    gp = grid::gpar(
      col = data$colour,
      lwd = data$linewidth *4
    )
  )

  points <- grid::pointsGrob(
    x = data$xend,
    y = data$yend,
    pch = 16,
    gp = grid::gpar(
      col = scales::alpha(data$colour, data$alpha),
      fontsize = data$size *4
    )
  )

  grid::grobTree(segments, points)
}
)

geom_lollipop_rowiz <- function(mapping = NULL,
                          data = NULL,
                          stat = "identity",
                          position = "identity",
                          ...,
                          na.rm = FALSE,
                          show.legend = NA,
                          inherit.aes = TRUE) {

  ggplot2::layer(
    geom = GeomLollipop,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    inherit.aes = inherit.aes,
    show.legend = show.legend,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}
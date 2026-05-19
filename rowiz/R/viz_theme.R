#' Theme
#'
#' Theme so all plots are homogeneous in terms of
#' grids, axes, font sizes, etc. 
#' 
#' Use either by adding +theme_professional()
#' to your ggplot object or by theme_set(theme_professional()) in your script.
#' @name theme_professional
#' @export

theme_professional <- function(base_size = 12, base_family = "sans") {

  # Start on the basis of theme_classic
  ggplot2::theme_classic(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      # Try to get all bloody fonts matching but probably fail
      # and specify for each of them
      text = ggplot2::element_text(family = base_family),

      # Plot general
      #---------------
      # Update margins
      plot.margin = grid::unit(c(14, 18, 14, 14), "pt"),
      # Force a white background so ggplot doesn't eat the margins away
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
      # Create an existing yet not too obvious grid
      panel.grid.major = ggplot2::element_line(color = "gray", linetype = "dotted"),
      panel.grid.minor = ggplot2::element_blank(),
      # Title characteristics (Big, bold and centered)
      plot.title = ggplot2::element_text(size = 14,
                                         face = "bold",
                                         hjust = 0.5,
                                         margin = ggplot2::margin(b=10)),
      plot.subtitle = ggplot2::element_text(size = 10,
                                   hjust = 0.5,
                                   margin = ggplot2::margin(b=12),
                                   color="darkgray"),
      # Caption (if anyone ever wants a caption)
      plot.caption = ggplot2::element_text(size=8,
                                  face="italic",
                                  hjust = 1,
                                  margin = ggplot2::margin(t=10)),

      # Axes specifics
      #----------------
      # Axis labels
      axis.text = ggplot2::element_text(size = 12),
      # X and y axis titles
      axis.title.x = ggplot2::element_text(size = 13,
                                  face = "bold",
                                  margin = ggplot2::margin(t = 10)),
      axis.title.y = ggplot2::element_text(size = 13,
                                  face = "bold",
                                  margin = ggplot2::margin(r = 10)),
      # Axis lines
      axis.line = ggplot2::element_line(linewidth=0.6),
      axis.ticks = ggplot2::element_line(linewidth=0.6),

      # Legend
      #--------
      legend.title = ggplot2::element_text(size = 12,
                                           face = "bold"),
      legend.text = ggplot2::element_text(size = 11),

      # Customize facet title strips
      #------------------------------
      strip.text = ggplot2::element_text(size = 11),
      strip.background = ggplot2::element_rect(fill="white",
                                               color="gray40",
                                               linewidth=0.2),
      panel.spacing = grid::unit(14, "pt")

    )
} # Theme function

#' Theme add-on to kill x axis
#' 
#' Theme function that deletes the x axis of a plot
#' 
#' Use by adding +theme_no_x_axis to your ggplot object
#' Better do it after +theme_professional() so you don't override it.
#' @export
theme_no_x_axis <- ggplot2::theme(axis.line.x = ggplot2::element_blank(),
                                  axis.ticks.x = ggplot2::element_blank(),
                                  axis.text.x = ggplot2::element_blank(),
                                  axis.title.x = ggplot2::element_blank())
#' Theme add-on to kill y axis
#' 
#' Theme function that deletes the y axis of a plot
#' 
#'Use by adding +theme_no_y_axis to your ggplot object
#' Better do it after +theme_professional() so you don't override it.
#' @export
theme_no_y_axis <- ggplot2::theme(axis.line.y = ggplot2::element_blank(),
                                  axis.ticks.y = ggplot2::element_blank(),
                                  axis.text.y = ggplot2::element_blank(),
                                  axis.title.y = ggplot2::element_blank())
#' Theme add-on for barplots/lollipops
#' 
#' Theme function that edits both axes so they look nice for a barplot
#' No x axis and no title for y axis. Also no grid.
#' 
#' Use by adding +theme_barplot_axes to your ggplot object
#' Better do it after +theme_professional() so you don't override it.
#' @export
theme_barplot_axes <- ggplot2::theme(axis.line.x = ggplot2::element_blank(),
                                     axis.ticks.x = ggplot2::element_blank(),
                                     axis.text.x = ggplot2::element_blank(),
                                     axis.title.x = ggplot2::element_blank(),
                                     axis.title.y = ggplot2::element_blank(),
                                     panel.grid.major = ggplot2::element_blank())


#' Exporting plots
#'
#' Function that saves a plot, with its size depending on how many
#' subplots exist on the grid. 
#' Aim: Have the same sizing for all
#' similar plots. Resolution is taken care of as well.
#'
#' @param plot The plot we want to save
#' @param rows The number of plots in each column of the grid
#' @param columns The number of plots in each row of the grid
#' @param legend "y/n" Whether the plot includes a legend on the side (so it offsets the plot width to keep it looking nice)
#' @param filename The absolute path and filename of the plot
#' @export
#'
save_plot <- function(plot, rows = 1, columns = 1, legend = "n", filename) {

  # base size per subplot (in inches)
  phi <- 1.4 # 1.618 if you want to switch to golden
  panel_w <- 5
  panel_h <- panel_w / phi

  # compute size
  width  <- columns * panel_w
  height <- rows * panel_h

  # legend adjustment (inches, not pixels)
  legend_offset <- if (legend == "y") 1.7 else 0

  width <- width + legend_offset

  ggplot2::ggsave(
    plot = plot,
    filename = filename,
    width = width,
    height = height,
    units = "in",
    dpi = 300
  )
}

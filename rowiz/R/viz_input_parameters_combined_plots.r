#' Function to plot irradiation conditions: beam intensity, 
#' irradiation time and waiting time. Returns the plot (patchwork wrap).
#' @name plot_irradiation_parameters
#' @param df Dataframe with beam intensity, irradiation and waiting time columns (can be scn or itm)
#' @export
plot_irradiation_parameters <- function(df){

  plot1 <- plot_beam_losses(df)
  plot2 <- plot_irradiation_time(df) + theme_no_y_axis
  plot3 <- plot_waiting_time(df) + theme_no_y_axis


  plot <- patchwork::wrap_plots(
    plot1, plot2, plot3,
    ncol = 3,
    nrow = 1
    )
  
  return(plot)
}

#' Function to plot mass, volume and density info in case it's needed.
#' Returns the plot (patchwork wrap)
#' @name plot_mass_info
#' @param df dataframe with mass, volume and density columns (be it scn or itm or whatever)
#' @export
plot_mass_info <- function(df) {

  plot1 <- plot_mass(df)
  plot2 <- plot_volume(df)
  plot3 <- plot_density(df)

    plot <- patchwork::wrap_plots(
    plot1, plot2,plot3,
    ncol = 3,
    nrow = 1
    )
  
  return(plot)

}


#' Function to plot most importan scenario quantities: 
#' Materials & irradiation details together. 
#' Returns the plot (patchwork wrap)
#' @name plot_scenario_parameters
#' @param df Dataframe with scenario parameters (can be scn or itm, as long as it has columns with materials and irradiation details)
#' @export
plot_scenario_parameters <- function(df){

  plot1 <- plot_materials(df) 
  plot2 <- plot_irradiation_parameters(df)

  plot1 <- patchwork::wrap_elements(full = plot1)
  plot2 <- patchwork::wrap_elements(full = plot2)

  plot <- patchwork::wrap_plots(
    plot1, plot2,
    ncol = 1,
    nrow = 2,
    heights = c(2,1)
    )
  
  return(plot)

}



#' Inspect all scenario parameters in a glance
#' Returns a named list of plots: "plot_physical_characteristics"
#' and "plot_irradiation_characteristics"
#' @name viz_all_input_parameters
#' @param df dataframe name
#' @export
viz_all_input_parameters <- function(df) {

  cat("\nReminder: Count your rows and columns before you save a plot, so it scales properly and readably\n")

  ############# PHYSICAL PROPERTIES
  # Material composition
  #----------------------
  plot_mats <- plot_materials(df)

  # Geometry
  #---------
  plot_dims <- plot_dimensions(df)
  plot_vol <- plot_volume(df)
  # combine
  plot_dimsvol <- patchwork::wrap_plots(
    plot_vol,plot_dims,
    ncol = 2,
    nrow = 1
  )
    
  # Mass
  #------
   plot_m <- plot_mass(df)
   plot_fill <- plot_filling_ratio(df)
   plot_dens <- plot_density(df)
# combine
  plot_filldens <- patchwork::wrap_plots(
    plot_fill,plot_dens,
    ncol = 2,
    nrow = 1
  )
  # combine
  plot_geom <- patchwork::wrap_plots(
    plot_dimsvol,plot_m,plot_filldens,
    ncol=1,
    nrow=3
  )

  # Combine all
  #-------------
  plot_phys <- patchwork::wrap_plots(
    plot_geom,plot_mats,
    ncol=2,
    nrow=1
  )



  ############# IRRADIATION PARAMETERS
  # Irradiation information
  #------------------------
  plot_irr <- plot_irradiation_parameters(df)

  # Machine of origin and place of irradiation
  plot_mach <- plot_machine(df)
  plot_pos <- plot_position(df)
  
  # combine
  plot_irr_all <- patchwork::wrap_plots(
    plot_irr,plot_mach,plot_pos,
    ncol=1,nrow=3
  )
  
# Return both in a named list
return(list(
  plot_physical_characteristics = plot_phys,
  plot_irradiation_characteristics = plot_irr_all
))

}
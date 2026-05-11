#' Function to plot irradiation conditions: beam intensity, 
#' irradiation time and waiting time. Returns the plot (patchwork wrap).
#' @name plot_irradiation
#' @param df Dataframe with beam intensity, irradiation and waiting time columns (can be scn or itm)
#' @export
plot_irradiation <- function(df){


  
  plot1 <- ggplot2::ggplot(df|>dplyr::filter(component_id==0),
                          ggplot2::aes(x=beam_p_s,y=machine_labelled))+
    ggridges::geom_density_ridges(ggplot2::aes(color=machine_labelled,fill=machine_labelled),
                        linewidth=0.8,alpha=0.6,
                        bandwidth = 0.25)+
    ggplot2::scale_x_log10()+
    ggplot2::scale_color_viridis_d()+ggplot2::scale_fill_viridis_d()+
    ggplot2::labs(y="Machine",x="Beam losses [p/s]")+
    ggplot2::guides(color="none",fill="none")+
    theme_professional()

  

  plot3 <- ggplot2::ggplot(df|>dplyr::filter(component_id==0),
                    ggplot2::aes(x=waiting_y,y=machine_labelled))+
    ggridges::geom_density_ridges(ggplot2::aes(color=machine_labelled,fill=machine_labelled),
                        linewidth=0.8,alpha=0.6,
                        bandwidth = 1.5)+
    ggplot2::scale_color_viridis_d()+ggplot2::scale_fill_viridis_d()+
    ggplot2::labs(x="Waiting time [y]")+
    theme_professional()+theme_no_y_axis+
    ggplot2::guides(color="none",fill="none")

  plot <- patchwork::wrap_plots(
    plot1, plot2, plot3,
    ncol = 3,
    nrow = 1
    )+
  patchwork::plot_annotation(
    title = "Irradiation parameters",
    theme = theme_professional()
  )
  
  return(plot)
}

#' Function to plot mass, volume and density info in case it's needed.
#' Returns the plot (patchwork wrap)
#' @name plot_mass_info
#' @param df dataframe with mass, volume and density columns (be it scn or itm or whatever)
#' @export
plot_mass_info <- function(df) {

  df_plot <- df |> dplyr::filter(component_id==0)

  plot1 <- ggplot2::ggplot(df_plot, ggplot2::aes(x = mass_kg)) +
    geom_density(aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                  fill="cadetblue", color="cadetblue",alpha=0.6,linewidth=0.8)+
    ggplot2::labs(x="Mass [kg]", y="Distribution [a.u.]")+
    theme_professional()

  df_plot <- df_plot |> dplyr::mutate(volume_m3 = volume_cm3 / 1000000)
  plot2 <- ggplot2::ggplot(df_plot, ggplot2::aes(x = volume_m3)) +
    geom_density(aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                  fill="cadetblue", color="cadetblue",alpha=0.6,linewidth=0.8)+
    ggplot2::labs(x="Volume [m3]", y="Distribution [a.u.]")+
    theme_professional()

  plot3 <- ggplot2::ggplot(df_plot, ggplot2::aes(x = density_g_cm3)) +
    geom_density(aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                  fill="cadetblue", color="cadetblue",alpha=0.6,linewidth=0.8)+
    ggplot2::labs(x="Density [g/cm3]", y="Distribution [a.u.]")+
    theme_professional()

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
  plot2 <- plot_irradiation(df)

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
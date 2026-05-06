#' Inspect all scenario parameters in a glance
#' @name inspect_parameters
#' @param df dataframe name
#' @export
inspect_parameters <- function(df) {

  df_items <- df |> dplyr::filter(component_id==0)
  
  ############# PHYSICAL PROPERTIES

  # Material composition
  #----------------------
  plot_mats <- plot_materials(df)

  # Geometry
  #---------
  df_dimensions <- df |> dplyr::filter(component_id==0) |>
    tidyr::pivot_longer(cols=c(width_cm,height_cm,thickness_cm),
                        names_to = "dimension", values_to = "value")
  df_dimensions$dimension <- factor(df_dimensions$dimension,
                                      levels = c("width_cm", "height_cm", "thickness_cm"),
                                      labels = c("Width", "Height", "Thickness"))

  plot_dims <- ggplot2::ggplot(df_dimensions, ggplot2::aes(y=dimension,x=value))+
    ggridges::geom_density_ridges(ggplot2::aes(color=dimension,fill=dimension),
                                  linewidth=0.8,alpha=0.6, bandwidth=4.5)+
    ggplot2::scale_color_viridis_d()+ggplot2::scale_fill_viridis_d()+guides(color="none",fill="none")+
    labs(x="Value [cm]",y="Dimension")+theme_professional()+
    scale_x_continuous(breaks = pretty(range(df_dimensions$value, na.rm = TRUE), n = 5))

  df_items <- df_items |> dplyr::mutate(volume_m3 = volume_cm3 / 1000000)
  plot_vol <- ggplot2::ggplot(df_items, ggplot2::aes(x = volume_m3)) +
    geom_density(aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                  fill="cadetblue", color="cadetblue",alpha=0.6,linewidth=0.8)+
    ggplot2::labs(x="Volume [m3]", y="Distribution [a.u.]")+
    theme_professional()

  plot_dimsvol <- patchwork::wrap_plots(
    plot_vol,plot_dims,
    ncol = 2,
    nrow = 1
  )
    
  plot_mass <- ggplot2::ggplot(df_items, ggplot2::aes(x = mass_kg)) +
    geom_density(aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                  fill="cadetblue", color="cadetblue",alpha=0.6,linewidth=0.8)+
    ggplot2::labs(x="Mass [kg]", y="Distribution [a.u.]")+
    theme_professional()  
   
  plot_filling <- ggplot2::ggplot(df_items, ggplot2::aes(x = filling)) +
    geom_density(aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                  fill="cadetblue", color="cadetblue",alpha=0.6,linewidth=0.8)+
    ggplot2::labs(x="Filling factor", y="Distribution [a.u.]")+
    theme_professional()

  plot_dens <- ggplot2::ggplot(df_items, ggplot2::aes(x = density_g_cm3)) +
    geom_density(aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                  fill="cadetblue", color="cadetblue",alpha=0.6,linewidth=0.8)+
    ggplot2::labs(x="Density [g/cm3]", y="Distribution [a.u.]")+
    theme_professional()  

 plot_filldens <- patchwork::wrap_plots(
    plot_filling,plot_dens,
    ncol = 2,
    nrow = 1
  )
  
  plot_geom <- patchwork::wrap_plots(
    plot_dimsvol,plot_mass,plot_filldens,
    ncol=1,
    nrow=3
  )

  plot_phys <- patchwork::wrap_plots(
    plot_geom,plot_mats,
    ncol=2,
    nrow=1
  )

  save_plot(plot_phys,3,5,"y","../test_save.png")

  cat("\n\nReminder: Count your rows and columns before you save a plot, so it scales properly and readably")


  ############# IRRADIATION PARAMETERS


  # Irradiation information
  #------------------------
  plot_irr <- plot_irradiation(df)

  

  

}
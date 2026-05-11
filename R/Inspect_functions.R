#' Inspect all scenario parameters in a glance
#' Returns a named list of plots: "plot_physical_characteristics"
#' and "plot_irradiation_characteristics"
#' @name inspect_parameters
#' @param df dataframe name
#' @export
inspect_parameters <- function(df) {

  cat("\nReminder: Count your rows and columns before you save a plot, so it scales properly and readably\n")

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
    ggplot2::scale_color_viridis_d()+ggplot2::scale_fill_viridis_d()+
    ggplot2::guides(color="none",fill="none")+
    ggplot2::labs(x="Value [cm]",y="Dimension")+theme_professional()+
    ggplot2::scale_x_continuous(breaks = pretty(range(df_dimensions$value, na.rm = TRUE), n = 5))

  df_items <- df_items |> dplyr::mutate(volume_m3 = volume_cm3 / 1000000)
  plot_vol <- ggplot2::ggplot(df_items, ggplot2::aes(x = volume_m3)) +
    ggplot2::geom_density(ggplot2::aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                  fill="cadetblue", color="cadetblue",alpha=0.6,linewidth=0.8)+
    ggplot2::labs(x="Volume [m3]", y="Distribution [a.u.]")+
    theme_professional()

  plot_dimsvol <- patchwork::wrap_plots(
    plot_vol,plot_dims,
    ncol = 2,
    nrow = 1
  )
    
  plot_mass <- ggplot2::ggplot(df_items, ggplot2::aes(x = mass_kg)) +
    ggplot2::geom_density(ggplot2::aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                  fill="cadetblue", color="cadetblue",alpha=0.6,linewidth=0.8)+
    ggplot2::labs(x="Mass [kg]", y="Distribution [a.u.]")+
    theme_professional()  
   
  plot_filling <- ggplot2::ggplot(df_items, ggplot2::aes(x = filling)) +
    ggplot2::geom_density(ggplot2::aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                  fill="cadetblue", color="cadetblue",alpha=0.6,linewidth=0.8)+
    ggplot2::labs(x="Filling factor", y="Distribution [a.u.]")+
    theme_professional()

  plot_dens <- ggplot2::ggplot(df_items, ggplot2::aes(x = density_g_cm3)) +
    ggplot2::geom_density(ggplot2::aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
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



  ############# IRRADIATION PARAMETERS


  # Irradiation information
  #------------------------
  plot_irr <- plot_irradiation(df)

  # Machine of origin and place of irradiation
  plot_mach <- plot_machine(df)

  df_items <- label_machines(df_items)
  df_positions <- df_items |> 
    dplyr::mutate(machine_group = dplyr::case_when(
                                  machine_labelled == "LHC experiments" ~ machine,
                                  TRUE ~ "accelerators"
    )) |> 
  dplyr::group_by(machine_group,position) |>
  dplyr::summarise(count = dplyr::n(), .groups="drop") |>
  dplyr::group_by(machine_group) |>
  dplyr::mutate(percentage = 100 * count / sum(count, na.rm = TRUE)) |>
  dplyr::arrange(machine_group, desc(percentage))

  df_acc <- df_positions |>
    dplyr::filter(machine_group == "accelerators") 

  df_exp <- df_positions |>
    dplyr::filter(machine_group != "accelerators") 

  plot_acc <- ggplot2::ggplot(df_acc,ggplot2::aes(y = position, x = percentage)) +
    ggplot2::geom_bar(stat = "identity", width = 0.4) +
    ggplot2::labs(title = "Position in accelerators",x = "Percentage [%]",y = "") +
    theme_professional()+theme_barplot_axes+
    ggplot2::geom_label(ggplot2::aes(label = paste0(round(percentage, 1), "%")),
                        hjust = -0.1, size = 3.5, fill = "white", label.size = 0)+
    ggplot2::coord_cartesian(xlim=c(0,80))
  
  plot_exp <- ggplot2::ggplot(df_exp,ggplot2::aes(y = position, x = percentage)) +
    ggplot2::geom_bar(stat = "identity", width = 0.4) +
    ggplot2::labs(title="Position in LHC experiments", x = "Percentage [%]",y = "") +
    ggplot2::facet_wrap(~machine_group, ncol = 2, scales="free") +
    theme_professional()
  
  plot_pos <- patchwork::wrap_plots(
    A = plot_acc,B = plot_exp,
  design = "
  AB
  AB
  ",
  widths = c(1.3, 1))

  plot_irr_all <- patchwork::wrap_plots(
    plot_irr,plot_mach,plot_pos,
    ncol=1,nrow=3
  )
  
return(list(
  plot_physical_characteristics = plot_phys,
  plot_irradiation_characteristics = plot_irr_all
))

}
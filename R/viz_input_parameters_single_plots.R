#' Function to plot material composition
#' Will plot main material distributions and subgroup percentages.
#' Returns the plot (patchwork wrap).
#' @name plot_materials
#' @param df dataframe containing a column with materials and one with groups (can be scn or itm). Note: column names are hard-coded but it will warn you if anything has changed.
#' @export
plot_materials <- function(df) {

  # Dummy dataframe to use for text annotations
  x <- c(1)
  y<-c(1)
  dummy <- data.frame(x,y)

  # First the main materials
  df_main <- df |> dplyr::filter(component_id >0)

  df_main <- df_main |>
  dplyr::group_by(item_id) |>
  dplyr::mutate(percentage = mass_kg / sum(mass_kg, na.rm = TRUE)) |>
  dplyr::ungroup()
  
  
  main_mats <- unique(df_main$material)
  palette <- viridis::viridis(length(main_mats), option = "D")
  palette_named <- setNames(palette, main_mats)

  plot1 <- ggplot2::ggplot(df_main)

  i <- 0
  for (material in main_mats) {
    i <- i+1
    plot1 <- plot1 +
      geom_density_rowiz(data=df_main|>dplyr::filter(material==!!material),
                   ggplot2::aes(x=percentage,
                       y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                       color=palette[i], fill=palette[i])+
      ggplot2::geom_point(data = dummy,
                 x = 1.0, y = 0.85 - 0.1 * i, color = palette[i],
                 size = 5) +
      ggplot2::geom_text(data = dummy,
                x = 1.03, y = 0.85 - 0.1 * i,
                label = paste0(material),
                color = "black", size = 5, hjust = 0, vjust=0.5)
    }
  
    plot1 <- plot1 +
          ggplot2::scale_x_continuous(breaks=seq(0,1.0,0.2),labels=seq(0,100,20))+
          ggplot2::coord_cartesian(xlim=c(0,1.1))+
          ggplot2::labs(x="Percentage [%]", y="Percentage distribution [a.u.]")+
          ggplot2::geom_label(data=dummy,
                    x=1.0,y=0.9, color="black",label="Material",
                    size=5, hjust=0)+
      theme_professional()
  
  
  # And now the subgroup materials
  df_groups <- df |> dplyr::filter(component_id >0)

  df_groups <- df_groups |>
  dplyr::group_by(material,group) |>
  dplyr::summarise(count = dplyr::n(), .groups="drop") |>
  dplyr::group_by(material) |>
  dplyr::mutate(percentage = 100 * count / sum(count, na.rm = TRUE)) |>
  dplyr::arrange(material, desc(percentage))

    plot2 <- ggplot2::ggplot(df_groups, 
      ggplot2::aes(y = group, x = percentage)) +
      geom_bar_rowiz(stat = "identity", ggplot2::aes(fill=material)) +
      ggplot2::labs(
         x = "Percentage [%]",
         y = "") +
      ggplot2::facet_wrap(~material, scales = "free")+
      ggplot2::scale_fill_manual(values = palette_named, guide = "none")+
      theme_professional()
  
  plot <- patchwork::wrap_plots(
    plot1, plot2, 
    ncol = 1,
    heights = c(1, 1)
    )
  
  return(plot)

}


#' Function to plot the irradiation time distribution
#' Returns the plot (ggplot)
#' @name plot_irradiation_time
#' @param df dataframe with irradiation time column (be it scn, itm or whatever works)
#' @export
plot_irradiation_time <- function(df) {

  # Make sure machines are labelled
  df <- label_machines(df)

  plot <- ggplot2::ggplot(df|>dplyr::filter(component_id==0),
                            ggplot2::aes(x=irradiation_y,y=machine_labelled))+
    geom_density_ridges_rowiz(ggplot2::aes(color=machine_labelled,fill=machine_labelled),
                        bandwidth = 1.3)+
    ggplot2::scale_color_viridis_d()+ggplot2::scale_fill_viridis_d()+
    ggplot2::labs(x="Irradiation time [y]", y="Machine")+
    theme_professional()+
    ggplot2::guides(color="none",fill="none")

  return(plot)
}


#' Function to plot the waiting time distribution
#' Returns the plot (ggplot)
#' @name plot_waiting_time
#' @param df dataframe with waiting time column (be it scn, itm or whatever works)
#' @export
plot_waiting_time <- function(df) {

  # Make sure machines are labelled
  df <- label_machines(df)

  plot <- ggplot2::ggplot(df|>dplyr::filter(component_id==0),
                            ggplot2::aes(x=waiting_y,y=machine_labelled))+
    geom_density_ridges_rowiz(ggplot2::aes(color=machine_labelled,fill=machine_labelled),
                        bandwidth = 1.3)+
    ggplot2::scale_color_viridis_d()+ggplot2::scale_fill_viridis_d()+
    ggplot2::labs(x="Waiting time [y]", y="Machine")+
    theme_professional()+
    ggplot2::guides(color="none",fill="none")

  return(plot)
}


#' Function to plot the beam losses distribution
#' Returns the plot (ggplot)
#' @name plot_beam_losses
#' @param df dataframe with beam losses column (be it scn, itm or whatever works)
#' @export
plot_beam_losses <- function(df) {

    # Make sure machines are labelled
    df <- label_machines(df)
  
    plot <- ggplot2::ggplot(df|>dplyr::filter(component_id==0),
                          ggplot2::aes(x=beam_p_s,y=machine_labelled))+
    geom_density_ridges_rowiz(ggplot2::aes(color=machine_labelled,fill=machine_labelled),
                        bandwidth = 0.25)+
    ggplot2::scale_x_log10()+
    ggplot2::scale_color_viridis_d()+ggplot2::scale_fill_viridis_d()+
    ggplot2::labs(y="Machine",x="Beam losses [p/s]")+
    ggplot2::guides(color="none",fill="none")+
    theme_professional()

  return(plot)
}

#' Function to plot machine of origin barlot, in case it's needed.
#' Returns the plot (ggplot)
#' @name plot_machine
#' @param df dataframe with machine column (be it scn, itm or whatever works)
#' @export
plot_machine <- function(df) {

  # Make sure machines are labelled
  df <- label_machines(df)

  plot1 <- ggplot2::ggplot(df,
                          ggplot2::aes(y=machine_labelled))+
    geom_bar_rowiz()+
    ggplot2::labs(title="Machine",y="")+
    theme_professional()+theme_barplot_axes+
    ggplot2::coord_cartesian(xlim=c(0,nrow(df)*0.75))+
    ggplot2::geom_label(stat = "count", 
                        ggplot2::aes(label = paste0(round(ggplot2::after_stat(count)/sum(ggplot2::after_stat(count)) * 100, 1), "%")),
                        hjust = -0.1, size = 3.5, fill = "white", label.size = 0)
    
  plot2 <- ggplot2::ggplot(df|>dplyr::filter(machine_labelled=="LHC experiments"),
                          ggplot2::aes(y=machine))+
    geom_bar_rowiz()+
    ggplot2::labs(title="LHC experiment",y="")+
    theme_professional()+theme_barplot_axes+
    ggplot2::coord_cartesian(xlim=c(0,nrow(df|>dplyr::filter(machine_labelled=="LHC experiments"))*0.5))+
    ggplot2::geom_label(stat = "count", 
                        ggplot2::aes(label = paste0(round(ggplot2::after_stat(count)/sum(ggplot2::after_stat(count)) * 100, 1), "%")),
                        hjust = -0.1, size = 3.5, fill = "white", label.size = 0)

  plot <- patchwork::wrap_plots(
    plot1,plot2,
    ncol=2,
    nrow=1
  )
  return(plot)
}

#' Function to plot position of irradiation
#' Returns the plot (patchwork)
#' @name plot_position
#' @param df dataframe with position column (be it scn, itm or whatever works)
#' @export
plot_position <- function(df) {

  df <- label_machines(df)

  df_positions <- df |> dplyr::filter(component_id==0) |>
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
    geom_bar_rowiz(stat = "identity") +
    ggplot2::labs(title = "Position in accelerators",x = "Percentage [%]",y = "") +
    theme_professional()+theme_barplot_axes+
    ggplot2::geom_label(ggplot2::aes(label = paste0(round(percentage, 1), "%")),
                        hjust = -0.1, size = 3.5, fill = "white", label.size = 0)+
    ggplot2::coord_cartesian(xlim=c(0,80))
  
  plot_exp <- ggplot2::ggplot(df_exp,ggplot2::aes(y = position, x = percentage)) +
    geom_bar_rowiz(stat = "identity") +
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

  return(plot_pos)

}

#' Function to plot synthetic items' dimensions
#' Returns the plot (ggplot)
#' @name plot_dimensions
#' @param df dataframe with machine column (be it scn, itm or whatever works)
#' @export
plot_dimensions <- function(df) {

  df_dimensions <- df |> dplyr::filter(component_id==0) |>
    tidyr::pivot_longer(cols=c(width_cm,height_cm,thickness_cm),
                        names_to = "dimension", values_to = "value")
  df_dimensions$dimension <- factor(df_dimensions$dimension,
                                      levels = c("width_cm", "height_cm", "thickness_cm"),
                                      labels = c("Width", "Height", "Thickness"))

  plot_dims <- ggplot2::ggplot(df_dimensions, ggplot2::aes(y=dimension,x=value))+
    geom_density_ridges_rowiz(ggplot2::aes(color=dimension,fill=dimension),bandwidth=4.5)+
    ggplot2::scale_color_viridis_d()+ggplot2::scale_fill_viridis_d()+
    ggplot2::guides(color="none",fill="none")+
    ggplot2::labs(x="Value [cm]",y="Dimension")+theme_professional()+
    ggplot2::scale_x_continuous(breaks = pretty(range(df_dimensions$value, na.rm = TRUE), n = 5))

  return(plot_dims)

}


#' Function to plot synthetic items' volume
#' Returns the plot (ggplot)
#' @name plot_volume
#' @param df dataframe with machine column (be it scn, itm or whatever works)
#' @export
plot_volume <- function(df) {

  df <- df |> dplyr::mutate(volume_m3 = volume_cm3 / 1000000)
  plot_vol <- ggplot2::ggplot(df |> dplyr::filter(component_id==0), 
                              ggplot2::aes(x = volume_m3)) +
    geom_density_rowiz(ggplot2::aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))))+
    ggplot2::labs(x="Volume [m3]", y="Distribution [a.u.]")+
    theme_professional()

  return(plot_vol)

}


#' Function to plot synthetic items' mass
#' Returns the plot (ggplot)
#' @name plot_mass
#' @param df dataframe with machine column (be it scn, itm or whatever works)
#' @export
plot_mass <- function(df) {
    plot <- ggplot2::ggplot(df |> dplyr::filter(component_id==0), ggplot2::aes(x = mass_kg)) +
    geom_density_rowiz(ggplot2::aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))))+
    ggplot2::labs(x="Mass [kg]", y="Distribution [a.u.]")+
    theme_professional()  

  return(plot)
}


#' Function to plot synthetic items' filing ratio
#' Returns the plot (ggplot)
#' @name plot_filling_ratio
#' @param df dataframe with filling ratio column (be it scn, itm or whatever works)
#' @export
plot_filling_ratio <- function(df) {
    plot <- ggplot2::ggplot(df |> dplyr::filter(component_id==0), ggplot2::aes(x = filling)) +
    geom_density_rowiz(ggplot2::aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))))+
    ggplot2::labs(x="Filling factor", y="Distribution [a.u.]")+
    theme_professional()

  return(plot)
}


#' Function to plot synthetic items' density
#' Returns the plot (ggplot)
#' @name plot_density
#' @param df dataframe with density column (be it scn, itm or whatever works)
#' @export
plot_density<- function(df) {
    plot_dens <- ggplot2::ggplot(df |> dplyr::filter(component_id==0), ggplot2::aes(x = density_g_cm3)) +
    geom_density_rowiz(ggplot2::aes(y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))))+
    ggplot2::labs(x="Density [g/cm3]", y="Distribution [a.u.]")+
    theme_professional()  
  return(plot_dens)
}
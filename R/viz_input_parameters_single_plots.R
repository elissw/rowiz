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
      ggplot2::geom_density(data=df_main|>dplyr::filter(material==!!material),
                   ggplot2::aes(x=percentage,
                       y = ggplot2::after_stat(density) / max(ggplot2::after_stat(density))),
                       color=palette[i], fill=palette[i],
                       alpha=0.6, linewidth=0.8)+
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
      ggplot2::geom_bar(stat = "identity", width = 0.4, ggplot2::aes(fill=material)) +
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
    )+
  patchwork::plot_annotation(
    title = "Material composition",
    theme = theme_professional()
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
    ggridges::geom_density_ridges(ggplot2::aes(color=machine_labelled,fill=machine_labelled),
                        linewidth=0.8,alpha=0.6,
                        bandwidth = 1.3)+
    ggplot2::scale_color_viridis_d()+ggplot2::scale_fill_viridis_d()+
    ggplot2::labs(x="Irradiation time [y]")+
    theme_professional()+
    ggplot2::guides(color="none",fill="none")

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
    ggplot2::geom_bar(width=0.4, fill="#26828e")+
    ggplot2::labs(title="Machine",y="")+
    theme_professional()+theme_barplot_axes+
    ggplot2::coord_cartesian(xlim=c(0,nrow(df)*0.75))+
    ggplot2::geom_label(stat = "count", 
                        ggplot2::aes(label = paste0(round(ggplot2::after_stat(count)/sum(ggplot2::after_stat(count)) * 100, 1), "%")),
                        hjust = -0.1, size = 3.5, fill = "white", label.size = 0)
    
  plot2 <- ggplot2::ggplot(df|>dplyr::filter(machine_labelled=="LHC experiments"),
                          ggplot2::aes(y=machine))+
    ggplot2::geom_bar(width=0.4, fill="#26828e")+
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
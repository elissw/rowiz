#' Label machines and group LHC experiments (keeps original column).
#' Returns the dataframe with an added column named machine_labelled.
#' @name label_machines
#' @param df dataframe name
#' @export
label_machines <- function(df) {

  column = "machine"
  if (! column %in% colnames(df)){
    print("The machine column has changed name")
    return()
  }

  new_col <- paste0(column, "_labelled")
  if (new_col %in% colnames(df)) {
  message("Machines are already labelled — Moving on with our lives, I mean, our code")
  return(df)
}

  machine_levels <- c("7000GeV", "50MeV", "400GeVc", "160MeV", "14GeVc", "1400MeV")
  machine_labels <- c("LHC", "Lin2", "SPS", "Lin4", "PS", "PSB")
  lhc_experiments <- c("ATLAS", "ALICE", "CMS", "LHCb")

  # re-order in order of importance
  df <- df |>
  dplyr::mutate(
    machine = forcats::fct_infreq(machine)
  )

  # Add the label column
  df[[new_col]] <- dplyr::case_when(
    df[[column]] %in% lhc_experiments ~ "LHC experiments",
    df[[column]] %in% machine_levels ~ 
      machine_labels[match(df[[column]], machine_levels)],
    TRUE ~ as.character(df[[column]])
  )

  # place new column next to original
  df <- dplyr::relocate(df, dplyr::all_of(new_col), .after = dplyr::all_of(column))

  machine_order <- c(
    "Lin2","Lin4","PSB","PS","SPS","LHC", "LHC experiments"
  )

  df[[new_col]] <- factor(df[[new_col]], levels = machine_order)

  return(df)

}


#' Function to plot material composition
#' Will plot main material distributions and subgroup percentages.
#' Returns the plot (patchwork wrap).
#' @name plot_materials
#' @param df dataframe containing a column with materials and one with groups (can be scn or itm). Note: column names are hard-coded but it will warn you if anything has changed.
#' @export
plot_materials <- function(df) {

  ####### Check if anything has changed in column names
  df_names <- colnames(df)
  col_names <- c("component_id","item_id","material","group","mass_kg")
  for (name in col_names){
    if(!name %in% df_names){
      print(paste0("Column names changed! ",name," is not anymore in the dataframe!"))
      return()
    }
  }

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





#' Function to plot irradiation conditions: beam intensity, 
#' irradiation time and waiting time. Returns the plot (patchwork wrap).
#' @name plot_irradiation
#' @param df Dataframe with beam intensity, irradiation and waiting time columns (can be scn or itm)
#' @export
plot_irradiation <- function(df){

  ####### Check if anything has changed in column names
  df_names <- colnames(df)
  col_names <- c("component_id","beam_p_s","irradiation_y","waiting_y")
  for (name in col_names){
    if(!name %in% df_names){
      print(paste0("Column names changed! ",name," is not anymore in the dataframe!"))
      return()
    }
  }

  # Make sure machines are labelled
  df <- label_machines(df)
  
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

  plot2 <- ggplot2::ggplot(df|>dplyr::filter(component_id==0),
                            ggplot2::aes(x=irradiation_y,y=machine_labelled))+
    ggridges::geom_density_ridges(ggplot2::aes(color=machine_labelled,fill=machine_labelled),
                        linewidth=0.8,alpha=0.6,
                        bandwidth = 1.3)+
    ggplot2::scale_color_viridis_d()+ggplot2::scale_fill_viridis_d()+
    ggplot2::labs(x="Irradiation time [y]")+
    theme_professional()+theme_no_y_axis+
    ggplot2::guides(color="none",fill="none")

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


#' Function to plot mass, volume and density info in case it's needed.
#' Returns the plot (patchwork wrap)
#' @name plot_mass_info
#' @param df dataframe with mass, volume and density columns (be it scn or itm or whatever)
#' @export
plot_mass_info <- function(df) {

  ####### Check if anything has changed in column names
  df_names <- colnames(df)
  col_names <- c("component_id","mass_kg","volume_cm3","density_g_cm3")
  for (name in col_names){
    if(!name %in% df_names){
      print(paste0("Column names changed! ",name," is not anymore in the dataframe!"))
      return()
    }
  }

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
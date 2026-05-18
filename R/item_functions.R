#' Function to plot measurable quantities: bgo counting rate and 
#' dose rate. Returns the plot (patchwork wrap)
#' @name plot_measures
#' @param df Dataframe with bgo and dose rate columns
#' @export
plot_measures <- function(df){

   ####### Check if anything has changed in column names
  df_names <- colnames(df)
  col_names <- c("component_id","bgo_10cm_c_s","bgo_40cm_c_s","DR_10cm_uSv_h","DR_40cm_uSv_h")
  for (name in col_names){
    if(!name %in% df_names){
      print(paste0("Column names changed! ",name," is not anymore in the dataframe!"))
      return()
    }
  }

  # Keep only the items
  #df <- df |> dplyr::filter(component_id == 0)

  binwidth_bgo <- freedman_diaconis_binwidth_log(df$bgo_10cm_c_s)
  binwidth_dr <- freedman_diaconis_binwidth_log(c(df$DR_10cm_uSv_h, df$DR_40cm_uSv_h))
print(binwidth_dr)

  plot1 <- ggplot2::ggplot(df)+
    geom_histogram_rowiz(ggplot2::aes(bgo_10cm_c_s),
  binwidth= binwidth_bgo,color="coral")+
    geom_histogram_rowiz(ggplot2::aes(bgo_40cm_c_s),
  binwidth=binwidth_bgo,color="cadetblue")+
    ggplot2::scale_x_log10()+
    theme_professional()+
    ggplot2::labs(x="BGO counting rate [c/s]", y="Number of items")+
    ggplot2::annotate("text", x = Inf, y = Inf,
    label = "@ 10 cm",color="coral", size=5,
    hjust = 1.1,
    vjust = 1.1)+
    ggplot2::annotate("text", x = Inf, y = Inf,
    label = "@ 40 cm",color="cadetblue", size=5,
    hjust = 1.1,
    vjust = 4)

  plot2 <- ggplot2::ggplot(df)+
    geom_histogram_rowiz(ggplot2::aes(DR_10cm_uSv_h),
  binwidth=binwidth_dr,color="coral")+
    geom_histogram_rowiz(ggplot2::aes(DR_40cm_uSv_h),
  binwidth=binwidth_dr,color="cadetblue")+
    ggplot2::scale_x_log10()+
    theme_professional()+
    ggplot2::labs(x="Dose rate [uSv/h]", y="Number of items")+
    ggplot2::annotate("text", x = Inf, y = Inf,
    label = "@ 10 cm",color="coral", size=5,
    hjust = 1.1,
    vjust = 1.1)+
    ggplot2::annotate("text", x = Inf, y = Inf,
    label = "@ 40 cm",color="cadetblue", size=5,
    hjust = 1.1,
    vjust = 4)
   
  plot <- patchwork::wrap_plots(
    plot1, plot2,
    ncol = 2,
    nrow = 1
    )
  
  return(list(plot1,plot2,plot))
}

#' Function to plot characterisation quantities: LL and IRAS. 
#' Returns the plot (patchwork wrap).
#' @name plot_char_quantities
#' @param df dataframe with said quantities
#' @export
plot_char_quantities <- function(df) {

     ####### Check if anything has changed in column names
  df_names <- colnames(df)
  col_names <- c("component_id","LL","IRAS")
  for (name in col_names){
    if(!name %in% df_names){
      print(paste0("Column names changed! ",name," is not anymore in the dataframe!"))
      return()
    }
  }

  # Keep only the items
  df <- df |> dplyr::filter(component_id == 0)

  binwidth_ll <- freedman_diaconis_binwidth_log(df$LL)
  binwidth_iras <- freedman_diaconis_binwidth_log(df$IRAS)


  plot1 <- ggplot2::ggplot(df)+
    geom_histogram_custom("LL",binwidth_ll,"black")+
    ggplot2::labs(x="LL",y="Number of items")+
    ggplot2::geom_vline(xintercept=1,linetype="dashed",
                        linewidth=0.8, color="firebrick")+
    ggplot2::scale_x_log10()+
    theme_professional()+
    ggplot2::annotate("text", x = 1, y = Inf,
    label = "LL = 1",color="firebrick", size=5,
    angle=90,
    hjust = 1.5,
    vjust = -1)

    plot2 <- ggplot2::ggplot(df)+
    geom_histogram_custom("IRAS",binwidth_iras,"black")+
    ggplot2::labs(x="IRAS",y="Number of items")+
    ggplot2::geom_vline(xintercept=10,linetype="dashed",
                        linewidth=0.8, color="firebrick")+
    ggplot2::scale_x_log10()+
      theme_professional()+
    ggplot2::annotate("text", x = 10, y = Inf,
    label = "IRAS = 10",color="firebrick", size=5,
    angle=90,
    hjust = 1.5,
    vjust = 1.5)

  plot <- patchwork::wrap_plots(
    plot1,plot2,
    ncol=2,
    nrow=1
  )

  return(plot)

}


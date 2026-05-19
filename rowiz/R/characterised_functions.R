#' Function to plot IRAS resulting from the characterisation 
#' as well as the original AW RN inventory IRAS. 
#' Returns the plot (ggplot).
#' @name plot_IRAS
#' @param df dataframe with characterised and aw iras
#' @export
plot_iras <- function(df){


       ####### Check if anything has changed in column names
  df_names <- colnames(df)
  col_names <- c("IRAS", "awz_IRAS")
  for (name in col_names){
    if(!name %in% df_names){
      print(paste0("Column names changed! ",name," is not anymore in the dataframe!"))
      return()
    }
  }

  binwidth_iras <- freedman_diaconis_binwidth_log(df$IRAS)

  plot <- ggplot2::ggplot(df)+
    ggplot2::geom_point(ggplot2::aes(x=IRAS,y=awz_IRAS),
                        alpha=0.6)+
    ggplot2::geom_abline(slope=1,intercept=0,
                          linetype="dashed",color="firebrick",linewidth=0.8)+
    ggplot2::scale_x_log10()+ggplot2::scale_y_log10()+
    ggplot2::labs(x="Characterisation IRAS",y="ActiWiz IRAS")+
    theme_professional()

  return(plot)
}
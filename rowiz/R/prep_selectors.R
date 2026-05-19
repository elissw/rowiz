#' Check what are the main materials our items consist of
#' Returns a vector with the main material names
#' @name get_materials
#' @param df dataframe name
#' @export
get_materials <- function(df) {
  df_main <- df |> dplyr::filter(component_id >0)
  main_mats <- unique(df_main$material)
  return(main_mats)
}


#' Extract the radionuclides present in the dataframe.
#' Returns a vector with the names.
#' @name get_radionuclides
#' @param df dataframe name
#' @export
get_radionuclides <- function(df) {

  # Radionuclide naming convention 
  # WILL CRASH IF YOU DON'T READ WITH THE PROVIDED FUNCTION 
  # Or if you don't read in the dataframe yourself with check.names = FALSE
  rn_pattern <- "^[a-zA-Z]{1,2}-[0-9]{1,3}[mn]?$"

  # Get the columns following the convention
  all_columns <- colnames(df)
  radionuclides <- all_columns[ grepl(rn_pattern, colnames(df)) ]

  return(radionuclides)

}
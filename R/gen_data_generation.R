#' Function to create one package
#' @name create_one_package
#' @param df dataframe containing the items we will sample from
#' @param items_per_package how many  items should the package contain
#' @export
create_one_package <- function(df, items_per_package, materials) {

    # Sample the items/components
    df_items_one_package <- df |>
      dplyr::slice_sample(n = items_per_package, replace = TRUE) |>
      dplyr::mutate(weight_item = mass_kg)
  
    # Quantities that will enter the package as a weighted average of 
    # those of individual items  
    rp_item_quantities <- c("LL", "Co-60_eq", "IRAS",
                            "dose_inh_uSv_g", "dose_ing_uSv_g",
                            "total_activity_Bq_g", 
 )


}
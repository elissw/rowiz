#' Label machines
#'
#' Label machines and group LHC experiments together under a new column (keeps original column).
#' 
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

#' Extract relevant radionuclides
#'
#' Find the relevant nuclides for a specific radiological limit.
#' By relevant nuclides we mean the ones that have an activity of >= 1% of the whatever limit
#' for at least one item in the dataframe.
#' 
#' Returns a vector with the revelant nuclide names
#' @name get_relevant_radionuclides
#' @param df dataframe name
#' @param limit_col the name of the column containing the limit we want to check (eg CL_lim)
#' @export
get_relevant_radionuclides <- function(df, limit_col) {

  df_radionuclide_library <- read.csv(system.file("lib", "radionuclide_library.csv", package = "rowiz"))

  # Keep only item rows
  df_items <- df[df$component_id == 0, ]
  # make sure it works evn if someone didn't read with check.names = FALSE
  df_radionuclide_library$radionuclide_norm  <- make.names(df_radionuclide_library$radionuclide)
  data_norm <- make.names(names(df_items))

  # Keep only radionuclides that exist in the data
  df_radionuclide_library <-
    df_radionuclide_library[
      df_radionuclide_library$radionuclide_norm %in% data_norm,
    ]

  # Keep only radionuclides with a normal limit for the chosen column
  df_radionuclide_library <-
    df_radionuclide_library[
      df_radionuclide_library[[limit_col]] > 0,
    ]

  # Extract activities
  df_activities <-
    df_items[, match(df_radionuclide_library$radionuclide_norm, data_norm)]

  # Divide by the chosen limit column
  df_LL_fractions <- sweep(
    df_activities,
    2,
    df_radionuclide_library[[limit_col]],
    `/`
  )

  # Check which ones reach 1% of the limit
  keep <- apply(df_LL_fractions > 0.01, 2, any, na.rm = TRUE)

  return(df_radionuclide_library$radionuclide[keep])

}



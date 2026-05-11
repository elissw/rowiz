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
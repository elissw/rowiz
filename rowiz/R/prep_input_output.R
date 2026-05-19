#' Read csv file
#'
#' Accept an input csv file path and name and read it into a dataframe
#' making sure the options are what we need them to be:
#' Treat first row as header.
#' Don't convert strings to factors, keep them characters.
#' Don't "fix" the names .
#' 
#' Returns the dataframe
#' @name read_input_dataframe
#' @param filename The full path and name of the input csv file
#' @export
read_input_dataframe <- function(filename) {
  df <- read.csv(
    file = filename,
    header = TRUE,
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
  
  return(df)
}
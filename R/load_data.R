#' Load Data from CSV File

#'
#' Reads a CSV file into R and cleans the data by dropping any row(s) containing missing values.

#'
#' @param file_name The name of the CSV file to load, with an optional default value `"data.csv"`.


#' @return The loaded data.


#' @export

load_data <- function(file_name = "data.csv") {
  data <- reader::read_csv(file_name)
  
  # drop rows with missing values
  data <- data[!is.na(data)]
  
  return(data)
}


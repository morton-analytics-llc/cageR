#' Convert R Docs to Data
#' 
#' This function converts R documentation into prompts and responses
#' 
#' @param pkg a string indicating the package to convert
#' 
#' @return a dataframe of prompts and responses
#' 
#' @export
convert_r_docs <- function(pkg){
  docs_to_convert <- tools::Rd_db(pkg)
  doc_titles <- purrr::map_chr(docs_to_convert, tools:::.Rd_get_title)
  
  names_to_use <- names(docs_to_convert)
  funcs_to_convert <- gsub(".Rd","", names_to_use)
  
  df_text <- purrr::map_df(funcs_to_convert, function(d){
    
    library(pkg, character.only = TRUE)
    try(this_function <- deparse(eval(str2lang(d))))
    detach(paste("package", pkg, sep = ":"), character.only = TRUE)

    this_function <- paste0(this_function, collapse = " ")

    data.frame(response = this_function)
  }) |>
    dplyr::mutate(request = doc_titles,.before = response )

  return(df_text)
}
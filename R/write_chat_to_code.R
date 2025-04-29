#' Write Chat Text to Code
#' 
#' @description
#' This function takes chat responses with code chunks and converts it
#' to R files.
#' 
#' @param filename a string indicating what the file should be called
#' @param folder a string indicating where the file should be stored
#' @param chat_response a string from the LLM chat API with code chunks
#' 
#' @return Nothing is returned - side effects only to write an R file
#' 
#' @export
write_chat_to_code <- function(filename, folder, chat_response){
  temp_file <- tempfile(pattern = "temp", fileext = '.md')

  writeLines(text = test_response, con = temp_file)

  final_file <- glue::glue("{folder}/{filename}")

  subset_even <- function(x) x[!seq_along(x) %% 2]

  lines <- readr::read_file(temp_file) %>% 
    stringr::str_split("```.*", simplify = TRUE) %>%
    subset_even() %>% 
    stringr::str_flatten("\n## new chunk \n")
  
  writeLines(lines, con= final_file)

  return(NULL)
}
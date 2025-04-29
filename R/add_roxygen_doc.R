#' Add roxgyen documentation
#' 
#' @description
#' This function provides basic documentation to an R function stored in a file.
#' 
#' @param file_path a string to the file to document
#' 
#' @return Nothing is returned; the file is re-written with documentation
#' 
#' @export
add_roxygen_doc <- function(file_path){

  system_prompt <- system.file("system_prompts/roxygen.md", package = "cageR")
  chat_prompt <- chat_ollama(model = "llama3.2", system_prompt = readLines(system_prompt))

  lines_to_read <- readLines(file_path)
  lines_to_read <- paste0(lines_to_read, collapse = "\n")

  this_request <- glue::glue("
  Write documentation for this function:
    {lines_to_read}
  ")

  this_response <- chat_prompt$chat(this_request, echo = FALSE)

  result <- sprintf("%s\n%s", this_response, lines_to_read)

  writeLines(text = result, con = file_path)
}
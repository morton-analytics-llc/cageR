#' Create Content for Tuning
#' 
#' This function converts a function into content usable for
#' an LLM tuning.
#' 
#' @param func a string indicating the function name that could be called in R
#' @param args_to_use arguments to use in the function
#' 
#' @return a JSON string with a prompt and the function to be written
#' 
#' @export
create_content <- function(func, args_to_use){
  
  ## initial assets
  prompt_start <- glue::glue("use the R programming language function {func}")
  
  func_args <- formals(get(func))
  
  ellipses_available <- length(func_args[names(func_args) == '...']) > 0
  
  ## generate string from arguments
  func_args_glued <- purrr::imap(args_to_use, function(d, i){
    if(d %in% names(func_args) | ellipses_available){
      final <- glue::glue(" {names(args_to_use[i])} = {d}")
      return(final)
    } else {
      next
    }
  }) |>
    paste0(collapse = ",")
  
  ## produce data.frame row where each column is text
  prompt_var <- glue::glue("{prompt_start} using the arguments {func_args_glued}")
  
  func_call <- glue::glue("{func}({func_args_glued})")
  
  func_result <- tryCatch(
    func_result <- lazyeval::lazy_eval(func_call)
    ,error = function(err){
      func_result <- 'error'
    }
  )
  func_result <- glue::glue("{func_result}")

  final <- data.frame(
    prompt_var = prompt_var
    ,response_var = func_call
    ,result = func_result
  ) 
  
  return( final )
}
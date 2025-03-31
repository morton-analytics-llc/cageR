library(cageR)

## generate csv from datasets
temp_1 <- tempfile(pattern = "mtcars", fileext = ".csv")
write.csv(mtcars, temp_1)
temp_2 <- tempfile(pattern = "iris", fileext = ".csv")
write.csv(iris, temp_2)
files_to_read <- c(temp_1, temp_2)
files_to_read <- glue::glue("file = '{files_to_read}'")

## define functions to use
functions_to_create <- c(
  'read.csv', 'read.csv2', 'read.delim'
)

## generate content args
content_args <- purrr::map(functions_to_create, function(d){
  purrr::map(files_to_read, function(e){
    list(func = d, args_to_use = e)
  })
}) |>
  purrr::flatten()

## generate text
content_text <- purrr::map_df(content_args, function(d){
  create_content(func = d[['func']], args_to_use = d[['args_to_use']])
})
str(content_text)

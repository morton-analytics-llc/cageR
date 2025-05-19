library(plotly)

draw_line_chart_plotly <- function(data, x_var, y_var, group_var, legend_title){
  validate_data <- is.data.frame(data)
  if(!validate_data){
    stop("Data must be a dataframe for the plotly line chart")
  }
  validate_inputs <- purrr::map(c("x_var", "y_var", "group_var", "legend_title"),function(d){
    valid_input <- is.character(get(d))
    if(valid_input){
      return(NULL)
    } else {
      glue::glue("{d} must be a character string")
    }
  }) |>
    purrr::compact()

  if(length(validate_inputs) > 0){
    stop(glue::glue("{validate_inputs} needs to be a character string."))
  }

  final <- plotly::plot_ly(
    data = data
    ,x = data[[ x_var ]]
    ,y = data[[ y_var ]]
    ,color = as.character( data[[ group_var ]] )
    ,type = 'scatter'
    ,mode = 'lines'
  ) |>
    plotly::layout(
      title = legend_title
      ,xaxis = list(title = x_var)
      ,yaxis = list (title = y_var)
    )
  
  return(final)
}
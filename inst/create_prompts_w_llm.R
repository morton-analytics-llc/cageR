library(ellmer)
library(ollamar)
library(tidyr)
library(purrr)
library(furrr)
library(cageR)

plan(multisession)

pull("llama3.2")

## develop personas
personas_to_use <- c(
  'Albert Einstein'
  ,'Hannah Arendt'
  ,'Aristotle'
  ,'Toni Morrison'
  ,'Stephen Hawking'
  ,'Katherine Johnson'
)

## develop roles
roles_to_use <- c(
  'data engineer'
  ,'data analyst'
  ,'data scientist'
  ,'machine learning engineer'
  ,'software engineer'
)

## develop purpose
purposes_to_use <- c(
  'build an API'
  ,'build a web-based application'
  ,'build a web-based user interface'
  ,'perform an analysis'
  ,'extract, transform, and load data'
)

functions_to_use <- c(
  "load_csv <- function(file_name = 'data.csv'){

      final <- reader::read_csv(file = file_name)

      return(final)
    }
  "
)

## longer and shorter
lengths_to_use <- c('longer', 'shorter')

## all combinations 
combos_to_use <- crossing(personas_to_use, roles_to_use, purposes_to_use, functions_to_use)

df_prompts_response <- map_df(seq_len(nrow(combos_to_use[1:5,])), function(idx){
  this_df <- combos_to_use[idx,]
  this_persona <- this_df[['personas_to_use']]
  this_role <- this_df[['roles_to_use']]
  this_purpose <- this_df[['purposes_to_use']]
  this_function <- this_df[['functions_to_use']]


  this_chat <- chat_ollama(
    model = "llama3.2"
    ,system_prompt = glue::glue("
    You are {this_persona} as if you are a {this_role} while {this_purpose}.
    You are an expert prompt engineer that needs to fine-tune.
    Example code provided is the only target response.
    Just give me the prompt you would use for the target response
    Focus on the problem the R programming task that the example code is trying to perform.
    ")
  )

  prompt_to_send <- glue::glue("
    Engineer a prompt that produces code very similar to the example code:
      '{this_function}'
    Function arguments are examples only and can be replaced with different file paths and names.
  ")

  response_to_write <- this_chat$chat(prompt_to_send, echo = FALSE)

  final <- data.frame(
    prompt = response_to_write
    ,response = this_function
  )

})

chat_test <- chat_ollama(model = "llama3.2", system_prompt = readLines("inst/system_prompts/r_bindings.md"))

idx <- 1
df_prompts_response$prompt[idx]

test_response <- chat_test$chat(df_prompts_response$prompt[idx])

test_documentation <- chat_test$chat("Write documentation using roxygen2 style syntax for this function.")

write_chat_to_code("load_data.R", "./R", test_response)

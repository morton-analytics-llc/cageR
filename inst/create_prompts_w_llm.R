library(ellmer)
library(ollamar)
library(tidyr)
library(furrr)

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
  "df <- read.table(file_name = data.csv, headers = T, sep = ',')"
)

## longer and shorter
lengths_to_use <- c('longer', 'shorter')

## all combinations 
combos_to_use <- crossing(personas_to_use, roles_to_use, purposes_to_use)

df_prompts_response <- map_df(seq_len(nrow(combos_to_use[1:5,])), function(idx){
  this_df <- combos_to_use[idx,]
  this_persona <- this_df[['personas_to_use']]
  this_role <- this_df[['roles_to_use']]
  this_purpose <- this_df[['purposes_to_use']]
  this_function <- this_df[['functions_to_use']]


  this_chat <- chat_ollama(
    model = "llama3.2"
    ,system_prompt = glue::glue("
    You are an expert prompt engineer that needs to fine-tune your large language model with novel datasets.
    Your prompts are only used to generate code in the R Programming language.
    The example code provided is the only target response.
    Do not make assumptions.
    Focus on the problem the R programming task that the example code is trying to perform.
    Adapt the prompt in the persona of {this_persona} as if they
    are a {this_role} while {this_purpose}.
    ")
  )

  prompt_to_send <- glue::glue("
    Engineer a prompt that produces code very similar to the example code:
      '{function_to_use}'
    Function arguments are examples only and can be replaced with different file paths and names.
  ")

  response_to_write <- this_chat$chat(prompt_to_send, echo = FALSE)

  final <- data.frame(
    prompt = response_to_write
    ,response = function_to_use
  )

})

chat_test <- chat_ollama(model = "llama3.2",system_prompt = "
You are an expert R programmer who prefers the tidyverse.
Just give me the code. I don't want any explanation or sample data.
Follow the tidyverse style guide:
  * Spread long function calls across multiple lines.
  * Where needed, always indent function calls with two spaces.
  * Only name arguments that are less commonly used.
  * Always use double quotes for strings.
  * Use the base pipe, `|>`, not the magrittr pipe `%>%`.
Use the least amount of code possible.
Debug the code.
Optimize the code for performance.
")

idx <- 4
df_prompts_response$prompt[idx]

test_response <- chat_test$chat(df_prompts_response$prompt[idx])

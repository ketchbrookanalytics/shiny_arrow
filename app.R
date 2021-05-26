library(shiny)
library(arrow)
library(dplyr)


data <- arrow::read_parquet(
  file = here::here("data/all_of_the_data.parquet"), 
  as_data_frame = FALSE   # keep as parquet table to keep back-end lighter
)



ui <- shiny::fluidPage(
  
  # Create a UI drop-down menu...
  shiny::selectizeInput(
    inputId = "choose_item_code", 
    label = NULL, 
    choices = NULL, 
    selected = character(0), 
    options = list(
      placeholder = "Choose One...",
      onInitialize = I('function() { this.setValue(""); }')
    )
  ), 
  
)

server <- function(input, output, session) {
  
  # Initiate a 'reactiveValues' object
  rctv <- shiny::reactiveValues()
  
  # Start off with no Item Code selected
  rctv$selected_item_code <- NULL
  
  # Set up the 'selectizeInput' drop-down choices on the server-side; this is 
  # done to improve performance, 
  # RE: https://shiny.rstudio.com/articles/selectize.html
  shiny::updateSelectizeInput(
    session = session,
    inputId = "choose_item_code", 
    choices = data %>% 
      dplyr::select(Item_Code) %>% 
      dplyr::collect() %>% 
      dplyr::pull(Item_Code) %>% 
      unique() %>% 
      sort(), 
    selected = character(0), 
    options = list(
      placeholder = "Choose One...",
      render = I('function() { this.setValue(""); }')
    ),
    server = TRUE
  )
  
  
  
  # When an Item Code is selected...
  shiny::observeEvent(input$choose_item_code, {
    
    # Require that an Item Code has been selected
    shiny::req(rctv$selected_item_code)
    
    # Capture the filtered data based upon the UI selection
    rctv$filtered_data <- data %>% 
      dplyr::filter(Item_Code == rctv$selected_item_code) %>% 
      dplyr::collect()   # convert from parquet table to tibble, so that we can
                         # use the selected data downstream in a plot/table/etc.
    
  })
  
  
  # TODO: build a ggplot or something to display the selected observations
  
  
  
}

shinyApp(ui, server)
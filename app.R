## Developed by: 
##   Michael Thomas
##   Chief Data Scientist
##   Ketchbrook Analytics
## Contact:  MTHOMAS@KETCHBROOKANALYTICS.COM


library(shiny)
library(shinythemes)   # simple way to use bootstrap UI theme
library(emo)   # emojis (for app header)
library(arrow)   # read data from parquet
library(dplyr)   # ETL
library(reactable)   # interactive data tables
library(waiter)   # custom loading screens


data <- arrow::read_parquet(
  file = here::here("data/all_of_the_data.parquet"), 
  as_data_frame = FALSE   # keep as parquet table to keep back-end lighter
)


# Build the front-end UI
ui <- shiny::navbarPage(
  
  title = paste0("{arrow} + {shiny} ", emo::ji(keyword = "heart")), 
  
  theme = shinythemes::shinytheme(theme = "cerulean"),
  
  shiny::tabPanel(
    
    title = "Home",
    
    waiter::use_waiter(), 
    
    shiny::fluidRow(
      
      shiny::column(
        width = 4, 
        
        shiny::wellPanel(
          
          # Create a UI drop-down menu...
          shiny::selectizeInput(
            inputId = "choose_item_code", 
            label = paste0("Select an \"Item Code\" to View Related Data"), 
            choices = NULL, 
            selected = character(0), 
            options = list(
              placeholder = "Choose One...",
              onInitialize = I('function() { this.setValue(""); }')
            )
          ), 
          
          shiny::br(), 
          
          shiny::div(
            class = "float-right", 
            shiny::actionButton(
              inputId = "apply_item_code_btn", 
              class = "float-right", 
              label = "Apply"
            )
          )
          
        )
        
      ), 
      
      shiny::column(
        width = 8, 
        
        shiny::wellPanel(
          
          shiny::h4("How it works:"), 
          
          shiny::p(
            paste0(
              "The back-end dataset behind this app consists of 1 million rows ", 
              "of data across 11 variables. The 'Item_Code' variable contains ", 
              "1,000 unique alphanumeric codes, which must be individually ", 
              "selected to view the related (filtered) data."
            )
          ), 
          
          shiny::p(
            paste0(
              "When the user selects an Item Code and clicks \"Apply\", that ", 
              "Item Code is sent to the server to be used to generate a ", 
              "reactive data frame via "
            )
          ), 
          
          shiny::code("dplyr::filter(Item_Code == [Selected Item Code])")
          
        )
        
      )
      
    ), 
    
    shiny::hr(), 
    
    shiny::fluidRow(
      
      shiny::column(
        width = 12, 
        
        reactable::reactableOutput(
          outputId = "tbl"
        )
        
      )
      
    )
    
  ), 
  
  shiny::tabPanel(
    
    title = "About", 
    
    shiny::fluidRow(
      
      shiny::column(
        width = 12, 
        
        shiny::div(
          class = "jumbotron", 
          shiny::h1("Curious to Learn More?"), 
          shiny::p(
            class = "lead", 
            "Check out what else we do at Ketchbrook Analytics."
          ), 
          shiny::a(
            class = "btn btn-info btn-lg", 
            href = "https://www.ketchbrookanalytics.com/", 
            target = "_blank", 
            "Visit Us"
          )
        )
        
      )
    )
    
  )
  
)

# Build the back-end Server
server <- function(input, output, session) {
  
  # Build loading screen
  w <- waiter::Waiter$new(
    html = shiny::tagList(
      "Querying Data...", 
      waiter::spin_ball()
    )
  )
  
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
  shiny::observeEvent(input$apply_item_code_btn, {
    
    # Require that a valid Item Code has been selected
    shiny::req(input$choose_item_code != "")
    
    w$show()
    
    Sys.sleep(1)
    
    rctv$selected_item_code <- input$choose_item_code
    
    # Capture the filtered data based upon the UI selection
    rctv$filtered_data <- data %>% 
      dplyr::filter(Item_Code == rctv$selected_item_code) %>% 
      dplyr::collect()   # convert from parquet table to tibble, so that we can
                         # use the selected data downstream in a plot/table/etc.
    
  })
  
  
  # TODO: build a ggplot or something to display the selected observations
  
  # Build an interactive data table using the 'filtered_data' data frame
  output$tbl <- reactable::renderReactable({
    
    shiny::req(rctv$filtered_data)
    
    tbl <- reactable::reactable(
      
      data = rctv$filtered_data %>% 
        dplyr::relocate(
          Item_Code, 
          .before = tidyselect::everything()
        ), 
      
      defaultColDef = reactable::colDef(
        cell = function(value) {
          round(value, 3)
        }
      ), 
      
      columns = list(
        Item_Code = reactable::colDef(
          align = "center", 
          cell = function(value) {
            value
          }
        )
      )
      
    )
    
    w$hide()
    
    return(tbl)
    
  })
  
  
  
}

shinyApp(ui, server)
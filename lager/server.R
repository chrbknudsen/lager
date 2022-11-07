#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# define functions ----



  
add_to_stock <- function(input){
   data <- read_rds("../data/transaktioner.rds")
   ny <- data.frame(matrix(nrow=1,ncol=0))
   ny$timestamp <- lubridate::now()
   ny$hvad <- input[["hvad"]]
   ny$antal <- input[["antal"]]
   ny$storrelse <- input[["storrelse"]]
   ny$lokation <- input[["lokation"]]
   ny$kategori <- input[["kategori"]]
   ny$tags <- input[["tags"]]
   ny$note <- input[["note"]]
   data <- rbind(data, ny)
   write_rds(data, "../data/transaktioner.rds")
  }

# Define server logic required to draw a histogram ----
shinyServer(function(input, output, session) {

    output$tabel <- renderTable({
        read_rds("../data/transaktioner.rds")
    })
    
    observeEvent(input$addbutton, {
      print("added")
      add_to_stock(input)
    })
    
    choices_remove_hvor <- reactive({
      choices_remove_hvor <- read_rds("../data/transaktioner.rds") %>% 
        select(lokation) %>% 
        distinct() %>% 
        pull(lokation)
    })
    
    choices_remove_hvad <- reactive({
      choices_remove_hvor <- read_rds("../data/transaktioner.rds") %>% 
        filter(lokation == input$remove_hvor) %>% 
        select(hvad) %>% 
        distinct() %>% 
        pull(hvad)
    })
    
    
    observe({
      updateSelectInput(session = session, inputId = "remove_hvor", choices = choices_remove_hvor())
    })
    observe({
      updateSelectInput(session = session, inputId = "remove_hvad", choices = choices_remove_hvad())
    })

})

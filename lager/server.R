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


fields <- c("timestamp","hvad","antal","storrelse","lokation","kategori", "tags", "note")
  
add_to_stock <- function(input){
   data <- read_rds("../data/transaktioner.rds")
   ny <- data.frame(matrix(nrow=1,ncol=0))
   ny$timestamp <- lubridate::now()
   for(x in fields){
     var <- input[[x]]
     ny[[x]] <- var
   }
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
    
    observe({
      updateSelectInput(session = session, inputId = "remove_hvor", choices = choices_remove_hvor())
    })

})

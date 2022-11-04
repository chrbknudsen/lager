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

fields <- c("hvad","maengde","udloeb","hvor")

add_to_stock <- function(input){
   data <- read_csv("../data/transaktioner.csv")
   ny <- data.frame(matrix(nrow=1,ncol=0))
   ny$timestamp <- lubridate::now()
   for(x in fields){
     var <- input[[x]]
     ny[[x]] <- var
   }
   data <- rbind(data, ny)
   write_csv(data, "../data/transaktioner.csv")
  }

# Define server logic required to draw a histogram ----
shinyServer(function(input, output, session) {

    output$tabel <- renderTable({
        read_csv("../data/transaktioner.csv")
    })
    
    observeEvent(input$addbutton, {
      print("added")
      add_to_stock(input)
    })
    
    choices_remove_hvor <- reactive({
      choices_remove_hvor <- read_csv("../data/transaktioner.csv") %>% 
        select(hvor) %>% 
        distinct() %>% 
        pull(hvor)
    })
    
    observe({
      updateSelectInput(session = session, inputId = "remove_hvor", choices = choices_remove_hvor())
    })

})

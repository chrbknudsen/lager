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

fields <- c("timestamp","hvad","maengde","udloeb","hvor")

add_to_stock <- function(input){
   data <- read_csv("../data/transaktioner.csv")
   ny <- data.frame(matrix(nrow=1,ncol=0))
   ny$timestamp <- lubridate::now()
   for(x in fields){
     var <- input[[x]]
     ny$´x´ <- var
   }
   
   print(class(ny))
   print("----")
   print("data")
   print(data)
   print(ncol(data))
   print("-----")
   print("ny")
   print(ny)
   print(ncol(ny))
   print(str(ny))
   data <- rbind(data, ny)
   print(data)
   write.csv(data, "../data/transaktioner.csv")
  }

# Define server logic required to draw a histogram ----
shinyServer(function(input, output) {

    output$tabel <- renderTable({
        iris
    })
    
    observeEvent(input$addbutton, {
      print("added")
      add_to_stock(input)
    })

})

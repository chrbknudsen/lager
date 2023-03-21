library(shiny)

shinyUI(fluidPage(
  titlePanel("Lagerstyring"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("action", "Handling:", choices = c("Tilføj varer", "Fjern varer")),
      uiOutput("itemNameUI"),
      uiOutput("locationUI"),
      numericInput("quantity", "Antal:", value = 1, min = 1),
      actionButton("submit", "Udfør handling")
    ),
    
    mainPanel(
      tableOutput("inventoryTable")
    )
  )
))

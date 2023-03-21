# ui.R

library(shiny)

# Define UI for the Shiny app
ui <- fluidPage(
  # read in the csv-file
  my_data <- read.csv("data/my_data.csv", stringsAsFactors = FALSE),
  
  # Create a tabset with three tabs
  tabsetPanel(
    tabPanel("Add data", 
             h1("This is tab 1"),
             
             # Create a form for adding data to the CSV file
             fluidRow(
               # Create the input fields
               selectInput("type", "Type:", choices = c("", unique(my_data$Type))),
               numericInput("amount", "Amount:", 0),
               # Create the "Add Data" button
               actionButton("add_data", "Add Data")
             )
    ),
    
    tabPanel("Tab 2", h1("This is tab 2")),
    tabPanel("Tab 3", h1("This is tab 3"))
  )
)
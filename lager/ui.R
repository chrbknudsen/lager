#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Lager"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput(
              inputId = "handling",
              label = NULL,
              choices = c(
                "lagerstatus" = "status",
                "tilføj" = "add",
                "udtag" = "remove"
              )
            ),
            conditionalPanel(
              condition = "input.handling == 'status'",
              sliderInput("breakCount", "status", min = 1, max = 50, value = 10)
            ),
            conditionalPanel(
              condition = "input.handling == 'add'",
              textInput(
                inputId = "hvad",
                label = "Hvad",
                value = ""
                ),
              textInput(
                inputId = "maengde",
                label = "Mængde",
                value = ""
              ),
              textInput(
                inputId = "udloeb",
                label = "Udløb",
                value = ""
              ),
              selectInput(
                inputId = "hvor",
                label = "Hvor",
                choices = c(
                  "fryser" = "fryser2",
                  "kælder" = "kælder",
                  "kælder2" = "kælder2a"
                  )
                ),
              actionButton("addbutton", "Tilføj til lager")
              ),
            conditionalPanel(
              condition = "input.handling == 'remove'",
              sliderInput("breakCount", "remove", min = 1, max = 50, value = 10)
            )
          
        ),

        # Show a plot of the generated distribution
        mainPanel(
          conditionalPanel(
            condition = "input.handling == 'status'",
            tableOutput("tabel")
          )
          
        )
    )
))

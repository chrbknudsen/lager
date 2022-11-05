#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
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
                inputId = "antal",
                label = "Antal",
                value = ""
              ),
              textInput(
                inputId = "storrelse",
                label = "Størrelse",
                value = ""
              ),
              selectInput(
                inputId = "lokation",
                label = "Lokation",
                choices = c(
                  "fryser" = "fryser2",
                  "kælder" = "kælder",
                  "kælder2" = "kælder2a"
                  )
                ),
              textInput(
                inputId = "kategori",
                label = "Kategori",
                value = ""
              ),
              textInput(
                inputId = "tags",
                label = "Tags",
                value = ""
              ),
              textInput(
                inputId = "note",
                label = "Note",
                value = ""
              ),
              actionButton("addbutton", "Tilføj til lager")
              ),
            conditionalPanel(
              condition = "input.handling == 'remove'",
              selectInput(inputId = "remove_hvor", label = "Hvorfra skal der fjernes", choices = NULL)
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

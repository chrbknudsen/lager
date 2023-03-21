library(shiny)
library(readr)

shinyServer(function(input, output, session) {
  csv_file <- "inventory.csv"
  
  if (file.exists(csv_file)) {
    inventory <- reactive({ read_csv(csv_file, locale = locale(encoding = "UTF-8")) })
  } else {
    inventory <- reactive({ 
      empty_inventory <- data.frame(Item = character(0), Location = character(0), Quantity = numeric(0), stringsAsFactors = FALSE)
      write_csv(empty_inventory, csv_file)
      empty_inventory
    })
  }
  
  output$itemNameUI <- renderUI({
    selectizeInput("item_name", "Varenavn:", choices = unique(c("", inventory()$Item)), options = list(create = TRUE))
  })
  output$locationUI <- renderUI({
    selectizeInput("location", "Placering:", choices = unique(c("", inventory()$Location)), options = list(create = TRUE))
  })
  
  observeEvent(input$submit, {
    req(input$item_name, input$location)
    
    current_inventory <- inventory()
    
    if (input$action == "Tilføj varer") {
      idx <- which(current_inventory$Item == input$item_name & current_inventory$Location == input$location)
      
      if (length(idx) == 0) {
        new_entry <- data.frame(Item = input$item_name, Location = input$location, Quantity = input$quantity, stringsAsFactors = FALSE)
        current_inventory <- rbind(current_inventory, new_entry)
      } else {
        current_inventory[idx, "Quantity"] <- current_inventory[idx, "Quantity"] + input$quantity
      }
    } else {
      idx <- which(current_inventory$Item == input$item_name & current_inventory$Location == input$location)
      
      if (length(idx) != 0) {
        current_inventory[idx, "Quantity"] <- current_inventory[idx, "Quantity"] - input$quantity
        
        if (current_inventory[idx, "Quantity"] <= 0) {
          current_inventory <- current_inventory[-idx,]
        }
      }
    }
    
    write_csv(current_inventory, csv_file, col_names = TRUE)
    
    updateSelectizeInput(session, "item_name", choices = unique(c("", current_inventory$Item)), selected = "", server = TRUE)
    updateSelectizeInput(session, "location", choices = unique(c("", current_inventory$Location)), selected = "", server = TRUE)
    updateNumericInput(session, "quantity", value = 1)
  })
  
  output$inventoryTable <- renderTable(inventory(), rownames = FALSE)
})

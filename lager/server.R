library(shiny)
library(readr)

shinyServer(function(input, output, session) {
  csv_file <- "inventory.csv"
  
  if (file.exists(csv_file)) {
    inventory <- reactiveVal(read_csv(csv_file, locale = locale(encoding = "UTF-8")))
  } else {
    inventory <- reactiveVal(data.frame(Item = character(0), Location = character(0), Quantity = numeric(0), stringsAsFactors = FALSE))
    write_csv(inventory(), csv_file)
  }
  
  observe({
    inventory() # Invalidate the observer when the inventory changes
    updateSelectizeInput(session, "item_name", "Varenavn:", choices = unique(c("", inventory()$Item)), options = list(create = TRUE), selected = "")
    updateSelectizeInput(session, "location", "Placering:", choices = unique(c("", inventory()$Location)), options = list(create = TRUE), selected = "")
  })
  
  output$itemNameUI <- renderUI({
    selectizeInput("item_name", "Varenavn:", choices = NULL, options = list(create = TRUE))
  })
  
  output$locationUI <- renderUI({
    selectizeInput("location", "Placering:", choices = NULL, options = list(create = TRUE))
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
    
    inventory(current_inventory)
    write_csv(current_inventory, csv_file, col_names = TRUE)
  })
  
  output$inventoryTable <- renderTable({
    req(inventory())
    inventory()
  }, rownames = FALSE)
})

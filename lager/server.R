# server.R

# Define server logic
server <- function(input, output) {
  
  # Create the CSV file if it doesn't exist
  if (!file.exists("data/my_data.csv")) {
    write.csv(data.frame(Type = character(), Amount = numeric()), file = "data/my_data.csv", row.names = FALSE)
  }

  
  # Define the function for adding data to the CSV file
  add_data <- function(type, amount) {
    # Read in the CSV file
    my_data <- read.csv("data/my_data.csv", stringsAsFactors = FALSE)
    
    # Check if the type already exists in the data
    if (type %in% my_data$Type) {
      # Add the new data to the data frame
      new_data <- data.frame(Type = type, Amount = amount)
      my_data <- rbind(my_data, new_data)
    } else {
      # Create a new data frame with the new type and amount
      new_data <- data.frame(Type = type, Amount = amount)
      # Bind the new data frame to the existing data frame
      my_data <- rbind(my_data, new_data)
      # Sort the data frame by type
      my_data <- my_data[order(my_data$Type), ]
    }
    
    # Write the updated data frame to the CSV file
    write.csv(my_data, file = "data/my_data.csv", row.names = FALSE)
  }
  
  # Define the action when the "Add Data" button is clicked
  observeEvent(input$add_data, {
    type <- input$type
    amount <- input$amount
    
    # Only add data if the type is not blank
    if (type != "") {
      add_data(type, amount)
      
      # Reset the input fields and display a message
      updateSelectInput(session, "type", choices = c("", unique(my_data$Type)))
      updateNumericInput(session, "amount", value = 0)
      showModal(modalDialog(title = "Data added", "The following data was added to the CSV file:\n\nType: ", type, "\nAmount: ", amount))
    }
  })
}

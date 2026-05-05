library(shiny)
library(shinydashboard)
library(readxl)
library(writexl)
library(dplyr)
library(ggplot2)


#this was to change the file name, ignore this line
# ---------------------------
# Emission Factor Database
# ---------------------------
ef_material <- data.frame(
  Material = c("Steel", "Aluminium", "Plastic", "Glass", "Paper"),
  EF = c(2.1, 8.5, 3.2, 1.4, 0.9)
)

ef_spend <- data.frame(
  Sector = c("IT Services", "Office Supplies", "Consulting", "Logistics", "Marketing"),
  EF = c(0.5, 0.8, 0.3, 0.6, 0.4)
)

ef_transport <- data.frame(
  Mode = c("Truck", "Ship", "Air"),
  EF = c(0.1, 0.02, 0.6)
)

ef_waste <- data.frame(
  Type = c("Landfill", "Recycling", "Incineration"),
  EF = c(0.8, 0.2, 1.1)
)

# ---------------------------
# UI
# ---------------------------
ui <- dashboardPage(
  dashboardHeader(title = "Scope 3 Category 1 Tool"),
  
  dashboardSidebar(
    selectInput("method", "Calculation Method",
                choices = c("Supplier Specific", "Hybrid", "Spend-Based")),
    
    fileInput("file", "Upload Data (Excel/CSV)"),
    
    hr(),
    h4("Emission Factor Override"),
    checkboxInput("override", "Use Custom EF", FALSE)
  ),
  
  dashboardBody(
    fluidRow(
      valueBoxOutput("totalBox"),
      valueBoxOutput("methodBox")
    ),
    
    fluidRow(
      box(title = "Emissions by Item", width = 6,
          plotOutput("barPlot")),
      
      box(title = "Contribution Breakdown", width = 6,
          plotOutput("piePlot"))
    ),
    
    fluidRow(
      box(title = "Results Table", width = 12,
          tableOutput("results"))
    ),
    
    fluidRow(
      box(title = "Data Quality Warnings", width = 12,
          verbatimTextOutput("warnings"))
    ),
    
    downloadButton("download_results", "Download Excel")
  )
)

# ---------------------------
# SERVER
# ---------------------------
server <- function(input, output) {
  
  data_input <- reactive({
    req(input$file)
    ext <- tools::file_ext(input$file$name)
    
    if (ext == "csv") {
      read.csv(input$file$datapath)
    } else {
      read_excel(input$file$datapath)
    }
  })
  
  results <- reactive({
    df <- data_input()
    
    if (input$method == "Supplier Specific") {
      
      if (!input$override) {
        df <- df %>%
          left_join(ef_material, by = c("Item" = "Material")) %>%
          mutate(EF_used = EF,
                 Emissions = Quantity_kg * EF_used)
      } else {
        df <- df %>%
          mutate(Emissions = Quantity_kg * EF_kgCO2e_per_kg)
      }
      
    } else if (input$method == "Spend-Based") {
      
      if (!input$override) {
        df <- df %>%
          left_join(ef_spend, by = c("Item" = "Sector")) %>%
          mutate(EF_used = EF,
                 Emissions = Spend_USD * EF_used)
      } else {
        df <- df %>%
          mutate(Emissions = Spend_USD * EF_kgCO2e_per_USD)
      }
      
    } else if (input$method == "Hybrid") {
      
      df <- df %>%
        mutate(
          Material_Emissions = Material_mass * Material_EF,
          Transport_Emissions = Transport_km * Transport_EF,
          Waste_Emissions = Waste_kg * Waste_EF,
          Emissions = Scope1_2 + Material_Emissions +
            Transport_Emissions + Waste_Emissions
        )
    }
    
    df
  })
  
  # ---------------------------
  # Outputs
  # ---------------------------
  
  output$results <- renderTable({
    results()
  })
  
  output$totalBox <- renderValueBox({
    total <- sum(results()$Emissions, na.rm = TRUE)/1000
    valueBox(round(total,2), "Total tCO2e", icon = icon("globe"))
  })
  
  output$methodBox <- renderValueBox({
    valueBox(input$method, "Method Used", icon = icon("cogs"))
  })
  
  output$barPlot <- renderPlot({
    ggplot(results(), aes(x = Item, y = Emissions)) +
      geom_bar(stat = "identity") +
      theme_minimal()
  })
  
  output$piePlot <- renderPlot({
    df <- results()
    df$fraction <- df$Emissions / sum(df$Emissions)
    
    ggplot(df, aes(x = "", y = fraction, fill = Item)) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar("y")
  })
  
  output$warnings <- renderText({
    df <- results()
    
    warnings <- c()
    
    if (any(is.na(df$Emissions))) {
      warnings <- c(warnings, "Missing values detected in emissions calculation.")
    }
    
    if (input$method == "Spend-Based") {
      warnings <- c(warnings, "Spend-based method has lower accuracy.")
    }
    
    paste(warnings, collapse = "\n")
  })
  
  output$download_results <- downloadHandler(
    filename = function() {
      "Scope3_Results.xlsx"
    },
    content = function(file) {
      write_xlsx(results(), file)
    }
  )
}

shinyApp(ui, server)
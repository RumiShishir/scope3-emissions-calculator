library(shiny)
library(shinydashboard)
library(dplyr)
library(readxl)
library(writexl)
library(ggplot2)
library(scales)
library(DT)

# =====================================================
# UI
# =====================================================

ui <- dashboardPage(
  
  dashboardHeader(title = "Scope 3 Category 1 Dashboard"),
  
  dashboardSidebar(
    
    sidebarMenu(
      
      menuItem("Supplier-Specific", tabName = "supplier", icon = icon("industry")),
      
      menuItem("Hybrid Method", tabName = "hybrid", icon = icon("project-diagram")),
      
      menuItem("Average-Data Method", tabName = "average", icon = icon("database")),
      
      menuItem("Mixed Spend-Mass", tabName = "mixed", icon = icon("dollar-sign")),
      
      menuItem("Comparison Dashboard", tabName = "comparison", icon = icon("chart-bar"))
    )
  ),
  
  dashboardBody(
    
    tabItems(
      
      # =====================================================
      # TAB 1: SUPPLIER-SPECIFIC
      # =====================================================
      
      tabItem(
        tabName = "supplier",
        
        fluidRow(
          
          box(
            width = 4,
            title = "Upload Dataset",
            status = "primary",
            solidHeader = TRUE,
            
            fileInput("file_sup", "Upload CSV/XLSX"),
            actionButton("calc_sup", "Calculate")
          ),
          
          valueBoxOutput("total_sup")
        ),
        
        fluidRow(
          
          box(
            width = 12,
            title = "Results Table",
            status = "primary",
            solidHeader = TRUE,
            DTOutput("table_sup")
          )
        ),
        
        fluidRow(
          
          box(
            width = 12,
            title = "Visualization",
            status = "primary",
            solidHeader = TRUE,
            plotOutput("plot_sup", height = 350)
          )
        )
      ),
      
      # =====================================================
      # TAB 2: HYBRID
      # =====================================================
      
      tabItem(
        tabName = "hybrid",
        
        fluidRow(
          
          box(
            width = 4,
            title = "Hybrid Settings",
            status = "warning",
            solidHeader = TRUE,
            
            selectInput(
              "variant",
              "Select Variant",
              choices = c(
                "Full Supplier Activity Data",
                "Limited Supplier Data (Scope 1 & 2 + Waste)"
              )
            ),
            
            fileInput("file_hyb", "Upload CSV/XLSX"),
            actionButton("calc_hyb", "Calculate")
          ),
          
          valueBoxOutput("total_hyb")
        ),
        
        fluidRow(
          
          box(
            width = 12,
            title = "Results Table",
            status = "warning",
            solidHeader = TRUE,
            DTOutput("table_hyb")
          )
        ),
        
        fluidRow(
          
          box(
            width = 12,
            title = "Visualization",
            status = "warning",
            solidHeader = TRUE,
            plotOutput("plot_hyb", height = 350)
          )
        )
      ),
      
      # =====================================================
      # TAB 3: AVERAGE-DATA
      # =====================================================
      
      tabItem(
        tabName = "average",
        
        fluidRow(
          
          box(
            width = 4,
            title = "Upload Dataset",
            status = "success",
            solidHeader = TRUE,
            
            fileInput("file_avg", "Upload CSV/XLSX"),
            actionButton("calc_avg", "Calculate")
          ),
          
          valueBoxOutput("total_avg")
        ),
        
        fluidRow(
          
          box(
            width = 12,
            title = "Results Table",
            status = "success",
            solidHeader = TRUE,
            DTOutput("table_avg")
          )
        ),
        
        fluidRow(
          
          box(
            width = 12,
            title = "Visualization",
            status = "success",
            solidHeader = TRUE,
            plotOutput("plot_avg", height = 350)
          )
        )
      ),
      
      # =====================================================
      # TAB 4: MIXED SPEND-MASS METHOD
      # =====================================================
      
      tabItem(
        tabName = "mixed",
        
        fluidRow(
          
          box(
            width = 4,
            title = "Upload Dataset",
            status = "danger",
            solidHeader = TRUE,
            
            fileInput("file_mix", "Upload CSV/XLSX"),
            actionButton("calc_mix", "Calculate")
          ),
          
          valueBoxOutput("total_mix")
        ),
        
        fluidRow(
          
          box(
            width = 12,
            title = "Results Table",
            status = "danger",
            solidHeader = TRUE,
            DTOutput("table_mix")
          )
        ),
        
        fluidRow(
          
          box(
            width = 12,
            title = "Visualization",
            status = "danger",
            solidHeader = TRUE,
            plotOutput("plot_mix", height = 350)
          )
        )
      ),
      
      # =====================================================
      # TAB 5: COMPARISON DASHBOARD
      # =====================================================
      
      tabItem(
        tabName = "comparison",
        
        fluidRow(
          
          valueBoxOutput("comparison_total", width = 4),
          valueBoxOutput("highest_method", width = 4),
          valueBoxOutput("lowest_method", width = 4)
        ),
        
        fluidRow(
          
          box(
            width = 12,
            title = "Method Comparison Table",
            status = "info",
            solidHeader = TRUE,
            DTOutput("comparison_table")
          )
        ),
        
        fluidRow(
          
          box(
            width = 6,
            title = "Total Emissions by Method",
            status = "info",
            solidHeader = TRUE,
            plotOutput("comparison_plot", height = 350)
          ),
          
          box(
            width = 6,
            title = "Percentage Contribution",
            status = "info",
            solidHeader = TRUE,
            plotOutput("comparison_pie", height = 350)
          )
        ),
        
        fluidRow(
          
          box(
            width = 6,
            title = "Normalized Comparison",
            status = "info",
            solidHeader = TRUE,
            plotOutput("comparison_normalized", height = 350)
          ),
          
          box(
            width = 6,
            title = "Cumulative Emissions",
            status = "info",
            solidHeader = TRUE,
            plotOutput("comparison_cumulative", height = 350)
          )
        ),
        
        fluidRow(
          
          box(
            width = 12,
            title = "Method Ranking",
            status = "info",
            solidHeader = TRUE,
            plotOutput("ranking_plot", height = 350)
          )
        )
      )
    )
  )
)

# =====================================================
# SERVER
# =====================================================

server <- function(input, output, session) {
  
  # =====================================================
  # STORAGE
  # =====================================================
  
  store <- reactiveValues(
    sup = NULL,
    hyb = NULL,
    avg = NULL,
    mix = NULL
  )
  
  # =====================================================
  # FILE LOADER
  # =====================================================
  
  load_data <- function(file) {
    
    req(file)
    
    ext <- tools::file_ext(file$name)
    
    if (ext == "csv") {
      read.csv(file$datapath)
    } else {
      read_excel(file$datapath)
    }
  }
  
  # =====================================================
  # SUPPLIER-SPECIFIC
  # =====================================================
  
  observeEvent(input$calc_sup, {
    
    df <- load_data(input$file_sup)
    
    df <- df %>%
      mutate(
        Emissions = Quantity_kg * EmissionFactor_kgCO2e_per_kg
      )
    
    store$sup <- df
  })
  
  output$total_sup <- renderValueBox({
    
    req(store$sup)
    
    total <- sum(store$sup$Emissions, na.rm = TRUE)
    
    valueBox(
      round(total, 2),
      "kg CO2e",
      icon = icon("industry"),
      color = "blue"
    )
  })
  
  output$table_sup <- renderDT({
    datatable(store$sup)
  })
  
  output$plot_sup <- renderPlot({
    
    ggplot(store$sup, aes(x = reorder(Item, Emissions), y = Emissions)) +
      geom_col(fill = "steelblue") +
      coord_flip() +
      theme_minimal() +
      labs(x = "", y = "kg CO2e")
  })
  
  # =====================================================
  # HYBRID
  # =====================================================
  
  observeEvent(input$calc_hyb, {
    
    df <- load_data(input$file_hyb)
    
    if (input$variant == "Full Supplier Activity Data") {
      
      df <- df %>%
        mutate(
          S1S2 = Scope1_2_kgCO2e,
          Materials = Material_mass_kg * Material_EF,
          Transport = Transport_km * Transport_mass_kg * Transport_EF,
          Waste = Waste_kg * Waste_EF,
          Emissions = S1S2 + Materials + Transport + Waste
        )
      
    } else {
      
      df <- df %>%
        mutate(
          S1S2 = Scope1_2_kgCO2e,
          Waste = Waste_kg * Waste_EF,
          Upstream = Total_Units * Cradle_to_gate_EF,
          Emissions = S1S2 + Waste + Upstream
        )
    }
    
    store$hyb <- df
  })
  
  output$total_hyb <- renderValueBox({
    
    req(store$hyb)
    
    total <- sum(store$hyb$Emissions, na.rm = TRUE)
    
    valueBox(
      round(total, 2),
      "kg CO2e",
      icon = icon("project-diagram"),
      color = "yellow"
    )
  })
  
  output$table_hyb <- renderDT({
    datatable(store$hyb)
  })
  
  output$plot_hyb <- renderPlot({
    
    ggplot(store$hyb, aes(x = reorder(Item, Emissions), y = Emissions)) +
      geom_col(fill = "orange") +
      coord_flip() +
      theme_minimal() +
      labs(x = "", y = "kg CO2e")
  })
  
  # =====================================================
  # AVERAGE DATA
  # =====================================================
  
  observeEvent(input$calc_avg, {
    
    df <- load_data(input$file_avg)
    
    df <- df %>%
      mutate(
        Emissions = Quantity * EmissionFactor_kgCO2e_per_unit
      )
    
    store$avg <- df
  })
  
  output$total_avg <- renderValueBox({
    
    req(store$avg)
    
    total <- sum(store$avg$Emissions, na.rm = TRUE)
    
    valueBox(
      round(total, 2),
      "kg CO2e",
      icon = icon("database"),
      color = "green"
    )
  })
  
  output$table_avg <- renderDT({
    datatable(store$avg)
  })
  
  output$plot_avg <- renderPlot({
    
    ggplot(store$avg, aes(x = reorder(Item, Emissions), y = Emissions)) +
      geom_col(fill = "darkgreen") +
      coord_flip() +
      theme_minimal() +
      labs(x = "", y = "kg CO2e")
  })
  
  # =====================================================
  # MIXED METHOD
  # =====================================================
  
  observeEvent(input$calc_mix, {
    
    df <- load_data(input$file_mix)
    
    df <- df %>%
      mutate(
        Emissions = case_when(
          Type == "mass" ~ Quantity_kg * EF_kgCO2e_per_kg,
          Type == "spend" ~ Spend_USD * EF_kgCO2e_per_USD,
          TRUE ~ 0
        )
      )
    
    store$mix <- df
  })
  
  output$total_mix <- renderValueBox({
    
    req(store$mix)
    
    total <- sum(store$mix$Emissions, na.rm = TRUE)
    
    valueBox(
      round(total, 2),
      "kg CO2e",
      icon = icon("dollar-sign"),
      color = "red"
    )
  })
  
  output$table_mix <- renderDT({
    datatable(store$mix)
  })
  
  output$plot_mix <- renderPlot({
    
    ggplot(store$mix, aes(x = reorder(Item, Emissions), y = Emissions, fill = Type)) +
      geom_col() +
      coord_flip() +
      theme_minimal() +
      labs(x = "", y = "kg CO2e")
  })
  
  # =====================================================
  # COMPARISON DATA
  # =====================================================
  
  comparison_df <- reactive({
    
    data.frame(
      Method = c(
        "Supplier-Specific",
        "Hybrid",
        "Average-Data",
        "Mixed Spend-Mass"
      ),
      
      Emissions = c(
        ifelse(is.null(store$sup), 0,
               sum(store$sup$Emissions, na.rm = TRUE)),
        
        ifelse(is.null(store$hyb), 0,
               sum(store$hyb$Emissions, na.rm = TRUE)),
        
        ifelse(is.null(store$avg), 0,
               sum(store$avg$Emissions, na.rm = TRUE)),
        
        ifelse(is.null(store$mix), 0,
               sum(store$mix$Emissions, na.rm = TRUE))
      )
    )
  })
  
  # =====================================================
  # COMPARISON VALUE BOXES
  # =====================================================
  
  output$comparison_total <- renderValueBox({
    
    df <- comparison_df()
    
    valueBox(
      round(sum(df$Emissions), 2),
      "Combined Total kg CO2e",
      icon = icon("globe"),
      color = "purple"
    )
  })
  
  output$highest_method <- renderValueBox({
    
    df <- comparison_df()
    
    top <- df[which.max(df$Emissions), ]
    
    valueBox(
      paste0(round(top$Emissions, 2), " kg"),
      paste("Highest:", top$Method),
      icon = icon("arrow-up"),
      color = "red"
    )
  })
  
  output$lowest_method <- renderValueBox({
    
    df <- comparison_df()
    
    low <- df[which.min(df$Emissions), ]
    
    valueBox(
      paste0(round(low$Emissions, 2), " kg"),
      paste("Lowest:", low$Method),
      icon = icon("arrow-down"),
      color = "green"
    )
  })
  
  # =====================================================
  # COMPARISON TABLE
  # =====================================================
  
  output$comparison_table <- renderDT({
    
    df <- comparison_df()
    
    df$Percentage <- round((df$Emissions / sum(df$Emissions)) * 100, 2)
    
    datatable(df)
  })
  
  # =====================================================
  # COMPARISON BAR CHART
  # =====================================================
  
  output$comparison_plot <- renderPlot({
    
    df <- comparison_df()
    
    ggplot(df, aes(x = reorder(Method, Emissions), y = Emissions, fill = Method)) +
      geom_col() +
      theme_minimal() +
      labs(x = "", y = "kg CO2e") +
      coord_flip()
  })
  
  # =====================================================
  # PIE CHART
  # =====================================================
  
  output$comparison_pie <- renderPlot({
    
    df <- comparison_df()
    
    df$fraction <- df$Emissions / sum(df$Emissions)
    df$label <- paste0(df$Method, " (", round(df$fraction * 100, 1), "%)")
    
    ggplot(df, aes(x = "", y = fraction, fill = label)) +
      geom_col(width = 1) +
      coord_polar(theta = "y") +
      theme_void()
  })
  
  # =====================================================
  # NORMALIZED COMPARISON
  # =====================================================
  
  output$comparison_normalized <- renderPlot({
    
    df <- comparison_df()
    
    max_val <- max(df$Emissions)
    
    df$Normalized <- df$Emissions / max_val
    
    ggplot(df, aes(x = Method, y = Normalized, fill = Method)) +
      geom_col() +
      ylim(0, 1.1) +
      theme_minimal() +
      labs(y = "Normalized Emissions", x = "")
  })
  
  # =====================================================
  # CUMULATIVE EMISSIONS
  # =====================================================
  
  output$comparison_cumulative <- renderPlot({
    
    df <- comparison_df() %>%
      arrange(desc(Emissions))
    
    df$Cumulative <- cumsum(df$Emissions)
    
    ggplot(df, aes(x = reorder(Method, Emissions), y = Cumulative, group = 1)) +
      geom_line(size = 1.5) +
      geom_point(size = 4) +
      theme_minimal() +
      labs(x = "", y = "Cumulative kg CO2e")
  })
  
  # =====================================================
  # RANKING PLOT
  # =====================================================
  
  output$ranking_plot <- renderPlot({
    
    df <- comparison_df() %>%
      arrange(desc(Emissions))
    
    df$Rank <- 1:nrow(df)
    
    ggplot(df, aes(x = Rank, y = Emissions, label = Method)) +
      geom_point(size = 5, color = "darkred") +
      geom_text(vjust = -1) +
      theme_minimal() +
      scale_x_continuous(breaks = df$Rank) +
      labs(x = "Rank", y = "kg CO2e")
  })
}

# =====================================================
# RUN APP
# =====================================================

shinyApp(ui, server)
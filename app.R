library(shiny)
library(ggplot2)
library(gganimate)
options(scipen = 100)

ui <- fluidPage(
  titlePanel("Czy PiS nas zadłuża?"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("yearInput", "Year", 2008, 2018, 2008, 1, animate = T), 
      selectInput("higlight_countryInput", "Highlight country", choices = unique(d$country), selected = "PL", 
                  multiple = T)
    ),
   
    mainPanel(
      plotOutput("def_gdpPlot")
    )
  )
)

server <- function(input, output) {
  
  output$def_gdpPlot <- renderPlot({
    e <- e[e$year == input$yearInput,]
    e$selected <- e$country == input$higlight_countryInput
    ggplot(e, aes(deficit_pc_gdp, def_rank, size = gdp, color = selected)) +
      geom_point(alpha = 0.5) + 
      xlim(-10, 5) +
      # theme_minimal() +
      transition_states(year, 3, 1) + 
      ease_aes('cubic-in-out')
  })
}

shinyApp(ui = ui, server = server)
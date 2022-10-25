
## Server Outline
# Load in Illinois EBF data
# Define server logic 
# State formula current + dynamic calculations
# Create app data – code for base, weights, and direct funding 
# Create dynamic formula code 
# Calculate new funding amounts for poverty concentration weights 
# Calculate new funding amounts for increasing MFL 
# Define outputs to show in UI
# Poverty concentration weights increase to funding	# Change in MFL 
#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })

})

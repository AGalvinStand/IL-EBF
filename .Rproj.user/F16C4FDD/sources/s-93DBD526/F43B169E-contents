##UI Outline
# Load packages 
library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyBS)
library(htmltools)
library(DT)
library(leaflet)
require(scales)

library(plotly)
# Define UI for poverty-concentration application 

# Dashboard header: EBF Poverty Concentration 

# Create dashboard body

# Insert Formula Input 

# Insert tab panels for Output 1, Output 2, and Output 3 

# Insert column with Topline Outputs 

# Build dashboard elements ---- color, header, body 

# Show quantitative relationship between school funding (local and state) and poverty through a scatter plot. 

# Output 1 -- Dynamic output. Show a scatterplot of generated distribution. 

# Output 2 -- Show the spatial relationship between school funding and poverty through map tab

# Convert to sf object for mapping 

# Check the projection of your objects using the st_crs() function

# Create a leaflet map with a baselayer

# Color according to percent of adequacy  

# Output 3 -- Table 

# Define UI for MFL application 

# Application title EBF Minimum Funding Level  

# Insert Formula Input 

# Insert tab panels for Output 1 and Output 2 

# Insert column with Topline Outputs 

# Build dashboard elements ---- color, header, body 

# Output 1: Dynamic output. Show a scatterplot of generated distribution. 

# Output 2: Map output. 

# Convert to sf object for mapping 

# Check the projection of your objects using the st_crs() function

# Create a leaflet map with a baselayer

# Color according to percent of adequacy   

# Output 3: Table


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
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
))

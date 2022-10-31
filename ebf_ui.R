# EBF Simulator
# Ayesha Safdar
# 2022-10-27-22

# load -------
library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyBS)
library(htmltools)
library(DT)
library(leaflet)
require(scales)
library(plotly)

# Define UI for EBF Simulator 
# Dashboard header: EBF Simulator
# Create dashboard body

shinyUI({
  
  header <- dashboardHeader(title = "EBF Simulator")
  
  body <- dashboardBody(
    fluidPage(
      theme = "yeti",
      fluidRow(
        column(2,
               wellPanel(
                 h3("Minimum Funding Level")
               ) # close well panel
        ), # close input column
        
        # Insert tab panels for Output 1, Output 2, and Output 3 
        # Insert column with Topline Outputs 
        # Build dashboard elements ---- color, header, body 
        
        column(8,
               tabsetPanel(
                 tabPanel("Scatterplot"),
                 tabPanel("Illinois Map"),
                 tabPanel("Table")
               ) # close tabset panel
        ),# close visual output column
        
        column(2,
               wellPanel(
                 h3("Topline Outputs")
               ) # close well panel
        ) # close text output column
        
        
      ) # close page fluidrow
      
      
    )# close fluidpage
    
    
  )# close dashboardbody
  
  # build dashboard elements --------
  dashboardPage(
    skin = "black",
    header,
    dashboardSidebar(disable = TRUE),
    body
  )
  # Show quantitative relationship between school funding (local and state) and poverty through a scatter plot. 
  # Output 1 -- Dynamic output. Show a scatterplot of generated distribution. 
  # Output 2 -- Show the spatial relationship between school funding and poverty through map tab
  # Convert to sf object for mapping 
  # Check the projection of your objects using the st_crs() function
  # Create a leaflet map with a baselayer
  # Color according to percent of adequacy  
  # Output 3 -- Table 
  
})

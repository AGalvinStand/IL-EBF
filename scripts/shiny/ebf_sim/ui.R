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

options(shiny.trace = TRUE)

# Define UI for EBF Simulator 
# Dashboard header: EBF Simulator
# Create dashboard body

shinyUI({
  
  header <- dashboardHeader(
    disable = FALSE,
    titleWidth = 350,
    title = "EBF Simulator"
    )
  
  body <- dashboardBody(
    fluidPage(
      theme = "yeti",
      fluidRow(
        column(2,
               wellPanel(
                 h3(strong("Minimum Funding Level Simulations")),
                 h6("Set the toggles below to see how policy choices effect EBF funding requirements."),
                 br(),
                 h4("When would you like Illinis schools to be fully funded?"),
                 h6("MAYBE ADD SOME TEXT PROVIDING CONTEXT OR OVERVIEW OF WHY THIS IS IMPORTANT?"),
                 fluidRow(
                   column(8,
                          numericInput("years", "Year:", value = 2027, step = 1, min = 2027, max = 3000, width = '700px'),
                          verbatimTextOutput("value"),
                          id = "year_id",
                          bsTooltip("year_id", "Legislation currently designates 2027 as the target year for full-funding.", 
                                    placement = "right"),
                          
                          ) #close input 
                 ), # close fluidRow
                 
                 br(), 
                 
                 fluidRow(
                   column(5, h4("Concentrated poverty weights"))
                 ),
                 fluidRow(
                   column(12,
                          radioButtons(inputId = 'cp_wgts', label = 'CP weights',
                                       choices = c('Show', 'Hide'), inline = TRUE, selected = 'Hide')
                   )
                 ),
                 
                 conditionalPanel(

                   condition = "input.cp_wgts == 'Show'", 
                   fluidRow(
                     column(8,
                            checkboxGroupInput("cp_weights", label="Select from the following:", c("CP weights" = "cp1",
                                                                                              "CP weights 2" = "cp2"))
                     ),
                     bsTooltip("cp_weights", "Descirbe the weights here", 
                               placement = "bottom")
                   )
                 ),
                 fluidRow(
                   column(12,
                          radioButtons(inputId = 'race_wgt', label = 'Race weights',
                                       choices = c('Show', 'Hide'), inline = TRUE, selected = 'Hide')
                   )
                 ),
                 conditionalPanel(
                   condition = "input.race_wgt == 'Show'", 
                   fluidRow(
                     column(8,
                            checkboxInput("race_weight", label="Apply a weight for race", FALSE),
                     ),
                     bsTooltip("race_weight", "500 years of white supremacy has set back Black and Brown students. See what would happen if school funding takes this into account.", placement = "bottom")
                   )
                 ),
                 
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

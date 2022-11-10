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
library(tidyverse)

options(shiny.trace = TRUE)

# Define UI for EBF Simulator 
# Dashboard header: EBF Simulator
# Create dashboard body

ebf_base_calc_conpov <- read_rds("data/ebf_base_calc_conpov.rds")
ebf_base_calc <- read_rds("data/ebf_base_calc_conpov.rds")

shinyUI({
  
  header <- dashboardHeader(
    disable = FALSE,
    titleWidth = 450,
    title = strong("Illinois Evidence-Based Funding Simulator")
    )
  
  body <- dashboardBody(
    fluidPage(
      theme = shinytheme("united"),
      fluidRow(
        column(2,
               wellPanel(
                 img(src = "ebfsim_logo2.png", height = 250, width = 200, align = "center"),
                 h3(strong("Adequacy Target and Minimum Funding Level Simulations")),
                 br(),
                 h4(em("Explore the policy choices below to see how they effect the amount of funding required to fully fund Illinois schools and how much yearly funding is necessary to get there!")),
                 br(),
                 h4(strong("Adjust the target year for full funding")),
                 h6("Fully funding the schools that students deserve takes strong financial commitments. At our current pace, Illinois schools will not be funded until 2050! That's generations beyond the legislation's original goal. Select a year to see how we should be funding schools to achieve that goal."), #NOTE: I'm back and forth on this. I think we might want to do the MFL instead of year. It's sends a stronger messages. What funding level are you committed to? How long will it take us? The right hand out put could then say: "That is X years more than originally proposed on the legislation."
                 fluidRow(
                   column(8,
                          numericInput("years", "Year:", value = 2027, step = 1, min = 2027, max = 3000, width = '700px'),
                          id = "year_id",
                          bsTooltip("year_id", "Legislation currently designates 2027 as the target year for full-funding.", 
                                    placement = "right"),
                          
                          ) #close input 
                 ), # close fluidRow
                 
                 br(), 
                 
                 fluidRow(
                   column(12, h4(strong("Additional weights")))
                 ),
                 fluidRow(
                   column(12,
                          radioButtons(inputId = 'add_wgts', label = 'Show weights',
                                       choices = c('Show', 'Hide'), inline = TRUE, selected = 'Hide')
                   )
                 ),
                 
                 conditionalPanel(

                   condition = "input.add_wgts == 'Show'", 
                   fluidRow(
                     column(8,
                            checkboxInput("add_weights", 
                                               label="Select from the following:", 
                                               value = "ebf_base_calc_conpov")

                     ),
                     bsTooltip("add_weights", "Descirbe the weights here", 
                               placement = "bottom")
                   )
                 ),

               ) # close well panel
        ), # close input column
        
        # Insert tab panels for Output 1, Output 2, and Output 3 
        # Insert column with Topline Outputs 
        # Build dashboard elements ---- color, header, body 
        
        column(8,
               tabsetPanel(
                 tabPanel("Scatterplot",plotlyOutput("plot1", height = "700px")),
                 tabPanel("Illinois Map",leafletOutput("map", height = "700px")),
                 tabPanel("Table",dataTableOutput("tbl"))
               ) # close tabset panel
        ),# close visual output column
        
        column(2,
               wellPanel(
                 h3("Topline Outputs"),
                 h4("To be included:"),
                 h5(strong("Minimum yearly funding:")),
                 br(),
                 h5(textOutput("myf")),
                 br(),
                 h5(strong("Are you on track to fully-fund schools?")), 
                 br(),
                 h5(textOutput("goal")), # add clarification here make it obvious
                 br(),
                 h5("3. Percent of students in underfunded districts"),
                 h5("4. Race gaps"),
                 h5("5. Per pupil funding increases"),
                 h5("6. Print out PDF for your district"),
                 tableOutput("toplines")
               ) # close well panel
               
        ) # close text output column
    
        
      ## --- ADD DOWNLOAD OPTION    
    
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

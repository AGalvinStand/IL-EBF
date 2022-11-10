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
ebf_base_calc <- read_rds("data/ebf_base_calc.rds")

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
                   column(12, h4(strong("See what happens to EBF funding when you add additional weights")))
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
                     column(12,
                            selectInput(
                              inputId = "df_test",
                              label = "Select weights",
                              choices = c(
                                "EBF (as is)" = "ebf_base_calc",
                                "EBF (concentrated poverty weights)" = "ebf_base_calc_conpov"
                                # ADD "EBF (race weights)" = "ebf_base_calc_race"
                                # ADD "EBF (concentrated poverty+race weights)" = "ebf_base_calc_cp_race"
                                ),
                              selected = "EBF (as is)",
                              width = "50%")

                     ),
                     DT::dataTableOutput("test_table"),
                     bsTooltip("add_weights", "Add weights to adjust for concentrated poverty, race, or both to compare to EBF as it currently is.", 
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
                 conditionalPanel(
                   condition = "input.df_test == 'ebf_base_calc'",
                   h3(strong("EBF as it is"))
                 ),
                 conditionalPanel(
                   condition = "input.df_test == 'ebf_base_calc_conpov'",
                   h3(strong("EBF with concentrated poverty weights")),
                   br()
                 ),
                 h4("Here are some things to know about your policy choices:"),
                 br(),
                 h5(strong("Minimum yearly funding increases need to reach your goal year")),
                 br(),
                 h5(textOutput("myf")),
                 conditionalPanel(
                   condition = "input.df_test == 'ebf_base_calc_conpov'",
                   br(),
                   h5("Compared to EBF as it is, this amounts to an additional"),
                   br(),
                   textOutput("myf_diff"), 
                   br(),
                   h5("in minimum yearly funding increases.")
                   ),
                 br(),
                 # Add conditional panels for other weights ----
                 h5(strong("How far off track are you from our original goal to fully-fund school?")), 
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

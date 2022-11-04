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

ebf_base_calc_cp <- read_rds("data/raw/ebf_base_calc_conpov.rds")

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
                 img(src = "scrooge.gif", height = 200, width = 250, align = "center"),
                 h3(strong("Adequacy Target and Minimum Funding Level Simulations")),
                 br(),
                 h4(em("Explore the policy choices below to see how they effect the amount of funding required to fully fund Illinois schools and how much yearly funding is necessary to get there!")),
                 br(),
                 h4(strong("Adjust the target year for full funding")),
                 h6("Fully funding the schools that students deserve takes strong financial commitments. At our current pace, Illinois schools will not be funded until 2050! That's generations beyond the legislation's original goal. Select a year to see how we should be funding schools to achieve that goal."), #NOTE: I'm back and forth on this. I think we might want to do the MFL instead of year. It's sends a stronger messages. What funding level are you committed to? How long will it take us? The right hand out put could then say: "That is X years more than originally proposed on the legislation."
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
                   column(12, h4(strong("Concentrated poverty weights")))
                 ),
                 fluidRow(
                   column(12,
                          radioButtons(inputId = 'cp_wgts', label = 'Show weights',
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
                 
                 br(), 
                 
                 fluidRow(
                   column(12, h4(strong("Race weights"))) # make it clear this is a suggestion/hypothetical - compare against cp.
                 ),
                 
                 fluidRow(
                   column(12,
                          radioButtons(inputId = 'race_wgt', label = 'Show weight',
                                       choices = c('Show', 'Hide'), inline = TRUE, selected = 'Hide')
                   )
                 ),
                 conditionalPanel(
                   condition = "input.race_wgt == 'Show'", 
                   fluidRow(
                     column(8,
                            checkboxInput("race_weight", label="Apply a weight for race", FALSE),
                     ),
                     bsTooltip("race_weight", "500 years of white supremacy has set back Black and Brown students relative to their White peers. See what happens if EBF adjusted for this injustice.", placement = "bottom")
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
                 h5("1. Total funding"),
                 h5("2. Yearly minimum funding requirements"), # add clarification here make it obvious
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

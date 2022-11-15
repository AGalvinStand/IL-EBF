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
ebf_base_calc_race <- read_rds("data/ebf_base_calc_race.rds")
ebf_base_calc_conpov_race <- read_rds("data/ebf_base_calc_conpov_race.rds")

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
                 img(src = "logo_mr2.png", height = 250, width = 225, align = "center"),
                 h3(strong("Adequacy Target and Minimum Yearly Funding Simulations")),
                 br(),
                 h4(em("Explore the policy choices below to see how they effect the amount of funding required to fully fund Illinois schools and how much yearly funding is necessary to get there!")),
                 br(),
                 h4(strong("Adjust the target year for full funding")),
                 h6("Fully funding the schools that students deserve takes strong financial commitments. At our current pace, Illinois schools will not be funded until 2050! That's a generation beyond the legislation's original goal. Select a year to see how we should be funding schools to achieve that goal."), #NOTE: I'm back and forth on this. I think we might want to do the MFL instead of year. It's sends a stronger messages. What funding level are you committed to? How long will it take us? The right hand out put could then say: "That is X years more than originally proposed on the legislation."
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
                                "EBF (concentrated poverty weights)" = "ebf_base_calc_conpov",
                                "EBF (race weights)" = "ebf_base_calc_race",
                                "EBF (both weights)" = "ebf_base_calc_conpov_race"
                                
                                ),
                              selected = "EBF (as is)",
                              width = "50%"),
                            id = "wgts",
                            bsTooltip("wgts", "Add weights to account for concentrated poverty, race, or both.", 
                                      placement = "bottom"),

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
                 tabPanel("Tier funding distribution",plotlyOutput("plot1", height = "700px")),
                 tabPanel("Illinois Map",leafletOutput("map", height = "700px")),
                 tabPanel("District details",dataTableOutput("tbl"))
               ) # close tabset panel
        ),# close visual output column
        
        column(2,
               wellPanel(
                 h3("Here are some things to know about your policy choices:"),
                 conditionalPanel(
                   condition = "input.df_test == 'ebf_base_calc'",
                   h3(strong("EBF as it is"))
                 ),
                 conditionalPanel(
                   condition = "input.df_test == 'ebf_base_calc_conpov'",
                   h3(strong("EBF with concentrated poverty weights")),
                   br(),
                   h5(em("Research shows that districts with poverty rates of 50% or more are uniquely disadvantaged relative to districts with less poverty. This 50% marker could be understood as a threashold whereby the cumulative effects of poverty really begin to take a toll on student achievements. Our weights account for these unique disadvantages by providing more resources that benefit low-income families, such as, more funding for afterschool and summerschool staff, among other things."))
                 ),
                 conditionalPanel(
                   condition = "input.df_test == 'ebf_base_calc_race'",
                   h3(strong("EBF with race weights")),
                   br(),
                   h5(em("As the Professional Review Panel stated, students of color face historical and structural inequities because of their race/ethnicity. These weights are meant to address systemtic racism via the PRP's policy recommendation."))
                 ),
                 conditionalPanel(
                   condition = "input.df_test == 'ebf_base_calc_conpov_race'",
                   h3(strong("EBF with race and concentrated poverty weights")),
                   br(),
                   h5(em("Lets see what happens when we address two of Dr. MLK's 'evils of society', racism and poverty, at once. We'll leave excessive militarism for another day." ))
                 ),
                 br(),
                 h5(strong("Minimum yearly funding increases need to reach your goal year")),
                 h5(textOutput("myf")),
                 conditionalPanel(
                   condition = "input.df_test == 'ebf_base_calc_conpov' | input.df_test == 'ebf_base_calc_race' | input.df_test == 'ebf_base_calc_conpov_race'",
                   br(),
                   em(textOutput("myf_diff")), 
                   br(),
                   ),
                 conditionalPanel(
                   condition = "input.df_test == 'ebf_base_calc_conpov' | input.df_test == 'ebf_base_calc_race' | input.df_test == 'ebf_base_calc_conpov_race'",
                   # h5(strong("This amounts to a yearly per pupil funding increase of:")),
                   em(textOutput("fat_perpupil")),
                   br()
                 ),
                 br(),
                 h5(strong("How far off track are you from our original goal to fully-fund schools by 2027?")),
                 h5(textOutput("goal")), # add clarification here make it obvious
                 br(),
                 h5(strong("Here's the additional number of students, relative to EBF's current funding levels, who will recieve more and/or prioritized funding:")),
                 h5(textOutput("poor_students")),
                 br(),
                 h5(strong("Download district data for the selected model")),
                 downloadButton(outputId = "download_data", 
                                label = "Download")
               ) # close well panel
               
               )# close text output column
    
        
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

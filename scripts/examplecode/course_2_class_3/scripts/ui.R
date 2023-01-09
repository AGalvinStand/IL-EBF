# R Class Shiny Simulator Template
# 2022-10-04

# load -------------
library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyBS)
library(htmltools)
library(DT)
library(leaflet)
require(scales)
library(plotly)


# If TRUE, all of the messages sent between the R server and the web browser 
# will be printed on the console. This is useful for debugging.
options(shiny.trace = TRUE)

# Define the UI function for a education finance simulator template application 
shinyUI ({
  
  # define header ---------
  header <- dashboardHeader(
    disable = FALSE,
    titleWidth = 250,
    # Change this to fit your title for the Shiny App
    title = "My Shiny App Title" 
    
  )
  
  # define body -------------
  body <- dashboardBody(
    fluidPage(
      # other themes available here: https://rstudio.github.io/shinythemes/
      theme = "yeti",
      fluidRow(
        
        # left panel -----------------
        
        column(2, # this number defines the width of your column, 
                  # all of your columns within a fluid row should add up to 12
                  # to fit the whole space - this is a standard website thing
               wellPanel(
                 id = "formula_inputs", 
                 h3("Formula Inputs"), # h3 defines the font size and style, 
                                       # the smaller the number, the bigger the
                                       # font (h3 is bigger than h4)
                 h4("Base Funding"),
                 fluidRow(
                   column(12, 
                          numericInput("base", "Per-Pupil Base:", step = 1, value = 6860)
                          )
                 ),
                 # set a numeric input value with id = 'base'
                 # means you can call this in server.r with input$base
                  
                 # create hover-over help text when a user hovers over the 
                 # input for "base", which is defined above
                 bsTooltip("base", "The base cost to educate a student with no special needs. Users can adjust this amount.", 
                           placement = "bottom"),
                 # another standard web development thing - this means break, 
                 # aka create one line of blank space
                 br(), 
                 
                 fluidRow(
                   column(5, h4("Student Weights"))
                 ),
                 fluidRow(
                   column(12,
                          radioButtons(inputId = 'frpl_adm', label = 'FRPL weight',
                                       choices = c('Show', 'Hide'), inline = TRUE, selected = 'Hide')
                   )
                 ),
                 # create a conditional set of UI that only appears when a 
                 # certain action is taken by the user
                 conditionalPanel(
                   # input.____ refers to a variable generated in the UI script, 
                   # in this case, so if the input frpl_adm is "Show", do this
                   condition = "input.frpl_adm == 'Show'", 
                   fluidRow(
                     column(6,
                            numericInput("frpl_weight", label="Free or Reduced-Price Lunch", min=0, max=1.5, step=.01, value=0.25)
                     ),
                     bsTooltip("frpl_weight", "The percent of additional funding, relative to the base, that each qualifying student receives.<br><br>(.2 = 20%, .5 = 50%, 1.5 = 150%, etc.)", 
                               placement = "bottom")
                   )
                 ),
                 fluidRow(
                   column(12,
                          radioButtons(inputId = 'sped_weights', label = 'Special Education',
                                       choices = c('Show', 'Hide'), inline = TRUE, selected = 'Hide')
                   )
                 ),
                 conditionalPanel(
                   condition = "input.sped_weights == 'Show'", 
                   fluidRow(
                     column(6,
                            numericInput("sped_opt1_weight", label="SPED Option 1 Weight", min = 0, max = 1.0, step = .01, value = 0.15),
                            numericInput("sped_opt2_weight", label="SPED Option 2 Weight", min = 0, max = 1.0, step = .01, value = 0.20),
                            numericInput("sped_opt3_weight", label="SPED Option 3 Weight", min = 0, max = 1.0, step = .01, value = 0.40)
                     ),
                     bsTooltip("sped_weights", "The percent of additional funding, relative to the base, that each qualifying student receives.<br><br>(.2 = 20%, .5 = 50%, 1.5 = 150%, etc.)", placement = "bottom")
                   )
                 ),
                 fluidRow(
                   column(12,
                          radioButtons(inputId = 'el_weights', label = 'English Learners',
                                       choices = c('Show', 'Hide'), inline = TRUE, selected = 'Hide')
                   )
                 ),
                 conditionalPanel(
                   condition = "input.el_weights == 'Show'", ## inputs refer to anything in the UI script, so if the input is yes, do this
                   fluidRow(
                     column(6,
                            numericInput("el_weight", label="EL Weight", min = 0 , max= 1, step = .01, value = 0.2)
                            
                     ),
                     bsTooltip("el_weight", "The percent of additional funding, relative to the base, that each qualifying student receives.<br><br>(.2 = 20%, .5 = 50%, 1.5 = 150%, etc.)", placement = "bottom")
                   )
                 ), 
                 
                 # district weights 
                 br(),
                 fluidRow(
                   column(5, h4("District Weights")),
                 ),
                 fluidRow(
                   column(12,
                          radioButtons(inputId = 'conc_pov', label = 'Concentrated Poverty',
                                       choices = c('Show', 'Hide'), inline = TRUE, selected = 'Hide')
                   )
                 ),
                 conditionalPanel(
                   condition = "input.conc_pov == 'Show'", ## inputs refer to anything in the UI script, so if the input  is yes, do this
                   fluidRow(
                     column(6,
                            numericInput("conc_pov_weight", label="Concentrated poverty weight", step = .01, value = .05)
                     )
                   ),
                   fluidRow(
                     column(6,
                            numericInput("conc_pov_min", label="Concentrated poverty minimum", step = .01, value = .5)
                     )
                   ),
                 ),
                 fluidRow(
                   column(12,
                          radioButtons(inputId = 'sparsity', label = 'Sparsity',
                                       choices = c('Show', 'Hide'), inline = TRUE, selected = 'Hide')
                   )
                 ),
              
                 
                 conditionalPanel(
                   condition = "input.sparsity == 'Show'", ## inputs refer to anything in the UI script, so if the input  is yes, do this
                   fluidRow(
                     column(6,
                            numericInput("sparsity_weight", label="Sparsity weight", step = .01, value = .05)
                     )
                   ), # close row
                   fluidRow(
                     column(6,
                            numericInput("sparsity_limit", label="Sparsity limit, students per sq. mi.", step = 1, value = 25)
                     )
                   ), # close row
                 ), # close conditional panel
                 
               ), # close input well panel
               
             ),  # input column close
      
      # center panel --------------
      #Below is where you put in the code to set up the scatter plots and tables 
      
      column(8,
             wellPanel(
               tabsetPanel(
                 tabPanel("Dynamic Map", leafletOutput("map", height = "700px")),
                 tabPanel("District Summary Table", dataTableOutput("tbl")),
                 tabPanel("Plot #1: Prop. Wealth vs. State Aid PP", plotlyOutput("plot1", height = "700px")),
                 tabPanel("Plot #2: Current vs. Dynamic State Aid PP", plotlyOutput("plot2", height = "700px")),
                 
               ),
             )
      ), # tabset column close
      
      # right panel ---------------------
      
      # This will show up on the righe side of the Shiny app and will show the current funding levels and the new funding levels 
      # once the changes are made 
      column(2,
             # create panel for topline output numbers
             wellPanel(
               h4("Topline Output"),
               h5("Current State Total Funding:", textOutput("budget")), ## an Output here means the UI script will look for this id in the server script
               h5("Change in State Total Funding:", textOutput("balance")),
               bsTooltip("balance", "Budget deficit or surplus size given current base amount, enrollment, and weights", placement = "bottom"),
             ), # well panel close
             br(),
             # create download sub-panel
             wellPanel(
               helpText("Write .csv of current model"),
               downloadButton(outputId = "download_data", 
                              label = "Download")
             )
      ),# left column close
      
      
    
    ) # page row close
    
    
  ) # page close 
  
) # close dashboard body
  
  # define dashboard page elements ----------
  # specify the order to view the dashboard: 
  # first the header we made, 
  # then ignore any sidebars the theme wants to make,
  # then the body
  # skin = black formats the header with white background and black text 
  dashboardPage(
    skin = "black",
    header,
    dashboardSidebar(disable = TRUE),
    body
  )
  
}) # shiny UI function close

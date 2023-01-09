# ui_template.R
# 2022-10-04

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

shinyUI({
  
  header <- dashboardHeader(title = "Bare Bones Shiny App")
  
  body <- dashboardBody(
    fluidPage(
      theme = "yeti",
      fluidRow(
        column(2,
               wellPanel(
                 h3("Formula Input"),
                 
                 fluidRow(
                   column(12,
                          numericInput("test","Test input:" ,value = 20)
                   )
                 
                 ) # close well panel
               
               
               ),
               
               ), # close input column
        
        
        column(8,
               tabsetPanel(
                 tabPanel("Output 1"),
                 tabPanel("Output 2"),
                 tabPanel("Output 3")
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
  
})
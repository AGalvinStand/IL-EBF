# testing merging shapefile with isbe data


library(shiny)
library(shinythemes)
# library(shinydashboard)
# library(shinyBS)
# library(htmltools)
library(DT)
# library(leaflet)
require(scales)
library(plotly)
library(tidyverse)
library(base)
library(edbuildmapr)
library(leaflet)
library(sf)


options(shiny.trace = TRUE)

setwd("~GitHub/IL-EBF/scripts/shiny/ebf_sim")

il_map_raw <- il_shapepull(data_year = "2019", with_data = TRUE)

# clean ----------

il_map_raw <- il_map_raw |>
  # tidy up colnames
  rename_with(tolower) |>
  filter(state == "Illinois")


ebf_base_calc_conpov <- read_rds("data/ebf_base_calc_conpov.rds")
ebf_base_calc <- read_rds("data/ebf_base_calc.rds")
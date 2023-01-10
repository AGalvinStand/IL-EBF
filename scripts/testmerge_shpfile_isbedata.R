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
library(readxl)


options(shiny.trace = TRUE)

setwd("~/GitHub/IL-EBF/scripts/shiny/ebf_sim")

il_map_raw <- edbuildmapr::sd_shapepull(data_year = "2019", with_data = TRUE)

# clean ----------

il_map_raw <- il_map_raw |>
  # tidy up colnames
  rename_with(tolower) |>
  filter(state == "Illinois")

# write shapefile for shiny

st_write(il_map_raw, "data/il_map_raw.shp")

il_map_raw <- read_sf("data/il_map_raw.shp")

ebf_base_calc_conpov <- read_rds("data/ebf_base_calc_conpov.rds")
ebf_base_calc <- read_rds("data/ebf_base_calc.rds")

crosswalk <- read_excel("data/crosswalk.xlsx",sheet = 3)
write_rds(crosswalk,"data/crosswalk.rds")

# join crosswalk to isbe ebf base cal

ebf_base_calc <- merge(ebf_base_calc, crosswalk, by.x = "distid", by.y = "District ID", all = FALSE)

# join map data to ebf crosswalk join

ebf_base_calc <- merge(il_map_raw, ebf_base_calc, by.x = "geoid", by.y = "ncesid")

leaflet(ebf_base_calc) |>
  addPolygons(color = "444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorQuantile("YlOrRd", total_ase)(total_ase))


# testing merge


ebf_base_calc_conpov <- read_rds("data/ebf_base_calc_conpov.rds")
ebf_base_calc <- read_rds("data/ebf_base_calc.rds")
ebf_base_calc_race <- read_rds("data/ebf_base_calc_race.rds")
ebf_base_calc_conpov_race <- read_rds("data/ebf_base_calc_conpov_race.rds")

il_map_raw <- read_sf("data/il_map_raw.shp")
crosswalk <- read_rds("data/crosswalk.rds")


crosswalkmerge <-  merge(ebf_base_calc, crosswalk, by.x = "distid", by.y = "District ID", all = FALSE)

map_data <- merge(il_map_raw, crosswalkmerge, by.x = "geoid", by.y = "ncesid", all = FALSE)
  


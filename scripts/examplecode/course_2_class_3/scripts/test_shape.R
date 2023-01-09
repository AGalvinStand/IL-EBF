# test_shape.R
# 2022-10-04

# load ------------
library(tidyverse)
library(sf)
library(edbuildmapr)

raw_sd_shp <- sd_shapepull()

de_shp <- raw_sd_shp |> 
  filter(State == "Delaware") |> 
  rename_with(tolower) |> 
  select(geoid, geometry) |> 
  st_transform("WGS84")

# write ------

write_sf(de_shp, "data/sim_dist.shp")


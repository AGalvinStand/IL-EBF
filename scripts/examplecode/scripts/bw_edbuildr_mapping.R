# 5_edbuildr_mapping
# Bellwether R For Education Research Course 2, Class 2
# 2022-09-22, Last updated by Krista Kaput 

# load -------

library(tidyverse)
library(sf)
library(scales)
library(viridis)
library(devtools)
library(ggplot2)
library(sf)
library(tmap)
library(tmaptools)
library(svglite)
library(leaflet)
library(tidycensus)

# Let's load in the edbuildr and edbuildmapr packages!
library(edbuildr)
library(edbuildmapr)

options(scipen = 999)

# new brand colors
bw_primary <- c("#6D1E4A", # 1 plum
                "#007786", # 2 teal
                "#0D525A", # 3 dark green
                "#212B46", # 4 navy
                "#5A6675", # 5 grey
                "#F0DEC1") # 6 cream

bw_secondary <- c("#FFC762", # 1 yellow
                  "#FFB653", # 2 orange
                  "#BEC6CE", # 3 light grey
                  "#2E1A4A", # 4 deep purple
                  "#7EA2D1", # 5 soft blue
                  "#CAD3FB", # 6 lavender
                  "#9CD4EA", # 7 sky
                  "#FFA497") # 8 peach

# Load in the school district mapping data 

sd_map_raw <- edbuildmapr::sd_shapepull(data_year = "2019", with_data = TRUE)

# Pull out the Minnesota mapping data 

mn_shp <- sd_map_raw |> 
  # tidy up colnames
  rename_with(tolower) |> 
  filter(state == "Minnesota") |>
  rename(ncesid = geoid)


## ### import the Minnesota
mn_data <- edbuildr::masterpull(data_year = "2019", data_type = "geo") %>% 
  filter(State == "Minnesota") |>
  rename(ncesid = NCESID, 
         fips = STATE_FIPS, 
         district = NAME,
         st_pov_rate = StPovRate) |>
  mutate(local_rev_pp = as.numeric(LRPP, na.rm = TRUE), 
         state_rev_pp = as.numeric(SRPP, na.rm = TRUE),
         total_rev_pp = as.numeric(SLRPP, na.rm = TRUE),
         dlep = as.numeric(dLEP, na.rm = TRUE),
         enroll = as.numeric(ENROLL),
         local_rev_total = LR, na.rm = TRUE,
         state_rev_total = SR, na.rm = TRUE, 
         total_revenue = SLR, na.rm = TRUE,
         pct_bipoc = pctNonwhite, na.rm = TRUE,
         pct_lr = round(LR/SLR, 3),
         pct_sr = round(SR/SLR, 3),
         pct_lep = dlep/enroll, na.rm = TRUE,
         pct_loc_rev = local_rev_total/total_revenue, 
         pct_state_rev = state_rev_total/total_revenue) |>
  select(ncesid, fips, district, enroll, dlep, local_rev_pp, state_rev_pp, total_rev_pp, 
         local_rev_total, state_rev_total, total_revenue, pct_lr, pct_sr, pct_lep, pct_loc_rev, 
         pct_state_rev, pct_bipoc, st_pov_rate)

### join state summary stats to state data
mn_shp <- mn_shp |>
  left_join(mn_data, by = "ncesid") |>
  filter(ncesid != 2727001) |>
  filter(ncesid != 2727002) |>
  filter(ncesid != 2727003) |>
  filter(ncesid != 2727004) |>
  filter(ncesid != 2727005) |>
  filter(ncesid != 2727006) |>
  filter(ncesid != 2799001) |>
  select(ncesid, name, pct_bipoc, pct_lr, pct_sr, everything())


# Plot the map

ggplot()  + 
  geom_sf(data = mn_shp, mapping = aes(fill = pct_sr)) +
  theme_void()

# Make several aesthetic changes: 
# Change the color of the lines to white within geom_sf()
# Reverse the direction of the color scale within scale_fill_viridis()
#Add a title, subtitle, and source caption within labs()

ggplot()  + 
  geom_sf(data = mn_shp, 
          mapping = aes(fill = pct_sr),
          color = "#ffffff") +
  theme_void() +
  scale_fill_viridis(name="Percent K-12 Budget from State Revenue(%)",
                     labels=percent_format(accuracy = 1L), 
                     direction=-1) +
  labs(
    title = "Minnesota School Districts",
    subtitle = "Percent of District K-12 Revenue From State (2019)",
    caption = "Source: EdBuildr Data, 2019")

# Create your own color palette to style it and create breaks in the data! 

bw_state_revenue <- c("#F0DEC1","#BEC6CE", "#FFC762", "#007786", "#212B46", "#6D1E4A")

# State Revenue 

ggplot()  + 
  geom_sf(data = mn_shp, mapping = aes(fill = pct_sr),
          color = "#ffffff") +
  theme_void() +
  scale_fill_stepsn(breaks=c(.5, .6, .7, .8, .9, 1),
                    colors = bw_state_revenue, 
                    name="State K-12 Revenue (%)",
                    labels=percent_format(accuracy = 1L)) + 
  labs(
    title = "Minnesota School Districts",
    subtitle = "Percent of District K-12 Revenue From State (2019)",
    caption = "Source: EdBuildr Data, 2019")






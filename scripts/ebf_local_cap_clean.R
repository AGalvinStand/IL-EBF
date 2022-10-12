# PURPOSE ---------

#   This script will clean the local capacity target sheet and produce
#   a dataframe with necessary variables for the final school funding
#   calculations.

# -------------

# PREPARED BY ------

# Jose Pacas

# 2022-08-25

# Vamos! - <('o' <)

#----------

# load ---------

options(scipen = 999)

library(tidyverse)
library(readxl)

# Bring in and clean Local Capacity Target sheet ------

il_fy22_local_cap_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 7,
                                    skip = 4, n_max = 922)

# fix column names

il_fy22_local_cap_raw <- il_fy22_local_cap_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_local_cap_raw)

# set new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("distid",
               "distname",  # Confirm that RCDT is district id
               "county",
               "orgtype",
               "delete5",
               "total_ase",
               "delete7",
               "adjustedeav",
               "final_ade_target",
               "final_ade_target_perstu",
               "delete11",
               "local_cap_ratio",
               "adjusted_lcr",                                                                         
               "weighted_lcr_value",                                                                   
               "delete15",                                                                               
               "variance",                                                                             
               "weighted_variance",                                                                    
               "delete18",                                                                                
               "cum_distper_ranklcr",                        
               "local_cap_ratio_capped90",                               
               "delete21",                                                              
               "local_cap_target",
               "delete23",                                                                            
               "cpprt",                                                                              
               "base_funding_minimum",                                
               "prelim_resources",                                                                
               "prelim_percent_adeq",                                                            
               "adjusted_eav_for_realreceipts",
               "2019_adjusted_otr",                                                                
               "calc_localrev_realreceipts",                                          
               "calc_realreceipts_adj",                                                
               "final_adj_lct",
               "delete33",                                                                           
               "fy_17_sgsa",                                 
               "delete35",                                                                                
               "adj_base_funding_min",                                                        
               "final_resources",                                                                      
               "final_percent_adequacy"     
               )

# manually replace column names
colnames(il_fy22_local_cap_raw) <- new_names

# look at column names now
names(il_fy22_local_cap_raw)

# look at district names - they are imported as characters!
glimpse(il_fy22_local_cap_raw$distid)

# delete unwanted columns

ebf_local_capacity_target <- il_fy22_local_cap_raw[,-c(2:19,21:24,26:31,33:35)]

rm(il_fy22_local_cap_raw,
   new_names)


# PURPOSE ---------

#   This script will clean REGION FACTOR and turn it into 
#   a dataset for the EBF calculation.

# -------------

# PREPARED BY ------

# Chris Poulos

# 2022-07-26

# Vamos! - <('o' <)

#----------

# load ---------

options(scipen = 999)

library(tidyverse)
library(readxl)

# --------------

#             SHEET TABLE OF CONTENTS 
#--------------------------------------------
#       SHEET NAME          - SHEET NUMBER
#--------------------------------------------

# District Results Summary  - 1

# Base Calc                 - 2

# Control Variables         - 3

# Core Investments          - 4

# Per Student Investments   - 5

# Additional Investments    - 6

# Local Capacity Target     - 7

# Tier $                    - 8

# ENROLL-ALL                - 9

# ENROLL- LOW INCOME        - 10

# ENROLL - LI - ROE         - 11

#  ROE-LI Data              - 12

# ENROLL - EL               - 13

# REGION FACTOR             - 14

# ADJUSTED OTR              - 15

# ADJUSTED_EAV              - 16

# REAL EAV CALC             - 17

# PTELL EAV CALC            - 18

# FY 21 BFM                 - 19


# clean --------------

# load il ebf raw data -  skip to row five. Referencing the FY22-EBF..xlsx
#                         to clean the column names

il_fy22_region_factor_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 14,
                                    skip = 5)

# fix column names
il_fy22_region_factor_raw <- il_fy22_region_factor_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_region_factor_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("distid",
               "distname",  # Confirm that RCDT is district id
               "county",
               "tot_ase",
               "countyfips",
               "cwi_2013",
               "adj_counties_num",
               "weight_ident",
               "orig_county_weight",
               "adj_county weight",
               "adj_county_tot_index",
               "delete12",
               "adj_county_index_avg",
               "delete14",
               "adjusted_index_value",
               "delete16",
               "cwi_final", #Final CWI greater original versus adjusted
               "delete18",
               "cwi_stateweight",
               "delete20",
               "region_factor_ebm")

# manually replace column names
colnames(il_fy22_region_factor_raw) <- new_names

# look at column names now
names(il_fy22_region_factor_raw)

# look at district names - they are imported as characters!
glimpse(il_fy22_region_factor_raw)

# delete unwanted columns

il_fy22_region_factor_clean <- il_fy22_region_factor_raw[,-c(12,14,16,18,20)]


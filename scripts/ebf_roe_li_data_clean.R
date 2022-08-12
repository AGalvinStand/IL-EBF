# PURPOSE ---------

#   This script will clean ROE-LI Data and turn it into 
#   a dataset for the EBF calculation.

# -------------

# PREPARED BY ------

# Chris Poulos

# 2022-07-26

# Let's go! - <('.' <)

#----------

# load ---------

options(scipen = 999)

library(tidyverse)
library(readxl)

# --------------

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

# load il ebf raw data -  skip to row four. Referencing the FY22-EBF..xlsx
#                         to clean the column names

il_fy22_roe_li_data_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 12,
                                      skip = 4) 

# fix column names
il_fy22_roe_li_data_raw <- il_fy22_roe_li_data_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_roe_li_data_raw)

# new column names

new_names <- c("roenum",
               "distid",  # Confirm that RCDT is district id
               "distname",
               "tot_ase",
               "li_per",
               "tot_li")

# manually replace column names
colnames(il_fy22_roe_li_data_raw) <- new_names

# look at column names now
names(il_fy22_roe_li_data_raw)

# look at district names - they are imported as characters!
glimpse(il_fy22_enroll_li_raw$distid)

il_fy22_roe_li_data_clean <- il_fy22_roe_li_data_raw


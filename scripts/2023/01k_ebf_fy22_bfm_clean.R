# PURPOSE ---------

#   This script will clean FY 21 BFM and turn it into 
#   a dataset for the EBF calculation.
#   NOTE: This will require creating multiple data frames.

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

# load il ebf raw data -  skip to row three. Referencing the FY22-EBF..xlsx
#                         to clean the column names

# CLEANING BFM FY 21 --------

il_fy23_bfm_fy22_raw <- read_excel("C:/Users/jpacas/Documents/GitHub/IL-EBF/data/raw/FY-23-Evidence-Based-Funding-Full-Calc.xlsx", sheet = 19,
                                    skip = 5, n_max=927)

# fix column names
il_fy23_bfm_fy22_raw <- il_fy23_bfm_fy22_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy23_bfm_fy22_raw)

# new column names

# naming convention - delete# is the column number used to delete further
#                     down in the script

new_names <- c("distid",
               "distname",
               "final_tierfunding_fy22",
               "bfm_fy22_hh",
               "fy22_prop_tax_relief",
               "ebf_corrections_fy22",
               "delete7",
               "total_bfm_fy22",
               "delete9",
               "orgtype")  

# manually replace column names
colnames(il_fy23_bfm_fy22_raw) <- new_names

# look at column names now
names(il_fy23_bfm_fy22_raw)

# delete columns

il_fy23_bfm_fy22_clean <- il_fy23_bfm_fy22_raw[,-c(7,9)]

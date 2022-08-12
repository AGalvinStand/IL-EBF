# PURPOSE ---------

#   This script will clean ENROLL-ALL sheet and turn it into a 
#   dataset for the EBF calculation.

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

il_fy22_enroll_all_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 9, skip = 4) 

# fix column names
il_fy22_enroll_all_raw |>
  # convert colnames to lowercase
  rename_with(tolower) 

# look at column names
names(il_fy22_enroll_all_raw)

# create vector of new column names - include blank columns,
# rename these to delete1....N.
new_names <- c("distid",
               "distname",
               "county",
               "orgtype",
               "greaterof",
               "tot_ase",
               "delete",
               "enroll_k_3",
               "enroll_4_12",
               "delete2",
               "enroll_4_8",
               "enroll_9_12",
               "delete3",
               "enroll_dist_elem", #PK-8
               "enroll_dist_hs",   #9-12
               "enroll_dist_reg",  #Unit Labs Regional PK-12
               "delete4",
               "enroll_school_elem_pk_5",
               "enroll_school_elem_k_5",
               "enroll_school_mid_6_8",
               "enroll_school_hs_9_12",
               "delete5",
               "enroll_sped_pk",
               "enroll_k_all",     # includes 1/2 counted as .5
               "enroll_1",
               "enroll_2",
               "enroll_3",
               "enroll_4",
               "enroll_5",
               "enroll_6",
               "enroll_7",
               "enroll_8",
               "enroll_9",
               "enroll_10",
               "enroll_11",
               "enroll_12",
               "total") # total = tot_ase

# manually replace column names
colnames(il_fy22_enroll_all_raw) <- new_names

# look at column names now
names(il_fy22_enroll_all_raw)

# look at district names - they are imported as characters!
glimpse(il_fy22_enroll_all_raw$distid)

# select only columns with data

# delete duplicate columns (at the end after "total") and
# delete the empty columns using command below. Tidyverse's
# mutate command (i.e. keep = c(selected columns) does not
# work when there are duplicate columns (the 3 columns at the
# end, 37-40).

il_fy22_enroll_all_clean <- il_fy22_enroll_all_raw[,-c(7,10,13,17,22,37:40)]

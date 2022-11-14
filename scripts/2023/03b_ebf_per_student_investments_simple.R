# PURPOSE ---------

#   This script will extract the necessary variables from the Per Student Investments
#   sheet in order to perform the Base Calculation for EBF.

#   The goal will be to continue working on "ebf_per_student_investments.R" after the
#   8/30/22 project.

# PREPARED BY ------

# Chris Poulos

# 2022-08-25

# Let's go! - <('.' <)

options(scipen = 999)

library(tidyverse)
library(readxl)

# Bring in and clean Local Capacity Target sheet ------

il_fy22_per_student_investments_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 5, 
                                               skip = 5, n_max = 922)

ebf_per_student_investments <- il_fy22_per_student_investments_raw[,-c(2,3,6:61,64:65)] 

new_names <- c("distid",
               "orgtype",
               "total_ase",
               "total_psi_cwi",
               "total_psi_nocwi")

colnames(ebf_per_student_investments) <- new_names

rm(il_fy22_per_student_investments_raw,
   new_names)

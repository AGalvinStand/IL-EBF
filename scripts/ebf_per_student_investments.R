# 

options(scipen = 999)

library(tidyverse)
library(readxl)

# Bring in and clean Local Capacity Target sheet ------

il_fy22_perstudentinvestment_raw <- read_excel("data/raw/FY22-EBF-Full-Calc-Revised.xlsx", sheet = 5, 
                                               skip = 5, n_max = 922)

# Purpose ------------

#This script will perform the Per Student Investments calculation

#Prepared by: Aimee Galvin 2022-08-12


# Load libraries ---------

options(scipen = 999)

library(tidyverse)
library(readxl)


# Load source data -------

source("scripts/ebf_enroll_all_clean.R")
source("scripts/ebf_control_variables_clean.R")


# Calculate Gifted Cost ----------

psi_elementry <- il_fy22_cvs_perstudent_investment_perstudent_clean[1,]
psi_middle <- il_fy22_cvs_perstudent_investment_perstudent_clean[2,]
psi_hs <- il_fy22_cvs_perstudent_investment_perstudent_clean[3,]

ebf_per_student_investments <-  il_fy22_enroll_all_clean |>
  mutate(
    gifted_k_5 = (enroll_school_elem_k_5  * psi_elementry$gifted[1]),
    gifted_6_8 = (enroll_school_mid_6_8 * psi_middle$gifted[1]),
    gifted_9_12 = (enroll_school_hs_9_12 * psi_hs$gifted[1])
  ) |> 
  mutate(
    gifted_total = gifted_k_5 + gifted_6_8 + gifted_9_12
  )

# Calculate Profession Development ------------

ebf_per_student_investments <-  il_fy22_enroll_all_clean |>
  mutate(
    professional_development_pk_5 = (enroll_school_elem_pk_5  * psi_elementry$professional_development[1]),
    professional_development_6_8 = (enroll_school_mid_6_8 * psi_middle$professional_development[1]),
    professional_development_9_12 = (enroll_school_hs_9_12 * psi_hs$professional_development[1])
  ) |> 
  mutate(
    professional_development_total = professional_development_pk_5 + professional_development_6_8 + professional_development_9_12
  )


# Instructional Materials --------------

ebf_per_student_investments <-  il_fy22_enroll_all_clean |>
  mutate(
    instructional_material_pk_5 = (enroll_school_elem_pk_5  * psi_elementry$instructional_material[1]),
    instructional_material_6_8 = (enroll_school_mid_6_8 * psi_middle$instructional_material[1]),
    instructional_material_9_12 = (enroll_school_hs_9_12 * psi_hs$instructional_material[1])
  ) |> 
  mutate(
    instructional_material_total = instructional_material_pk_5 + instructional_material_6_8 + instructional_material_9_12
  )

# Assessments ------------------

ebf_per_student_investments <-  il_fy22_enroll_all_clean |>
  mutate(
    assessments_pk_5 = (enroll_school_elem_pk_5  * psi_elementry$assessments[1]),
    assessments_6_8 = (enroll_school_mid_6_8 * psi_middle$assessments[1]),
    assessments_9_12 = (enroll_school_hs_9_12 * psi_hs$assessments[1])
  ) |> 
  mutate(
    assessments_total = assessments_pk_5 + assessments_6_8 + assessments_9_12
  )

# Computer and Tech Equipment------------
#AG Note: this section requires a different formula, resume work here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


# Student Activities

ebf_per_student_investments <-  il_fy22_enroll_all_clean |>
  mutate(
    student_activities_pk_5 = (enroll_school_elem_pk_5  * psi_elementry$student_activities[1]),
    student_activities_6_8 = (enroll_school_mid_6_8 * psi_middle$student_activities[1]),
    student_activities_9_12 = (enroll_school_hs_9_12 * psi_hs$student_activities[1])
  ) |> 
  mutate(
    student_activities_total = student_activities_pk_5 + student_activities_6_8 + student_activities_9_12
  )


# Maintenance and Operations ----------------

centralservices_elementry <- il_fy22_cvs_perstudent_centralservices_clean[1,]
centralservices_middle <- il_fy22_cvs_perstudent_centralservices_clean[2,]
centralservices_hs <- il_fy22_cvs_perstudent_centralservices_clean[3,]

ebf_per_student_investments <-  il_fy22_enroll_all_clean |>
  mutate(
    maint_ops_pk_5 = (enroll_school_elem_pk_5  * centralservices_elementry$maint_ops[1]),
    maint_ops_6_8 = (enroll_school_mid_6_8 * centralservices_middle$maint_ops[1]),
    maint_ops_9_12 = (enroll_school_hs_9_12 * centralservices_hs$maint_ops[1])
  ) |> 
  mutate(
    maint_ops_total = maint_ops_pk_5 + maint_ops_6_8 + maint_ops_9_12
  )

# Central Office --------------

centralservices_elementry <- il_fy22_cvs_perstudent_centralservices_clean[1,]
centralservices_middle <- il_fy22_cvs_perstudent_centralservices_clean[2,]
centralservices_hs <- il_fy22_cvs_perstudent_centralservices_clean[3,]

ebf_per_student_investments <-  il_fy22_enroll_all_clean |>
  mutate(
    central_office_pk_5 = (enroll_school_elem_pk_5  * centralservices_elementry$maint_ops[1]),
    central_office_6_8 = (enroll_school_mid_6_8 * centralservices_middle$maint_ops[1]),
    central_office_9_12 = (enroll_school_hs_9_12 * centralservices_hs$maint_ops[1])
  ) |> 
  mutate(
    central_office_total = central_office_pk_5 + central_office_6_8 + central_office_9_12
  )



# Employee Costs ----------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Total Costs -----------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



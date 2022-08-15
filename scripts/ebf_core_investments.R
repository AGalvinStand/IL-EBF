# PURPOSE ---------

#   This script will perform the core investments calculations.

# -------------

# PREPARED BY ------

# Chris Poulos

# 2022-08-10

# Let's go! - <('.' <)

# load ---------

options(scipen = 999)

library(tidyverse)
library(readxl)

# CORE INVESTMENT STEPS --------

# CORE TEACHER AMOUNT------

# Bring in Low-income enrollment and control vairable dataframes.

source("scripts/ebf_enroll_li_clean.R")
source("scripts/ebf_control_variables_clean.R")

# Extract class size variables (by grade category and low-income status)

li_k_3 <- as.numeric(il_fy22_cvs_core_class_size_clean$li[1])
nonli_k_3 <- as.numeric(il_fy22_cvs_core_class_size_clean$nonli[1])

li_4_12 <- as.numeric(il_fy22_cvs_core_class_size_clean$li[2])
nonli_4_12 <- as.numeric(il_fy22_cvs_core_class_size_clean$nonli[2])

# FTE core teachers to students by grade - taking into account income

ebf_core_investments_fy22 <- il_fy22_enroll_li_clean |>
  mutate(fte_coreteacher_k_3 = as.integer(((enroll_k_3_li/li_k_3)+(enroll_k_3_noli/nonli_k_3))*100)/100,
         fte_coreteacher_4_8 = as.integer(((enroll_4_8_li/li_4_12)+(enroll_4_8_noli/nonli_4_12))*100)/100,
         fte_coreteacher_9_12 = as.integer(((enroll_9_12_li/li_4_12)+(enroll_9_12_noli/nonli_4_12))*100)/100)

# Core teacher salary by grade

k8_coreteacher_salary <- as.numeric(il_fy22_cvs_avgsalary_clean$core_teacher[1])
hs_coreteacher_salary <- as.numeric(il_fy22_cvs_avgsalary_clean$core_teacher[2])

# Core teacher cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(core_teacher_cost = 
           (fte_coreteacher_k_3*k8_coreteacher_salary)+
           (fte_coreteacher_4_8*k8_coreteacher_salary)+
           (fte_coreteacher_9_12*hs_coreteacher_salary))

# SPECIALIST TEACHER COST ----------

# Specialist Teacher % of Core Teacher

specialists_pk_5 <- il_fy22_cvs_core_investments_clean$specialists_per_of_coreteachers[1]
specialists_middle <- il_fy22_cvs_core_investments_clean$specialists_per_of_coreteachers[2]
specialists_hs <- il_fy22_cvs_core_investments_clean$specialists_per_of_coreteachers[3]

# Specialist teacher by grade

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_specialists = 
           (specialists_pk_5*fte_coreteacher_k_3)+
           (specialists_middle*fte_coreteacher_4_8)+
           (specialists_hs*fte_coreteacher_9_12))

# Specialist teacher cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(specialist_cost = 
           (specialists_pk_5*fte_coreteacher_k_3*k8_coreteacher_salary)+
           (specialists_middle*fte_coreteacher_4_8*k8_coreteacher_salary)+
           (specialists_hs*fte_coreteacher_9_12*hs_coreteacher_salary))

# INSTRUCTIONAL FACILITATOR COST -----------------

source("scripts/ebf_enroll_all_clean.R")

# Students for every 1 instructional facilitator by grade variable

instructional_facilitator_pk_5 <- il_fy22_cvs_core_investments_clean$instructional_facilitators[1]
instructional_facilitator_middle <- il_fy22_cvs_core_investments_clean$instructional_facilitators[2]
instructional_facilitator_hs <- il_fy22_cvs_core_investments_clean$instructional_facilitators[3]

# Join enrollment all tab data (to calculation FTE instructional facilitator by grade)

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  left_join(il_fy22_enroll_all_clean, by = c("distid" = "distid")) 

# Instructional facilitator by grade

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_instructional_facilitator_pk_5 =
           (enroll_school_elem_pk_5/instructional_facilitator_pk_5),
         fte_instructional_facilitator_middle =
           (enroll_school_mid_6_8/instructional_facilitator_middle),
         fte_instructional_facilitator_hs =
           (enroll_school_hs_9_12/instructional_facilitator_hs))

# Instructional facilitator cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(instructional_facilitator_cost = 
           (fte_instructional_facilitator_pk_5* k8_coreteacher_salary)+
           (fte_instructional_facilitator_middle * k8_coreteacher_salary)+
           (fte_instructional_facilitator_hs * hs_coreteacher_salary))

# CORE INTERVENTION TEACHER (Tutor) COST ---------

# Students for every 1 core intervention teacher by grade variable

core_intervention_pk_5 <- il_fy22_cvs_core_investments_clean$core_intervention_teacher[1]
core_intervention_middle <- il_fy22_cvs_core_investments_clean$core_intervention_teacher[2]
core_intervention_hs <- il_fy22_cvs_core_investments_clean$core_intervention_teacher[3]

# Core intervention teacher by grade

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_core_intervention_pk_5 =
           (enroll_school_elem_pk_5/core_intervention_pk_5),
         fte_core_intervention_middle =
           (enroll_school_mid_6_8/core_intervention_middle),
         fte_core_intervention_hs =
           (enroll_school_hs_9_12/core_intervention_hs))

# Core intervention cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(core_intervention_cost = 
           (fte_core_intervention_pk_5* k8_coreteacher_salary)+
           (fte_core_intervention_middle * k8_coreteacher_salary)+
           (fte_core_intervention_hs * hs_coreteacher_salary))

# SUBSTITUTE TEACHER COST ------------------------

# NEED ADDITIONAL INVESTMENT COL 51 AND 42

# GUIDANCE COUNSELOR COST ------------------------

# Students for every 1 guidance counselor by grade variable

guidance_counselor_pk_5 <- il_fy22_cvs_core_investments_clean$guidance_counselor[1]
guidance_counselor_middle <- il_fy22_cvs_core_investments_clean$guidance_counselor[2]
guidance_counselor_hs <- il_fy22_cvs_core_investments_clean$guidance_counselor[3]

# Guidance counselor salary by grade variable

k8_guidance_counselor_salary <- il_fy22_cvs_avgsalary_clean$guidance_counselor[1]
hs_guidance_counselor_salary <- il_fy22_cvs_avgsalary_clean$guidance_counselor[2]

# Guidance counselor by grade

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_guidance_counselor_pk_5 =
           (enroll_school_elem_pk_5/guidance_counselor_pk_5),
         fte_guidance_counselor_middle =
           (enroll_school_mid_6_8/guidance_counselor_middle),
         fte_guidance_counselor_hs =
           (enroll_school_hs_9_12/guidance_counselor_hs))

# Guidance counselor cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(guidance_counselor_cost = 
           (fte_guidance_counselor_pk_5* k8_guidance_counselor_salary)+
           (fte_guidance_counselor_middle * k8_guidance_counselor_salary)+
           (fte_guidance_counselor_hs * hs_guidance_counselor_salary))

# NURSE COST -------------------------------------

# Students for every 1 nurse by grade variable

school_nurse_pk_5 <- il_fy22_cvs_core_investments_clean$nurse[1]
school_nurse_middle <- il_fy22_cvs_core_investments_clean$nurse[2]
school_nurse_hs <- il_fy22_cvs_core_investments_clean$nurse[3]

# Nurse salary by grade

k8_school_nurse_salary <- il_fy22_cvs_avgsalary_clean$school_nurse[1]
hs_school_nurse_salary <- il_fy22_cvs_avgsalary_clean$school_nurse[2]

# Nurses per student by grade

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_school_nurse_pk_5 =
           (enroll_school_elem_pk_5/school_nurse_pk_5),
         fte_school_nurse_middle =
           (enroll_school_mid_6_8/school_nurse_middle),
         fte_school_nurse_hs =
           (enroll_school_hs_9_12/school_nurse_hs))

# Nurse cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(school_nurse_cost = 
           (fte_school_nurse_pk_5* k8_school_nurse_salary)+
           (fte_school_nurse_middle * k8_school_nurse_salary)+
           (fte_school_nurse_hs * hs_school_nurse_salary))

# SUPERVISORY AIDE COST --------------------------

# Students for every 1 supervisory aide by grade variable

supervisory_aide_pk_5 <- il_fy22_cvs_core_investments_clean$supervisory_aide[1]
supervisory_aide_middle <- il_fy22_cvs_core_investments_clean$supervisory_aide[2]
supervisory_aide_hs <- il_fy22_cvs_core_investments_clean$supervisory_aide[3]

# Supervisory aide salary by grade

k8_supervisory_aide_salary <- il_fy22_cvs_assumedsalary_clean$noninstruction_assistant[1]
hs_supervisory_aide_salary <- il_fy22_cvs_assumedsalary_clean$noninstruction_assistant[2]

# Supervisory aide by grade

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_supervisory_aide_pk_5 =
           (enroll_school_elem_pk_5/supervisory_aide_pk_5),
         fte_supervisory_aide_middle =
           (enroll_school_mid_6_8/supervisory_aide_middle),
         fte_supervisory_aide_hs =
           (enroll_school_hs_9_12/supervisory_aide_hs))

# Supervisory aide cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(supervisory_aide_cost = 
           (fte_supervisory_aide_pk_5* k8_supervisory_aide_salary)+
           (fte_supervisory_aide_middle * k8_supervisory_aide_salary)+
           (fte_supervisory_aide_hs * hs_supervisory_aide_salary))

# LIBRARIAN COST ---------------------------------

# Students for every 1 librarian by grade variable

librarian_pk_5 <- il_fy22_cvs_core_investments_clean$librarian[1]
librarian_middle <- il_fy22_cvs_core_investments_clean$librarian[2]
librarian_hs <- il_fy22_cvs_core_investments_clean$librarian[3]

# Nurse salary by grade

k8_librarian_salary <- il_fy22_cvs_avgsalary_clean$librarian_mediaspecialist[1]
hs_librarian_salary <- il_fy22_cvs_avgsalary_clean$librarian_mediaspecialist[2]

# Nurses per student

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_librarian_pk_5 =
           (enroll_school_elem_pk_5/librarian_pk_5),
         fte_librarian_middle =
           (enroll_school_mid_6_8/librarian_middle),
         fte_librarian_hs =
           (enroll_school_hs_9_12/librarian_hs))

# Nurse cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(librarian_cost = 
           (fte_librarian_pk_5* k8_librarian_salary)+
           (fte_librarian_middle * k8_librarian_salary)+
           (fte_librarian_hs * hs_librarian_salary))

# LIBRARIAN AIDE / MEDIA TECH COST ---------------

# Students for every 1 librarian aide by grade variable

librarian_aide_pk_5 <- il_fy22_cvs_core_investments_clean$librarian_aide[1]
librarian_aide_middle <- il_fy22_cvs_core_investments_clean$librarian_aide[2]
librarian_aide_hs <- il_fy22_cvs_core_investments_clean$librarian_aide[3]

# Librarian aide salary by grade

k8_librarian_aide_salary <- il_fy22_cvs_assumedsalary_clean$noninstruction_assistant[1]
hs_librarian_aide_salary <- il_fy22_cvs_assumedsalary_clean$noninstruction_assistant[2]

# Librarian aide per student 

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_librarian_aide_pk_5 =
           (enroll_school_elem_pk_5/librarian_aide_pk_5),
         fte_librarian_aide_middle =
           (enroll_school_mid_6_8/librarian_aide_middle),
         fte_librarian_aide_hs =
           (enroll_school_hs_9_12/librarian_aide_hs))

# Librarian aide cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(librarian_aide_cost = 
           (fte_librarian_aide_pk_5* k8_librarian_aide_salary)+
           (fte_librarian_aide_middle * k8_librarian_aide_salary)+
           (fte_librarian_aide_hs * hs_librarian_aide_salary))

# PRINCIPAL COST ---------------------------------

# Students for every 1 principal by grade variable

principal_pk_5 <- il_fy22_cvs_core_investments_clean$principal[1]
principal_middle <- il_fy22_cvs_core_investments_clean$principal[2]
principal_hs <- il_fy22_cvs_core_investments_clean$principal[3]

# Principal salary by grade

k8_principal_salary <- il_fy22_cvs_avgsalary_clean$principal[1]
hs_principal_salary <- il_fy22_cvs_avgsalary_clean$principal[2]

# Principal per student

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_principal_pk_5 =
           (enroll_school_elem_pk_5/principal_pk_5),
         fte_principal_middle =
           (enroll_school_mid_6_8/principal_middle),
         fte_principal_hs =
           (enroll_school_hs_9_12/principal_hs))

# Principal cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(principal_cost = 
           (fte_principal_pk_5* k8_principal_salary)+
           (fte_principal_middle * k8_principal_salary)+
           (fte_principal_hs * hs_principal_salary))

# ASSISTANT PRINCIPAL COST -----------------------

# Students for every 1 Assistant principal by grade variable

assistant_principal_pk_5 <- il_fy22_cvs_core_investments_clean$assistant_principal[1]
assistant_principal_middle <- il_fy22_cvs_core_investments_clean$assistant_principal[2]
assistant_principal_hs <- il_fy22_cvs_core_investments_clean$assistant_principal[3]

# Assistant principal salary by grade

k8_assistant_principal_salary <- il_fy22_cvs_avgsalary_clean$assistant_principal[1]
hs_assistant_principal_salary <- il_fy22_cvs_avgsalary_clean$assistant_principal[2]

# Assistant principal per student

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_assistant_principal_pk_5 =
           (enroll_school_elem_pk_5/assistant_principal_pk_5),
         fte_assistant_principal_middle =
           (enroll_school_mid_6_8/assistant_principal_middle),
         fte_assistant_principal_hs =
           (enroll_school_hs_9_12/assistant_principal_hs))

# Assistant principal cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(assistant_principal_cost = 
           (fte_assistant_principal_pk_5* k8_assistant_principal_salary)+
           (fte_assistant_principal_middle * k8_assistant_principal_salary)+
           (fte_assistant_principal_hs * hs_assistant_principal_salary))

# SCHOOL SITE STAFF COST -------------------------

# Students for every 1 School site staff by grade variable

school_site_staff_pk_5 <- il_fy22_cvs_core_investments_clean$school_site_staff[1]
school_site_staff_middle <- il_fy22_cvs_core_investments_clean$school_site_staff[2]
school_site_staff_hs <- il_fy22_cvs_core_investments_clean$school_site_staff[3]

k8_school_site_staff_salary <- il_fy22_cvs_assumedsalary_clean$school_site_staff[1]
hs_school_site_staff_salary <- il_fy22_cvs_assumedsalary_clean$school_site_staff[2]

# School site staff per student

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(fte_school_site_staff_pk_5 =
           (enroll_school_elem_pk_5/school_site_staff_pk_5),
         fte_school_site_staff_middle =
           (enroll_school_mid_6_8/school_site_staff_middle),
         fte_school_site_staff_hs =
           (enroll_school_hs_9_12/school_site_staff_hs))

# School site staff cost

ebf_core_investments_fy22 <- ebf_core_investments_fy22 |>
  mutate(school_site_staff_cost = 
           (fte_school_site_staff_pk_5* k8_school_site_staff_salary)+
           (fte_school_site_staff_middle * k8_school_site_staff_salary)+
           (fte_school_site_staff_hs * hs_school_site_staff_salary))

# TOTAL COST -------------------------------------

# TOTAL SALARY COST (LESS SUBSTITUTES) -----------


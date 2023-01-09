# test_data.R
# 2022-10-04

# load ---------

set.seed(36)

library(tidyverse)
library(edbuildr)

dist_raw <- masterpull(data_year = "2019", data_type = "geo")

de_raw <- dist_raw |> 
  filter(State == "Delaware") |> 
  rename_with(tolower) 
  
de_clean <- de_raw |> 
  mutate(frpl_pct = case_when(stpovrate > .12 ~ stpovrate * 3,
                              stpovrate > .1 ~ stpovrate * 2,
                              TRUE ~ stpovrate),
         frpl_adm = enroll * frpl_pct) |> 
  mutate(sped_opt1_adm = rnorm(16, mean = .12, sd = .04) * enroll,
         sped_opt2_adm = rnorm(16, mean = .06, sd = .02) * enroll,
         sped_opt3_adm = rnorm(16, mean = .03, sd = .01) * enroll) |> 
  mutate(el_adm = abs(rnorm(16, mean = .05, sd = .025)) * enroll) |> 
  rename(base_adm = enroll,
         district = name) |> 
  select(ncesid, state_id, district, frpl_pct,
         base_adm, frpl_adm,
         sped_opt1_adm, sped_opt2_adm, sped_opt3_adm,
         el_adm, 
         student_per_sq_mile, mhi, mpv)

write_rds(de_clean, "data/simulator_data.rds")


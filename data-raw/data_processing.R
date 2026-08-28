# Description ------------------------------------------------------------------
# R script to process uploaded raw data into a tidy, analysis-ready data frame
# Load packages ----------------------------------------------------------------
## Run the following code in console if you don't have the packages
## install.packages(c("usethis", "fs", "here", "readr", "readxl", "openxlsx"))
library(usethis)
library(fs)
library(here)
library(readr)
library(dplyr)
library(tidyr)
library(openxlsx)

# Read data --------------------------------------------------------------------
# data_in <- readr::read_csv("data-raw/dataset.csv")
# codebook <- readxl::read_excel("data-raw/codebook.xlsx") |>
#  clean_names()

# Tidy data --------------------------------------------------------------------
## Clean the raw data into a tidy format here

raw <- read_csv("../data/raw/MZ_WISE_baseline-endline2.csv")

cols_to_remove <- c(
  "Container_size", "total_liters", "liters_person",
  "25liter", "20liter", "15liter", "10liter", "5liter",
  "Code", "survey_date", "mgmt_turnoff", "mgmt_comm",
  "notsatisfied_why", "places_adults_poo", "handwash_demo"
)
clean <- raw |>
  select(-any_of(cols_to_remove)) |>
  rename_with(~ gsub("hwise:drinking", "hwise_drinking", .x))

# --- Factor and numeric conversions ---
clean <- clean |>
  mutate(
    survey_type = factor(survey_type, levels = c("Baseline", "Endline")),
    District = factor(District, levels = c("Larde", "Memba", "Moma", "Mecuburi")),
    insecurity_level = factor(insecurity_level,
                              levels = c("High", "Moderate", "Low", "No-to-marginal" )),
    whether_improved = factor(whether_improved, levels = c("Unimproved", "Improved")),
    satisfied = case_when(
      trimws(satisfied) == "Satistfied" ~ "Satisfied",
      TRUE ~ satisfied
    ),
    satisfied = factor(satisfied, levels = c("Not Satisfied", "Satisfied")),
    hwise_score = as.numeric(hwise_score),
    total_collect_time = as.numeric(total_collect_time),
    water_basic = as.numeric(water_basic),
    water_limited = as.numeric(water_limited),
    water_unimproved = as.numeric(water_unimproved),
    water_surface = as.numeric(water_surface)
  )

hwise_cols <- c(
  "hwise_worry", "hwise_interrupt", "hwise_clothes",
  "hwise_change_plans", "hwise_change_meal", "hwise_nohandwash",
  "hwise_no_bodywash", "hwise_drinking", "hwise_angry",
  "hwise_sleepthirsty", "hwise_nowater", "hwise_shame"
)
# --- Filter out invalid responses ---
clean <- clean |>
  filter(!if_any(all_of(hwise_cols), ~ . %in% c("", "DNK", "N/A")))

clean <- clean |>
  rename(
    Felt_Worried = hwise_worry,
    Service_Interrupted = hwise_interrupt,
    Too_Little_for_Clothes = hwise_clothes,
    Changed_Routine = hwise_change_plans,
    Too_Little_for_Cooking = hwise_change_meal,
    Too_Little_for_Hands = hwise_nohandwash,
    Too_Little_to_Bathe = hwise_no_bodywash,
    Too_Little_to_Drink = hwise_drinking,
    Felt_Angry = hwise_angry,
    Slept_Thirsty = hwise_sleepthirsty,
    No_Water_at_All = hwise_nowater,
    Felt_Shame = hwise_shame
  )

hwise_items <- c(
  "Felt_Worried",
  "Service_Interrupted",
  "Too_Little_for_Clothes",
  "Changed_Routine",
  "Too_Little_for_Cooking",
  "Too_Little_for_Hands",
  "Too_Little_to_Bathe",
  "Too_Little_to_Drink",
  "Felt_Angry",
  "Slept_Thirsty",
  "No_Water_at_All",
  "Felt_Shame"
)
hwise_labels <- gsub("_", " ", hwise_items)

# --- Recode text responses into 4 levels ---
clean <- clean |>
  mutate(across(
    all_of(hwise_items),
    ~ case_when(
      . %in% c("Never (0 times)")                 ~ "Never",
      . %in% c("Rarely (1-2 times)")             ~ "Rarely",
      . %in% c("Sometimes (3-10 times)")         ~ "Sometimes",
      . %in% c("Often (11-20 times)", "Always (more than 20 times)") ~ "Often/Always",
      TRUE ~ NA_character_
    )
  ))

# --- Prepare long dataset for plotting with correct percent calculation ---
water_insecurity_items <- clean |>
  select(survey_type, all_of(hwise_items)) |>
  pivot_longer(
    cols = all_of(hwise_items),
    names_to = "item",
    values_to = "frequency"
  ) |>
  filter(!is.na(frequency)) |>
  mutate(
    frequency = factor(frequency, levels = c("Never", "Rarely", "Sometimes", "Often/Always")),
    item = factor(item, levels = rev(hwise_items))
  ) |>
  group_by(survey_type, item, frequency) |>
  summarise(n = n(), .groups = "drop") |>
  group_by(survey_type, item) |>        # <-- crucial for correct percentages
  mutate(percent = n / sum(n) * 100) |>
  ungroup()


# Export Data ------------------------------------------------------------------
usethis::use_data(kalaiwash, overwrite = TRUE)
fs::dir_create(here::here("inst", "extdata"))
readr::write_csv(kalaiwash,
                 here::here("inst", "extdata", paste0("kalaiwash", ".csv")))
openxlsx::write.xlsx(kalaiwash,
                     here::here("inst", "extdata", paste0("kalaiwash", ".xlsx")))

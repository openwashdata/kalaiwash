# Description ------------------------------------------------------------------
# R script to process uploaded raw data into a tidy, analysis-ready data frame

# Load packages ----------------------------------------------------------------
library(usethis)
library(here)
library(readxl)
library(dplyr)
library(tidyr)
library(openxlsx)

# Read data --------------------------------------------------------------------

raw_data <- read_excel(
  here::here("data-raw", "MZ_WISE_baseline-endline2.xlsx"),
  col_types = c("guess", "date", rep("guess", 47))  # column B is survey_date
)

# Tidy data --------------------------------------------------------------------

# whether_improved, hwise_score, insecurity_level, total_collect_time,
# total_liters and the JMP water_* indicators are calculated in the raw Excel
# file; they are dropped here and recalculated in transformed_data.
# liters_person is dropped and not recalculated.
clean_data <- raw_data |>
  janitor::clean_names() |>
  select(-code, -container_size, -handwashing_basic,
         -dry_months, -mgmt_turnoff, -mgmt_comm,
         -whether_improved, -hwise_score, -insecurity_level,
         -total_collect_time, -total_liters, -liters_person,
         -water_surface, -water_unimproved, -water_limited, -water_basic) |>
  rename(
    defecation_place = places_adults_poo,
    containers_25l = x25liter, containers_20l = x20liter,
    containers_15l = x15liter, containers_10l = x10liter,
    containers_5l = x5liter
  ) |>
  mutate(
    survey_date = as.Date(survey_date),
    across(starts_with("containers_"), ~ replace_na(.x, 0)),
    survey_type = factor(survey_type, levels = c("Baseline", "Endline")),
    district = factor(district, levels = c("Larde", "Memba", "Moma", "Mecuburi")),
    community = factor(community),
    gender = factor(gender, levels = c("Female", "Male")),
    source = factor(source, levels = c(
      "Borehole with handpump", "Protected dug well",
      "Protected dug well with handpump", "Public tap or standpipe",
      "Unprotected dug well", "Unprotected spring", "Surface water"
    )),
    across(c(collect_yesterday, handwash_demo, water_wash),
           ~ factor(.x, levels = c("No", "Yes"))),
    satisfied = if_else(satisfied == "Satistfied", "Satisfied", satisfied),
    satisfied = factor(satisfied, levels = c("Not Satisfied", "Satisfied")),
    notsatisfied_why = factor(notsatisfied_why),
    # the raw value separates "In water body" and "river or lake" with an en dash
    defecation_place = if_else(startsWith(defecation_place, "In water body"),
                               "In water body: river or lake", defecation_place),
    defecation_place = factor(defecation_place, levels = c(
      "Latrine/toilet", "In the open/no sanitation facilities",
      "In water body: river or lake"
    )),
    soap_ash = factor(soap_ash, levels = c(
      "Soap", "Ash", "Other cleanser or detergent", "None shown"
    ))
  )

hwise_cols <- c(
  "hwise_worry", "hwise_interrupt", "hwise_clothes",
  "hwise_change_plans", "hwise_change_meal", "hwise_nohandwash",
  "hwise_no_bodywash", "hwise_drinking", "hwise_angry",
  "hwise_sleepthirsty", "hwise_nowater", "hwise_shame"
)

improved_sources <- c(
  "Borehole with handpump", "Protected dug well",
  "Protected dug well with handpump", "Mechanized borehole",
  "Protected spring", "Public tap or standpipe",
  "Piped water into dwelling", "Piped water into yard or plot"
)

# HWISE-12 item weights: Never 0, Rarely 1, Sometimes 2, Often/Always 3
hwise_weights <- c(
  "Never (0 times)" = 0,
  "Rarely (1-2 times)" = 1,
  "Sometimes (3-10 times)" = 2,
  "Often (11-20 times)" = 3,
  "Always (more than 20 times)" = 3
)

transformed_data <- clean_data |>
  mutate(
    jmp_improved = case_when(
      source == "Don't know" ~ NA_character_,
      source %in% improved_sources ~ "Improved",
      TRUE ~ "Unimproved"
    ),
    jmp_improved = factor(jmp_improved, levels = c("Unimproved", "Improved")),
    hwise_score = rowSums(across(all_of(hwise_cols), ~ hwise_weights[.x])),
    hwise_insecurity_level = case_when(
      hwise_score <= 2 ~ "No-to-marginal",
      hwise_score <= 11 ~ "Low",
      hwise_score <= 23 ~ "Moderate",
      hwise_score <= 36 ~ "High"
    ),
    hwise_insecurity_level = factor(
      hwise_insecurity_level,
      levels = c("High", "Moderate", "Low", "No-to-marginal")
    ),
    .after = source
  ) |>
  relocate(hwise_score, hwise_insecurity_level, .after = hwise_shame) |>
  mutate(
    total_collect_time = 2 * oneway_travel + wait_time,
    .after = wait_time
  ) |>
  mutate(
    jmp_water_service = case_when(
      source == "Surface water" ~ "Surface water",
      jmp_improved == "Unimproved" ~ "Unimproved",
      total_collect_time > 30 ~ "Limited",
      TRUE ~ "Basic"
    ),
    jmp_water_service = factor(jmp_water_service,
                               levels = c("Surface water", "Unimproved",
                                          "Limited", "Basic")),
    .after = jmp_improved
  ) |>
  mutate(
    total_liters = 25 * containers_25l + 20 * containers_20l +
      15 * containers_15l + 10 * containers_10l + 5 * containers_5l,
    .after = collect_yesterday
  ) |>
  # the container counts are only used to derive total_liters
  select(-starts_with("containers_"))

# --- HWISE items as ordered factors with short labels ---
hwise_levels <- c(
  "Never (0 times)" = "Never",
  "Rarely (1-2 times)" = "Rarely",
  "Sometimes (3-10 times)" = "Sometimes",
  "Often (11-20 times)" = "Often",
  "Always (more than 20 times)" = "Always"
)

kalaiwash <- transformed_data |>
  mutate(
    across(all_of(hwise_cols),
           ~ factor(hwise_levels[.x], levels = hwise_levels, ordered = TRUE)),
    notsatisfied_why = recode(notsatisfied_why, "Other (please specify)" = "Other")
  ) |>
  relocate(jmp_improved, jmp_water_service, .before = hwise_worry)

# Export Data ------------------------------------------------------------------
usethis::use_data(kalaiwash, overwrite = TRUE)
fs::dir_create(here::here("inst", "extdata"))
readr::write_csv(kalaiwash,
                 here::here("inst", "extdata", paste0("kalaiwash", ".csv")))
openxlsx::write.xlsx(kalaiwash,
                     here::here("inst", "extdata", paste0("kalaiwash", ".xlsx")))

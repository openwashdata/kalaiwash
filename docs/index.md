# kalaiwash

The goal of kalaiwash is to provide the baseline and endline household
survey data of the KALAI water, sanitation and hygiene project of
HELVETAS in Nampula Province, Mozambique. The project was funded by
charity: water. Baseline data were collected in November 2024 and
endline data in June 2025 in the districts of Larde, Memba, Moma and
Mecuburi. The data describe drinking water sources classified with the
WHO/UNICEF Joint Monitoring Programme (JMP) service ladder, water
collection times and volumes, sanitation and handwashing practices, and
household water insecurity measured with the 12-item Household Water
Insecurity Experiences (HWISE) Scale.

## Installation

You can install the development version of kalaiwash from
[GitHub](https://github.com/) with:

``` r

# install.packages("devtools")
devtools::install_github("openwashdata/kalaiwash")
```

``` r

## Run the following code in console if you don't have the packages
## install.packages(c("dplyr", "knitr", "readr", "stringr", "gt", "kableExtra"))
library(dplyr)
library(knitr)
library(readr)
library(stringr)
library(gt)
library(kableExtra)
```

Alternatively, you can download the individual datasets as a CSV or XLSX
file from the table below.

1.  Click Download CSV. A window opens that displays the CSV in your
    browser.
2.  Right-click anywhere inside the window and select “Save Page As…”.
3.  Save the file in a folder of your choice.

| dataset | CSV | XLSX |
|:---|:---|:---|
| kalaiwash | [Download CSV](https://github.com/openwashdata/kalaiwash/raw/main/inst/extdata/kalaiwash.csv) | [Download XLSX](https://github.com/openwashdata/kalaiwash/raw/main/inst/extdata/kalaiwash.xlsx) |

## Data

The package provides access to one dataset.

``` r

library(kalaiwash)
```

### kalaiwash

The dataset `kalaiwash` contains one row per household interview. It has
275 observations and 40 variables.

``` r

kalaiwash |> 
  head(3) |> 
  gt::gt() |>
  gt::as_raw_html()
```

| survey_date | survey_type | district | community | gender | household_size | source | jmp_improved | jmp_water_service | collect_yesterday | containers_25l | containers_20l | containers_15l | containers_10l | containers_5l | oneway_travel | wait_time | total_collect_time | satisfied | notsatisfied_why | defecation_place | handwash_demo | soap_ash | water_wash | hwise_worry | hwise_interrupt | hwise_clothes | hwise_change_plans | hwise_change_meal | hwise_nohandwash | hwise_no_bodywash | hwise_drinking | hwise_angry | hwise_sleepthirsty | hwise_nowater | hwise_shame | hwise_score | hwise_insecurity_level | total_liters | liters_person |
|---:|:--:|:--:|:--:|:--:|---:|:--:|:--:|:--:|:--:|---:|---:|---:|---:|---:|---:|---:|---:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|---:|:--:|---:|---:|
| 2025-06-18 | Endline | Memba | Cruzamento dos velhos | Male | 6 | Borehole with handpump | Improved | Basic | No | 0 | 0 | 0 | 0 | 0 | 10 | 10 | 30 | Satisfied | NA | Latrine/toilet | Yes | Ash | Yes | Never | Never | Never | Never | Never | Never | Never | Never | Never | Never | Never | Never | 0 | No-to-marginal | 0 | 0.00000 |
| 2025-06-18 | Endline | Memba | Cruzamento dos velhos | Male | 10 | Borehole with handpump | Improved | Basic | Yes | 0 | 4 | 0 | 0 | 0 | 1 | 5 | 7 | Satisfied | NA | Latrine/toilet | Yes | Soap | Yes | Never | Never | Never | Never | Never | Never | Never | Never | Never | Never | Never | Never | 0 | No-to-marginal | 80 | 8.00000 |
| 2025-06-18 | Endline | Memba | Cruzamento dos velhos | Female | 6 | Borehole with handpump | Improved | Basic | Yes | 0 | 5 | 0 | 0 | 0 | 3 | 10 | 16 | Satisfied | NA | Latrine/toilet | Yes | Soap | Yes | Never | Never | Never | Never | Never | Never | Never | Never | Never | Never | Never | Never | 0 | No-to-marginal | 100 | 16.66667 |

For an overview of the variable names, see the following table. The
`options` column lists the levels of each categorical variable.

| variable_name | variable_type | description | options |
|:---|:---|:---|:---|
| survey_date | Date | Date of the interview | NA |
| survey_type | factor | Survey round: Baseline (November 2024) or Endline (June 2025) | Baseline; Endline |
| district | factor | District of Nampula Province where the household is located | Larde; Memba; Moma; Mecuburi |
| community | factor | Name of village | Cruzamento dos velhos; Jacagiua; Lusaka; Macuire; Matata; Miaja; Mieie; Monapo; Mpaheia; Namichir; Nanrele; Nihola; Valdemar |
| gender | factor | Whether the respondent is male or female | Female; Male |
| household_size | numeric | The number of people living and eating together in the household including the respondent | NA |
| source | factor | Household’s primary drinking water source | Borehole with handpump; Protected dug well; Protected dug well with handpump; Public tap or standpipe; Unprotected dug well; Unprotected spring; Surface water |
| jmp_improved | factor | If the Water source is “improved” or “unimproved” according to the JMP classification, derived from source: Improved for borehole with handpump, protected dug well (with or without handpump), public tap or standpipe, mechanized borehole, protected spring and piped water; Unimproved otherwise | Unimproved; Improved |
| jmp_water_service | factor | JMP drinking water service level derived from source and total_collect_time: Surface water; Unimproved (other unimproved source); Limited (improved source, total collection time over 30 minutes); Basic (improved source, total collection time of 30 minutes or less) | Surface water; Unimproved; Limited; Basic |
| collect_yesterday | factor | If anyone in the household collected drinking water yesterday | No; Yes |
| containers_25l | numeric | Number of 25 liter containers used to collect water yesterday | NA |
| containers_20l | numeric | Number of 20 liter containers used to collect water yesterday | NA |
| containers_15l | numeric | Number of 15 liter containers used to collect water yesterday | NA |
| containers_10l | numeric | Number of 10 liter containers used to collect water yesterday | NA |
| containers_5l | numeric | Number of 5 liter containers used to collect water yesterday | NA |
| oneway_travel | numeric | Estimate of how long household member had to walk to get to the water source in minutes (not round-trip) | NA |
| wait_time | numeric | The last time household member went to the source, estimate of how long to wait to collect water from the source in minutes | NA |
| total_collect_time | numeric | Total collection time in minutes: twice the one-way walk (oneway_travel) plus the wait time (wait_time) | NA |
| satisfied | factor | Whether the respondent is satisfied with the water service | Not Satisfied; Satisfied |
| notsatisfied_why | factor | Why not satisfied with your water service | It is broken; It is too expensive; It is too far away; Long lines; Other; Water has a bad smell, color, or quality; Water tastes bad |
| defecation_place | factor | The places that adult men and women in this household defecate | Latrine/toilet; In the open/no sanitation facilities; In water body: river or lake |
| handwash_demo | factor | Willing to show where and how handwashing happens | No; Yes |
| soap_ash | factor | Household demo uses soap or ash or another cleanser to wash hands | Soap; Ash; Other cleanser or detergent; None shown |
| water_wash | factor | Household demo uses water to wash hands | No; Yes |
| hwise_worry | ordered, factor | In the last 4 weeks, how frequently did you or anyone in your household worry you would not have enough water for all of your household needs? | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_interrupt | ordered, factor | In the last 4 weeks, how frequently has your main water source been interrupted or limited (e.g. water pressure, less water than expected, river dried up)? | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_clothes | ordered, factor | In the last 4 weeks, how frequently have problems with water meant that clothes could not be washed? | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_change_plans | ordered, factor | In the last 4 weeks, how frequently have you or anyone in your household had to change schedules or plans due to problems with your water situation? (e.g. caring for others, household chores, agricultural work, IGA, sleeping) | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_change_meal | ordered, factor | In the last 4 weeks, how frequently have you or anyone in your household had to change what was being eaten because there were problems with water (e.g., for washing foods, cooking, etc.)? | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_nohandwash | ordered, factor | In the last 4 weeks, how frequently have you or anyone in your household had to go without washing hands after dirty activities (e.g., defecating or changing diapers, cleaning animal dung) because of problems with water? | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_no_bodywash | ordered, factor | In the last 4 weeks, how frequently have you or anyone in your household had to go without washing their body because of problems with water (e.g., not enough water, dirty, unsafe)? | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_drinking | ordered, factor | In the last 4 weeks, how frequently has there not been as much water to drink as you would like for you or anyone in your household? | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_angry | ordered, factor | In the last 4 weeks, how frequently did you or anyone in your household feel angry about your water situation? | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_sleepthirsty | ordered, factor | In the last 4 weeks, how frequently have you or anyone in your household gone to sleep thirsty because there wasn’t any water to drink? | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_nowater | ordered, factor | In the last 4 weeks, how frequently has there been no useable or drinkable water whatsoever in your household? | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_shame | ordered, factor | In the last 4 weeks, how frequently did you or anyone in your household feel ashamed/excluded/stigmatized? | Never (0 times); Rarely (1-2 times); Sometimes (3-10 times); Often (11-20 times); Always (more than 20 times) |
| hwise_score | numeric | Sum of the 12 HWISE items scored Never 0, Rarely 1, Sometimes 2, Often or Always 3; range 0 to 36 | NA |
| hwise_insecurity_level | factor | Water insecurity level from hwise_score: 0 to 2 “No-to-marginal”, 3 to 11 “Low”, 12 to 23 “Moderate”, 24 to 36 “High” | High; Moderate; Low; No-to-marginal |
| total_liters | numeric | Total liters collected in past 24 hours using any water transport container(s) of any volume(s), derived as 25 \* containers_25l + 20 \* containers_20l + 15 \* containers_15l + 10 \* containers_10l + 5 \* containers_5l | NA |
| liters_person | numeric | Liters collected in past 24 hours per household member (total_liters divided by household_size) | NA |

Variables that were calculated in the original Excel workbook
(`jmp_improved`, `jmp_water_service`, `total_collect_time`,
`total_liters`, `liters_person`, `hwise_score` and
`hwise_insecurity_level`) were recalculated in R from the raw survey
responses and verified against the Excel values. The 12 HWISE items are
ordered factors whose levels refer to the number of times in the last
four weeks: Never (0), Rarely (1–2), Sometimes (3–10), Often (11–20) and
Always (more than 20). The HWISE score sums the 12 items scored Never 0,
Rarely 1, Sometimes 2, Often or Always 3. The insecurity levels follow
Frongillo et al. (2024): No-to-marginal (0–2), Low (3–11), Moderate
(12–23) and High (24–36).

## Example

The example compares the JMP drinking water service level of households
between the baseline and the endline survey.

``` r

library(kalaiwash)
library(dplyr)

kalaiwash |> 
  count(survey_type, jmp_water_service) |> 
  group_by(survey_type) |> 
  mutate(share = round(100 * n / sum(n))) |> 
  ungroup() |> 
  knitr::kable(col.names = c("Survey", "JMP service level", "Households", "Share (%)"))
```

| Survey   | JMP service level | Households | Share (%) |
|:---------|:------------------|-----------:|----------:|
| Baseline | Surface water     |         12 |         9 |
| Baseline | Unimproved        |        101 |        77 |
| Baseline | Limited           |         19 |        14 |
| Endline  | Unimproved        |          3 |         2 |
| Endline  | Limited           |         94 |        66 |
| Endline  | Basic             |         46 |        32 |

The share of households with at least basic drinking water service and
the distribution of HWISE insecurity levels can be compared in the same
way.

``` r

kalaiwash |> 
  count(survey_type, hwise_insecurity_level) |> 
  group_by(survey_type) |> 
  mutate(share = round(100 * n / sum(n))) |> 
  ungroup() |> 
  knitr::kable(col.names = c("Survey", "HWISE insecurity level", "Households", "Share (%)"))
```

| Survey   | HWISE insecurity level | Households | Share (%) |
|:---------|:-----------------------|-----------:|----------:|
| Baseline | High                   |         62 |        47 |
| Baseline | Moderate               |         65 |        49 |
| Baseline | Low                    |          5 |         4 |
| Endline  | Moderate               |          4 |         3 |
| Endline  | Low                    |          5 |         3 |
| Endline  | No-to-marginal         |        134 |        94 |

## License

Data are available as
[CC-BY](https://github.com/openwashdata/kalaiwash/blob/main/LICENSE.md).

## Citation

Please cite this package using:

``` r

citation("kalaiwash")
#> To cite package 'kalaiwash' in publications use:
#> 
#>   Brogan J, Clavijo Daza A (2026). "kalaiwash: Household Water
#>   Insecurity and Drinking Water Service Levels from the KALAI Project
#>   in Nampula, Mozambique." <https://github.com/openwashdata/kalaiwash>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Misc{brogan_etall:2026,
#>     title = {kalaiwash: Household Water Insecurity and Drinking Water Service Levels from the KALAI Project in Nampula, Mozambique},
#>     author = {John Brogan and Adriana {Clavijo Daza}},
#>     year = {2026},
#>     url = {https://github.com/openwashdata/kalaiwash},
#>     abstract = {Baseline (November 2024) and endline (June 2025) household survey data from the KALAI water, sanitation and hygiene project of HELVETAS in Larde, Memba, Moma and Mecuburi districts, Nampula Province, Mozambique. The data cover 275 household interviews and include the primary drinking water source classified with the WHO/UNICEF Joint Monitoring Programme (JMP) service ladder, water collection times and volumes, sanitation and handwashing practices, and the 12-item Household Water Insecurity Experiences (HWISE) Scale with its summary score and insecurity level.},
#>     version = {0.0.0.9000},
#>   }
```

## References

Young, S. L., Boateng, G. O., Jamaluddine, Z., et al. (2019). The
Household Water InSecurity Experiences (HWISE) Scale: development and
validation of a household water insecurity measure for low-income and
middle-income countries. *BMJ Global Health*, 4(5), e001750.
<https://doi.org/10.1136/bmjgh-2019-001750>

Frongillo, E. A., Bethancourt, H. J., Miller, J. D., Young, S. L., & the
HWISE Research Coordination Network (2024). Identifying ordinal
categories for the Water Insecurity Experiences Scales. *Journal of
Water, Sanitation and Hygiene for Development*, 14(11), 1066–1078.
<https://doi.org/10.2166/washdev.2024.042>

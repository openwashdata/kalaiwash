# kalaiwash 0.2.0

- Six variables that were part of 0.1.0 are no longer in the dataset, at the request of the data authors: the five container counts (`containers_25l`, `containers_20l`, `containers_15l`, `containers_10l`, `containers_5l`) and `liters_person`. `total_liters` is still derived from the container counts in the processing script. The dataset has 275 rows and 34 variables.
- The package metadata now carries discovery keywords, the place and the period the data cover (four districts of Nampula Province, 13 November 2024 to 26 June 2025), and the citation files describe the package as a dataset (#4).
- The data dictionary lists the answer options of the 12 HWISE items as they appear in the data (Never, Rarely, Sometimes, Often, Always) and gives each variable one type. The data are unchanged (#7).
- The documentation names the source of the data and how they were collected, states the size of the dataset, and gives a usage example on the help page (#10).
- The package check now also runs on the development branch, so changes are checked before they reach the published version (#12).

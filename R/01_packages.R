# 01_packages.R - Install and load required packages (run first).
packages <- c("readr", "readxl", "writexl", "dplyr", "stringr",
              "ggplot2", "corrplot", "car", "lmtest", "sandwich",
              "irr", "boot", "TOSTER")

for (p in packages) {
  if (!require(p, character.only = TRUE, quietly = TRUE)) {
    install.packages(p)
    library(p, character.only = TRUE)
  }
}

# Output folders for generated tables and figures
dir.create("outputs", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)

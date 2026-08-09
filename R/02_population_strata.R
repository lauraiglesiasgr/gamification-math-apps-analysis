# 02_population_strata.R - Build target population and verify strata sizes.
library(readr); library(dplyr)

raw <- read_csv("data/Google-Playstore.csv",
                col_types = cols(.default = "c"))

raw <- raw %>%
  filter(!is.na(`App Name`), !is.na(`App Id`)) %>%
  mutate(`Rating Count`     = as.numeric(`Rating Count`),
         `Maximum Installs` = as.numeric(`Maximum Installs`)) %>%
  filter(`Rating Count` > 0) %>%
  distinct(`App Id`, .keep_all = TRUE) %>%
  filter(!is.na(`Maximum Installs`), `Maximum Installs` > 0) %>%
  filter(Category %in% c("Education", "Educational"))

# Precision-oriented semantic keyword set
K <- c("math", "matem", "subtract", "multiply",
       "division", "geometry", "algebra", "calculus")
pattern <- paste(K, collapse = "|")

population <- raw %>%
  filter(grepl(pattern, tolower(`App Name`))) %>%
  mutate(LogMaxInstalls = log10(`Maximum Installs` + 1))

Q25 <- quantile(population$LogMaxInstalls, 0.25)
Q50 <- quantile(population$LogMaxInstalls, 0.50)
Q75 <- quantile(population$LogMaxInstalls, 0.75)

# Strata labels kept in the original coding (Baja/Media/MediaAlta/Alta)
# so they match the manually coded sample files.
population <- population %>%
  mutate(EstratoPopularidad = case_when(
    LogMaxInstalls < Q25 ~ "Baja",
    LogMaxInstalls < Q50 ~ "Media",
    LogMaxInstalls < Q75 ~ "MediaAlta",
    TRUE                 ~ "Alta"))

sizes <- table(population$EstratoPopularidad)
print(sizes)        # Alta:1055 Baja:1055 Media:1054 MediaAlta:1054
print(sizes / 50)   # Design weights w_h = N_h / n_h  (~21.09 each)
cat("Max variation between weights:",
    round((max(sizes/50) - min(sizes/50)) / mean(sizes/50) * 100, 3), "%\n")

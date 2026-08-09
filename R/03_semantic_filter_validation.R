# 03_semantic_filter_validation.R - Validate keyword set K vs extended K+.
# Requires the `raw` object from 02_population_strata.R.
library(writexl)

K_original <- c("math","matem","subtract","multiply",
                "division","geometry","algebra","calculus")
K_extended <- c("math","matem","subtract","multiply",
                "division","geometry","algebra","calculus",
                "arithmetic","fraction","number","addition",
                "times table","suma","resta","multiplicar",
                "dividir","fraccion","numeros","count")

pattern_original <- paste(K_original, collapse = "|")
pattern_extended <- paste(K_extended, collapse = "|")
name_lower <- tolower(raw$`App Name`)

mask_original <- grepl(pattern_original, name_lower)
mask_extended <- grepl(pattern_extended, name_lower)
mask_new      <- mask_extended & !mask_original

cat("K original ->", sum(mask_original), "apps\n")  # 4218
cat("K extended ->", sum(mask_extended), "apps\n")  # 5799
cat("New apps    :", sum(mask_new), "\n")           # 1581

# Which keywords drive the new (mostly ambiguous) captures
K_new <- c("arithmetic","fraction","number","addition",
           "times table","suma","resta","multiplicar",
           "dividir","fraccion","numeros","count")
for (k in K_new) {
  apps_k <- raw[mask_new, ]
  n <- sum(grepl(k, tolower(apps_k$`App Name`)))
  cat(k, "->", n, "apps\n")
}

new_apps <- raw[mask_new, c("App Name", "Maximum Installs", "Rating")]
write_xlsx(as.data.frame(new_apps), "outputs/apps_K_extended_review.xlsx")

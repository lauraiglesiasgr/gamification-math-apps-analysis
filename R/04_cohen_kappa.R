# 04_cohen_kappa.R - Inter-rater reliability (Cohen's kappa).
# Requires the extra coding files listed in data/README.md.
library(readxl); library(irr); library(writexl)

rater2 <- read_excel("data/codificacion_juez2.xlsx")
vars_kappa <- c("V_Niveles","V_Recompensas","V_Ranking",
                "V_Avatares","V_Feedback")

# Rater 1: your 200 coded apps
kappa_data <- read_excel("data/muestra_200_CODIFICADA.xlsx",
                         sheet = "CODIFICACION")
set.seed(42)
kappa_idx   <- sample(1:nrow(kappa_data), 30, replace = FALSE)
rater1_vals <- kappa_data[kappa_idx, vars_kappa]

kappa_results <- data.frame(
  Variable = vars_kappa, Kappa = NA_real_,
  Po = NA_real_, Interp = NA_character_,
  stringsAsFactors = FALSE)

for (i in seq_along(vars_kappa)) {
  v   <- vars_kappa[i]
  res <- kappa2(data.frame(as.numeric(rater1_vals[[v]]),
                           as.numeric(rater2[[v]])))
  k   <- round(res$value, 3)
  po  <- round(res$agree, 3)
  interp <- ifelse(k < 0.40, "Weak",
             ifelse(k < 0.60, "Moderate",
              ifelse(k < 0.80, "Substantial", "Almost perfect")))
  kappa_results$Kappa[i]  <- k
  kappa_results$Po[i]     <- po
  kappa_results$Interp[i] <- interp
  cat(v, "-> kappa =", k, "(", interp, ")\n")
}
cat("\nGlobal kappa (mean):", round(mean(kappa_results$Kappa), 3), "\n")
write_xlsx(kappa_results, "outputs/kappa_results.xlsx")

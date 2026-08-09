# 07_independence_tests.R - Stratum x mechanic independence tests.
gam_vars <- c("V_Niveles","V_Recompensas","V_Ranking",
              "V_Avatares","V_Feedback")

set.seed(42)
for (v in gam_vars) {
  tbl      <- table(apps$EstratoPopularidad, apps[[v]])
  expected <- chisq.test(tbl)$expected
  if (any(expected < 5)) {
    res <- fisher.test(tbl, simulate.p.value = TRUE, B = 10000)
    cat(v, "-> Fisher exact, p =", round(res$p.value, 4), "\n")
  } else {
    res <- chisq.test(tbl)
    cat(v, "-> chi2 =", round(res$statistic, 3),
        ", p =", round(res$p.value, 4), "\n")
  }
}

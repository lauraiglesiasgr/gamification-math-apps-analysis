# ---------------------------------------------------------------
# 00_run_all.R - Run the full analysis in order.
# Open the project at the repo ROOT before running so that the
# relative paths to data/ , outputs/ and figures/ resolve.
#
# NOTE: scripts 03 and 04 are validation/reliability steps that
# require extra files (see data/README.md). If you don't have
# them, comment those two lines out; the modelling chain 05->13
# does not depend on them.
# ---------------------------------------------------------------
source("R/01_packages.R")
source("R/02_population_strata.R")
source("R/03_semantic_filter_validation.R")
source("R/04_cohen_kappa.R")
source("R/05_load_transform_impute.R")
source("R/06_descriptives.R")
source("R/07_independence_tests.R")
source("R/08_correlation_matrix.R")
source("R/09_model_I_ols_hc3.R")
source("R/10_model_II_igam.R")
source("R/11_diagnostics.R")
source("R/12_robustness_rewards.R")
source("R/13_sensitivity_m0.R")

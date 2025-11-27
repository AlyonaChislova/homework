#!/usr/bin/env Rscript

if (!require("dplyr", quietly = TRUE)) {
  install.packages("dplyr", repos = "https://cloud.r-project.org/")
  library(dplyr)
}

cat("dplyr version: ", as.character(packageVersion("dplyr")), "\n")

experiment_samples <- data.frame(
  sample_id = paste0("Sample_", 1:6),
  cell_type = c("HEK293", "HeLa", "HEK293", "U2OS", "HeLa", "Primary"),
  treatment = c("Control", "Drug_A", "Drug_B", "Control", "Drug_A", "Drug_C"),
  replicate = c(1, 1, 1, 2, 2, 1),
  concentration_uM = c(0, 10, 50, 0, 10, 100)
)

proteomics_measurements <- data.frame(
  sample_id = paste0("Sample_", c(1, 2, 3, 4, 7)),
  total_proteins = c(2450, 2310, 2540, 2480, 2600),
  unique_peptides = c(15200, 14800, 15600, 15400, 16200),
  contamination_level = c(0.02, 0.05, 0.03, 0.01, 0.04)
)

dir.create("analysis_results", showWarnings = FALSE)

write.csv(experiment_samples, "analysis_results/sample_metadata.csv", row.names = FALSE)
write.csv(proteomics_measurements, "analysis_results/mass_spec_results.csv", row.names = FALSE)

sample_info <- read.csv("analysis_results/sample_metadata.csv")
ms_data <- read.csv("analysis_results/mass_spec_results.csv")

samples_without_ms <- dplyr::anti_join(sample_info, ms_data, by = "sample_id")
ms_without_samples <- dplyr::anti_join(ms_data, sample_info, by = "sample_id")
all_discrepancies <- dplyr::bind_rows(samples_without_ms, ms_without_samples)

write.csv(samples_without_ms, "analysis_results/samples_without_ms.csv", row.names = FALSE)
write.csv(ms_without_samples, "analysis_results/ms_without_samples.csv", row.names = FALSE)
write.csv(all_discrepancies, "analysis_results/all_discrepancies.csv", row.names = FALSE)

cat("Analysis results saved to analysis_results/*.csv\n")
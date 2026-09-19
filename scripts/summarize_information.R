# This script generates summary statistics and figures for taxonomic coverage in the Caryophyllales Medullary Bundles Dataset
# Output: summary/taxonomic_coverage.png
# Code developed by Israel L. Cunha-Neto, with assistance from ChatGPT (OpenAI).

# Load packages
library(dplyr)
library(ggplot2)
library(readr)
library(scales)

# Path to CSV
csv_path <- file.path("data", "Dataset.csv")
if (!file.exists(csv_path)) stop(paste("CSV not found at", csv_path))

# Read
taxa <- read_csv(csv_path, show_col_types = FALSE)
names(taxa) <- trimws(names(taxa))

cat("CSV read successfully. Rows:", nrow(taxa), "Columns:", ncol(taxa), "\n")
cat("Columns:", paste(colnames(taxa), collapse = ", "), "\n")

# Summaries 
medullary <- taxa %>%
  filter(Medullary_bundles == "Present")

family_count  <- n_distinct(medullary$Family)
genus_count  <- n_distinct(medullary$Genus)
species_count <- n_distinct(medullary$Species)

cat(
  "Families:", family_count,
  "Genus:", genus_count,
  "Species:", species_count, "\n"
)

summary_df <- tibble(
  level = factor(
    c("Families", "Genera", "Species"),
    levels = c("Species", "Genera", "Families")
  ),
  count = c(family_count, genus_count, species_count)
)

# Plot 
p <- ggplot(summary_df, aes(y = level, x = count)) +
  geom_col(fill = "grey") +
  geom_text(
    aes(label = comma(count)),
    hjust = -0.15,
    size = 5
  ) +
  labs(
    x = NULL,
    y = NULL,
    title = "Taxonomic coverage of medullary bundles"
  ) +
  scale_x_continuous(
    expand = expansion(mult = c(0, 0.10)),
    labels = comma
  ) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank()
  )

# Save 
ggsave("summary/medullary_bundles_taxonomic_coverage.png")
cat("Figure saved successfully!\n")
``

#End of code
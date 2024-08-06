# Install ggplot
install.packages("ggplot2")

# Load necessary libraries
library(dplyr)
library(haven)
library(ggplot2)

# Load data
data1 <- read_dta("C:/Users/alima/Google Drive/TAF UofT IEQ Study/Data/Processed Data/UofT/HUD_QFF_concentration.dta")
data2 <- read_dta("C:/Users/alima/Google Drive/TAF UofT IEQ Study/Data/Processed Data/UofT/shortTerm/summary/tsp_master.dta")
data3 <- read_dta("C:/Users/alima/Google Drive/ASHRAE_1649/data/processed/ldps/d_D_qff_psd_all.dta")

# Process first dataset
data1 <- data1 %>%
  mutate(tsp_conc = (dust_weight / k) * 1000) %>%
  select(tsp_conc, season, site) %>%
  rename(Suite = site) %>%
  mutate(Suite = as.character(Suite), study = "HUD")

# Save intermediate data
write_dta(data1, "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/Social_housing/processed/tsp_interstudy_comp.dta")

# Process second dataset
data2 <- data2 %>%
  filter(!(stage == 1 & season == 1)) %>%
  select(Suite, tsp_conc, stage, smoke) %>%
  mutate(study = ifelse(smoke == 0, "TCH No Smoke", "TCH Smoke")) %>%
  mutate(study = ifelse(smoke == 1, "TCH Smoke", study))

data2 <- data2 %>%
  slice(rep(1:n(), each = 2)) %>%
  mutate(study = ifelse(row_number() > 136, "TCH All", study))

# Append datasets
data_combined <- bind_rows(data2, data1)

# Save combined data
write_dta(data_combined, "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/Social_housing/processed/tsp_interstudy_comp.dta")

# Process third dataset
data3 <- data3 %>%
  select(TSP_conc_ug_m3, round, site) %>%
  rename(tsp_conc = TSP_conc_ug_m3, Suite = site) %>%
  mutate(Suite = as.character(Suite), study = "1649")

# Append combined data
data_combined <- bind_rows(data_combined, data3)

# Save final combined data
write_dta(data_combined, "C:/Life/5- Career & Business Development/Portfolio - Git/Buildings IOT/Social_housing/processed/tsp_interstudy_comp.dta")

# Classify data
data_combined <- data_combined %>%
  mutate(class = case_when(
    study == "TCH No Smoke" ~ 2,
    study == "TCH Smoke" ~ 3,
    study == "HUD" ~ 4,
    study == "1649" ~ 5,
    TRUE ~ 1
  ))

# Create the box plot
ggplot(data_combined, aes(x = factor(class, labels = c("TCH All", "TCH No Smoke", "TCH Smoke", "HUD", "RP-1649")), y = tsp_conc)) +
  geom_boxplot(aes(fill = factor(class)), outlier.shape = NA) +
  scale_fill_manual(values = c("grey80", "grey60", "grey20", "brown4", "brown")) +
  scale_y_log10(labels = scales::comma) +
  labs(y = expression(paste("Concentrations (", mu, "g/", m^3, ")")), x = NULL) +
  theme_minimal() +
  theme(legend.position = "none") +
  annotate("text", x = 1, y = 10, label = "This Study All", size = 3, vjust = -1) +
  annotate("text", x = 2, y = 30, label = "This Study No Smoke", size = 3, vjust = -1) +
  annotate("text", x = 3, y = 50, label = "This Study Smoke", size = 3, vjust = -1) +
  annotate("text", x = 4, y = 70, label = "C. Texas SFD", size = 3, vjust = -1) +
  annotate("text", x = 5, y = 90, label = "Toronto SFD", size = 3, vjust = -1) +
  annotate("text", x = 1, y = 10, label = "n = 136", size = 3, hjust = 0) +
  annotate("text", x = 2, y = 30, label = "n = 89", size = 3, hjust = 0) +
  annotate("text", x = 3, y = 50, label = "n = 47", size = 3, hjust = 0) +
  annotate("text", x = 4, y = 70, label = "n = 99", size = 3, hjust = 0) +
  annotate("text", x = 5, y = 90, label = "n = 79", size = 3, hjust = 0)


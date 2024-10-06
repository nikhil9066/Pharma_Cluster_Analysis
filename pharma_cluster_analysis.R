# Helper function to install missing packages
install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# List of required packages
required_packages <- c("readr", "cluster", "ggplot2", "dplyr", "tidyverse", "GGally", "corrplot", "reshape2", "plotly")

# Install missing packages
lapply(required_packages, install_if_missing)

# Load necessary libraries
library(readr)
library(cluster)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(GGally)
library(corrplot)
library(reshape2)
library(plotly)

# Load the dataset
pharma_data <- read_csv("Pharmaceuticals.csv")

# View the structure of the dataset
str(pharma_data)

# Select quantitative variables (a)-(i)
quant_data <- pharma_data %>%
  select(Market_Cap, Beta, PE_Ratio, ROE, ROA, Asset_Turnover, Leverage, Rev_Growth, Net_Profit_Margin)

# Scale the data to normalize it before clustering
scaled_data <- scale(quant_data)

# View the scaled data
head(scaled_data)

### Pre-processing Visualizations ###
# 1. Histograms for each variable
numerical_vars <- names(quant_data)
for (var in numerical_vars) {
  ggplot(pharma_data, aes_string(x = var)) +
    geom_histogram(bins = 10, fill = "skyblue", color = "black") +
    labs(title = paste("Histogram of", var), x = var, y = "Frequency") +
    theme_minimal() +
    print(ggplot(pharma_data, aes_string(x = var)) +
            geom_histogram(bins = 10, fill = "skyblue", color = "black") +
            labs(title = paste("Histogram of", var), x = var, y = "Frequency") +
            theme_minimal())
}

# 2. Boxplots for outliers detection
for (var in numerical_vars) {
  ggplot(pharma_data, aes_string(x = 1, y = var)) +
    geom_boxplot(fill = "lightgreen", color = "black") +
    labs(title = paste("Boxplot of", var), x = "", y = var) +
    theme_minimal() +
    print(ggplot(pharma_data, aes_string(x = 1, y = var)) +
            geom_boxplot(fill = "lightgreen", color = "black") +
            labs(title = paste("Boxplot of", var), x = "", y = var) +
            theme_minimal())
}

# 3. Pair Plot (Scatter Plot Matrix)
ggpairs(quant_data) +
  theme_minimal() +
  ggtitle("Scatter Plot Matrix of Financial Variables")

# 4. Correlation Matrix Heatmap
correlation_matrix <- cor(quant_data)
corrplot(correlation_matrix, method = "color", type = "upper", tl.col = "black", tl.srt = 45, addCoef.col = "black", title = "Correlation Heatmap")

# 5. Density Plots for each variable
for (var in numerical_vars) {
  ggplot(pharma_data, aes_string(x = var)) +
    geom_density(fill = "lightblue", alpha = 0.7) +
    labs(title = paste("Density Plot of", var), x = var, y = "Density") +
    theme_minimal() +
    print(ggplot(pharma_data, aes_string(x = var)) +
            geom_density(fill = "lightblue", alpha = 0.7) +
            labs(title = paste("Density Plot of", var), x = var, y = "Density") +
            theme_minimal())
}

# 6. Bar Plot for Categorical Variables (Location and Exchange)
ggplot(pharma_data, aes(x = Location)) +
  geom_bar(fill = "lightcoral", color = "black") +
  labs(title = "Firms by Location", x = "Location", y = "Count") +
  theme_minimal()

ggplot(pharma_data, aes(x = Exchange)) +
  geom_bar(fill = "lightblue", color = "black") +
  labs(title = "Firms by Stock Exchange", x = "Exchange", y = "Count") +
  theme_minimal()

### K-Means Clustering ###
# Determine optimal number of clusters using the Elbow method
wss <- (nrow(scaled_data)-1)*sum(apply(scaled_data, 2, var))
for (i in 2:10) {
  wss[i] <- sum(kmeans(scaled_data, centers=i)$tot.withinss)
}

# Plot the Elbow method graph
plot(1:10, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")

# Perform K-means clustering (3 clusters based on the elbow plot)
set.seed(123)  # For reproducibility
kmeans_result <- kmeans(scaled_data, centers = 3)

# Add the cluster membership to the original dataset
pharma_data$cluster <- kmeans_result$cluster

# Check the cluster assignments
table(pharma_data$cluster)
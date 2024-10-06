# Load necessary libraries
library(readr)
library(cluster)
library(ggplot2)
library(dplyr)
library(tidyverse)

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

# K-Means Clustering
# Determine optimal number of clusters using the Elbow method
wss <- (nrow(scaled_data)-1)*sum(apply(scaled_data, 2, var))
for (i in 2:10) wss[i] <- sum(kmeans(scaled_data, centers=i)$tot.withinss)

# Plot the Elbow method graph
plot(1:10, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")

# Perform K-means clustering
set.seed(123)  # For reproducibility
kmeans_result <- kmeans(scaled_data, centers = 3)  # Adjust 'centers' based on elbow plot

# Add the cluster membership to the original dataset
pharma_data$cluster <- kmeans_result$cluster

# Check the cluster assignments
table(pharma_data$cluster)

# Cluster Interpretation
# Calculate means for each cluster
cluster_means <- aggregate(. ~ cluster, data = pharma_data[, c("cluster", "Market_Cap", "Beta", "PE_Ratio", "ROE", "ROA", "Asset_Turnover", "Leverage", "Rev_Growth", "Net_Profit_Margin")], mean, na.rm = TRUE)

# Display cluster means for interpretation
print(cluster_means)

# Visualize the clusters using ggplot2
ggplot(pharma_data, aes(x = Market_Cap, y = Rev_Growth, color = factor(cluster))) +
  geom_point(size = 3) +
  labs(title = "Cluster Plot of Pharmaceutical Firms", x = "Market Capitalization", y = "Revenue Growth", color = "Cluster") +
  theme_minimal()
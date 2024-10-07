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
plot_list <- list()
for (var in numerical_vars) {
  p <- ggplot(pharma_data, aes_string(x = var)) +
    geom_histogram(bins = 10, fill = "skyblue", color = "black") +
    labs(title = paste("Histogram of", var), x = var, y = "Frequency") +
    theme_minimal()
  plot_list[[var]] <- p
}
grid.arrange(grobs = plot_list, ncol = 3)

# 2. Boxplots for outliers detection
boxplot_list <- list()
for (var in numerical_vars) {
  p <- ggplot(pharma_data, aes_string(x = "1", y = var)) +  # x = "1" to create a single box for each variable
    geom_boxplot(fill = "lightgreen", color = "black") +
    labs(title = paste("Boxplot of", var), x = "", y = var) +
    theme_minimal()
  
  boxplot_list[[var]] <- p
}
grid.arrange(grobs = boxplot_list, ncol = 3)

# 3. Pair Plot (Scatter Plot Matrix)
ggpairs(quant_data) +
  theme_minimal() +
  ggtitle("Scatter Plot Matrix of Financial Variables")

# 4. Correlation Matrix Heatmap
correlation_matrix <- cor(quant_data)
corrplot(correlation_matrix, method = "color", type = "upper", tl.col = "black", tl.srt = 45, addCoef.col = "black", title = "Correlation Heatmap")

# 5. Density Plots for each variable
for (var in numerical_vars) {
  Densp <- ggplot(pharma_data, aes_string(x = var)) +
    geom_density(fill = "lightblue", alpha = 0.7) +
    labs(title = paste("Density Plot of", var), x = var, y = "Density") +
    theme_minimal()
    print(Densp)
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
scaled_data <- as.matrix(scaled_data)

wss <- numeric(10)
for (i in 1:10) {
  kmeans_result <- kmeans(scaled_data, centers=i)
  wss[i] <- kmeans_result$tot.withinss
}
plot(1:10, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares",
     main="Elbow Method for Optimal Clusters")

# Perform K-means clustering (3 clusters based on the elbow plot)
set.seed(123)  # For reproducibility
kmeans_result <- kmeans(scaled_data, centers = 3)

# Add the cluster membership to the original dataset
pharma_data$cluster <- kmeans_result$cluster

# Check the cluster assignments
table(pharma_data$cluster)

# Silhouette Analysis for Validation
silhouette_score <- silhouette(kmeans_result$cluster, dist(scaled_data))
plot(silhouette_score, main = "Silhouette Plot for K-means Clustering")

### Post-Clustering Analysis ###

# 1. Cluster Size Information
cluster_sizes <- table(kmeans_result$cluster)
print(cluster_sizes)

# 2. Intra-cluster variance (withinss) for each cluster
cluster_variances <- kmeans_result$withinss
print(cluster_variances)

# 3. PCA for Dimensionality Reduction and Visualization
pca_result <- prcomp(scaled_data)
pca_data <- data.frame(pca_result$x[, 1:2], cluster = factor(kmeans_result$cluster))
ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 3) +
  labs(title = "PCA Plot of Pharmaceutical Firms", x = "Principal Component 1", y = "Principal Component 2") +
  theme_minimal()

# 4. Cluster Profiles with Boxplots
pharma_long <- melt(pharma_data[, c("cluster", numerical_vars)], id.vars = "cluster")
ggplot(pharma_long, aes(x = factor(cluster), y = value, fill = factor(cluster))) + 
  geom_boxplot() + 
  facet_wrap(~ variable, scales = "free_y") + 
  labs(title = "Boxplots of Numerical Variables by Cluster", x = "Cluster", y = "Value") + 
  theme_minimal() +
  theme(legend.position = "none")

# 5. Cluster Centers Visualization
cluster_means <- aggregate(. ~ cluster, data = pharma_data[, c("cluster", "Market_Cap", "Beta", "PE_Ratio", "ROE", "ROA", "Asset_Turnover", "Leverage", "Rev_Growth", "Net_Profit_Margin")], mean)
cluster_means_melt <- melt(cluster_means, id.vars = "cluster")
ggplot(cluster_means_melt, aes(x = variable, y = value, fill = factor(cluster))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Cluster Centers by Variable", x = "Variable", y = "Mean Value", fill = "Cluster") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 6. Feature Importance (Variance explained by each variable in clustering)
var_explained <- apply(kmeans_result$centers, 2, function(x) var(x))
var_explained_sorted <- sort(var_explained, decreasing = TRUE)
print(var_explained_sorted)

# 7. Alternative Clustering - Hierarchical Clustering
dist_matrix <- dist(scaled_data)
hclust_result <- hclust(dist_matrix, method = "ward.D2")
plot(hclust_result, labels = pharma_data$Name, main = "Dendrogram for Hierarchical Clustering")
pharma_data$hcluster <- cutree(hclust_result, k = 3)
table(pharma_data$cluster, pharma_data$hcluster)


### Interactive Visualizations using plotly ###
# Convert ggplot into interactive plot
pca_plot <- ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 3) +
  labs(title = "PCA Plot of Pharmaceutical Firms", x = "PC1", y = "PC2") +
  theme_minimal()
ggplotly(pca_plot)

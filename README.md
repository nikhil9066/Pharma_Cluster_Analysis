# Pharma_Cluster_Analysis
This project explores the financial structure of pharmaceutical firms through cluster analysis. The goal is to group 21 companies in the pharmaceutical industry based on key financial metrics and uncover patterns that reveal their financial health, profitability, risk profile, and growth prospects.

## Table of Contents
- [Data Overview](#data-overview)
- [Installation](#installation)
- [Usage](#usage)
- [Running the Code](#running-the-code)
- [Requirements](#requirements)
- [Conclusion](#conclusion)

## Data Overview

The analysis uses a dataset named `Pharmaceuticals.csv`, which includes the following quantitative financial variables for various pharmaceutical firms:
- **Market Cap**: Market capitalization of the firm.
- **Beta**: Measure of the firm's volatility relative to the market.
- **PE Ratio**: Price-to-earnings ratio indicating the firm's valuation.
- **ROE**: Return on equity, measuring profitability against shareholders' equity.
- **ROA**: Return on assets, showing how efficiently assets generate profit.
- **Asset Turnover**: Efficiency of asset utilization in generating revenue.
- **Leverage**: Financial leverage ratio indicating the degree of debt used.
- **Rev Growth**: Revenue growth rate of the firm.
- **Net Profit Margin**: Profitability metric after expenses.

## Installation

Ensure you have R and RStudio installed on your computer. Clone this repository and set up the required R packages:

```bash
git clone https://github.com/yourusername/pharmaceutical-cluster-analysis.git
cd pharmaceutical-cluster-analysis
```

## Usage

1. Ensure the `Pharmaceuticals.csv` dataset is in the working directory. This file contains the necessary financial metrics for the pharmaceutical firms included in the analysis.
2. Open R or RStudio and load the `cluster_analysis.R` script.
3. Execute the entire script by running it in your R environment. This will perform data preprocessing, generate visualizations, conduct clustering, and display the results.
4. Monitor the console output for information on cluster assignments, sizes, and additional analyses.
5. Visual outputs, such as plots and graphs, will appear in the R plotting window, allowing you to visually assess the clusters and underlying data distributions.

## Running the Code

To run the analysis, follow these steps:
1. Open the `cluster_analysis.R` file in RStudio.
2. Click on the "Source" button to run the entire script, or run each section individually to see step-by-step results.
3. Review the results, including cluster assignments, visualizations, and performance metrics displayed in the R console and plotting window.

## Features

1. **Data Preprocessing:**
   - Loading necessary libraries and installing any missing packages.
   - Reading and examining the dataset structure.
   - Selecting quantitative variables and scaling the data.

2. **Visualizations:**
   - Histograms, boxplots, and density plots for numerical variables.
   - Correlation heatmap and scatter plot matrix (pair plot).
   - Bar plots for categorical variables (Location and Exchange).

3. **Clustering:**
   - Determining the optimal number of clusters using the Elbow method.
   - Implementing K-means clustering.
   - Silhouette analysis for validation of clustering results.

4. **Post-Clustering Analysis:**
   - Cluster size information and intra-cluster variance.
   - Principal Component Analysis (PCA) for dimensionality reduction and visualization.
   - Boxplots and bar plots for cluster profiles.

5. **Interactive Visualizations:**
   - Converting ggplot visualizations into interactive plots using Plotly.

## Requirements

To run the code, ensure you have R and RStudio installed along with the following packages:

- `readr`
- `cluster`
- `ggplot2`
- `dplyr`
- `tidyverse`
- `GGally`
- `corrplot`
- `reshape2`
- `plotly`
- `gridExtra`

## Conclusion

The analysis provides valuable insights into the financial performance and clustering of pharmaceutical firms based on various metrics. By utilizing K-means clustering and evaluating the results through visualizations and statistical measures, we can categorize firms into distinct groups. 
This clustering approach not only highlights the differences in performance among firms but also aids in strategic decision-making for stakeholders within the pharmaceutical industry. The findings serve as a foundation for further research and can inform investment strategies and market positioning.
Feel free to submit issues, fork the project, and send pull requests if you wish to contribute. All contributions are welcome!
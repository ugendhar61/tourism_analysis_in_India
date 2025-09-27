💡 Project Goal
The primary goal of this project is to analyze and visualize the impact of recent years (2019-2021) on tourism in India, focusing on key monuments.

Key Objectives:
1) Calculate Growth Rate: Determine the average percentage growth for Domestic and Foreign visitors.

2) Visualize Visitor Trends: Create heatmaps and line plots to compare domestic and foreign visitor numbers across the top 20 monuments.

3) Geospatial Analysis: Map the locations of various monuments using interactive maps.

4) Forecasting: Predict future foreign visitor arrivals based on historical data.

📊 Analysis & Visualizations
The R script generates several insightful visualizations, revealing significant trends in Indian tourism.

1. Average Visitor Growth Percentages
This bar chart highlights the drastic difference in average growth rates between Domestic and Foreign visitor arrivals across the period, calculated from the dataset.

2. Visitors Heatmap for Top 20 Monuments
A heatmap visualizing the absolute number of Domestic and Foreign visitors for the top 20 monuments across the two periods (2019-20 and 2020-21).

3. Monument Visitors Growth Over the Years
A line graph showing the detailed visitor counts for all four categories (Domestic/Foreign, 2019-20/2020-21) across the top monuments.

4. Foreign Tourist Growth Prediction
A line plot showing historical Foreign Tourist Arrivals (2019-20 and 2020-21) and a simple linear model prediction for the next two periods.

5. Monument Locations Map
An interactive leaflet map showing the geographical distribution of the monuments included in the analysis. (The full interactive map is viewable upon running the script in R.)

🛠️ Installation & Setup
Prerequisites
To run this analysis, you must have R installed.

Dependencies
This project requires the following R packages. They will be installed automatically when you run the script's library() commands.

R

# Required Libraries
install.packages(c("ggplot2", "reshape2", "tidyr", "leaflet", "forecast"))
Data Files (Required)
The script uses two data files which you must provide and select when prompted by file.choose():

tourism dataset analysis.R (The main data file, containing visitor numbers.)

latlong.csv (A separate file containing the Latitude and Longitude for monuments for the map visualization.)

🚀 Usage
Follow these steps to run the analysis and generate the visualizations:

Open the R Script: Open the tourism dataset analysis.R file in RStudio or your preferred R environment.

Execute the Code: Run the entire script.

Select Data Files: When the script hits data2 <- read.csv(file.choose(), ...) and latlong <- read.csv(file.choose(), ...):

First Prompt: Select your main tourism data CSV file.

Second Prompt: Select your monument latitude/longitude CSV file.

View Output:

The plots will be displayed in the RStudio Plots pane.

The Leaflet map will open in the RStudio Viewer pane (or your default browser).

The Average Growth percentages will be printed to the Console.

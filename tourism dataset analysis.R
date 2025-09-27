# -----------------------------
# India Tourism Growth Analysis
# -----------------------------
#org
# Set working directory
getwd()

# Load required libraries
library(ggplot2)
library(reshape2)
library(tidyr)
library(leaflet)
library(forecast)

# -----------------------------
# Load data - india tour growth dataset
# -----------------------------
data2 <- read.csv(file.choose(), stringsAsFactors = FALSE)

# Inspect data
head(data2)
summary(data2)
str(data2)

# -----------------------------
# Data Cleaning
# -----------------------------
data2 <- na.omit(data2)

# -----------------------------
# Calculate Growth
# -----------------------------
data2$GrowthDomestic <- ((data2$Domestic.2020.21 - data2$Domestic.2019.20) / data2$Domestic.2019.20) * 100
data2$GrowthForeign <- ((data2$Foreign.2020.21 - data2$Foreign.2019.20) / data2$Foreign.2019.20) * 100

# -----------------------------
# Average Growth
# -----------------------------
average_growth_domestic <- mean(data2$GrowthDomestic, na.rm = TRUE)
average_growth_foreign <- mean(data2$GrowthForeign, na.rm = TRUE)

cat("Average Domestic Growth:", round(average_growth_domestic,2), "%\n")
cat("Average Foreign Growth:", round(average_growth_foreign,2), "%\n")

# -----------------------------
# Bar Plot: Average Growth
# -----------------------------
avg_growth_data <- data.frame(
  Category = c("Domestic", "Foreign"),
  AverageGrowth = c(average_growth_domestic, average_growth_foreign)
)

ggplot(avg_growth_data, aes(x = Category, y = AverageGrowth, fill = Category)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = round(AverageGrowth, 2)), vjust = -0.5) +
  labs(title = "Average Visitor Growth Percentages",
       x = "Visitor Type",
       y = "Average Growth (%)") +
  theme_minimal() +
  scale_fill_manual(values = c("Domestic" = "steelblue", "Foreign" = "orange"))

# -----------------------------
# Heatmap: Visitor Data for Top 20 Monuments
# -----------------------------
data_20 <- data2[1:20, ]
data_subset <- data_20[, c("Name.of.the.Monument", "Domestic.2019.20", "Foreign.2019.20",
                           "Domestic.2020.21", "Foreign.2020.21")]
colnames(data_subset) <- c("Monument", "Domestic.2019.20", "Foreign.2019.20", "Domestic.2020.21", "Foreign.2020.21")

melted_data <- melt(data_subset, id.vars = "Monument")

ggplot(melted_data, aes(x = variable, y = Monument, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "darkblue") +
  labs(title = "Visitors Heatmap for Top 20 Monuments", x = "Year", y = "Monument", fill = "Number of Visitors") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# -----------------------------
# Line Graph: Visitor Trend
# -----------------------------
data_long <- data_20 %>%
  pivot_longer(cols = c(Domestic.2019.20, Foreign.2019.20, Domestic.2020.21, Foreign.2020.21),
               names_to = "VisitorType",
               values_to = "Visitors")

ggplot(data_long, aes(x = Name.of.the.Monument, y = Visitors, color = VisitorType, group = VisitorType)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Monument Visitors Growth Over the Years",
       x = "Monument",
       y = "Number of Visitors") +
  scale_color_manual(values = c("Domestic.2019.20" = "blue",
                                "Foreign.2019.20" = "red",
                                "Domestic.2020.21" = "green",
                                "Foreign.2020.21" = "purple"))

# -----------------------------
# Leaflet Map: Monument Locations
# Load - lonandlat2
# -----------------------------
latlong <- read.csv(file.choose(), stringsAsFactors = FALSE, fileEncoding = "latin1")

# Clean Latitude/Longitude
latlong$Latitude  <- as.numeric(trimws(gsub("[^0-9+\\-\\.]", "", latlong$Latitude)))
latlong$Longitude <- gsub("[^0-9.-]", "", latlong$Longitude)
latlong$Longitude <- as.numeric(trimws(latlong$Longitude))

# Remove rows where Latitude or Longitude is still NA
latlong <- latlong[is.finite(latlong$Latitude) & is.finite(latlong$Longitude), ]

# Create map
leaflet(latlong) %>%
  addTiles() %>%
  addMarkers(lng = ~Longitude, lat = ~Latitude,
             popup = ~paste("City:", City, "<br>Monument:", `Name.of.the.Monument`))

# -----------------------------
# Forecast: Foreign Tourist Growth
# -----------------------------
data_for_pred <- data.frame(
  Monument = data_20$Name.of.the.Monument,
  Foreign_2019_20 = data_20$Foreign.2019.20,
  Foreign_2020_21 = data_20$Foreign.2020.21
)

# Add an index column for linear modeling
data_for_pred$Index <- seq_len(nrow(data_for_pred))  # 1, 2, 3, ..., n

# Fit linear model using the index
foreign_model <- lm(Foreign_2019_20 ~ Index, data = data_for_pred)

# Predict for next 2 periods (next 2 indices)
future_time <- data.frame(Index = (nrow(data_for_pred) + 1):(nrow(data_for_pred) + 2))

# Make prediction
predicted_growth <- predict(foreign_model, newdata = future_time)


# Plot historical + predicted
plot(data_for_pred$Foreign_2019_20, type = "o", col = "blue",
     ylim = c(0, max(predicted_growth, data_for_pred$Foreign_2019_20, data_for_pred$Foreign_2020_21)),
     xlab = "Monument Index", ylab = "Foreign Tourist Arrivals",
     main = "Foreign Tourist Growth Prediction")
lines(data_for_pred$Foreign_2020_21, type = "o", col = "red")
lines((length(data_for_pred$Foreign_2019_20)+1):(length(data_for_pred$Foreign_2019_20)+2),
      predicted_growth, type = "o", col = "green")
legend("topright", legend = c("2019-20", "2020-21", "Predicted Next 2 Years"),
       col = c("blue", "red", "green"), lty = 1, cex = 0.8)


# Calculate the number of monuments to determine the required number of unique colors
num_monuments <- nrow(data_for_pred) 
# Generate a palette with a unique color for each monument
monument_colors <- rainbow(num_monuments) 

# Transposed Plot for All Monuments
data_transposed <- t(data_for_pred[, c("Foreign_2019_20", "Foreign_2020_21")])
matplot(data_transposed, type = "l", xlab = "Year", ylab = "Foreign Tourist Arrivals",
        col = monument_colors, lty = 1, main = "Foreign Tourist Growth per Monument")
# Use the same unique colors for the legend
legend("topright", legend = data_for_pred$Monument, col = monument_colors, lty = 1, cex = 0.8)


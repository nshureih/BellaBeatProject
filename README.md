# Bellabeat Fitness Data Analysis

[![R](https://img.shields.io/badge/Analysis-R-276DC3)](https://www.r-project.org/)

## Project Overview
Analysis of Fitbit user data to identify behavioral trends for Bellabeat's wellness products. Focus areas include activity patterns, sleep quality, and device engagement metrics.

[View Full Analysis Report](https://nshureih.github.io/BellaBeatProject/)  
[LinkedIn Profile](https://www.linkedin.com/in/nadia-shureih-5287b6284/)

## Key Insights
- **Activity Frequency**: 81% of users tracked activity fewer than 3 times per week
- **Sleep Duration**: 58% of users averaged less than 7 hours of sleep nightly
- **Usage Peaks**: Highest engagement occurred between 6-8PM daily

## Technical Approach
```r
# Clean and summarize activity data
activity_summary <- raw_data %>%
  filter(!is.na(steps)) %>%
  group_by(user_type) %>%
  summarize(avg_steps = mean(steps))
```

##Methods:
- Data cleaning with tidyverse
- Time-series decomposition
- Correlation analysis
- Visualization

## Files
```r
Copy
/data          # Source datasets
/analysis      # R scripts and RMarkdown files
/output        # Generated visualizations and reports
```

##Recommendations
-Develop sleep quality scoring metrics
-Implement evening engagement features
-Create consistency incentives

##Contact
For professional inquiries:
nadia.shureih@gmail.com | [LinkedIn](https://www.linkedin.com/in/nadia-shureih-5287b6284/)

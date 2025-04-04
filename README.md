# BellaBeat Fitness Data Analysis

![Fitbit Dashboard](https://img.shields.io/badge/Data_Analysis-FF6B6B?style=for-the-badge) ![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white&style=for-the-badge) ![Tableau](https://img.shields.io/badge/Tableau-E97627?logo=tableau&logoColor=white&style=for-the-badge)

## 📌 Project Overview
Analysis of Fitbit user data to uncover trends in smart device usage for Bellabeat, a high-tech wellness company. This project demonstrates:
- Data cleaning and transformation in R
- Time-series analysis of fitness metrics
- Strategic recommendations for product development

[**View Full Analysis Report**](https://nshureih.github.io/BellaBeatProject/)

## 📊 Key Insights
| Metric | Finding | Business Impact |
|--------|---------|-----------------|
| Daily Activity | 81% of users track activity <3x/week | Opportunity for engagement features |
| Sleep Patterns | 58% get <7hrs sleep | Highlight sleep tracking in marketing |
| Device Usage | Peak usage at 6-8PM | Optimal time for notifications |

## 🛠️ Technical Approach
```r
# Sample code from analysis
daily_activity %>% 
  group_by(weekday) %>% 
  summarize(avg_steps = mean(steps)) %>% 
  ggplot(aes(x = weekday, y = avg_steps)) +
  geom_col(fill = "#4E79A7")
Methods Used:

Data cleaning with dplyr

Time-series decomposition

Correlation analysis

Tableau dashboard development

Files
/data/processed: Cleaned datasets (CSV)

/analysis: R Markdown files

/output: Visualizations and final report

Business Recommendations
Develop sleep-focused reminders

Create evening workout challenges

Implement "streak" gamification for consistency

How to Run
Clone repository

Open bellabeat_analysis.Rmd in RStudio

Install required packages:

r
Copy
install.packages(c("tidyverse", "lubridate", "ggplot2"))
Knit to HTML/PDF

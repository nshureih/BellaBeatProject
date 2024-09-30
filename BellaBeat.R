#importing libraries
library("here")
library("skimr")
library("janitor")
library ("dplyr")
library("tidyverse")
library("ggplot2")
library("kableExtra")

#taking a look at the data
head(sleep)
head(weight)
head(daily_activity)

#looking for duplicates
sum(duplicated(daily_activity))
sum(duplicated(sleep))
sum(duplicated(weight))

#deleting duplicates
daily_activity <- daily_activity %>%
  distinct() %>%
  drop_na()

sleep <- sleep %>%
  distinct() %>%
  drop_na()

#verifying duplicates have been removed
sum(duplicated(sleep))

#making date formatting cohesive
daily_activity <- daily_activity %>% 
  rename(Date = ActivityDate) %>% 
  mutate(Date = as.Date(Date, format = "%m/%d/%y"))

sleep <- sleep %>% 
  rename(Date = SleepDay) %>% 
  mutate(Date = as.Date(Date, format = "%m/%d/%y"))

weight <- weight %>% 
  select(-LogId) %>% 
  mutate(Date=as.Date(Date, format = "%m/%d/%y")) %>% 
  mutate(IsManualReport = as.factor(IsManualReport))

#cleaning names for columns
clean_names(daily_activity)
clean_names(sleep)
clean_names(weight)

#consistency of cases in column names
daily_activity <- rename_with(daily_activity, tolower)
sleep <- rename_with(sleep, tolower)
weight <- rename_with(weight, tolower)

#how many participants in each data set?
n_distinct(daily_activity$id)
n_distinct(sleep$id)
n_distinct(weight$id)

#there are 35 participants in the activity data, 24 in the sleep data, and 8 in weight data

#getting a summary of the datasets
daily_activity %>% 
  select(totalsteps, veryactiveminutes, veryactivedistance, calories) %>% 
  summary()

daily_activity %>% 
  select(sedentaryminutes, sedentaryactivedistance, fairlyactiveminutes, moderatelyactivedistance, lightlyactiveminutes, lightactivedistance) %>% 
  summary()

#average steps is 6547 (compare with the recommended 10,000 steps per day)
#average calories burned is 2189

#average amount of very active minutes is about 16.5, and very active distance is about 1.18m. 
#average amount of sedentary minutes is about 995.3
#average amount of fairly active minutes is about 13.07, and moderately active distance is about 0.48m. 
#average amount of lightly active minutes is about 170.1, and very active distance is about 2.89m. 

#people spend the most amount of time sedentary, and are able to complete more light activity next. 
#people who complete light active are able to go longer distances
#for people who are active, they will probably spend more time in 'very active' than 'fairly active' meaning maybe they are working harder in those workouts

sleep %>% 
  select(totalsleeprecords, totalminutesasleep, totaltimeinbed) %>% 
  summary()

#average time asleep is 419.2 minutes or about 6.9 hours
#averaged time in bed is 458.5 minutes

weight %>% 
  select(weightpounds, fat, bmi) %>% 
  summary()

#average weight is about 158.8lbs, average bmi is 25.19 (overweight) which makes sense as someone most likely to be tracking their weight would be someone who is overweight.

#i think some of the biggest questions to ask is how to keep people motivated towards their fitness goals
#reducing sedentary time by reminding people to get up and move and participate in light activity could be one way

#merging data 
merged_data <- merge(merge(daily_activity, sleep, by= c('id','date'), all= TRUE), weight, by = c('id', 'date'), all= TRUE)

merged_activity_sleep <- merge(daily_activity, sleep, by=c('id','date'))

#removing extra variables
merged_data <- merged_data %>% 
  select(-c(trackerdistance, totalsleeprecords, weightkg, ismanualreport))

merged_activity_sleep <- merged_activity_sleep %>% 
  select(-c(trackerdistance, totalsleeprecords))

#this dataset shows the averages of the users steps, calories, and sleep
daily_average <- merged_activity_sleep %>% 
  group_by(id) %>% 
  summarise(average_daily_steps = mean(totalsteps), average_daily_calories = mean(calories), average_daily_sleep = mean(totalminutesasleep))

average_steps <- daily_activity %>% 
  group_by(id)

#creating plots
ggplot(data=merged_data, aes(x=totalsteps, y=calories)) + geom_point() + geom_smooth()

#total steps during the week
merged_data %>% 
  mutate(weekdays = weekdays(date)) %>% 
  select(weekdays, totalsteps) %>% 
  mutate(weekdays = factor(weekdays, levels = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'))) %>% 
  drop_na() %>% 
  ggplot(aes(weekdays, totalsteps, fill = weekdays)) +
  geom_boxplot()

#calories burned during the week
merged_data %>% 
  mutate(weekdays = weekdays(date)) %>% 
  select(weekdays, calories) %>% 
  mutate(weekdays = factor(weekdays, levels = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'))) %>% 
  drop_na() %>% 
  ggplot(aes(weekdays, calories, fill = weekdays)) +
  geom_boxplot()

#this plot shows that less sedentary minutes means that a person will sleep more
ggplot(data=merged_activity_sleep, aes(x=totalminutesasleep, y=sedentaryminutes)) + geom_point() + geom_smooth()

#this graph shows all of the types of activity levels, and shows that reducing sedentary minutes makes the most difference in amount of sleep
merged_activity_sleep %>% 
  filter(veryactiveminutes != 0, fairlyactiveminutes != 0, lightlyactiveminutes != 0) %>%
  ggplot(aes(x=totalminutesasleep)) +
  geom_point(aes(y=veryactiveminutes), color="blue") +
  geom_point(aes(y=fairlyactiveminutes), color="red") +
  geom_point(aes(y=lightlyactiveminutes), color="green") +
  geom_point(aes(y=sedentaryminutes), color="purple") +
  geom_smooth(aes(y=veryactiveminutes), color="blue") +
  geom_smooth(aes(y=fairlyactiveminutes), color="red") +
  geom_smooth(aes(y=lightlyactiveminutes), color="green") +
  geom_smooth(aes(y=sedentaryminutes), color="purple")

#minutes asleep vs calories burned. cant really see a clear correlation here
ggplot(data=merged_activity_sleep, aes(y=calories, x=totalminutesasleep)) +geom_point() +geom_smooth()

#minutes asleep vs. total steps
ggplot(data=merged_activity_sleep, aes(y=totalsteps, x=totalminutesasleep)) +geom_point() +geom_smooth()

#minutes asleep vs total distance
ggplot(data=merged_activity_sleep, aes(y=totaldistance, x=totalminutesasleep)) +geom_point() +geom_smooth()

#this table seperates users by activity type
user_type <- daily_average %>% 
  mutate(user_type = case_when(
    average_daily_steps < 5000 ~ "sedentary",
    average_daily_steps >= 5000 & average_daily_steps < 7499 ~ "lightly active",
    average_daily_steps >= 7500 & average_daily_steps < 9999 ~ "fairly active", 
    average_daily_steps >= 1000 ~ "very active"
  ))

user_type_percent <- user_type %>% 
  group_by(user_type) %>% 
  summarise(total = n()) %>% 
  mutate(totals = sum(total)) %>% 
  group_by(user_type) %>% 
  summarise(total_percent = total/totals) %>% 
  mutate(labels = scales:: percent(total_percent))

user_type_percent$user_type <- factor(user_type_percent$user_type, levels = c("very active", "fairly active","lightly active", "sedentary"))

#pie chart on user type
user_type_percent %>%
  ggplot(aes(x="",y=total_percent, fill=user_type)) +
  geom_bar(stat = "identity", width = 1)+
  coord_polar("y", start=0)+
  theme_minimal()+
  theme(axis.title.x= element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(), 
        panel.grid = element_blank(), 
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        plot.title = element_text(hjust = 0.5, size=14, face = "bold")) +
  scale_fill_manual(values = c("#85e085","#e6e600", "#ffd480", "#ff8080")) +
  geom_text(aes(label = labels),
            position = position_stack(vjust = 0.5))+
  labs(title="User type distribution")

ggplot(user_type, aes(user_type, average_daily_calories, fill=user_type)) +
  geom_boxplot() 

#this table seperates users by sleep. poor sleep is defined as less than 6 hours, average sleep is defined as in between 6 and 7 hours, and good sleep is defined as over 7 hours
sleep_type <- daily_average %>% 
  mutate(sleep_type = case_when(
    average_daily_sleep < 360 ~ "poor",
    average_daily_sleep >= 360 & average_daily_sleep < 420 ~ "average",
    average_daily_sleep > 420 ~ "good"
  ))

sleep_type_percent <- sleep_type %>% 
  group_by(sleep_type) %>% 
  summarise(total = n()) %>% 
  mutate(totals = sum(total)) %>% 
  group_by(sleep_type) %>% 
  summarise(total_percent = total/totals) %>% 
  mutate(labels = scales:: percent(total_percent))

sleep_type_percent$sleep_type <- factor(sleep_type_percent$sleep_type, levels = c("poor", "average","good"))

sleep_user_type <- merge(sleep_type, user_type, by = "id") %>% 
  select(-c("average_daily_steps.y", "average_daily_calories.y", "average_daily_sleep.y"))

#this bar graph shows that fairly active users make up a majority of good sleepers. 
ggplot(sleep_user_type, aes(user_type, fill=sleep_type)) +
  geom_bar()

#pie chart on sleep type
sleep_type_percent %>%
  ggplot(aes(x="",y=total_percent, fill=sleep_type)) +
  geom_bar(stat = "identity", width = 1)+
  coord_polar("y", start=0)+
  theme_minimal()+
  theme(axis.title.x= element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(), 
        panel.grid = element_blank(), 
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        plot.title = element_text(hjust = 0.5, size=14, face = "bold")) +
  scale_fill_manual(values = c("red","green", "pink")) +
  geom_text(aes(label = labels),
            position = position_stack(vjust = 0.5))+
  labs(title="Sleep type distribution")

ggplot(sleep_type, aes(sleep_type, average_daily_steps, fill=sleep_type)) +
  geom_boxplot() 


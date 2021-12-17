library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
getwd() #displays your working directory
setwd("C:/Users/Administrator/Desktop/CASE STUDY 1/csv_data") #sets your working directory to simplify calls to data ... make sure to use your OWN username instead of mine ;)


#import data

jan <- read.csv("jan_21.csv")
feb <- read.csv("feb_21.csv")
mar <- read.csv("mar_21.csv")
apr <- read.csv("apr_21.csv")
may <- read.csv("may_21.csv")
jun <- read.csv("jun_21.csv")
jul <- read.csv("jul_21.csv")
aug <- read.csv("aug_21.csv")
sep <- read.csv("sep_21.csv")
oct <- read.csv("oct_21.csv")

colnames(feb)
# maintain column consistency before merging

jan <- rename(jan,
               trip_id = ride_id
               ,bike_id = rideable_type
               ,start_time = started_at
               ,end_time = ended_at
               ,user_type = member_casual)

feb <- rename(feb,
               trip_id = ride_id
               ,bike_id = rideable_type
               ,start_time = started_at
               ,end_time = ended_at
               ,user_type = member_casual)

(mar <- rename(mar,
               trip_id = ride_id
               ,bike_id = rideable_type
               ,start_time = started_at
               ,end_time = ended_at
               ,user_type = member_casual))

(apr <- rename(apr,
               trip_id = ride_id
               ,bike_id = rideable_type
               ,start_time = started_at
               ,end_time = ended_at
               ,user_type = member_casual))

(may <- rename(may,
               trip_id = ride_id
               ,bike_id = rideable_type
               ,start_time = started_at
               ,end_time = ended_at
               ,user_type = member_casual))

(jun <- rename(jun,
               trip_id = ride_id
               ,bike_id = rideable_type
               ,start_time = started_at
               ,end_time = ended_at
               ,user_type = member_casual))

(jul <- rename(jul,
               trip_id = ride_id
               ,bike_id = rideable_type
               ,start_time = started_at
               ,end_time = ended_at
               ,user_type = member_casual))

(aug <- rename(aug,
               trip_id = ride_id
               ,bike_id = rideable_type
               ,start_time = started_at
               ,end_time = ended_at
               ,user_type = member_casual))

(sep <- rename(sep,
               trip_id = ride_id
               ,bike_id = rideable_type
               ,start_time = started_at
               ,end_time = ended_at
               ,user_type = member_casual))

(oct <- rename(oct,
               trip_id = ride_id
               ,bike_id = rideable_type
               ,start_time = started_at
               ,end_time = ended_at
               ,user_type = member_casual))

#store trip_id and bike_id as character data type

jan <-  mutate(jan, trip_id = as.character(trip_id)
               ,bike_id = as.character(bike_id)) 

feb <-  mutate(feb, trip_id = as.character(trip_id)
               ,bike_id = as.character(bike_id)) 

mar <-  mutate(mar, trip_id = as.character(trip_id)
               ,bike_id = as.character(bike_id)) 

apr <-  mutate(apr, trip_id = as.character(trip_id)
               ,bike_id = as.character(bike_id)) 

may <-  mutate(may, trip_id = as.character(trip_id)
               ,bike_id = as.character(bike_id)) 

jun <-  mutate(jun, trip_id = as.character(trip_id)
               ,bike_id = as.character(bike_id)) 

jul <-  mutate(jul, trip_id = as.character(trip_id)
               ,bike_id = as.character(bike_id)) 

aug <-  mutate(aug, trip_id = as.character(trip_id)
               ,bike_id = as.character(bike_id)) 

sep <-  mutate(sep, trip_id = as.character(trip_id)
               ,bike_id = as.character(bike_id)) 

oct <-  mutate(oct, trip_id = as.character(trip_id)
               ,bike_id = as.character(bike_id)) 

#merge all tables into a singular dataset

trips_df <- bind_rows(jan,feb,mar,apr,jun,may,jul,aug,sep,oct)
trips_df <- trips_df %>% 
  select(-c(start_lat, start_lng, end_lat, end_lng))


no_of_users <- trips_df %>% 
  count(user_type)      #counting number of distinct user types and checking if there are any null or irregular values
View(no_of_users)


#View(trips_df)
#str(trips_df)
#summary(trips_df)


#make a backup or v2 data frame

v2_trips_df<- as.data.frame(trips_df)
View(v2_trips_df)
str(v2_trips_df)
summary(v2_trips_df)

str(trips_df)
summary(trips_df)


##THIS RIGHT HERE IS HOLY GRAIL (CONVERSION INTO DATE_TIME FROM CHR)
trips_df$day_of_week <- format(as.Date(trips_df$day_of_week, origin=lubridate::origin),"%A")

trips_df$start_time<- as_datetime(trips_df$start_time, format=("%m/%d/%Y %H:%M"))
trips_df$end_time<- as_datetime(trips_df$end_time,tz="NULL", format("%m/%d/%Y %H:%M"))

trips_df$ride_length<- difftime(trips_df$end_time,trips_df$start_time, units = "mins")



###ANALYSIS PROCESS###

#comparing user types w.r.t ride_length
aggregate(trips_df$ride_length ~ trips_df$user_type, FUN = mean)
aggregate(trips_df$ride_length ~ trips_df$user_type, FUN = median)
aggregate(trips_df$ride_length ~ trips_df$user_type, FUN = max)
aggregate(trips_df$ride_length ~ trips_df$user_type, FUN = min)

#average ride_length vs day of the week for each user type
aggregate(trips_df$ride_length ~ trips_df$user_type + trips_df$day_of_week, FUN = mean)

#to order days of week properly
trips_df$day_of_week<-ordered(trips_df$day_of_week,levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

###grouping by hourly, weekly and monthly factors

weekday_group<- as.data.frame(
trips_df %>% 
  mutate(weekday=wday(start_time, label=TRUE)) %>% 
  group_by(user_type,weekday) %>% 
  summarise(number_of_rides=n(),
            avg_duration=mean(ride_length)) %>% 
  arrange(user_type, weekday)
)
View(weekday_group)


monthly_group<- as.data.frame(
trips_df %>% 
  mutate(mths=month(start_time, label=TRUE)) %>% 
  group_by(user_type,mths,bike_id) %>% 
  summarise(number_of_rides=n(),
            avg_duration=mean(ride_length)) %>% 
  arrange(user_type, mths,bike_id)
)
View(monthly_group)


hourly_group<- as.data.frame(
trips_df %>% 
  mutate(hrs=hour(start_time)) %>% 
  group_by(user_type,hrs) %>% 
  summarise(number_of_rides=n(),
            avg_duration=mean(ride_length)) %>% 
  arrange(user_type, hrs))
View(hourly_group)

ride_length_count<-trips_df %>% 
  count(ride_length,sort = TRUE)

View(ride_length_count)


#VISUALIZATION
hrs_viz<-  ggplot(data=hourly_group)+geom_line(mapping = aes(x=hrs,y=number_of_rides, color=user_type, size=1)) +
  scale_x_continuous(breaks = seq(from = 0, to = 24, by = 2))



week_viz<-ggplot(data=weekday_group)+geom_point(mapping = aes(x=weekday,y=number_of_rides, color=user_type,size=1))



bike_pref_viz<-ggplot(monthly_group)+geom_col(mapping = aes(x=bike_id, y=number_of_rides,fill=user_type))+facet_wrap(~user_type)



hrs_viz+
  labs(title="active hours of cyclistic users", subtitle ="the graphic explains at what hour of the day are the cyclistic users most active", caption = "Data Based on 'Sophisticated, Clear, and Polished': Divvy and Data Visualization written by Kevin Hartman" )+
  annotate("text", x=8,y=250000, label="Peak Hours are usually around 5pm for both user types", color="black",fontface="italic", size=3.5)

week_viz+
   labs(title="active weekdays of cyclistic users", subtitle ="the graphic explains which days of the week are busiest for cyclistic users ", caption = "Data Based on 'Sophisticated, Clear, and Polished': Divvy and Data Visualization written by Kevin Hartman" )+
    annotate("text", x="Wed",y=530000, label="Casuals prefer weekends, and members' preference is consistent over the week", color="black", fontface="italic", size=3.5)

bike_pref_viz+
  labs(title="what type of rental bikes do users prefer?", caption = "Data Based on 'Sophisticated, Clear, and Polished': Divvy and Data Visualization written by Kevin Hartman" )+
  annotate("text", x="docked_bike",y=1955000, label="Both casuals and members 
           prefer classic bikes over docked and electric", color="black", fontface="italic", size=3.5)




#ggplot(monthly_group)+geom_col(mapping=aes(x=mths, y=avg_duration, fill=user_type, size=1)) + facet_wrap(~user_type)

#export these data frames for analysis and visualization in other visualization tools

monthly_group
weekday_group
hourly_group
no_of_users
ride_length_count
trips_df

write.csv(monthly_group,file="monthly_group.csv")
write.csv(weekday_group,file="weekday_group.csv")
write.csv(hourly_group,file="hourly_group.csv")
write.csv(no_of_users,file="no_of_users.csv")
write.csv(ride_length_count,file="ride_length_count.csv")
write.csv(trips_df,file="final_trips_data.csv")




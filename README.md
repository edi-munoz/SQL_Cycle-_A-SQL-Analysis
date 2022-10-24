# SQL Cycle: An analysis of bike-sharing data 
## [Data cleaning and analysis through SQL]
### Introduction 
This repository contains another end-of-course case study from Coursera's "Google Data Analytics Professional Certificate." This time around, I am put into a scenario of working as a junior data analyst in the marketing analyst team at Cyclistic, a Chicago-based bike-sharing company. Lily Moreno, the director of marketing, wants to know how casual riders and annual members differ, as she believes the future of the company lies in increasing annual memberships. Casual riders are those who have purchased single-ride passes or full day passes, whereas member riders have purchased annual passes. 
---
### Ask 
The director of marketing, Lily Moreno has tasked me with the following question:

- How do casual riders and annual riders differ?

Mrs. Moreno and involved stakeholers believe the company's future lies in increasing annual memberships.

---
### Prepare
The dataset I used is from Motivate International Inc. under this [license](https://ride.divvybikes.com/data-license-agreement). This [public dataset](https://divvy-tripdata.s3.amazonaws.com/index.html) has monthly Cyclistic trip data, which contains the following:


- `rider_id`
- `rideable_type`
- `started_at`
- `ended_at`
- `start_station_name`
- `start_station_id`
- `end_station_name`
- `end_station_id`
- `start_lat`
- `start_lng`
- `end_lat`
- `end_lng`
- `member_casual`

---
### Process
To process all of this data at once (and to practice my SQL skills), I opted for MySQL workbench as my processing tool. I first had to download and install MySQL Workbench, then I created a table for each month of the year 2021 with the following SQL query: 

![create_table_query](/images/create_table_query.png)

Afterwards, I created another table `2021_all_trips`, where I then inserted all of my 12 months into this one table via a union query as shown below:

![union_all_query](/images/union_all_query.png)

With all of my data in one table, I began cleaning. I took these [actions](https://github.com/edi-munoz/SQL_Project/blob/0fa07302908a5ccc7064e2bda6563f399147b927/cleaning_steps.sql) to clean my data: 

- Added a `ride_duration` column and made the column be a `TIMEDIFF` from `ended_at` and `started_at` column
- Created the `month`, `day_of_week`, and `day` columns from my `started_at` column
- Deleted negative, zero, and greater than 24 hour ride durations
- Deleted temporary stations
- Deleted station ids with string 
- Addressed stations that had more than 1 station ID
- Filled in station names from station ID's
- Lowered the casing of some stations
- Filled in station ID's from station names
- Added a `ride_distance` column and made the column set to `St_Distance_Sphere` between the start and end coordinates and multipled the result by .000621371192 to get the distance in miles

I then proceeded to create another table to prepare for an analysis on the data in the newly created `2021_trips_analyzed` table. 

I altered the table by dropping 
- `started_at`
- `ended_at`
- `start_station_id`
- `end_station_id` 
- `start_lat`
- `start_lng`
- `end_lat`
- `end_lng`

I also changed columns names: 
- `ride_id` into `rider_id`
- `rideable_type` into `bike_type`
- `member_casual` into `rider_status`

Additionally, I updated `ride_distance` to be rounded by 2 decimal places through the expression ROUND(ride_distance, 2), where I deleted rows that equaled '0' or that were less than '0.00' which amounted to a total of 7% of rows deleted from the total. 

---
### Analyze

There is a total of 5,132,861 riders in this cleaned data set, with 56% being annual members and 44% as casual riders.

![ridertype_percentages](/images/ridertype_percentages.png)

As far as bike types go in this data set, classic bikes take the lead at 59%, then electric bikes coming in at 37%, along with docked bikes being 4% of the total number of riders. 

![biketype_percentages](/images/biketype_percentages.png)

I examined the top 10 most popular stations, but the number 1 spot is a blank value. I decided not to delete these rows associated with the blank station name because, if deleted, 11% of my total data would be lost. 

I do not consider this to be bad data either, as the job tasked to me was to examine how casual riders and annual members differ, and I do believe there are more important aspects of ride length, ride distance, day of week, and monthly trends; having the start station name be blank, in my opinion, does not take precedence over other fields. [I would like to point out that I wish to fill in the names of these stations in the future using the longitutde and latitude values provided, but because of the complexity of exact geological coordinates, I do not have the skills at the moment to resolve this missing data.] 

![top_10_stations](/images/top_10_stations.png)

Next, I explored the most popular stations by rider status: 

![top_10_stations_members](/images/top_10_stations_members.png)

![top_10_stations_casual](/images/top_10_stations_casual.png)

Afterwards, I proceeded to analyze the average distances and durations between casual riders and annual members, but I found an interesting discovery instead: casual riders have a higher average for riding longer than annual members. 

![before_average_ride_distance-duration](/images/before_average_ride_distance-duration.png)

To start, I looked at the monthly trends of duration and distance for casual riders to see what if I would find a deviation of sorts. I found that in the month of February, my average distance amounted to 20.25 miles, the highest in the year. 

![monthly_duration-distance_casual](/images/monthly_duration-distance_casual.png)

I looked into this further by pulling up all values that have a ride distance greater than 100. 

![ride_distance_6000](/images/ride_distance_6000.png)

From the log files, I found that both tables have the same amount of rows where the ride distances are greater than 100 (exactly 2076 rows). 
![all_trips_ride_distance_6000](/images/all_trips_ride_distance_6000.png)

![trips_analyzed_ride_distance_6000](/images/trips_analyzed_ride_distance_6000.png)

Since 2076 rows will not affect my overall analysis, I decided to delete them.  

This screenshot below demonstrates the SQL queries I inputted to address this issue. 

![steps_delete_ride_distance_6000](/images/steps_delete_ride_distance_6000.png)

I ran into another issue, however, in that my ride duration for casual riders is significantly higher than annual members.

![after_average_ride_distance-duration](/images/after_average_ride_distance-duration.png)

This is the steps I took to attempt to solve the problem: 

![ride_duration_steps](/images/ride_duration_steps.png)

I realized that the issue was in the data itself, in which a rider would take almost 24 hours to ride 0.27 miles, whereas another rider would take about two hours to ride 5.42 miles. I hypothesize the issue lies in human error on the part of the rider as the rider could have forgotten to close the trip in monitoring their ride distance and came back to end the bike trip. Nonetheless, my job is to point out this observation to Mrs. Lily Moreno or a senior data analyst working with me (if this scenario were real-life), and we would try to come up with a solution. Currently, I cannot think of a way to overcome this issue, so, unfortunately, for the rest of my project, this inconsistency will be included in my analysis. 

For the next step in my analysis, I am looking at the average ride distance and duration by day of week for annual members and casual riders. 

![avg_ride_distance-duration_casual_day_of_week](/images/avg_ride_distance-duration_casual_day_of_week.png)

Sunday has the highest average for both ride distance and duration. 

![avg_ride_distance-duration_member_day_of_week](/images/avg_ride_distance-duration_member_day_of_week.png)

As far as members go, annual members, on average, ride the longest and furtherest trips on Sunday as well, along with Saturday being the second highest day of the week. 

Here is a look at the month-to-month breakdown of average ride distance and duration for rider status.

![avg_ride_distance-duration_casual_month](/images/avg_ride_distance-duration_casual_month.png)

Casual riders have the highest average of ride distance in September, but they take longer rides in May. 

![avg_ride_distance-duration_member_month](/images/avg_ride_distance-duration_member_month.png)

Member riders, on average, bike longer distances in July but take longer lasting rides in February. 

Finally, I examine exactly how many rides take place during the week and month for casual riders and annual members. 

![count_ride_casual_day_of_week](/images/count_ride_casual_day_of_week.png)

Throughout the year, casual riders' favorite day to ride is on Wednesday. 

![count_ride_member_day_of_week](/images/count_ride_member_day_of_week.png)

Members also ride more on Wednesday. 

![count_ride_casual_month](/images/count_ride_casual_month.png)



![count_ride_member_month](/images/count_ride_member_month.png)

Annual members ride the most in July. 

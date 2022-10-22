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
To process all of this data at once (and to practice my SQL skills), I opted for MySql workbench as my processing tool. I first had to download and install MySql Workbench, then I created a table for each month of the year 2021 with the following SQL query: 

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

There is a total of 5,132,861 riders in this cleaned data set, with 56% being annual members and 44% casual riders.

[insert screenshot image here]

Furthermore, I looked at the percentages of bike types in this data set with classic bikes taking the lead at 59%, then electric bikes at 37%, and docked bikes 4%. 

[insert screenshot image here]

I examined the top 10 most popular stations for these riders with the number 1 spot being a blank value. I decided not to delete rows associated with the blank station name because if deleted 11% of my total data would be lost. I do not consider this bad data either as the goal is to examine how casual riders and annual members differ, and I believe there are more important aspects than the name of stations that have little to do with riders. I would like to point out that I wish to fill in the names of these stations in the future using the longitutde and latitude values provided, but because of the complexity of exact geological coordinates, I do not have the skills at the moment to resolve this missing data. 


[insert screenshot image here]

Next, I explored the most popular stations by rider status: 

[insert screenshot image here]

Afterwards, I proceeded to analyze the average distances and durations between casual riders and annual members, but I found an interesting discovery. Casual riders have a higher average for riding longer than annual members. I 

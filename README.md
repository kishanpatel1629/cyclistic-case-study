# Cyclistic Bike Share Case Study

**Google Data Analytics Professional Certificate, Capstone Project**
Analysis of 12 months of bike share trips (January to December 2023)

**Tools:** SQL Server (T-SQL, SSMS), Tableau Public, Excel

**[View the interactive Tableau dashboard](https://public.tableau.com/views/Cyclistic_tripdata_2023/CyclisticDashboard)**

## Business question

Cyclistic is a fictional bike share company in Chicago used in the Google capstone. Its marketing team believes annual members are more profitable than casual riders who buy single rides or day passes. My task was to answer:

1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy an annual membership?
3. How can Cyclistic use digital media to turn casual riders into members?

## Key results

| Metric | Casual riders | Annual members |
|---|---|---|
| Total rides (after cleaning) | 1,516,520 (35%) | 2,763,545 (65%) |
| Average ride length | 23.04 minutes | 12.27 minutes |
| Longest average rides | Sunday (26.73 min) and Saturday (26.01 min) | Sunday (13.78 min) and Saturday (13.77 min) |
| Busiest days | Saturday and Sunday | Monday to Friday |
| Busiest hours | Builds through the day, peaks at 5 PM | Two peaks, 8 AM and 5 PM |
| Top stations | Lakefront and tourist areas such as Navy Pier | Commuter areas |

In short, member rides are short and follow commute times. Casual rides are almost twice as long and happen more on weekends, which points to leisure use.

## Recommendations

1. **Weekend membership campaigns at lakefront stations.** Casual riders are most active on weekends at stations near Navy Pier and the Lakefront Trail, so digital ads and in app offers should target those places and times.
2. **Show casual riders what they would save.** Casual riders take long trips, so a message comparing their pay per ride cost with the cost of an annual membership gives them a clear reason to switch.
3. **Partner with museums and attractions on the lakefront.** At stations next to the Field Museum, Shedd Aquarium and Buckingham Fountain, about 78% of rides are taken by casual riders, the highest share of any busy station. Membership offers placed at these attractions, or bundled with their tickets, would reach casual riders where they already ride.

## Data source

The trip data comes from [Divvy Bikes](https://divvybikes.com/system-data), Chicago's bike share system, which publishes anonymized trip records. It is made available by Lyft Bikes and Scooters, LLC under the [Divvy Data License Agreement](https://divvybikes.com/data-license-agreement). The raw CSV files are not stored in this repository because they are too large and the license does not allow redistributing the dataset itself. Download the 12 files for 2023 (202301 to 202312) from the link above.

The 12 files contain 5,712,419 trips. After cleaning, 4,280,065 trips (75%) remained for analysis.

Each row is one trip, with the bike type, start and end time, start and end station, coordinates, and whether the rider was a member or casual rider.

## How the analysis works

The SQL files are numbered in the order they should be run in SQL Server Management Studio:

| File | What it does |
|---|---|
| [1_Data_Combining.sql](1_Data_Combining.sql) | Creates a table for each month, loads the 12 CSV files, and combines them into one table with UNION ALL |
| [2_Data_Exploration.sql](2_Data_Exploration.sql) | Adds ride length and day of week columns, then checks for missing values, inconsistent ride IDs, outlier trip times and rider type counts |
| [3_Data_Cleaning.sql](3_Data_Cleaning.sql) | Builds the clean table by removing trips with missing stations, invalid rider types, and trips of zero minutes or over 24 hours |
| [4_Data_Analysis.sql](4_Data_Analysis.sql) | Answers the three business questions: ride length, rides by weekday and hour, bike type, and top stations and routes for casual riders |
| [5_Advanced_Analysis.sql](5_Advanced_Analysis.sql) | Follow up queries using CTEs, JOINs and window functions (see below) |

### Follow up queries (5_Advanced_Analysis.sql)

| Question | SQL technique | Result |
|---|---|---|
| What share of rides does each user type take? | `SUM() OVER ()` | Members 64.6%, casual riders 35.4% |
| Which weekdays matter most to each group? | CTE with `SUM() OVER (PARTITION BY ...)` | Saturday is the top day for casual riders (20.3% of their rides). Wednesday is the top day for members (16.2%), and Sunday is their lowest (11.0%) |
| What are the top 5 start stations for each group? | CTE with `ROW_NUMBER()` | Casual: Streeter Dr & Grand Ave, DuSable Lake Shore Dr & Monroe St, Michigan Ave & Oak St, Millennium Park, DuSable Lake Shore Dr & North Blvd. Members: Clinton St & Washington Blvd, Kingsbury St & Kinzie St, Clark St & Elm St, Wells St & Concord Ln, Clinton St & Madison St |
| What is the busiest start hour for each group? | `RANK()` | 5 PM for both groups |
| Which busy stations have the highest share of casual riders? | Two CTEs joined with `INNER JOIN` | Field Museum (79%), Shedd Aquarium (78%), Buckingham Fountain (78%), DuSable Lake Shore Dr & Monroe St (76%), Streeter Dr & Grand Ave (73%), among stations with at least 1,000 rides |
| How do rides change month to month? | `LAG()` | Casual rides rise from 29,276 in January to a peak of 242,893 in July, more than 8 times higher. Member rides peak in August (347,063) and change less across the year |

The top casual stations are all on the lakefront or near tourist sites, while the top member stations are in downtown business areas. This supports the view that members commute and casual riders ride for leisure.

## Visual insights

### Total rides by user type
![Total rides by user type](images/Total%20Rides%20by%20User%20Type.png)

Members took about 65% of all rides after cleaning. Casual riders still took more than 1.5 million rides, which is a large group to market memberships to.

### Average ride length by day and user type
![Average ride length by day and user type](images/Avg%20Duration%20by%20Day%20and%20User%20Type.png)

Casual riders take longer trips every day of the week, and their longest trips are on weekends. Member trip lengths stay steady at about 12 to 14 minutes, which fits commuting.

### Hourly usage by user type
![Hourly usage by user type](images/Hourly%20Usage%20by%20User%20Type.png)

Member rides have two clear peaks, at 8 AM and 5 PM, matching commute times. Casual rides have no morning spike. They build through the day and peak at 5 PM.

### Bike type preference by user type
![Bike type preference by user type](images/Bike%20Type%20Preference%20by%20User%20Type.png)

Both groups use classic bikes most. Casual riders use electric bikes a little more than members (38% of casual rides compared with 35% of member rides), and docked bikes appear only for casual riders.

### Top start and end stations for casual riders
![Top start stations for casual riders](images/Top%20Start%20Stations%20%E2%80%93%20Casual%20Riders.png)
![Top end stations for casual riders](images/Top%20End%20Stations%20%E2%80%93%20Casual%20Riders.png)

The most popular casual rider stations are near tourist and lakefront spots such as Navy Pier and the Lakefront Trail, which makes them strong locations for membership campaigns.

## Limitations

* **Trips with missing station names were removed.** Many electric bike trips end away from a station and have no station name, so electric bike use is undercounted in the clean data.
* **Ride length is stored in whole minutes.** `DATEDIFF(MINUTE, ...)` counts minute boundaries, so a single trip can be off by up to one minute. This has little effect on averages across millions of trips.
* **No rider IDs or prices.** The data cannot show how many different people took the rides or how much each rider spent, so the savings message in recommendation 2 should be tested with real pricing.

## What I learned

* Combining and cleaning millions of rows in SQL Server, and checking data quality before analysis
* Writing SQL to answer business questions, from simple aggregations to CTEs and window functions
* Building a Tableau dashboard that turns query results into clear findings for a business audience
* Following the full Ask, Prepare, Process, Analyze, Share and Act process from start to finish

## Contact

**Kishan Patel** | [LinkedIn](https://www.linkedin.com/in/kishan-patel-kp1629) | [GitHub](https://github.com/kishanpatel1629) | [Tableau Public](https://public.tableau.com/app/profile/kishan.patel5786)

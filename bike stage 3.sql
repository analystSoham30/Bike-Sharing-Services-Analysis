
# 1 How does bike usage fluctuate throughout the day, and how does peak-hour demand vary across users?

select 
	hour(start_time) as hour_of_day,
    count(*) as Total_trips,
    case
		when hour(start_time) between 7 and 9 
        or hour(start_time) between 17 and 19 then "Peak"
        else "Off_peak" 
	end as Peak_off_peak
from final_trips_data
group by hour(start_time), peak_off_peak
order by hour_of_day;

#2 How do weekday and weekend ride patterns differ across different locations?  

select 
		day_type, 
		sum(trip_count), 
        avg(avgtime), 
		Main_ride_purpose
from
		(select 
			dayname(start_time) as day, 
            count(trip_id) as Trip_count, 
            round(avg(Trip_Duration_Min),2) as avgtime, 
		case 
			when dayname(Start_Time) in("saturday","sunday") then "Weekend"
            else "Weekday"
		end as Day_type,
        case 
			when dayname(Start_Time) in("saturday","sunday") then "Leisure trip"
            else "Commute trip"
		end as Main_ride_purpose
		from final_trips_data
		group by day, Day_type, Main_ride_purpose) 
        temp
group by day_type, Main_ride_purpose;  

# 3 How does net bike usage vary across stations based on arrivals and departures?
-- Use 2 CTEs

with cte1 as (
	select 
		start_station_ID as station_ID,
        count(*) as total_departures
    from final_trips_data    
	group by 
		station_ID
	) ,

cte2 as (
	select 
		end_station_ID as station_ID,
        count(*) as total_arrivals
	from final_trips_data
    group by
		station_ID
	)
    
select 
	t1.station_ID, 
    t1.total_departures,
    t2.total_arrivals,
    (t2.total_arrivals - t1.total_departures) as Net_Usage
from
	cte1 t1 inner join cte2 t2 on t1.station_id = t2.station_id
order by 
	net_usage desc;
    
#4 How do peak-hour trips compare to off-peak trips in terms of duration and distance?

select
	case
		when hour(start_time) between 7 and 9 or hour(start_time) between 17 and 19 then "Peak"
        else "Off-Peak"
	end as time_period,
    round(avg(trip_duration_min),2) as avg_trip_Duration,
    round(avg(distance_km),2) as avg_trip_Distance,
    case
		when hour(start_time) between 7 and 9 or hour(start_time) between 17 and 19 then "Commute"
        else "Leisure"
	end as Primary_ride_type
from Final_trips_data
group by
	time_period,
    primary_ride_type;
    
#5 Which stations experience peak-hour demand patterns that differ from standard commuter trends?
    
select*
from trips_data;
select*
from stations_data;

with cte1 as(
	select
		t.Start_Station_ID as station_id,
        s.Station_Name as Station_Name,
        hour(t.start_time) as hour,
        count(t.Trip_ID)as number_of_trips
	from final_trips_data as t
    inner join final_stations_data as s
		on s.Station_ID = t.Start_Station_ID
	group by
		t.Start_Station_ID,
        s.Station_Name,
        hour(t.start_time)
),
cte2 as (
	select
		station_id,
        Station_Name,
        hour,
        number_of_trips,
        row_number() over (partition by station_id order by number_of_trips desc) as peak_rank
	from cte1
)
select
	Station_Name,
    hour as Peak_Usage_Hour,
    number_of_trips as Total_Ride_During_Peak,
    case
		when hour in (7,8,9,17,18,19) then 'No'
        else 'Yes'
	end as Unusual_Peak_Pattern
from cte2
where
	peak_rank = 1
order by
	Total_Ride_During_Peak desc;
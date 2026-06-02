#1 How does ride behavior differ across user types?

select 
	ride_type, 
	round(avg(trip_duration_min),2) as avg_duration, 
    round(avg(distance_km),2) as avg_distance, 
    count(trip_id) as total_trips
from final_trips_data
group by ride_type;

#2 Which user segments ride most frequently, and how does this relate to lifetime engagement?

select 
	user_id, 
	ride_type,
    count(trip_id) as total_trips, 
    round(sum(distance_km),2) as total_km
from final_trips_data
group by 
	user_id, 
	ride_type 
order by 
	total_trips desc,
    total_km desc;

#3 How do users vary in their preference for time-of-day travel?

select 
	hour(start_time) as hour_of_day, 
	ride_type, 
    count(trip_id) as trip_count
from 
	final_trips_data
group by 
	hour_of_day, 
    ride_type
order by hour_of_day;


# How does the volume of records in each dataset compare to expected operational usage?	

select 
	'final_bikes_data' as Table_name, 
    count(*) as Total_Records,
    case when count(*) >=20000 then "Yes" else "No" end as Expected_Volume_Verified
from final_bikes_data

union all 

select 
	'final_maintenance_data' as Table_name, 
    count(*) as Total_Records,
    case when count(*) >=20000 then "Yes" else "No" end as Expected_Volume_Verified
from final_maintenance_data

union all 

select 
	'final_revenue_data' as Table_name, 
    count(*) as Total_Records,
    case when count(*) >=20000 then "Yes" else "No" end as Expected_Volume_Verified
from final_maintenance_data

union all 

select 
	'final_stations_data' as Table_name, 
    count(*) as Total_Records,
    case when count(*) >=20000 then "Yes" else "No" end as Expected_Volume_Verified
from final_stations_data

union all 

select 
	'final_trips_data' as Table_name, 
    count(*) as Total_Records,
    case when count(*) >=20000 then "Yes" else "No" end as Expected_Volume_Verified
from final_trips_data

union all 

select 
	'final_users_data' as Table_name, 
    count(*) as Total_Records,
    case when count(*) >=20000 then "Yes" else "No" end as Expected_Volume_Verified
from final_users_data

union all 

select 
	'final_weather_data' as Table_name, 
    count(*) as Total_Records,
    case when count(*) >=20000 then "Yes" else "No" end as Expected_Volume_Verified
from final_weather_data;


# Q2: How do missing values in key fields impact the reliability of trip analysis?

select * from final_trips_data;

select 
	'User_ID' as column_name, 
    sum(case when user_id is null then 1 else 0 end) as missing_values,
    round((sum(case when user_id is null then 1 else 0 end)/count(*) *100),2) as percentage_missing,
    case
		when (sum(case when user_id is null then 1 else 0 end)/count(*) *100) = 0 then 'Low'
        when (sum(case when user_id is null then 1 else 0 end)/count(*) *100) <5 then 'Medium'
        else 'High' 
	end as 'Impact_level'
        
from final_trips_data

union all

select 
	'Bike_ID' as column_name, 
    sum(case when Bike_ID is null then 1 else 0 end) as missing_values,
    round((sum(case when Bike_ID is null then 1 else 0 end)/count(*) *100),2) as percentage_missing,
    case
		when (sum(case when Bike_ID is null then 1 else 0 end)/count(*) *100) = 0 then 'Low'
        when (sum(case when Bike_ID is null then 1 else 0 end)/count(*) *100) <5 then 'Medium'
        else 'High' 
	end as 'Impact_level'
        
from final_trips_data
Union all
select 
	'End_station_ID' as column_name, 
    sum(case when End_station_ID is null then 1 else 0 end) as missing_values,
    round((sum(case when End_station_ID is null then 1 else 0 end)/count(*) *100),2) as percentage_missing,
    case
		when (sum(case when End_station_ID is null then 1 else 0 end)/count(*) *100) = 0 then 'Low'
        when (sum(case when End_station_ID is null then 1 else 0 end)/count(*) *100) <5 then 'Medium'
        else 'High' 
	end as Impact_level
        
from final_trips_data;

# continue union all for remaining records

#3 How are missing User IDs distributed across ride types, and what are the implications?

select
	ride_type, 
    sum(case when user_id is null then 1 else 0 end) as Missing_User_ID_Count,
    count(*) as Total_Trips,
    round((sum(case when user_id is null then 1 else 0 end)/count(*) *100),2) as percentage
from final_trips_data
group by ride_type;
    
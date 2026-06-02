
#1 How should duplicate trip records be handled while ensuring a valid ride history?

with cte as (
	select trip_id, user_id, start_time, bike_id, 
	row_number() over(partition by trip_id, user_id, start_time, bike_id) as rn
	from final_trips_data)
select * from cte
where rn>1;

# deleting duplicate records if present

DELETE FROM final_trips_data

WHERE (Trip_ID, User_ID, Start_Time, Bike_ID) IN 
			( SELECT 
				Trip_ID, User_ID, Start_Time, Bike_ID
			  FROM (SELECT 
						Trip_ID, 
                        User_ID, 
                        Start_Time, 
                        Bike_ID,
                        ROW_NUMBER() OVER ( PARTITION BY Trip_ID, User_ID, Start_Time, Bike_ID ORDER BY Start_Time) AS row_num
                    FROM 
						final_trips_data
				) AS duplicate_tracker
	WHERE row_num > 1

);

#2 What is the best approach to handle missing User IDs in the dataset?

-- No null or blank values present, but if present we can use 
update table_name
set user_id = "NO USer ID present"
where (user_id is null or user_id = "") 
	  and ride_type = "casual" ; --


#3 What adjustments should be made to correct negative trip durations?

select trip_id
from final_trips_data
where Start_Time > end_time;

-- if negative then how to delete the record

delete from final_trips_data
where Start_Time > end_time;

#4 How should station names be standardized to avoid inconsistencies in trip aggregation?

-- addresses not given in required format for replacing 

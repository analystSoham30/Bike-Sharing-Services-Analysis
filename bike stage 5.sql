
#1 What are the most common types of bike issues, and do they vary by season or location?

select
    m.Issue_Reported,
    t.Start_Station_ID,
    count(m.Bike_ID),
    case
			when month(m.final_Maintenance_Date) in (12,1,2) then 'Winter'
            when month(m.final_Maintenance_Date) in (3,4,5) then 'Spring'
            when month(m.final_Maintenance_Date) in (6,7,8) then 'Summer'
            else 'Fall'
	end as Season
from final_trips_data as t
	inner join final_maintenance_data as m
	on t.Bike_ID = m.Bike_ID
where
	t.Bike_ID = m.Bike_ID
group by
	m.Issue_Reported,
    t.Start_Station_ID,
    Season;
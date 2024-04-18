/*
Question #1:
return users who have booked and completed at least 10 flights, ordered by user_id.

Expected column names: `user_id`
*/

-- q1 solution:

With completed_flights as
(
select *
from sessions
where flight_booked = true 
and cancellation = false
)
select user_id
from completed_flights
group by user_id
having count(flight_booked) > 9
order by user_id;


/*

Question #2: 
Write a solution to report the trip_id of sessions where:

1. session resulted in a booked flight
2. booking occurred in May, 2022
3. booking has the maximum flight discount on that respective day.

If in one day there are multiple such transactions, return all of them.

Expected column names: `trip_id`

*/

-- q2 solution:

With ranked_per_day as
(
select trip_id,
session_end,
EXTRACT(Day from session_end) as day,
flight_discount_amount,
RANK() OVER(PARTITION BY EXTRACT(DAY FROM session_end) ORDER BY flight_discount_amount DESC) AS rank
from sessions
where flight_booked = true
and cancellation = false
AND EXTRACT(Month from session_end) = 5
AND EXTRACT(YEAR from session_end) = 2022
AND flight_discount_amount is not Null
)
SELECT trip_id
from ranked_per_day
where rank = 1
order by trip_id;

/*
Question #3: 
Write a solution that will, for each user_id of users with greater than 10 flights, 
find out the largest window of days between 
the departure time of a flight and the departure time 
of the next departing flight taken by the user.

Expected column names: `user_id`, `biggest_window`

*/

-- q3 solution:

WITH user_flights AS (
SELECT 
user_id, 
departure_time,
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY departure_time) AS flight_num,
LEAD(departure_time) OVER (PARTITION BY user_id ORDER BY departure_time) AS next_departure_time
FROM sessions s
JOIN flights f ON s.trip_id = f.trip_id
)
SELECT 
user_id,
MAX(ROUND(EXTRACT(EPOCH FROM (next_departure_time - departure_time)) / (60 * 60 * 24))) AS biggest_window
FROM user_flights
GROUP BY user_id
HAVING COUNT(*) > 10;


/*
Question #4: 
Find the user_id’s of people whose origin airport is Boston (BOS) 
and whose first and last flight were to the same destination. 
Only include people who have flown out of Boston at least twice.

Expected column names: user_id
*/

-- q4 solution:

WITH boston_origin AS (
SELECT 
user_id,
origin_airport,
destination_airport,
COUNT(*) OVER (PARTITION BY user_id) AS num_flights,
FIRST_VALUE(destination_airport) OVER (PARTITION BY user_id ORDER BY departure_time) AS first_destination,
LAST_VALUE(destination_airport) OVER (PARTITION BY user_id ORDER BY departure_time ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_destination
FROM sessions s
JOIN flights f ON s.trip_id = f.trip_id
WHERE origin_airport = 'BOS'
AND Cancellation = 'False'
)
SELECT distinct(user_id)
FROM boston_origin
WHERE num_flights > 1
AND first_destination = last_destination;


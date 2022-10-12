/* PROMPT: The Airbnb marketing analytics team is trying to understand what are the most common marketing channels that lead 
users to book their first rental on Airbnb. Write a query to find the top marketing channel and percentage of first rental 
bookings from the aforementioned marketing channel. Round the percentage to the closest integer. Assume there are no ties.
*/

/*
NOTES: While you can try taking the min of the date for each user, the easiest is to rank the booking_ids for each user by date. 
I also went ahead and joined with the channels in this first CTE. I used the second CTE to get the top channel and its booking 
count just using an order by with a limit 1. Finally, the main query grabs the ratio of the count of the top category with the 
total count of first booking id's from the first CTE where the date rank was 1.
*/

WITH firsts AS(
  SELECT b.user_id, b.booking_id, b.booking_date, a.channel,
         RANK() OVER(PARTITION BY b.user_id ORDER BY b.booking_date) AS the_rank
  FROM bookings b JOIN booking_attribution a ON b.booking_id = a.booking_id
),
top_channel AS(
  SELECT DISTINCT channel, COUNT(*) OVER(PARTITION BY channel) AS top_count
  FROM firsts
  WHERE the_rank = 1
  ORDER BY 2 DESC LIMIT 1
)
SELECT channel,
       ROUND(100.0*top_count/(SELECT COUNT(*) FROM firsts WHERE the_rank = 1),0) AS first_booking_pct
FROM top_channel

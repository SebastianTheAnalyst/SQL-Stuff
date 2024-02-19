/*
Question #1: 
Return the percentage of users who have posted more than 10 times rounded to 3 decimals.

Expected column names: more_than_10_posts
*/

-- q1 solution:

SELECT * FROM users LIMIT 5; -- replace this with your query


/*

Question #2: 
Recommend posts to user 888 by finding posts liked by users who have liked a post 
user 888 has also liked more than one time.

The output should adhere to the following requirements: 

- User 888 should not be recommend posts that they have already liked.
- Of the posts that meet the criteria above, return only the three most popular posts 
(by number of likes).
- Return the post_ids in descending order.

Expected column names: post_id
*/

-- q2 solution:

SELECT * FROM users LIMIT 5; -- replace this with your query

/*
Question #3: 
Vibestream wants to track engagement at the user level. 
When a user makes their first post, 
the team wants to begin tracking the cumulative sum of posts over time for the user.

Return a table showing the date and the total number of posts user 888 has made to date.
The time series should begin at the date of 888’s first post 
and end at the last available date in the posts table.

Expected column names: post_date, posts_made
*/

-- q3 solution:

SELECT * FROM users LIMIT 5; -- replace this with your query

/*
Question #4: 
The Vibestream feed algorithm updates with user preferences every day. 
Every update is independent of the previous update. 
Sometimes the update fails because Vibestreams systems are unreliable. 

Write a query to return the update state for each continuous interval of days 
in the period from 2023-01-01 to `023-12-30.

the algo_update is failed if tasks in a date interval failed 
and succeeded if tasks in a date interval succeeded. 
every interval has a  start_date and an end_date.

Return the result in ascending order by start_date.

Expected column names: algo_update, start_date, end_date
*/

-- q4 solution:

SELECT * FROM users LIMIT 5; -- replace this with your query


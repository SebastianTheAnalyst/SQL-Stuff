/*

Question #1: 
Vibestream is designed for users to share brief updates about how they are feeling, 
as such the platform enforces a character limit of 25. How many posts are exactly 25 characters long?
Expected column names: char_limit_posts
*/
-- q1 solution:
select count(content) as char_limit_posts
from posts
where length(content)=25

/*
Question #2: 
Users JamesTiger8285 and RobertMermaid7605 are Vibestream’s most active posters.
Find the difference in the number of posts these two users made on each day that at least one of them made a post. 
Return dates where the absolute value of the difference between posts made is greater than 2
 (i.e dates where JamesTiger8285 made at least 3 more posts than RobertMermaid7605 or vice versa).
Expected column names: post_date
*/

-- q2 solution:
SELECT post_date
FROM
(
select post_date,
SUM(case when user_name ='JamesTiger8285' then 1 else 0 end) as james,
SUM(case when user_name ='RobertMermaid7605'then 1 else 0 end) as robert
from users u
join posts p
on u.user_id = p.user_id
where u.user_name = 'JamesTiger8285'
OR u.user_name = 'RobertMermaid7605'
group by 1
 ) as total_counts
 where james - robert > 2 or robert - james > 2
order by 1 desc;

/*
Question #3: 
Most users have relatively low engagement and few connections. 
User WilliamEagle6815, for example, has only 2 followers. 

Network Analysts would say this user has two 1-step path relationships. 
Having 2 followers doesn’t mean WilliamEagle6815 is isolated, however.
 Through his followers, he is indirectly connected to the larger Vibestream network.  

Consider all users up to 3 steps away from this user:

1-step path (X → WilliamEagle6815)
2-step path (Y → X → WilliamEagle6815)
3-step path (Z → Y → X → WilliamEagle6815)

Write a query to find follower_id of all users within 4 steps of WilliamEagle6815. 
Order by follower_id and return the top 10 records.
*/

-- q3 solution:
SELECT distinct(f3.follower_id)
from users u
join follows f
on u.user_id = f.followee_id
join follows f1 on f.follower_id = f1.followee_id
join follows f2 on f1.follower_id = f2.followee_id
join follows f3 on f2.follower_id = f3.followee_id
where user_name = 'WilliamEagle6815'
order by follower_id
LIMIT 10;


/*
Question #4: 
Return top posters for 2023-11-30 and 2023-12-01. 
A top poster is a user who has the most OR second most number of posts in a given day. 
Include the number of posts in the result and order the result by post_date and user_id.
Expected column names: post_date, user_id, posts
*/

-- q4 solution:
SELECT p.post_date, u.user_id, COUNT(p.post_id) as posts
FROM users u
join posts p
on u.user_id=p.user_id
where post_date in ('2023-11-30', '2023-12-01')
group by 1, 2
having COUNT(p.post_id)>= 2
order by 1,2;


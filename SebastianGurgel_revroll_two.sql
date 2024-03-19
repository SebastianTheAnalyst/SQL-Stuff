/*
Question #1:

Write a query to find the customer(s) with the most orders. 
Return only the preferred name.

Expected column names: preferred_name
*/

-- q1 solution:
WITH RankedCustomers AS (
SELECT preferred_name,
RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.preferred_name
)
SELECT preferred_name
FROM RankedCustomers
WHERE rank = 1;

/*
Question #2: 
RevRoll does not install every part that is purchased. 
Some customers prefer to install parts themselves. 
This is a valuable line of business 
RevRoll wants to encourage by finding valuable self-install customers and sending them offers.

Return the customer_id and preferred name of customers 
who have made at least $2000 of purchases in parts that RevRoll did not install. 

Expected column names: customer_id, preferred_name
*/

-- q2 solution:
select distinct c.customer_id, c.preferred_name
from customers c
left join orders o 
on c.customer_id = o.customer_id
left join installs i
on o.order_id = i.order_id
left join parts p
on o.part_id = p.part_id
where install_id is null
group by 1, 2
HAVING SUM(o.quantity * p.price) >= 2000;

/*
Question #3: 
Report the id and preferred name of customers who bought an Oil Filter and Engine Oil 
but did not buy an Air Filter since we want to recommend these customers buy an Air Filter.
Return the result table ordered by `customer_id`.

Expected column names: customer_id, preferred_name

*/

-- q3 solution:
SELECT T1.customer_id, T1.preferred_name
FROM (
SELECT c.customer_id, c.preferred_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN parts p ON o.part_id = p.part_id
WHERE p.name IN ('Oil Filter', 'Engine Oil')
GROUP BY c.customer_id, c.preferred_name
HAVING SUM(CASE WHEN p.name = 'Oil Filter' THEN 1 ELSE 0 END) > 0
AND SUM(CASE WHEN p.name = 'Engine Oil' THEN 1 ELSE 0 END) > 0
AND SUM(CASE WHEN p.name = 'Air Filter' THEN 1 ELSE 0 END) = 0
) T1
LEFT JOIN (
SELECT c.customer_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN parts p ON o.part_id = p.part_id
WHERE p.name = 'Air Filter'
) T2 
ON T1.customer_id = T2.customer_id
WHERE T2.customer_id IS NULL
ORDER BY T1.customer_id;

/*
Question #4: 

Write a solution to calculate the cumulative part summary for every part that 
the RevRoll team has installed.

The cumulative part summary for an part can be calculated as follows:

- For each month that the part was installed, 
sum up the price*quantity in **that month** and the **previous two months**. 
This is the **3-month sum** for that month. 
If a part was not installed in previous months, 
the effective price*quantity for those months is 0.
- Do **not** include the 3-month sum for the **most recent month** that the part was installed.
- Do **not** include the 3-month sum for any month the part was not installed.

Return the result table ordered by `part_id` in ascending order. In case of a tie, order it by `month` in descending order. Limit the output to the first 10 rows.

Expected column names: part_id, month, part_summary
*/

-- q4 solution:
WITH totalforparts AS (
  SELECT
    p.part_id,
    EXTRACT(MONTH FROM ins.install_date) AS month,
    SUM(p.price * o.quantity) AS part_month_total
  FROM
    installs ins
    JOIN orders o ON ins.order_id = o.order_id
    JOIN parts p ON o.part_id = p.part_id
  GROUP BY
    p.part_id,
    EXTRACT(MONTH FROM ins.install_date)
  ORDER BY
    month
)
SELECT
  part_id,
  month,
  SUM(part_month_total) OVER (
    PARTITION BY part_id
    ORDER BY month
    RANGE BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS part_summary
FROM
  totalforparts
WHERE
  (part_id, month) NOT IN (
    SELECT part_id, MAX(month) AS month
    FROM totalforparts
    GROUP BY part_id
  )
ORDER BY
  part_id, month DESC
LIMIT 10;


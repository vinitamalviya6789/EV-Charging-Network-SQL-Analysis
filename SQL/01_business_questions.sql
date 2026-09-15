-- Q1 — How many customers are registered in the database?
SELECT COUNT(*) as total_customers FROM customers;

-- Q2. How many charging sessions were completed?
SELECT COUNT(*) AS completed_sessions
FROM charging_sessions
WHERE session_status = 'Completed';

-- Q3. How many charging sessions were cancelled?
SELECT COUNT(*) AS cancelled_sessions
FROM charging_sessions
WHERE session_status = 'Cancelled';

-- Q4. What is the total energy consumed across completed charging sessions?
SELECT SUM(energy_consumed_kwh) AS total_energy_kwh
FROM charging_sessions
WHERE session_status = 'Completed';

-- Q5. What is the average energy consumed per completed session?
SELECT ROUND(AVG(energy_consumed_kwh), 2) AS avg_energy_per_session
FROM charging_sessions
WHERE session_status = 'Completed';

-- Q6. Which payment methods are most commonly used by customers?
SELECT  payment_method,count(*) as total_payments
from payments
WHERE payment_status = 'Completed'
GROUP BY payment_method
ORDER BY total_payments DESC;

-- Q7. Which charging sessions lasted longer than 1 hour?
SELECT
    session_id,
    start_time,
    end_time,
    end_time - start_time AS session_duration
FROM charging_sessions
WHERE session_status = 'Completed'
  AND end_time - start_time > INTERVAL '1 hour'
ORDER BY session_duration DESC;

-- Q8. Which customers have never used the charging network?
SELECT
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN charging_sessions cs
    ON c.customer_id = cs.customer_id
WHERE cs.session_id IS NULL;


-- Q9. Which charging stations have the highest number of charging
SELECT
    s.station_id,
    s.station_name,
    COUNT(cs.session_id) AS total_sessions
FROM stations s
JOIN chargers c
    ON s.station_id = c.station_id
JOIN charging_sessions cs
    ON c.charger_id = cs.charger_id
GROUP BY
    s.station_id,
    s.station_name
ORDER BY total_sessions DESC;

-- Q10. Which customer has consumed the most energy?
SELECT
    c.customer_id,
    c.customer_name,
    SUM(cs.energy_consumed_kwh) AS total_energy_kwh
FROM customers c
JOIN charging_sessions cs
    ON c.customer_id = cs.customer_id
WHERE cs.session_status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_energy_kwh DESC
LIMIT 1;

-- Q11. Which vehicle models are used most frequently?
SELECT
    v.vehicle_model,
    COUNT(cs.session_id) AS total_sessions
FROM vehicles v
JOIN charging_sessions cs
    ON v.vehicle_id = cs.vehicle_id
WHERE cs.session_status = 'Completed'
GROUP BY v.vehicle_model
ORDER BY total_sessions DESC;

-- Q12. How much revenue was collected through each payment method?
SELECT
    payment_method,
    SUM(amount) AS total_revenue
FROM payments
WHERE payment_status = 'Completed'
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- Q13. Which stations have maintenance chargers?
SELECT
    s.station_name,
    c.charger_id,
    c.charger_type,
    c.power_kw
FROM stations s
JOIN chargers c
    ON s.station_id = c.station_id
WHERE c.charger_status = 'Maintenance'
ORDER BY s.station_name;

-- Q14.Which charging stations have the highest average energy consumed per completed session?
SELECT
    s.station_id,
    s.station_name,
    ROUND(AVG(cs.energy_consumed_kwh), 2) AS avg_energy_per_session
FROM stations s
JOIN chargers c
    ON s.station_id = c.station_id
JOIN charging_sessions cs
    ON c.charger_id = cs.charger_id
WHERE cs.session_status = 'Completed'
GROUP BY
    s.station_id,
    s.station_name
ORDER BY avg_energy_per_session DESC;


-- Q15. Which city generated the highest charging revenue?
SELECT
    l.city,
    SUM(p.amount) AS total_revenue
FROM locations l
JOIN stations s
    ON l.location_id = s.location_id
JOIN chargers c
    ON s.station_id = c.station_id
JOIN charging_sessions cs
    ON c.charger_id = cs.charger_id
JOIN payments p
    ON cs.session_id = p.session_id
WHERE p.payment_status = 'Completed'
GROUP BY l.city
ORDER BY total_revenue DESC
LIMIT 1;


-- Q16. Find customers who have charged more than 2 times.
SELECT c.customer_id,c.customer_name,count(cs.session_id) as charging_sessions
from customers c
join charging_sessions cs
on c.customer_id=cs.customer_id
where cs.session_status='completed'
group by c.customer_name,c.customer_id
having count(cs.session_id) > 2
order by charging_sessions  desc;

-- Q17. Which charger has delivered the most energy?
SELECT
    c.charger_id,
    c.charger_type,
    c.power_kw,
    SUM(cs.energy_consumed_kwh) AS total_energy_kwh
FROM chargers c
JOIN charging_sessions cs
    ON c.charger_id = cs.charger_id
WHERE cs.session_status = 'Completed'
GROUP BY c.charger_id, c.charger_type, c.power_kw
ORDER BY total_energy_kwh DESC
LIMIT 1;


-- Q18. What is the average revenue per completed payment? 
SELECT
    ROUND(AVG(amount), 2) AS average_payment_amount
FROM payments
WHERE payment_status = 'Completed';

-- Q19. Which charging sessions consumed more energy than the overall average?
SELECT
    session_id,
    energy_consumed_kwh
FROM charging_sessions
WHERE session_status = 'Completed'
  AND energy_consumed_kwh > (
      SELECT AVG(energy_consumed_kwh)
      FROM charging_sessions
      WHERE session_status = 'Completed'
  )
ORDER BY energy_consumed_kwh DESC;

-- Q20. Which day of the week has the highest number of charging sessions?
SELECT TO_CHAR(start_time,'Day') as day_of_week,
count(*) as  total_sessions
from charging_sessions
where session_status='Completed'
group by TO_CHAR(start_time,'Day'),EXTRACT(DOW FROM start_time)
order by total_sessions desc;

-- Q21. Which charging session generated the highest payment amount?
SELECT
    p.session_id,
    p.amount,
    p.payment_method
FROM payments p
WHERE p.payment_status = 'Completed'
ORDER BY p.amount DESC
LIMIT 1;


-- Q22. Which charger has the highest power capacity?
SELECT
    charger_id,
    charger_type,
    power_kw
FROM chargers
ORDER BY power_kw DESC
LIMIT 1;


-- Q23. Rank the charging stations by total revenue
SELECT
    s.station_id,
    s.station_name,
    SUM(p.amount) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(p.amount) DESC
    ) AS revenue_rank
FROM stations s
JOIN chargers c
    ON s.station_id = c.station_id
JOIN charging_sessions cs
    ON c.charger_id = cs.charger_id
JOIN payments p
    ON cs.session_id = p.session_id
WHERE p.payment_status = 'Completed'
GROUP BY s.station_id, s.station_name
ORDER BY revenue_rank;


-- Q24. Find the city whose charging revenue is above the average city revenue
SELECT
    l.city,
    SUM(p.amount) AS total_revenue
FROM locations l
JOIN stations s
    ON l.location_id = s.location_id
JOIN chargers c
    ON s.station_id = c.station_id
JOIN charging_sessions cs
    ON c.charger_id = cs.charger_id
JOIN payments p
    ON cs.session_id = p.session_id
WHERE p.payment_status = 'Completed'
GROUP BY l.city
HAVING SUM(p.amount) > (
    SELECT AVG(amount)
    FROM payments
    WHERE payment_status = 'Completed'
)
ORDER BY total_revenue DESC;


-- Q25. Rank customers within each city by total energy consumed
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    SUM(cs.energy_consumed_kwh) AS total_energy_kwh,
    RANK() OVER (
        PARTITION BY c.city
        ORDER BY SUM(cs.energy_consumed_kwh) DESC
    ) AS city_rank
FROM customers c
JOIN charging_sessions cs
    ON c.customer_id = cs.customer_id
WHERE cs.session_status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city
ORDER BY
    c.city,
    city_rank;


-- Q30. Find the second-highest revenue payment
SELECT
    payment_id,
    session_id,
    amount,
    DENSE_RANK() OVER (
        ORDER BY amount DESC
    ) AS payment_rank
FROM payments
WHERE payment_status = 'Completed'
ORDER BY payment_rank;



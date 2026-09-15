-- EV Charging Network Operations & Revenue Analysis
-- Final Business Insights Queries


-- 1. What is the total collected revenue?

SELECT
    SUM(amount) AS total_revenue
FROM payments
WHERE payment_status = 'Completed';


-- 2. What is the total energy consumed?

SELECT
    SUM(energy_consumed_kwh) AS total_energy_kwh
FROM charging_sessions
WHERE session_status = 'Completed';


-- 3. Which city had the most completed charging sessions?

SELECT
    l.city,
    COUNT(cs.session_id) AS total_sessions
FROM locations l
JOIN stations s
    ON l.location_id = s.location_id
JOIN chargers c
    ON s.station_id = c.station_id
JOIN charging_sessions cs
    ON c.charger_id = cs.charger_id
WHERE cs.session_status = 'Completed'
GROUP BY l.city
ORDER BY total_sessions DESC
LIMIT 1;


-- 4. Which payment method was used most often?

SELECT
    payment_method,
    COUNT(*) AS successful_payments
FROM payments
WHERE payment_status = 'Completed'
GROUP BY payment_method
ORDER BY successful_payments DESC
LIMIT 1;


-- 5. Which vehicle model consumed the most energy?

SELECT
    v.vehicle_model,
    SUM(cs.energy_consumed_kwh) AS total_energy_kwh
FROM vehicles v
JOIN charging_sessions cs
    ON v.vehicle_id = cs.vehicle_id
WHERE cs.session_status = 'Completed'
GROUP BY v.vehicle_model
ORDER BY total_energy_kwh DESC
LIMIT 1;
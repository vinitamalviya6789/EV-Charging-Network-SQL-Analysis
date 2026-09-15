EV CHARGING NETWORK DATABASE SCHEMA

1. customers
   Primary Key: customer_id

2. vehicles
   Primary Key: vehicle_id
   Foreign Key: customer_id → customers.customer_id

3. locations
   Primary Key: location_id

4. stations
   Primary Key: station_id
   Foreign Key: location_id → locations.location_id

5. chargers
   Primary Key: charger_id
   Foreign Key: station_id → stations.station_id

6. charging_sessions
   Primary Key: session_id
   Foreign Keys:
   customer_id → customers.customer_id
   vehicle_id → vehicles.vehicle_id
   charger_id → chargers.charger_id

7. payments
   Primary Key: payment_id
   Foreign Key:
   session_id → charging_sessions.session_id
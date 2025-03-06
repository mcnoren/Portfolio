--1

--A
CREATE TABLE hw6.airport_delays AS(
	SELECT airports.description AS description, avg(hw6.flights.depart_delay) AS avg_delay, COUNT(*) AS count
	FROM hw6.flights
	JOIN hw6.airports
	ON origin_airport_id = airport_id
	GROUP BY airport_id
	ORDER BY avg(hw6.flights.depart_delay) DESC
)
;

SELECT description, avg_delay, count
FROM hw6.airport_delays
WHERE count > 100
ORDER BY avg_delay DESC
;

--DROP table hw6.airport_delays;

--B
SELECT city_markets.description AS description, COUNT(flights.dest_city_market_id) AS num_inbound_flights
FROM hw6.flights
JOIN hw6.city_markets
ON dest_city_market_id = city_market_id
GROUP BY city_market_id
ORDER BY COUNT(flights.dest_city_market_id) DESC
LIMIT 3
;
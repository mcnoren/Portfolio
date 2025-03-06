DROP TABLE taxi_rides;

CREATE TABLE taxi_rides (
	vendorID INT,
	tpep_pickup_datetime TIMESTAMP,
	tpep_dropoff_datetime TIMESTAMP,
	passenger_count INT,
	trip_distance NUMERIC,
	ratecodeID INT,
	store_and_fwd_flag CHAR(1),
	pulocationID INT,
	dolocationID INT,
	payment_type SMALLINT,
	fare_amount NUMERIC,
	extra NUMERIC,
	mta_tax NUMERIC,
	tip_amount NUMERIC,
	tolls_amount NUMERIC,
	improvement_surcharge NUMERIC,
	total_amount NUMERIC,
	congestion_surcharge NUMERIC,
	airport_fee NUMERIC
);

COPY taxi_rides
FROM '/Users/mcnoren/Library/Mobile Documents/com~apple~CloudDocs/Desktop/SQL/Data/yellow_tripdata_2024-06.csv'
WITH (FORMAT CSV, HEADER);

SELECT * FROM taxi_rides;

SELECT * FROM taxi_rides
WHERE tpep_pickup_datetime < '2024-6-1' AND tpep_dropoff_datetime < '2024-6-1'
OR tpep_pickup_datetime > '2024-6-30' AND tpep_dropoff_datetime > '2024-6-30';
--26 rows

SELECT * FROM taxi_rides
WHERE payment_type = 4;

SELECT 63775::REAL / 3539193;
--0.018019644591295247


	SELECT 
		percentile_cont(0.5) WITHIN GROUP (ORDER BY fare_amount) AS med
	FROM taxi_rides;
	--14.2

SELECT 
	mode() WITHIN GROUP (ORDER BY pulocationid)
FROM taxi_rides;

SELECT 
	mode() WITHIN GROUP (ORDER BY dolocationid)
FROM taxi_rides;

SELECT 
	mode() WITHIN GROUP (ORDER BY (pulocationid, dolocationid))
FROM taxi_rides;

CREATE TEMP TABLE backwards_in_time_taxis AS (
	SELECT tpep_dropoff_datetime - tpep_pickup_datetime AS time_interval FROM taxi_rides 
	WHERE tpep_dropoff_datetime < tpep_pickup_datetime
);

SELECT * FROM backwards_in_time_taxis;

SELECT avg(time_interval) 
FROM backwards_in_time_taxis;

---------Problem 3----------
DROP TABLE valid_taxi_rides;

CREATE TABLE valid_taxi_rides AS (
	SELECT *
	FROM taxi_rides
	WHERE (EXTRACT( EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime))) >= 30
	AND trip_distance > 0
);

SELECT *
FROM valid_taxi_rides;

DROP TABLE valid_taxi_ride_speeds;

CREATE TABLE valid_taxi_ride_speeds AS (
	SELECT trip_distance / (EXTRACT( EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 3600 ) AS speed
	FROM valid_taxi_rides
);

SELECT * FROM valid_taxi_ride_speeds;

SELECT
	percentile_cont(.25) WITHIN GROUP (ORDER BY speed) AS q1,
	percentile_cont(.75) WITHIN GROUP (ORDER BY speed) AS q3,
	percentile_cont(.75) WITHIN GROUP (ORDER BY speed) - percentile_cont(.25) WITHIN GROUP (ORDER BY speed) AS IQR
FROM valid_taxi_ride_speeds;

COPY (
	SELECT vendorid, trip_distance / (EXTRACT( EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 3600 ) AS speed
	FROM valid_taxi_rides
	WHERE trip_distance / (EXTRACT( EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 3600 ) < 7.0054 - 1.5 * 5.9029
	OR trip_distance / (EXTRACT( EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 3600 ) > 12.9084 + 1.5 * 5.9029
	ORDER BY trip_distance / (EXTRACT( EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 3600 )
)
TO '/Users/mcnoren/Library/Mobile Documents/com~apple~CloudDocs/Desktop/SQL/bad_taxi_mphs.csv'
WITH(FORMAT CSV, HEADER);

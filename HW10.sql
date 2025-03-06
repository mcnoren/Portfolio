--Problem 1
--Part A
DROP TABLE cities;
CREATE TABLE cities(
	id INT,
	city_original TEXT,
	city_simplified TEXT,
	city_other_languages TEXT,
	latitude FLOAT,
	longitude FLOAT,
	G TEXT,
	H TEXT,
	I TEXT,
	J TEXT,
	K TEXT,
	L TEXT,
	M TEXT,
	N TEXT,
	O BIGINT,
	P INT,
	Q INT,
	continent TEXT,
	date DATE
);

COPY cities
FROM '/Users/mcnoren/Desktop/SQL/Data/prob1_data/cities.csv'
WITH (FORMAT CSV)
;

ALTER TABLE cities
ADD COLUMN geog_loc GEOGRAPHY
;

UPDATE cities
SET geog_loc = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography
;

CREATE INDEX geog_loc_index
ON cities
USING GIST(geog_loc)
;

--Part B
DROP TABLE cities_seen;
CREATE TABLE cities_seen AS(
	SELECT id, city_simplified
	FROM cities
	WHERE ST_Dwithin(
		ST_MakeLine(
		(SELECT geog_loc FROM cities WHERE city_simplified ILIKE 'Portland' AND I = 'US' AND K = 'OR')::geometry,
		(SELECT geog_loc FROM cities WHERE city_simplified ILIKE 'Paris' AND I = 'FR')::geometry
		)::geography, geog_loc, 150000) --150 Kilometers (150000 meters)
)
;

--Part C
SELECT cities.city_simplified, O AS population
FROM cities_seen
JOIN cities
ON cities.id = cities_seen.id
ORDER BY O DESC
LIMIT 5
;

--Part D
CREATE TABLE country_info(
	abr TEXT,
	long_abr TEXT,
	C TEXT,
	abr2 TEXT,
	country TEXT,
	F TEXT,
	G TEXT,
	H TEXT,
	I TEXT,
	J TEXT,
	K TEXT,
	L TEXT,
	M TEXT,
	N TEXT,
	O TEXT,
	P TEXT,
	Q TEXT,
	R TEXT,
	S TEXT
)
;

COPY country_info
FROM '/Users/mcnoren/Desktop/SQL/Data/prob1_data/country_info.csv'
WITH (FORMAT CSV)
;

DROP TABLE cities_per_country;
CREATE TABLE cities_per_country AS(
	SELECT country, COUNT(*)
	FROM cities
	JOIN country_info
	ON cities.I = country_info.abr
	GROUP BY country
	ORDER BY COUNT(*) DESC
)
;

COPY cities_per_country
TO '/Users/mcnoren/Desktop/SQL/Homework/cities_per_country.csv'
WITH (FORMAT CSV)
;
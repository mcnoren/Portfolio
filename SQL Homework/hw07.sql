DROP TABLE artwork_artists;
DROP TABLE artworks;
DROP TABLE artists;


CREATE TABLE artworks (
  title TEXT,
  artist TEXT,
  constituent_id TEXT,
  artist_bio TEXT,
  nationality TEXT,
  begin_date TEXT,
  end_date TEXT,
  gender TEXT,
  date TEXT,
  medium TEXT,
  dimensions TEXT,
  credit_line TEXT,
  accession_number TEXT,
  classification TEXT,
  department TEXT,
  date_acquired DATE,
  cataloged TEXT,
  object_id INTEGER,
  url TEXT,
  image_url TEXT,
  on_view TEXT,
  circumference_cm DOUBLE PRECISION,
  depth_cm DOUBLE PRECISION,
  diameter_cm DOUBLE PRECISION,
  height_cm DOUBLE PRECISION,
  length_cm DOUBLE PRECISION,
  weight_kg DOUBLE PRECISION,
  width_cm DOUBLE PRECISION,
  seat_height_cm DOUBLE PRECISION,
  duration_sec DOUBLE PRECISION
);

CREATE TABLE artists (
  constituent_id BIGINT,
  display_name TEXT,
  artist_bio TEXT,
  nationality TEXT,
  gender TEXT,
  begin_date INTEGER,
  end_date INTEGER,
  wiki_qid TEXT,
  ulan TEXT
);

--A
COPY artworks 
FROM '/Users/mcnoren/Desktop/SQL/Data/Artworks.csv'
WITH (FORMAT CSV, HEADER);

COPY artists
FROM '/Users/mcnoren/Desktop/SQL/Data/Artists.csv'
WITH (FORMAT CSV, HEADER);

SELECT * FROM artworks;

--B
CREATE TABLE artwork_artists AS (
	SELECT object_id, STRING_TO_TABLE(constituent_id, ',') AS constituent_id
	FROM artworks
	ORDER BY object_id
);

SELECT * FROM artwork_artists;

--C
ALTER TABLE artwork_artists
ALTER COLUMN constituent_id SET DATA TYPE INT
USING constituent_id::INT;

--D
ALTER TABLE artworks
ADD CONSTRAINT pk_object_id PRIMARY KEY(object_id);

ALTER TABLE artists
ADD CONSTRAINT pk_constituent_id PRIMARY KEY(constituent_id);

ALTER TABLE artwork_artists
ADD CONSTRAINT pk_object_constituent_id PRIMARY KEY(object_id, constituent_id);

ALTER TABLE artwork_artists
ADD CONSTRAINT fk_object_id FOREIGN KEY(object_id)
	REFERENCES artworks(object_id),
ADD CONSTRAINT fk_constituent_id FOREIGN KEY(constituent_id)
	REFERENCES artists(constituent_id);

--E
ALTER TABLE artworks
DROP COLUMN artist,
DROP COLUMN constituent_id,
DROP COLUMN artist_bio,
DROP COLUMN nationality,
DROP COLUMN begin_date,
DROP COLUMN end_date,
DROP COLUMN gender;

SELECT * FROM artworks;
SELECT * FROM artwork_artists;
SELECT * FROM artists;

--Problem 2

--A
UPDATE artists
SET begin_date = NULL
WHERE begin_date = 0;

UPDATE artists
SET end_date = NULL
WHERE end_date = 0;

--B
ALTER TABLE artworks
ADD COLUMN date_int INT;

UPDATE artworks
SET date_int = substring(date FROM '\d{4}')::INT;

SELECT SUM(date_int)
FROM artworks;

--C
ALTER TABLE artworks
RENAME circumference_cm TO perimeter_cm;

UPDATE artworks
SET perimeter_cm = 2 * height_cm + 2 * width_cm
WHERE height_cm IS NOT NULL and width_cm IS NOT NULL;

UPDATE artworks
SET perimeter_cm = diameter_cm * pi()
WHERE diameter_cm IS NOT NULL;


SELECT * FROM artworks;
SELECT * FROM artwork_artists;
SELECT * FROM artists;

--Problem 3

--A
SELECT title, COUNT(*)
FROM artwork_artists
JOIN artworks
ON artworks.object_id = artwork_artists.object_id
GROUP BY artworks.object_id
ORDER BY COUNT(*) DESC;

--B
CREATE TEMP TABLE artwork_age AS (
	SELECT date_part('year', date_acquired) - date_int AS age
	FROM artworks
);

SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY age) AS med
FROM artwork_age;

--C
CREATE TEMP TABLE classification_by_artist AS (
	SELECT DISTINCT constituent_id, classification
	FROM artwork_artists
	JOIN artworks
	ON artworks.object_id = artwork_artists.object_id
	ORDER BY constituent_id
);

SELECT display_name, COUNT(*) AS num_distinct_classifications
FROM classification_by_artist
JOIN artists 
ON artists.constituent_id = classification_by_artist.constituent_id
GROUP BY artists.constituent_id
ORDER BY COUNT(*) DESC

--D
DROP TABLE departments;

CREATE TEMP TABLE departments AS (
	SELECT title, department, perimeter_cm 
	FROM artworks 
	WHERE perimeter_cm IS NOT NULL
);

SELECT * FROM departments;

SELECT title, department, dense_rank
FROM (
	SELECT department, title, perimeter_cm, dense_rank() OVER(PARTITION BY department ORDER BY perimeter_cm)
	FROM departments
	ORDER BY departments, perimeter_cm DESC
)
WHERE dense_rank = 30;

SELECT department
FROM (
	SELECT DISTINCT department
	FROM artworks
)
WHERE department NOT IN (
	SELECT DISTINCT department
	FROM departments
);
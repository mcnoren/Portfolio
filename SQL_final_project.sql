DROP TABLE IF EXISTS people_imdb;
CREATE TABLE people_imdb (
	nconst TEXT,
	primaryName TEXT,
	birthYear INT,
	deathYear INT,
	primaryProfession TEXT, --Seperated by ,
	knownForTitles TEXT --Seperated by ,
)
;

COPY people_imdb
FROM '/Users/mcnoren/Downloads/cleaned_people.tsv'
WITH (FORMAT CSV, HEADER, DELIMITER E'\t', NULL '\N')
;

SELECT * FROM people_imdb;

DROP TABLE IF EXISTS movies_imdb;
CREATE TABLE movies_imdb (
	tconst TEXT,
	titleType TEXT,
	primaryTitle TEXT,
	originalTitle TEXT,
	isAdult BOOLEAN,
	startYear INT,
	endYear INT,
	runtimeMinutes INT,
	genres TEXT --Seperated by ,
)
;

COPY movies_imdb
FROM '/Users/mcnoren/Downloads/title.basics.tsv'
WITH (FORMAT CSV, 
	HEADER, 
	DELIMITER E'\t', 
	NULL '\N',
  	QUOTE E'\b',
  	ESCAPE E'\b')
;

SELECT * FROM movies_imdb;

DROP TABLE IF EXISTS movie_principals_imdb;
CREATE TABLE movie_principals_imdb(
	tconst TEXT,
	ordering INT,
	nconst TEXT,
	category TEXT,
	job TEXT,
	characters TEXT --in an Array
)
;

COPY movie_principals_imdb
FROM '/Users/mcnoren/Downloads/title.principals.tsv'
WITH (FORMAT CSV,
	HEADER,
	DELIMITER E'\t',
	NULL '\N',
  	QUOTE E'\b',
  	ESCAPE E'\b')
;

SELECT * FROM movie_principals_imdb;

DROP TABLE IF EXISTS ratings_imdb;
CREATE TABLE ratings_imdb(
	tconst TEXT,
	averageRating FLOAT,
	numVotes BIGINT
);

COPY ratings_imdb
FROM '/Users/mcnoren/Downloads/title.ratings.tsv'
WITH (FORMAT CSV, HEADER, DELIMITER E'\t', NULL '\N');

SELECT * FROM ratings_imdb;

DROP TABLE IF EXISTS movies_metadata;
CREATE TABLE movies_metadata(
	adult BOOLEAN,
	belongs_to_collection TEXT,
	budget INT,
	genres TEXT,
	homepage TEXT,
	id TEXT,
	imdb_id TEXT,
	original_language TEXT,
	original_title TEXT,
	overview TEXT,
	popularity FLOAT,
	poster_path TEXT,
	production_companies TEXT,
	production_countries TEXT,
	release_date DATE,
	revenue BIGINT,
	runtime FLOAT,
	spoken_languages TEXT,
	status TEXT,
	tagline TEXT,
	title TEXT,
	video BOOLEAN,
	vote_average FLOAT,
	vote_count INT
)
;

COPY movies_metadata
FROM '/Users/mcnoren/Downloads/movies_metadata.csv'
WITH (FORMAT CSV, 
	HEADER)
;

DROP TABLE IF EXISTS movies_metadata_cleaned;
CREATE TABLE movies_metadata_cleaned AS(
	SELECT imdb_id, budget, original_language, overview, popularity, 
	production_companies, production_countries, release_date, revenue,
	spoken_languages, tagline
	FROM movies_metadata
)
;



SELECT * FROM movies_metadata;

DROP TABLE IF EXISTS one_large_table;
CREATE TABLE one_large_table AS(
	SELECT movies_imdb.tconst, titletype, primarytitle, originaltitle, isadult, startyear, endyear, runtimeminutes,
		genres, ordering, people_imdb.nconst, category, job, characters, primaryname, birthyear, deathyear, primaryprofession, 
		knownfortitles, averagerating, numvotes, budget, original_language, overview, 
		production_companies, release_date, revenue, spoken_languages, tagline
	FROM movies_imdb
	LEFT JOIN movie_principals_imdb
	ON movies_imdb.tconst = movie_principals_imdb.tconst
	RIGHT JOIN people_imdb
	ON movie_principals_imdb.nconst = people_imdb.nconst
	JOIN ratings_imdb
	ON movies_imdb.tconst = ratings_imdb.tconst
	JOIN movies_metadata_cleaned
	ON movies_imdb.tconst = movies_metadata_cleaned.imdb_id
)
;

SELECT * FROM one_large_table
ORDER BY tconst, ordering
;

DROP TABLE IF EXISTS movies;
CREATE TABLE movies AS (
	SELECT DISTINCT tconst, titletype, primarytitle, originaltitle, isadult, 
		startyear, endyear, runtimeminutes, genres, averagerating, 
		numvotes, budget, original_language, production_companies, 
		release_date, revenue, spoken_languages, tagline
	FROM one_large_table
)
;

DROP INDEX IF EXISTS movie_names;
CREATE INDEX movie_names ON movies (primarytitle);

EXPLAIN ANALYZE
SELECT *
FROM movies
WHERE primarytitle = 'Toy Story'

ALTER TABLE movies
ADD CONSTRAINT movie_id PRIMARY KEY (tconst)
;

ALTER TABLE movies
ALTER COLUMN originalTitle SET NOT NULL
;

ALTER TABLE movies
ALTER COLUMN primaryTitle SET NOT NULL
;

DROP TABLE IF EXISTS people;
CREATE TABLE people AS (
	SELECT DISTINCT nconst, primaryname, birthyear, deathyear,
		primaryprofession, knownfortitles
	FROM one_large_table
)
;

DROP INDEX IF EXISTS people_names;
CREATE INDEX people_names ON people (primaryname)
;

ALTER TABLE people
ADD CONSTRAINT people_id PRIMARY KEY (nconst)
;

ALTER TABLE people
ALTER COLUMN primaryName SET NOT NULL
;

DROP TABLE IF EXISTS movie_principals;
CREATE TABLE movie_principals AS(
	SELECT DISTINCT tconst, nconst, ordering, category, job, characters
	FROM one_large_table
)
;

ALTER TABLE movie_principals
ADD CONSTRAINT tconst_fk FOREIGN KEY (tconst) REFERENCES movies(tconst)
;
ALTER TABLE movie_principals
ADD CONSTRAINT nconst_fk FOREIGN KEY (nconst) REFERENCES people(nconst)
;
ALTER TABLE movie_principals
ADD CONSTRAINT movie_principals_pk PRIMARY KEY (tconst, ordering)
;
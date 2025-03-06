--Problem 1
CREATE TABLE fables_raw (
	contents TEXT
);

COPY fables_raw
FROM '/Users/mcnoren/Desktop/SQL/Data/fables.txt'
WITH (FORMAT CSV);

SELECT * FROM fables_raw

CREATE TABLE fables_spilt AS (
SELECT regexp_split_to_table(
	contents,
	'\n{5}'
) AS contents
FROM fables_raw
)
;

COPY fables_split
TO '/Users/mcnoren/Desktop/SQL/Homework/fables_split.csv'
WITH (FORMAT CSV);

--Problem 2
CREATE TABLE fables AS(
	SELECT title,
		regexp_replace(story, '\n{2}.*', '') AS story,
		substring(story, '\n{2}\s*(.*)')
	FROM (
		SELECT 	substring(contents, '(.+)\n{3}') AS title,
			substring(contents, '\n{3}(.+)') AS story
		FROM fables_spilt
		)
	)
;

COPY fables
TO '/Users/mcnoren/Desktop/SQL/Homework/fables.csv'
WITH (FORMAT CSV)
;

--Problem 3
ALTER TABLE fables
ADD COLUMN story_vec tsvector;

UPDATE fables
SET story_vec = to_tsvector(story)
;

CREATE INDEX index ON fables
USING GIN(story_vec)
;

SELECT * 
FROM fables
WHERE story_vec @@ to_tsquery('sea')
AND NOT story_vec @@ to_tsquery('sailor')
AND NOT story_vec @@ to_tsquery('perform')
;

CREATE TABLE IF NOT EXISTS animals (
    name text
);
INSERT INTO animals VALUES
('ant'),
('ass'),
('bear'),
('bull'),
('cat'),
('crow'),
('dog'),
('eagle'),
('fox'),
('frog'),
('goat'),
('grasshopper'),
('hare'),
('lion'),
('monkey'),
('mouse'),
('owl'),
('ox'),
('snake'),
('wolf');

SELECT name, (
	SELECT COUNT(*)
	FROM fables
	WHERE story_vec @@ to_tsquery(name)
	)
FROM animals
ORDER BY count DESC
;

--Problem 4
CREATE TABLE snippets AS(
SELECT 
	title, 
	unnest(String_to_array(regexp_replace(ts_headline(story, to_tsquery('cry'), 'MaxWords=15,MinWords=10,MaxFragments=3'), '\n', ' '), '...')) AS snippets
FROM fables
WHERE story_vec @@ to_tsquery('cry')
)
;

COPY snippets
TO '/Users/mcnoren/Desktop/SQL/Homework/crying_fables.csv'
WITH (FORMAT CSV)
;
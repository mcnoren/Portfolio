DROP TABLE IF EXISTS users;
CREATE TABLE users (
  user_id bigint,
  first_name varchar(50),
  last_name varchar(50),
  street_address text,
  city varchar(50),
  state varchar(50),
  country char(2),
  birthdate date,
  local_timezone varchar(50)
);
COPY users
FROM '/Users/mcnoren/Desktop/SQL/Data/users.csv'
WITH(FORMAT CSV);


DROP TABLE IF EXISTS appointments;
CREATE TABLE appointments (
  appointment_id bigint,
  start_time timestamp,
  duration interval,
  apt_timezone varchar(50),
  apt_topic text
);

COPY appointments
FROM '/Users/mcnoren/Desktop/SQL/Data/appointments.csv'
WITH(FORMAT CSV);


DROP TABLE IF EXISTS participants;
CREATE TABLE participants (
  appointment_id bigint,
  user_id bigint,
  is_attending varchar(5)
);

COPY participants
FROM '/Users/mcnoren/Desktop/SQL/Data/participants.csv'
WITH(FORMAT CSV);



/* SETTING UP CONSTRAINTS */
ALTER TABLE users ADD PRIMARY KEY (user_id);
ALTER TABLE appointments ADD PRIMARY KEY (appointment_id);
ALTER TABLE participants ADD PRIMARY KEY (appointment_id, user_id);
ALTER TABLE participants ADD FOREIGN KEY (user_id) REFERENCES users (user_id);
ALTER TABLE participants ADD FOREIGN KEY (appointment_id) REFERENCES appointments (appointment_id);


--Problem 1
--What percentage of appointments have 100% of the invited guests planning to attend?
SELECT num / den AS perc
FROM (
SELECT (
	SELECT
	COUNT(*)::DOUBLE PRECISION
	FROM participants
	WHERE appointment_id NOT IN (
		SELECT DISTINCT
		appointment_id
		FROM participants
		WHERE is_attending ILIKE 'no'
	)
) AS num, (
	SELECT
	COUNT(*)
	FROM appointments
	) AS den
);

--Problem 2
--How many users are attending a meeting on their birthday? Only count meetings that would start on a user’s birthday.
SELECT COUNT(*)
FROM (
	SELECT user_id
	FROM users
	WHERE date_part('month', birthdate::DATE AT TIME ZONE local_timezone) IN (
		SELECT date_part('month', start_time::DATE at TIME ZONE users.local_timezone)
		FROM appointments
		WHERE appointment_id IN (
			SELECT appointment_id
			FROM participants
			WHERE participants.user_id = users.user_id and is_attending ILIKE 'yes'
		)
	) and date_part('day', birthdate::DATE AT TIME ZONE local_timezone) IN (
	SELECT date_part('day', start_time::DATE at TIME ZONE users.local_timezone)
		FROM appointments
		WHERE appointment_id IN (
			SELECT appointment_id
			FROM participants
			WHERE participants.user_id = users.user_id and is_attending ILIKE 'yes'
		)
	)
);

--Problem 3
--A
SELECT u1.user_id, appts.appointment_id,
	appts.start_time AT TIME ZONE appts.apt_timezone AT TIME ZONE u1.local_timezone AS st1,
	appts.start_time AT TIME ZONE appts.apt_timezone AT TIME ZONE u1.local_timezone + duration AS et1,
	app_id2,
	st2,
	et2
FROM appointments AS appts
JOIN participants AS p1
ON p1.appointment_id = appts.appointment_id
JOIN users AS u1
ON u1.user_id = p1.user_id
CROSS JOIN (
	SELECT appts2.appointment_id AS app_id2,
		appts2.start_time AT TIME ZONE appts2.apt_timezone AT TIME ZONE u2.local_timezone AS st2,
		appts2.start_time AT TIME ZONE appts2.apt_timezone AT TIME ZONE u2.local_timezone + appts2.duration AS et2
	FROM appointments AS appts2
	JOIN participants AS p2
	ON p2.appointment_id = appts2.appointment_id
	JOIN users AS u2
	ON u2.user_id = p2.user_id
	WHERE p2.is_attending ILIKE 'yes'
	AND u2.user_id = 12
)
WHERE is_attending ILIKE 'yes'
AND u1.user_id = 12
AND appts.appointment_id != app_id2
AND (appts.start_time AT TIME ZONE apt_timezone AT TIME ZONE u1.local_timezone, appts.start_time AT TIME ZONE apt_timezone AT TIME ZONE u1.local_timezone + duration) OVERLAPS (st2, et2)
LIMIT 2
;

--B
SELECT count(*) / 2
FROM appointments AS appts
JOIN participants AS p1
ON p1.appointment_id = appts.appointment_id
JOIN users AS u1
ON u1.user_id = p1.user_id
CROSS JOIN (
	SELECT appts2.appointment_id AS app_id2,
		u2.user_id AS user_id2,
		appts2.start_time AT TIME ZONE appts2.apt_timezone AT TIME ZONE u2.local_timezone AS st2,
		appts2.start_time AT TIME ZONE appts2.apt_timezone AT TIME ZONE u2.local_timezone + appts2.duration AS et2
	FROM appointments AS appts2
	JOIN participants AS p2
	ON p2.appointment_id = appts2.appointment_id
	JOIN users AS u2
	ON u2.user_id = p2.user_id
	WHERE p2.is_attending ILIKE 'yes'
)
WHERE is_attending ILIKE 'yes'
AND u1.user_id = user_id2
AND appts.appointment_id != app_id2
AND (appts.start_time AT TIME ZONE apt_timezone AT TIME ZONE u1.local_timezone, appts.start_time AT TIME ZONE apt_timezone AT TIME ZONE u1.local_timezone + duration) OVERLAPS (st2, et2)
;

--Problem 4
CREATE EXTENSION tablefunc;

CREATE TABLE cat_counts_over_week AS(
SELECT *
FROM crosstab(
	$$
	SELECT CASE
			WHEN apt_topic ~ '^I am angry about' THEN 'angry'
			WHEN apt_topic ~ '^Important topic:' THEN 'Important_topic:'
			WHEN apt_topic ~ '^Thoughts on' THEN 'thoughts'
			WHEN apt_topic ~ '^I love' THEN 'love'
			WHEN apt_topic ~ '^Ruminations on the existence of' THEN 'ruminations'
		END AS simple_topic, date_part('dow', start_time AT TIME ZONE apt_timezone) AS dp, COUNT(*)
	FROM appointments
	GROUP BY simple_topic, dp
	ORDER BY simple_topic, dp
	$$,
	$$
	SELECT DISTINCT date_part('dow', start_time AT TIME ZONE apt_timezone)
	FROM appointments
	ORDER BY 1
	$$
) AS (
	topic_type TEXT,
	sun INT, mon INT, tues INT, wed INT, thur INT, fri INT, sat INT
)
)



COPY cat_counts_over_week
TO '/Users/mcnoren/Desktop/SQL/Homework/cat_counts_over_week.csv'
WITH(FORMAT CSV, HEADER);


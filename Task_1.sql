CREATE TABLE df_subscriber
(
  my_date           DATE,
  event_type1       TEXT,
  user_id           BIGINT
);

COPY df_subscriber
FROM '/home/dataguy/df_subscriber.csv' WITH CSV HEADER DELIMITER ',' ;

COMMIT;

SELECT * FROM df_subscriber
LIMIT 10;

CREATE TABLE df_paying_user
(
  my_date           DATE,
  event_type1       TEXT,
  user_id           BIGINT,
  price             INTEGER
);

COPY df_paying_user
FROM '/home/dataguy/df_paying_user.csv' WITH CSV HEADER DELIMITER ',' ;

COMMIT;

SELECT * FROM df_paying_user
LIMIT 10;


CREATE TABLE df_first_reader
(
  my_date           DATE,
  event_type1       TEXT,
  country           TEXT,
  user_id           BIGINT,
  source            TEXT,
  topic             TEXT
);

COPY df_first_reader
FROM '/home/dataguy/df_first_reader.csv' WITH CSV HEADER DELIMITER ',' ;

COMMIT;

SELECT * FROM df_first_reader
LIMIT 10;

CREATE TABLE df_reg_reader
(
  my_date           DATE,
  event_type1       TEXT,
  country           TEXT,
  user_id           BIGINT,
  topic             TEXT
);

COPY df_reg_reader
FROM '/home/dataguy/df_reg_reader.csv' WITH CSV HEADER DELIMITER ',' ;

COMMIT;

SELECT * FROM df_reg_reader
LIMIT 10;

-- first reader by country
SELECT country, COUNT(*)
FROM df_first_reader
GROUP BY country
ORDER BY COUNT(*) DESC;

--first reader by topic
SELECT topic, COUNT(*)
FROM df_first_reader
GROUP BY topic
ORDER BY COUNT(*) DESC;

--first readers by source
SELECT source, COUNT(*)
FROM df_first_reader
GROUP BY source
ORDER BY COUNT(*) DESC;

--paying user by country
SELECT df_first_reader.country, COUNT(*)
FROM df_first_reader
JOIN df_paying_user 
ON df_first_reader.user_id = df_paying_user.user_id
GROUP BY df_first_reader.country
ORDER BY COUNT(*) DESC;

--paying user by source
SELECT df_first_reader.source, COUNT(*)
FROM df_first_reader
JOIN df_paying_user
ON df_first_reader.user_id = df_paying_user.user_id
GROUP BY df_first_reader.source
ORDER BY COUNT(*) DESC;

--paying user by topic
SELECT df_first_reader.topic, COUNT(*)
FROM df_first_reader
JOIN df_paying_user 
ON df_first_reader.user_id = df_paying_user.user_id
GROUP BY df_first_reader.topic
ORDER BY COUNT(*) DESC;

--regular reader by country
SELECT country, COUNT(*)
FROM df_reg_reader
GROUP BY country
ORDER BY COUNT(*) DESC;

--regular reader by topic
SELECT df_reg_reader.topic, COUNT(*)
FROM df_first_reader
JOIN df_reg_reader
ON df_first_reader.user_id = df_reg_reader.user_id
GROUP BY df_reg_reader.topic
ORDER BY COUNT(*) DESC;

--regular reader by source
SELECT df_first_reader.source, COUNT(*)
FROM df_first_reader
JOIN df_reg_reader
ON df_first_reader.user_id = df_reg_reader.user_id
GROUP BY df_first_reader.source
ORDER BY COUNT(*) DESC;

--subscriber by country
SELECT df_first_reader.country, COUNT(*)
FROM df_first_reader
JOIN df_subscriber
ON df_first_reader.user_id = df_subscriber.user_id
GROUP BY df_first_reader.country
ORDER BY COUNT(*) DESC;

--subscriber by source
SELECT df_first_reader.source, COUNT(*)
FROM df_first_reader
JOIN df_subscriber
ON df_first_reader.user_id = df_subscriber.user_id
GROUP BY df_first_reader.source
ORDER BY COUNT(*) DESC;

--subscriber by topic
SELECT df_first_reader.topic, COUNT(*)
FROM df_first_reader
JOIN df_subscriber
ON df_first_reader.user_id = df_subscriber.user_id
GROUP BY df_first_reader.topic
ORDER BY COUNT(*) DESC;


--trends by source pivot tablehez
SELECT my_date, source, COUNT(*)
FROM df_first_reader
GROUP BY my_date, source
ORDER BY my_date;

--microsegmentations first reader
SELECT topic, source, country, COUNT(*)
FROM df_first_reader
GROUP BY topic, source, country
ORDER BY count DESC;

----microsegmentations reg_eader
SELECT df_reg_reader.topic, df_reg_reader.country, df_first_reader.source, COUNT(*)
FROM df_first_reader
JOIN df_reg_reader
ON df_first_reader.user_id = df_reg_reader.user_id
GROUP BY df_reg_reader.topic, df_reg_reader.country, df_first_reader.source
ORDER BY COUNT(*) DESC;

--microsegments subscriber
SELECT df_first_reader.country, df_first_reader.topic, df_first_reader.source, COUNT(*)
FROM df_first_reader
JOIN df_subscriber
ON df_first_reader.user_id = df_subscriber.user_id
GROUP BY df_first_reader.country, df_first_reader.topic, df_first_reader.source
ORDER BY COUNT(*) DESC;

--microsegments paying_user
SELECT df_first_reader.topic, df_first_reader.country, df_first_reader.source, COUNT(*)
FROM df_first_reader
JOIN df_paying_user 
ON df_first_reader.user_id = df_paying_user.user_id
GROUP BY df_first_reader.topic, df_first_reader.country, df_first_reader.source
ORDER BY COUNT(*) DESC;

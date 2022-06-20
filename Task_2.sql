-- Return on investment calculations

--total revenue for the source
SELECT df_first_reader.source, SUM(df_paying_user.price) AS revenue
FROM df_first_reader
JOIN df_paying_user
ON df_first_reader.user_id = df_paying_user.user_id
GROUP BY df_first_reader.source
ORDER BY revenue DESC;

--total revenue by country
SELECT df_first_reader.country, SUM(df_paying_user.price) AS revenue
FROM df_first_reader
JOIN df_paying_user
ON df_first_reader.user_id = df_paying_user.user_id
GROUP BY df_first_reader.country
ORDER BY revenue DESC;

--total revenue microsegment
SELECT df_first_reader.country, df_first_reader.source, SUM(df_paying_user.price) AS revenue
FROM df_first_reader
JOIN df_paying_user
ON df_first_reader.user_id = df_paying_user.user_id
GROUP BY df_first_reader.country, df_first_reader.source
ORDER BY revenue DESC;

--daily revenue
SELECT my_date, SUM(price) AS revenue
FROM df_paying_user
GROUP BY my_date
ORDER BY my_date;


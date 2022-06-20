--FUNNEL
--STEP 1 first readers
SELECT first_visitor.my_date,
       first_visitor.country,
       first_visitor.source,
       first_visitor.topic,
       first_visitor.firstread,
       regular_visitor.regread,
       subscriber.subscriber,
       payed_8.payer1,
       payed_80.payer2
FROM (SELECT my_date,
             country,
             source,
             topic,
             COUNT(*) AS firstread
      FROM df_first_reader
      GROUP BY my_date,
               country,
               source,
               topic
      ORDER BY my_date DESC) AS first_visitor
  LEFT JOIN
        
--Step 2 reg readers
 (SELECT df_first_reader.my_date,
         df_first_reader.country,
         df_first_reader.source,
         df_first_reader.topic,
         COUNT(DISTINCT (df_reg_reader.user_id)) AS regread
  FROM df_first_reader
    JOIN df_reg_reader ON df_first_reader.user_id = df_reg_reader.user_id
  GROUP BY df_first_reader.my_date,
           df_first_reader.country,
           df_first_reader.source,
           df_first_reader.topic
  ORDER BY my_date DESC) AS regular_visitor
  ON first_visitor.my_date = regular_visitor.my_date
        AND first_visitor.country = regular_visitor.country
        AND first_visitor.source = regular_visitor.source
        AND first_visitor.topic = regular_visitor.topic
        
  LEFT JOIN
        
--STEP 3 subscribers
 (SELECT df_first_reader.my_date,
         df_first_reader.country,
         df_first_reader.source,
         df_first_reader.topic,
         COUNT(df_subscriber.user_id) AS subscriber
  FROM df_first_reader
    JOIN df_subscriber ON df_first_reader.user_id = df_subscriber.user_id
  GROUP BY df_first_reader.my_date,
           df_first_reader.country,
           df_first_reader.source,
           df_first_reader.topic
  ORDER BY my_date DESC) AS subscriber
   ON first_visitor.my_date = subscriber.my_date
        AND first_visitor.country = subscriber.country
        AND first_visitor.source = subscriber.source
        AND first_visitor.topic = subscriber.topic
  LEFT JOIN
         
--STEP 4 paying users 8
 (SELECT df_first_reader.my_date,
         df_first_reader.country,
         df_first_reader.source,
         df_first_reader.topic,
         COUNT(payers1.user_id) AS payer1
  FROM (SELECT user_id,
               COUNT(*)
        FROM df_paying_user
        WHERE price = 8
        GROUP BY user_id) AS payers1
    JOIN df_first_reader ON df_first_reader.user_id = payers1.user_id
  GROUP BY df_first_reader.my_date,
           df_first_reader.country,
           df_first_reader.source,
           df_first_reader.topic
  ORDER BY my_date DESC) AS payed_8
  ON first_visitor.my_date = payed_8.my_date
        AND first_visitor.country = payed_8.country
        AND first_visitor.source = payed_8.source
        AND first_visitor.topic = payed_8.topic
  LEFT JOIN
        
--STEP 5 paying user 80
 (SELECT df_first_reader.my_date,
         df_first_reader.country,
         df_first_reader.source,
         df_first_reader.topic,
         COUNT(payers2.user_id) AS payer2
  FROM (SELECT user_id,
               COUNT(*)
        FROM df_paying_user
        WHERE price = 80
        GROUP BY user_id) AS payers2
    JOIN df_first_reader ON df_first_reader.user_id = payers2.user_id
  GROUP BY df_first_reader.my_date,
           df_first_reader.country,
           df_first_reader.source,
           df_first_reader.topic
  ORDER BY my_date DESC) AS payed_80
   ON first_visitor.my_date = payed_80.my_date
        AND first_visitor.country = payed_80.country
        AND first_visitor.source = payed_80.source
        AND first_visitor.topic = payed_80.topic;


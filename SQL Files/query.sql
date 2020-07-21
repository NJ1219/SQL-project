--To isolate the transactions of any particular cardholder

SELECT c.cardholder_id
, c.cardholder_name
, cc.cardnumber
, t.transation_id
, t.transaction_date
, t.amount
, t.merchant_id
, m.merchant_name
, m.category_id
, mc.category_name
FROM cardholder AS c
LEFT JOIN credit_card AS cc ON c.cardholder_id = cc.cardholder_id
LEFT JOIN transactions AS t ON cc.cardnumber = t.cardnumber
LEFT JOIN merchant AS m ON m.merchant_id = t.merchant_id
LEFT JOIN merchant_category AS mc ON mc.category_id = m.category_id
WHERE c.cardholder_id = 12; 

--To create view for the combined table which can be used to 
-- query more requirements

CREATE VIEW customer AS
SELECT c.cardholder_id
, c.cardholder_name
, cc.cardnumber
, t.transation_id
, t.transaction_date
, t.amount
, t.merchant_id
, m.merchant_name
, m.category_id
, mc.category_name
FROM cardholder AS c
LEFT JOIN credit_card AS cc ON c.cardholder_id = cc.cardholder_id
LEFT JOIN transactions AS t ON cc.cardnumber = t.cardnumber
LEFT JOIN merchant AS m ON m.merchant_id = t.merchant_id
LEFT JOIN merchant_category AS mc ON mc.category_id = m.category_id
WHERE c.cardholder_id = 12; 


--To extract data for transactions between 7 am and 9 am.
SELECT c.cardholder_id
, c.cardholder_name
, cc.cardnumber
, t.transation_id
, t.transaction_date
, t.amount
, t.merchant_id
, m.merchant_name
, m.category_id
, mc.category_name
FROM cardholder AS c
LEFT JOIN credit_card AS cc ON c.cardholder_id = cc.cardholder_id
LEFT JOIN transactions AS t ON cc.cardnumber = t.cardnumber
LEFT JOIN merchant AS m ON m.merchant_id = t.merchant_id
LEFT JOIN merchant_category AS mc ON mc.category_id = m.category_id
WHERE EXTRACT(HOUR FROM t.transaction_date)>= 7 AND EXTRACT(HOUR FROM t.transaction_date)<9
ORDER BY t.amount DESC LIMIT 100;


--Transaction data for transactional value of less than $2

SELECT c.cardholder_id
, c.cardholder_name
, count(t.transation_id)

FROM cardholder AS c
LEFT JOIN credit_card AS cc ON c.cardholder_id = cc.cardholder_id
LEFT JOIN transactions AS t ON cc.cardnumber = t.cardnumber

WHERE t.amount<2
GROUP BY c.cardholder_name, c.cardholder_id
ORDER BY  count(transation_id)  DESC ;


--merchants prone to hacking attempts
SELECT m.merchant_name
, m.merchant_id
, mc.category_name
, count(t.transation_id)

FROM transactions AS t
LEFT JOIN merchant AS m ON m.merchant_id = t.merchant_id
LEFT JOIN merchant_category as mc on m.category_id = mc.category_id

WHERE t.amount<2
GROUP BY m.merchant_name, m.merchant_id, mc.category_name
ORDER BY  count(transation_id)  DESC ;


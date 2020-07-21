# Week-7-SQL-project

In this assignment, I have used my SQL skills to analyze historical credit card transactions and consumption patterns in order to identify possible fraudulent transactions.

## Files Used

* [card_holder.csv](Data/card_holder.csv)
* [credit_card.csv](Data/credit_card.csv)
* [merchant.csv](Data/merchant.csv)
* [merchant_category.csv](Data/merchant_category.csv)
* [transaction.csv](Data/transaction.csv)

### The assignment is done in 3 steps.
### Data Modeling

Created an entity relationship diagram (ERD) by inspecting the provided CSV files.
*[Quick Database Diagram](Quick_DBD.png)


There are 5 tables that I created which are shown in the diagram along with the relationships to define among the tables.



### Data Engineering

Using your database model as a blueprint, I created a database schema for each of your tables and relationships which include data types, primary keys, foreign keys, and any other constraints I defined. The ERD file, schema, seed and query files are stored in the folder "SQL Files"


### Data Analysis

Finally, the data analysis is done through importing the queries and the related data to Jupyter Notebook and is analysed using Python.

* How can you isolate (or group) the transactions of each cardholder?
### --Query
--
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
LEFT JOIN merchant_category AS mc ON mc.category_id = m.category_id;
--WHERE c.cardholder_id = 12; 
--

The above query will fetch all the records based on a particular customer and further operations can be performed by creating a view and specifying the cardholder_id in the query. 


-----
* Consider the time period 7:00 a.m. to 9:00 a.m.
* What are the top 100 highest transactions during this time period?
### Query 

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
-

  * Do you see any fraudulent or anomalous transactions?
    * Yes. There seems to be 2 possible fraudulent transactions.

  * If you answered yes to the previous question, explain why you think there might be fraudulent transactions during this time frame.
    
    There are 9 spends of more than $1000 in Pubs, bars and restaurants in early morning but few of them are repetitive spends and can point to consumer regular habit. 
      * Transaction ids 3163, 968 and 1368 are by the same person at different times and can point to all night parties and the large amount points towards a group. The person may be settling the bill in the morning.
      * Similar conclusion could be for transaction ids 2451 and 1442 as it is also by the same person.
      * For transaction ids 2840, 774 and 1620, a further confirmation call is required to acertain the rightful spend of the amount. Transactions 2840 and 774 is done by the same person and transaction id 774 is for $100 in a coffee shop.
      * Transaction id 1620 seems to be fraudulent or mistaken transactions and needs further investigation. It is an expense of $1009 at a coffee shop. 
---

* Some fraudsters hack a credit card by making several small payments (generally less than $2.00), which are typically ignored by cardholders. Count the transactions that are less than $2.00 per cardholder. Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.

SELECT c.cardholder_id
, c.cardholder_name
, count(t.transation_id)

FROM cardholder AS c
LEFT JOIN credit_card AS cc ON c.cardholder_id = cc.cardholder_id
LEFT JOIN transactions AS t ON cc.cardnumber = t.cardnumber

WHERE t.amount<2
GROUP BY c.cardholder_name, c.cardholder_id
ORDER BY  count(transation_id)  DESC ;

The above query returns the list of customers with the total number of transactions of less than $2 for each cardholder. After that, the first query can be run again by changing the cardholder_id for each query and putting in another clause for transaction amount of less than $2. Then the results can be analysed further in detail.

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
WHERE c.cardholder_id = 12 AND t.amount<2; 

---
The tranasactions for top 5 cardholders with the most number of transactions worth less than $2 were analysed. There seems to be no proof regarding the hacking of any credit card as the transactions are spaced out in date. 




* What are the top 5 merchants prone to being hacked using small transactions?

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


Food Trucks and Coffee Shops may have a lot of transactions which are less than $2, so no conclusion can be derived on it.But for pubs, bars and resaturants, a payment of $2 might be suspicious. The following list contains 5 such merchants along with their category and number of transactions less than $2. 

    1. Wood-Ramirez, Bar, 7 counts of less than $2 transactions
    2. Hood-Phillips, Bar, 6 counts of less than $2 transactions
    3. Jarvis-Turner, Pub, 5 counts of less than $2 transactions
    4. Riggs-Adams, Restaurant, 5 counts of less than $2 transactions
    5. Walker, Deleon and Wolf, Restaurant, 5 counts of less than $2 transactions
  

  
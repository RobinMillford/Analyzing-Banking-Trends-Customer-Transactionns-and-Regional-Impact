use DB;

select * from user_nodes;

--the number of users assigned to each region
SELECT wr.region_name, COUNT(u.region_id) AS num_users
FROM world_regions wr
LEFT JOIN user_nodes u ON wr.region_id = u.region_id
GROUP BY wr.region_name;

-- user who made the largest deposit
SELECT TOP 1 t.consumer_id, t.transaction_amount AS deposit_amount, t.transaction_type
FROM user_transaction t
WHERE t.transaction_type = 'Deposit'
ORDER BY t.transaction_amount DESC;

-- total amount deposited for each user in the "Europe" region
SELECT u.consumer_id, SUM(t.transaction_amount) AS total_deposit
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
JOIN world_regions wr ON u.region_id = wr.region_id
WHERE wr.region_name = 'Europe' AND t.transaction_type = 'Deposit'
GROUP BY u.consumer_id;

-- total number of transactions made by each user in the "United States
SELECT u.consumer_id, COUNT(t.consumer_id) AS total_transactions
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
JOIN world_regions wr ON u.region_id = wr.region_id
WHERE wr.region_name = 'United States'
GROUP BY u.consumer_id;

-- total number of users who made more than 5 transactions
SELECT COUNT(*) AS total_users
FROM (
    SELECT consumer_id, COUNT(*) AS transaction_count
    FROM user_transaction
    GROUP BY consumer_id
    HAVING COUNT(*) > 5
) AS users_with_more_than_5_transactions;

-- the regions with the highest number of nodes assigned to them
SELECT wr.region_name, COUNT(u.node_id) AS num_nodes
FROM world_regions wr
JOIN user_nodes u ON wr.region_id = u.region_id
GROUP BY wr.region_name
HAVING COUNT(u.node_id) = (
    SELECT MAX(node_count)
    FROM (
        SELECT wr.region_id, COUNT(u.node_id) AS node_count
        FROM world_regions wr
        JOIN user_nodes u ON wr.region_id = u.region_id
        GROUP BY wr.region_id
    ) AS node_counts
);

-- user who made the largest deposit amount in the "Australia" region
SELECT 
Top 1
u.consumer_id, MAX(t.transaction_amount) AS largest_deposit_amount
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
JOIN world_regions wr ON u.region_id = wr.region_id
WHERE wr.region_name = 'Australia' AND t.transaction_type = 'Deposit'
GROUP BY u.consumer_id
ORDER BY largest_deposit_amount DESC;

-- total amount deposited by each user in each region
SELECT u.consumer_id, wr.region_name, SUM(t.transaction_amount) AS total_amount_deposited
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
JOIN world_regions wr ON u.region_id = wr.region_id
WHERE t.transaction_type = 'Deposit'
GROUP BY u.consumer_id, wr.region_name;

-- the total number of transactions for each region
SELECT wr.region_name, COUNT(*) AS total_transactions
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
JOIN world_regions wr ON u.region_id = wr.region_id
GROUP BY wr.region_name;

-- the total deposit amount for each region
SELECT wr.region_name, SUM(t.transaction_amount) AS total_deposit_amount
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
JOIN world_regions wr ON u.region_id = wr.region_id
WHERE t.transaction_type = 'Deposit'
GROUP BY wr.region_name;

--  the top 5 consumers who have made the highest total transaction amount
SELECT 
Top 5 u.consumer_id, SUM(t.transaction_amount) AS total_transaction_amount
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
WHERE t.transaction_type = 'Deposit'
GROUP BY u.consumer_id
ORDER BY total_transaction_amount DESC;

-- many consumers are allocated to each region
SELECT wr.region_name, COUNT(DISTINCT u.consumer_id) AS consumers_count
FROM world_regions wr
LEFT JOIN user_nodes u ON wr.region_id = u.region_id
GROUP BY wr.region_name;

-- the unique count and total amount for each transaction type,
SELECT transaction_type,
       COUNT(DISTINCT consumer_id) AS unique_count,
       SUM(transaction_amount) AS total_amount
FROM user_transaction
GROUP BY transaction_type;

-- 14. the average deposit counts and amounts for each transaction type ('deposit') across all customers
SELECT transaction_type,
       AVG(count_per_type) AS avg_deposit_count,
       AVG(amount_per_type) AS avg_deposit_amount
FROM (
    SELECT transaction_type,
           COUNT(*) AS count_per_type,
           AVG(transaction_amount) AS amount_per_type
    FROM user_transaction
    WHERE transaction_type = 'Deposit'
    GROUP BY transaction_type
) AS subquery
GROUP BY transaction_type;

-- 15. many transactions were made by consumers from each region
SELECT wr.region_name, COUNT(*) AS transaction_count
FROM user_transaction t
JOIN user_nodes u ON t.consumer_id = u.consumer_id
JOIN world_regions wr ON u.region_id = wr.region_id
GROUP BY wr.region_name;
create database Smartphone_db
CREATE TABLE Smatphone_ (
brand_name VARCHAR(50),	
model VARCHAR(100),	
price INT,	
rating VARCHAR(20)NULL,	
has_5g VARCHAR(10),
has_nfc	VARCHAR(10),
has_ir_blaster VARCHAR(10),	
processor_brand	VARCHAR(50),	
processor_speed	VARCHAR(30)NULL,
battery_capacity VARCHAR(20)NULL,	
fast_charging_available	BOOLEAN,
fast_charging	VARCHAR(30),
ram_capacity	INT,
internal_memory	INT,
screen_size  FLOAT,  
refresh_rate INT,
num_rear_cameras INT,	
num_front_cameras VARCHAR(30)NULL,
os	VARCHAR(50),
primary_camera_rear FLOAT,	
primary_camera_front INT NULL,	
extended_memory_available BOOLEAN,	
extended_upto VARCHAR(30),	
resolution_width INT,	
resolution_height INT);
Select * from smatphone_
# which brands are available in the dataset?
SELECT DISTINCT brand_name
FROM Smatphone_;
# How many smartphones does each brand offer?
SELECT brand_name, COUNT(*) AS NumberOfSmartphones
FROM smatphone_
GROUP BY brand_name
ORDER BY NumberOfSmartphones DESC;
# What is the average price of smartphones by brand?
SELECT brand_name, AVG(price) AS average_price
FROM smatphone_
GROUP BY brand_name
ORDER BY average_price DESC;
#  Which smartphones have 5G support?
SELECT brand_name, model, Price
FROM Smatphone_
WHERE has_5G = 'TRUE';
# What are the top 5 highest-rated smartphones?
SELECT brand_name, model, rating
FROM smatphone_
ORDER BY Rating DESC
LIMIT 5;
# List smartphones with more than 128 GB storage and less than ₹30,000 price?
SELECT brand_name, model, internal_memory, price
FROM smatphone_
WHERE internal_memory > 128 AND price < 30000;
# Find the most common operating system used in the dataset.
Select os, count(*) as Count_
FROM smatphone_
GROUP BY os
ORDER BY Count_ DESC LIMIT 1;
# Compare average ratings for smartphones with and without 5G.
SELECT has_5G, AVG(rating) AS avg_rating
FROM Smatphone_
GROUP BY has_5G;
# Which brand has the highest average rating for smartphones under ₹25,000?
SELECT brand_name, AVG(rating) AS avg_rating
FROM Smatphone_
WHERE Price < 25000
GROUP BY brand_name
ORDER BY avg_rating DESC
LIMIT 1;
# What is the distribution of smartphones by price range (under 15k, 15k–30k, above 30k)?
SELECT
  CASE 
    WHEN price < 15000 THEN 'Under 15K'
    WHEN price BETWEEN 15000 AND 30000 THEN '15K-30K'
    ELSE 'Above 30K'
  END AS price_range,
  COUNT(*) AS Smartphone_Count
FROM Smatphone_
GROUP BY price_range;

SELECT 
    model,
    price,
    CASE 
        WHEN price < 15000 THEN 'Under 15k'
        WHEN price BETWEEN 15000 AND 30000 THEN '15k–30k'
        ELSE 'Above 30k'
    END AS price_range
FROM smatphone_;
# Which brand offers the best battery capacity-to-price ratio?
SELECT brand_name, model, battery_capacity, price, ROUND(battery_capacity / price,2) AS battery_price_ratio
FROM smatphone_
ORDER BY battery_price_ratio DESC
LIMIT 5;
#List smartphones that are top-rated (rating > 4.2) and have at least 8 GB RAM and 128 GB storage.
SELECT brand_name, model, rating, ram_capacity, internal_memory
FROM Smatphone_
WHERE rating > 4.2 AND ram_capacity >= 8 AND internal_memory>= 128
ORDER BY rating DESC;
# Find the average price and rating of smartphones grouped by 5G support.
SELECT model,  has_5G, 
       AVG(price) AS avg_price, 
       AVG(rating) AS avg_rating
FROM smatphone_
where has_5G = 'TRUE'
GROUP BY model, has_5G;
# What is the percentage share of 5G smartphones for each brand, and which brand has the highest 5G penetration?
SELECT brand_name,
       COUNT(*) AS total_models,
       SUM(CASE WHEN Has_5G = 'TRUE' THEN 1 ELSE 0 END) AS models_with_5G,
       ROUND(100.0 * SUM(CASE WHEN Has_5G = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*), 2) AS 5G_percentage
FROM smatphone_
GROUP BY brand_name
ORDER BY 5G_percentage DESC;
#Rank smartphones within each brand based on rating, and find the top 2 highest-rated models per brand.
SELECT brand_name, model, rating,rank_perbrand
FROM (
  SELECT brand_name, model, rating,
         RANK() OVER (PARTITION BY brand_name ORDER BY rating DESC) AS rank_perbrand
  FROM smatphone_
) AS Ranked
WHERE rank_perBrand <= 2
ORDER BY  rank_perbrand ASC
#Find the most cost-efficient smartphone per brand with minimum 8GB RAM and 128GB storage
SELECT brand_name, model, price, ram_capacity, internal_memory
FROM smatphone_
WHERE ram_capacity >= 8 AND internal_memory >= 128 AND Price = (
  SELECT MIN(Price)
  FROM smatphone_ s2
  WHERE s2.brand_name = smatphone_.brand_name AND ram_capacity >= 8 AND internal_memory >= 128
)
ORDER BY brand_name;
# Which combination of RAM and Storage is most popular, and what’s the average price and rating for each configuration?
SELECT ram_capacity, internal_memory, COUNT(*) AS model_count,
       ROUND(AVG(price), 2) AS avg_price,
       ROUND(AVG(rating), 2) AS avg_rating
FROM smatphone_
GROUP BY ram_capacity, internal_memory
ORDER BY model_count DESC
LIMIT 5;

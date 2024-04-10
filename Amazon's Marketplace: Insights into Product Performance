/*
Strategic Insights with SQL: Amazon Product Performance
*/

SELECT *
FROM AmazonData.dbo.amazon_products;

---------------------------------------------------------------------------------------------------------
-- Determine which category has the most products that were bought in the last month and the average review count for these products. 
-- This query indicates the most popular categories based on last month's sales and 
-- shows which categories have higher customer engagement through review counts.
SELECT
	  category_name
	, COUNT(*) AS products_sold_last_month
	, AVG(reviews) AS average_reviews
FROM AmazonData.dbo.amazon_products
GROUP BY category_name
ORDER BY 
	  products_sold_last_month DESC
	, average_reviews DESC;

---------------------------------------------------------------------------------------------------------
-- Calculate the average discount provided and its effect on whether the product is a bestseller.
-- Updates list prices to match selling prices where necessary, then reveals the relationship 
-- between average discounts in each category and their impact on making products bestsellers.

UPDATE amazon_products
SET listPrice = price
where listPrice = 0 OR listPrice is null;

SELECT
	  category_name
	, AVG(listPrice - price) AS average_discount
	, COUNT(CASE WHEN isBestSeller = 'TRUE' THEN 1 END) as bestseller_count
FROM AmazonData.dbo.amazon_products
GROUP BY category_name
ORDER BY average_discount DESC;
  

---------------------------------------------------------------------------------------------------------
-- Compare the average number of units sold of discounted versus non-discounted products.
-- Distinguishes between discounted and non-discounted products to show how discounting 
-- affects the average number of units sold, indicating the effectiveness of discounts on sales.

SELECT 
    discount_present,
    AVG(boughtInLastMonth) AS average_units_sold
FROM 
    (SELECT 
        (CASE WHEN (price < listPrice) THEN 'Discounted' ELSE 'Non-Discounted' END) AS discount_present,
        boughtInLastMonth
     FROM 
        AmazonData.dbo.amazon_products) AS discounted_products
GROUP BY 
    discount_present;

---------------------------------------------------------------------------------------------------------
-- Find the top 20 products with the highest sales in the last month across all categories.
-- Identifies the 20 highest-selling products from the last month, providing insight into 
-- current consumer preferences and popular products across categories.

SELECT 
    TOP 20 
	title
	, category_name
    , boughtInLastMonth
FROM 
    AmazonData.dbo.amazon_products
ORDER BY 
    boughtInLastMonth DESC
	, category_name;

---------------------------------------------------------------------------------------------------------
-- Identify the number of bestsellers in each category and their average rating.
-- Shows which categories have the most bestsellers and their average star ratings, potentially 
-- indicating product quality and popularity within those categories.
SELECT 
      category_name
    , AVG(stars) AS average_rating
    , COUNT(*) AS number_of_bestsellers
FROM 
    AmazonData.dbo.amazon_products
WHERE 
    isBestSeller = 'TRUE'
GROUP BY 
    category_name
ORDER BY 
    number_of_bestsellers DESC, average_rating DESC;

---------------------------------------------------------------------------------------------------------
-- Analyze the correlation between the number of reviews and the average star rating of products.
-- Examines the relationship between the star ratings of products and the average number of reviews,
-- suggesting how customer feedback volume correlates with product ratings.

SELECT 
    stars,
    AVG(reviews) AS average_reviews,
    COUNT(*) AS number_of_products
FROM 
    AmazonData.dbo.amazon_products
GROUP BY 
    stars
ORDER BY 
    stars DESC;

---------------------------------------------------------------------------------------------------------
-- Identify the price range with the highest sales volume and the number of best sellers in each price range.
-- Analyzes sales volume and counts of bestsellers within specific price ranges to understand 
-- consumer price sensitivity and identify successful price points for bestsellers.

SELECT 
    price_range
    , SUM(boughtInLastMonth) AS total_units_sold
	, COUNT(CASE WHEN isBestSeller = 'TRUE' THEN 1 END) AS bestseller_count
FROM 
    (SELECT 
        CASE 
            WHEN price < 50 THEN 'Under $50'
            WHEN price BETWEEN 50 AND 100 THEN '$50 - $100'
            WHEN price BETWEEN 100 AND 150 THEN '$100 - $150'
            WHEN price BETWEEN 150 AND 200 THEN '$150 - $200'
            WHEN price BETWEEN 200 AND 250 THEN '$200 - $250'
            WHEN price BETWEEN 250 AND 300 THEN '$250 - $300'
            WHEN price BETWEEN 300 AND 350 THEN '$300 - $350'
            WHEN price BETWEEN 350 AND 400 THEN '$350 - $400'
            WHEN price > 400 THEN 'Above $400'
            ELSE 'Not specified' 
        END AS price_range,
        boughtInLastMonth
     FROM 
        AmazonData.dbo.amazon_products
		WHERE isBestSeller = 'TRUE') AS price_ranges
GROUP BY 
    price_range
ORDER BY 
    total_units_sold DESC;

---------------------------------------------------------------------------------------------------------

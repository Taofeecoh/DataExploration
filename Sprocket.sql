/* Check relations */
SELECT * FROM CusDemographs;
SELECT * FROM NewCustomers;
SELECT * FROM Transactions;
SELECT * FROM CusAddress

/* Change date format in Tables */
SELECT CONVERT(date, DOB) Birthdate
FROM CusDemographs;

SELECT CONVERT(date, transaction_date) TransDate, 
CONVERT(date, product_first_sold_date) FirstSale
FROM Transactions

/* Merge Tables */
SELECT *
FROM Transactions Tr
FULL JOIN CusDemographs De
	ON(Tr.customer_id = De.customer_id)
FULL JOIN CusAddress Ad
	ON(De.customer_id = Ad.customer_id)
--WHERE tr.customer_id IS NULL;

/* Choose target variables in joined tables*/
SELECT De.last_name, De.first_name, Tr.customer_id, Tr.transaction_id, Tr.product_id, Tr.brand, Tr.transaction_date, 
	Tr.standard_cost, Tr.list_price, Tr.Profit, Tr.product_first_sold_date, Tr.online_order, Tr.product_line,
	De.gender, De.Age, De.[Age bracket], De.past_3_years_bike_related_purchases, De.job_industry_category, De.job_title,
	De.wealth_segment, De.owns_car, Ad.state, Ad.postcode, Ad.property_valuation
FROM Transactions Tr
LEFT JOIN CusDemographs De
	ON (Tr.customer_id = De.customer_id)
FULL JOIN CusAddress Ad
	ON (De.customer_id = Ad.customer_id);

/* Temp table */
DROP TABLE IF EXISTS #SprocketTemp
CREATE TABLE #SprocketTemp(
Last_name NVARCHAR(255), 
First_name NVARCHAR(255), 
Customer_id FLOAT NULL, 
Transaction_id FLOAT NULL, 
Product_id FLOAT NULL, 
Brand NVARCHAR(255), 
Transaction_date DATE NULL, 
Standard_cost MONEY NULL, 
List_price MONEY NULL, 
Profit MONEY NULL, 
Product_first_sale DATE NULL, 
Online_order BIT NULL, 
Product_line NVARCHAR(255),
Gender NVARCHAR(255), 
Age TINYINT NULL, 
AgeBracket NVARCHAR(255), 
Past_3_years_bike_related_purchases FLOAT NULL,
Job_industry_category NVARCHAR(255), 
Job_title NVARCHAR(255),
Wealth_segment NVARCHAR(255), 
Owns_car NVARCHAR(255), 
State NVARCHAR(255),
Postcode FLOAT NULL, 
Property_valuation FLOAT NULL
);
INSERT INTO #SprocketTemp
SELECT De.last_name, De.first_name, Tr.customer_id, Tr.transaction_id, Tr.product_id, Tr.brand, Tr.transaction_date, 
	Tr.standard_cost, Tr.list_price, Tr.Profit, Tr.product_first_sold_date, Tr.online_order, Tr.product_line,
	De.gender, De.Age, De.[Age bracket], De.past_3_years_bike_related_purchases, De.job_industry_category, De.job_title,
	De.wealth_segment, De.owns_car, Ad.state, Ad.postcode, Ad.property_valuation
FROM Transactions Tr
LEFT JOIN CusDemographs De
	ON (Tr.customer_id = De.customer_id)
FULL JOIN CusAddress Ad
	ON (De.customer_id = Ad.customer_id);

/* Insert Calculated field to fix missing profit values) */
UPDATE #SprocketTemp
SET Profit = (List_price - Standard_cost) 
WHERE Profit IS NULL AND (List_price IS NOT NULL AND Standard_cost IS NOT NULL);

SELECT *
FROM #SprocketTemp
ORDER BY Transaction_date DESC;

/* Move temp to a full table for export */
DROP TABLE IF EXISTS FinalRel
CREATE TABLE FinalRel (
Last_name NVARCHAR(255), 
First_name NVARCHAR(255), 
Customer_id FLOAT NULL, 
Transaction_id FLOAT NULL, 
Product_id FLOAT NULL, 
Brand NVARCHAR(255), 
Transaction_date DATE NULL, 
Standard_cost MONEY NULL, 
List_price MONEY NULL, 
Profit MONEY NULL, 
Product_first_sale DATE NULL, 
Online_order BIT NULL, 
Product_line NVARCHAR(255),
Gender NVARCHAR(255), 
Age TINYINT NULL, 
AgeBracket NVARCHAR(255), 
Past_3_years_bike_related_purchases FLOAT NULL,
Job_industry_category NVARCHAR(255), 
Job_title NVARCHAR(255),
Wealth_segment NVARCHAR(255), 
Owns_car NVARCHAR(255), 
State NVARCHAR(255),
Postcode FLOAT NULL, 
Property_valuation FLOAT NULL
);
INSERT INTO FinalRel(Last_name,First_name,Customer_id,Transaction_id,Product_id,Brand, 
			Transaction_date, Standard_cost, List_price,Profit,Product_first_sale,Online_order,Product_line,
			Gender,Age, AgeBracket, Past_3_years_bike_related_purchases,Job_industry_category,Job_title,
			Wealth_segment, Owns_car,State,Postcode,Property_valuation)
SELECT * FROM #SprocketTemp
SELECT * FROM FinalRel

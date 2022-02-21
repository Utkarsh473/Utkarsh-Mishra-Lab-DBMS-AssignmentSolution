CREATE database if not exists Ecommerce;

USE Ecommerce;

CREATE TABLE IF NOT EXISTS Supplier(
SUPP_ID int primary key, 
SUPP_NAME varchar(50), 
SUPP_CITY varchar(50) ,
SUPP_PHONE varchar(10));

CREATE TABLE IF NOT EXISTS Customer(
CUS_ID int NOT NULL,
CUS_NAME varchar(50),
CUS_PHONE varchar(50),
CUS_CITY varchar(50),
CUS_GENDER char,
PRIMARY KEY (CUS_ID)
);

CREATE TABLE IF NOT EXISTS Category(
CAT_ID int NOT NULL,
CAT_NAME varchar(50),
PRIMARY KEY(CAT_ID)
);

CREATE TABLE IF NOT EXISTS Product(
PRO_ID int primary key,
PRO_NAME varchar(50),
PRO_DESC varchar(50),
CAT_ID int,
FOREIGN KEY(CAT_ID) REFERENCES Category(CAT_ID)
);

-- DROP TABLE ProductDetails;
CREATE TABLE IF NOT EXISTS ProductDetails(
PROD_ID int,
PRO_ID int,
SUPP_ID int,
PRICE int,
PRIMARY KEY (PROD_ID),
FOREIGN KEY(SUPP_ID) REFERENCES Supplier(`SUPP_ID`)
);

ALTER TABLE ProductDetails
ADD FOREIGN KEY(PRO_ID) REFERENCES Product(PRO_ID);

CREATE TABLE IF NOT EXISTS `order` 
( `ORD_ID` INT NOT NULL, 
`ORD_AMOUNT` INT NOT NULL, 
`ORD_DATE` DATE, 
`CUS_ID` INT NOT NULL, 
`PROD_ID` INT NOT NULL, 
PRIMARY KEY (`ORD_ID`), 
FOREIGN KEY (`CUS_ID`) REFERENCES Customer(`CUS_ID`), 
FOREIGN KEY (`PROD_ID`) REFERENCES ProductDetails(`PROD_ID`) 
); 

CREATE TABLE IF NOT EXISTS `rating` ( 
`RAT_ID` INT NOT NULL, 
`CUS_ID` INT NOT NULL, 
`SUPP_ID` INT NOT NULL, 
`RAT_RATSTARS` INT NOT NULL, 
PRIMARY KEY (`RAT_ID`), 
FOREIGN KEY (`SUPP_ID`) REFERENCES Supplier (`SUPP_ID`), 
FOREIGN KEY (`CUS_ID`) REFERENCES Customer(`CUS_ID`) ); 


----- Insert queries ----- 
insert into `Supplier` values(1,"Rajesh Retails","Delhi",'1234567890');
insert into `Supplier` values(2,"Appario Ltd.","Mumbai",'2589631470'); 
insert into `Supplier` values(3,"Knome products","Banglore",'9785462315'); 
insert into `Supplier` values(4,"Bansal Retails","Kochi",'8975463285'); 
insert into `Supplier` values(5,"Mittal Ltd.","Lucknow",'7898456532'); 


-- CUSTOMER 
INSERT INTO `Customer` VALUES(1,"AAKASH",'9999999999',"DELHI",'M'); 
INSERT INTO `Customer` VALUES(2,"AMAN",'9785463215',"NOIDA",'M'); 
INSERT INTO `Customer` VALUES(3,"NEHA",'9999999999',"MUMBAI",'F'); 
INSERT INTO `Customer` VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F'); 
INSERT INTO `Customer` VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M'); 


-- Category 
INSERT INTO `Category` VALUES( 1,"BOOKS"); 
INSERT INTO `Category` VALUES(2,"GAMES"); 
INSERT INTO `Category` VALUES(3,"GROCERIES"); 
INSERT INTO `Category` VALUES (4,"ELECTRONICS"); 
INSERT INTO `Category` VALUES(5,"CLOTHES"); 

-- Product 
INSERT INTO `Product` VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2); 
INSERT INTO `Product` VALUES(2,"TSHIRT","DFDFJDFJDKFD",5); 
INSERT INTO `Product` VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4); 
INSERT INTO `Product` VALUES(4,"OATS","REURENTBTOTH",3); 
INSERT INTO `Product` VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1); 


-- ProductDetails 
INSERT INTO ProductDetails VALUES(1,1,2,1500); 
INSERT INTO ProductDetails VALUES(2,3,5,30000); 
INSERT INTO ProductDetails VALUES(3,5,1,3000); 
INSERT INTO ProductDetails VALUES(4,2,3,2500); 
INSERT INTO ProductDetails VALUES(5,4,1,1000); 

INSERT INTO `order` VALUES (50,2000,"2021-10-06",2,1); 
INSERT INTO `order` VALUES(20,1500,"2021-10-12",3,5); 
INSERT INTO `order` VALUES(25,30500,"2021-09-16",5,2); 
INSERT INTO `order` VALUES(26,2000,"2021-10-05",1,1); 
INSERT INTO `order` VALUES(30,3500,"2021-08-16",4,3); 

INSERT INTO `rating` VALUES(1,2,2,4); 
INSERT INTO `rating` VALUES(2,3,4,3); 
INSERT INTO `rating` VALUES(3,5,1,5); 
INSERT INTO `rating` VALUES(4,1,3,2); 
INSERT INTO `rating` VALUES(5,4,5,4); 

-- 3. Display the number of the customer group by their genders 
-- who have placed any order of amount greater than or equal to Rs.3000.

SELECT CUS_GENDER, count(cust.CUS_ID)
FROM Customer AS cust
LEFT JOIN `order` AS ordr
ON cust.CUS_ID = ordr.CUS_ID
WHERE ordr.ORD_AMOUNT >= 3000
GROUP BY cust.CUS_GENDER;

-- 4. Display all the orders along with the product name 
-- ordered by a customer having Customer_Id=2.


SELECT ord.* , pro.PRO_NAME
FROM `order` as ord
INNER JOIN ProductDetails AS pd
ON ord.PROD_ID = pd.PROD_ID 
INNER JOIN Product AS pro
ON pd.PRO_ID = pro.PRO_ID
WHERE ord.CUS_ID = 2;

-- 5. Display the Supplier details who can supply more than one product

SELECT s.*
FROM ProductDetails as pd
INNER JOIN Supplier as s
ON s.SUPP_ID = pd.SUPP_ID
GROUP BY (pd.SUPP_ID)
HAVING count(pd.SUPP_ID) >1;

-- 6. Find the category of the product whose order amount is minimum.
SELECT *
FROM Category
WHERE CAT_ID =
(SELECT Category.CAT_ID
FROM `order` AS ord
INNER JOIN ProductDetails AS pd 
ON ord.PROD_ID = pd.PROD_ID 
INNER JOIN Product AS pro
ON pd.PRO_ID = pro.PRO_ID
INNER JOIN Category
ON Category.CAT_ID = pro.CAT_ID
ORDER BY ord.ORD_AMOUNT limit 1
);

-- 7. Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT p.PRO_ID, p.PRO_NAME
FROM `order` ord
INNER JOIN ProductDetails AS pd
ON ord.PROD_ID = pd.PROD_ID 
INNER JOIN Product AS p
ON pd.PRO_ID = p.PRO_ID
WHERE ord.ORD_DATE > '2021-10-05';

-- 8. Display customer name and gender whose names start or end with character 'A'.

SELECT CUS_NAME, CUS_GENDER 
FROM Customer
WHERE CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A';

-- 9. Create a stored procedure to display the Rating for a Supplier 
-- if any along with the Verdict on that rating if any like 
-- if rating >4 then “Genuine Supplier” 
-- if rating >2 “Average Supplier” 
-- else “Supplier should not be considered”.

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `RatingAndVerdict`()
BEGIN
SELECT Supplier.SUPP_ID, Supplier.SUPP_NAME,rating.RAT_RATSTARS,
CASE
WHEN rating.RAT_RATSTARS > 4 THEN 'Genuine Supplier'
WHEN rating.RAT_RATSTARS > 2 THEN 'Average Supplier'
ELSE 'Supplier should not be considered'
END AS verdict FROM rating INNER JOIN Supplier ON rating.SUPP_ID = Supplier.SUPP_ID;
END//
DELIMITER ;

call RatingAndVerdict();






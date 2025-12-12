--PAN Number Validation Project Using Postgresql

--Creating table for importing the csv file
CREATE TABLE pan_number_dataset(
		Pan_Numbers varchar(100)
);

SELECT * FROM pan_number_dataset;

--Importing csv file in the table
COPY pan_number_dataset(Pan_Numbers)
FROM 'C:\Users\Home\Desktop\Data Analyst\sql\pan_number_validation\PAN Number Validation Dataset.csv'
CSV HEADER;

--Data cleaning

--Handling missing values
SELECT * FROM pan_number_dataset WHERE Pan_Numbers IS NULL;

--Checks for duplicates
SELECT Pan_Numbers,COUNT(Pan_Numbers)
FROM pan_number_dataset
GROUP BY Pan_Numbers
HAVING COUNT(Pan_Numbers)>1;

--Handling the spaces
SELECT *
FROM pan_number_dataset
WHERE Pan_Numbers != trim(Pan_Numbers);

--Correct letter case
SELECT * 
FROM pan_number_dataset
WHERE Pan_Numbers != UPPER(Pan_Numbers);

--Cleaned Pan Numbers
SELECT DISTINCT(UPPER(TRIM(Pan_Numbers)))
FROM pan_number_dataset
WHERE Pan_Numbers IS NOT NULL 
      AND
	  TRIM(Pan_Numbers) !='';

--Function to check if adjacent characters are same....passing only first 5 characters
CREATE OR REPLACE FUNCTION check_adjacent_letters(str text)
RETURNS boolean
LANGUAGE plpgsql
AS $$
BEGIN
	FOR i IN 1 .. LENGTH(str)-1
	LOOP
		IF SUBSTRING(str,i,1)= SUBSTRING(str,i+1,1)
		THEN 
			RETURN true; -- characters are adjacent
		END IF;
	END LOOP;
	RETURN false; --None of the characters are adjacent to each other
END;
$$

--Function to check if sequential characters are used or not
CREATE OR REPLACE FUNCTION check_sequential_characters(str text)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
	flag boolean :=false;
BEGIN
	FOR i IN 1 .. LENGTH(str)-1
	LOOP
		IF ASCII(SUBSTRING(str,i+1,1))-ASCII(SUBSTRING(str,i,1))=1
		THEN 
			flag:=true;
		ELSE
			flag:=false;
			EXIT;
		END IF;
	END LOOP;
	RETURN flag;
END;
$$

SELECT check_sequential_characters('VWXYZ');
SELECT check_adjacent_letters('VWXYZ');

--Regular Expression to validate pattern and structure of pan number
SELECT *
FROM pan_number_dataset
WHERE Pan_Numbers ~ '^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
-- ^ means the first character should be alphabet range from [A-Z] 
-- and number of characters should be 5, then next 4 characters will be digits, last character will be alphabet
-- $ is used for marking the last character

--Valid and Invalid categorization

-- valid pan numbers
WITH cleaned_pan AS
(
	SELECT DISTINCT(UPPER(TRIM(Pan_Numbers))) AS Pan_Numbers
	FROM pan_number_dataset
	WHERE Pan_Numbers IS NOT NULL 
      	  AND
	  	  TRIM(Pan_Numbers) !=''
)
SELECT *
FROM cleaned_pan
WHERE check_adjacent_letters(SUBSTRING(Pan_Numbers,1,5))=false
	  AND
	  check_sequential_characters(SUBSTRING(Pan_Numbers,1,5))=false
	  AND
	  check_adjacent_letters(SUBSTRING(Pan_Numbers,6,4))=false
	  AND
	  check_sequential_characters(SUBSTRING(Pan_Numbers,6,4))=false
	  AND 
	  Pan_Numbers ~ '^[A-Z]{5}[0-9]{4}[A-Z]{1}$';

--Filling Valid and Invalid values
CREATE OR REPLACE VIEW 	valid_invalid_view AS
WITH cleaned_pan AS
(
	SELECT DISTINCT(UPPER(TRIM(Pan_Numbers))) AS Pan_Numbers
	FROM pan_number_dataset
	WHERE Pan_Numbers IS NOT NULL
		AND TRIM(Pan_Numbers)!=''
),

valid_pan AS
(
	SELECT * 
	FROM cleaned_pan
	WHERE check_adjacent_letters(SUBSTRING(Pan_Numbers,1,5))=false
		  AND
		  check_sequential_characters(SUBSTRING(Pan_Numbers,1,5))=false
		  AND
		  check_adjacent_letters(SUBSTRING(Pan_Numbers,6,4))=false
		  AND
		  check_sequential_characters(SUBSTRING(Pan_Numbers,6,4))=false
		  AND
		  Pan_Numbers ~ '^[A-Z]{5}[0-9]{4}[A-Z]{1}$'
)

SELECT cp.Pan_Numbers,
		CASE
		WHEN vp.Pan_Numbers IS NOT NULL THEN 'Valid'
		ELSE 'Invalid'
		END AS Status
FROM cleaned_pan cp left join valid_pan vp
ON cp.Pan_Numbers=vp.Pan_Numbers;

SELECT * FROM valid_invalid_view;

--Final Summary report(Total records processed,Total Valid PAN's, Total Invalid PAN's,Total missing or incomplete pans)
WITH cte AS
(
		SELECT 
	   		(SELECT COUNT(*) FROM pan_number_dataset) AS Total_Processed_Record,
	   		COUNT(*) FILTER(WHERE status='Valid') AS Total_Valid_Pans,
	   		COUNT(*) FILTER(WHERE status='Invalid') AS Total_Invalid_Pans
		FROM valid_invalid_view
)
SELECT Total_Processed_Record,Total_Valid_Pans,Total_Invalid_Pans,Total_Processed_Record-(Total_Valid_Pans+Total_Invalid_Pans) AS Missing_OR_Incomplete
FROM cte;



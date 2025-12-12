# PAN_NUMBER_VALIDATION
This project focuses on validating 10,000+ PAN numbers using SQL-based data cleaning, rule-based validation, and classification logic in PostgreSQL. The workflow includes data preprocessing, custom validation functions, and final categorization of PAN numbers as Valid, Invalid, or Incomplete.
.

<h3>📂 Project Overview</h3>

1). Started with an Excel dataset of 10,000 PAN numbers.

2). Converted the dataset into CSV format for smooth database import.

3). Imported the data into PostgreSQL using SQL commands.

4). Performed data cleaning (trimming, case normalization, removing blanks).

5). Implemented PAN format validation rules:

    a). First 5 characters → Alphabets
  
    b). Next 4 characters → Digits
  
    c). Last character → Alphabet
  
    d). Removed entries with incomplete or missing values

6). Created custom SQL functions to detect:
  
    a). Adjacent repeating letters
  
    b). Sequential alphabetical patterns
  
    c). Structural format errors

7). Classified each PAN number into:
  
    ✔️ Valid PAN
    
    ❌ Invalid PAN
    
    ⚠️ Incomplete / Missing Data

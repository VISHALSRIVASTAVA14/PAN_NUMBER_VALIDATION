# PAN_NUMBER_VALIDATION
This project focuses on validating 10,000+ PAN numbers using SQL-based data cleaning, rule-based validation, and classification logic in PostgreSQL. The workflow includes data preprocessing, custom validation functions, and final categorization of PAN numbers as Valid, Invalid, or Incomplete.
.

## 📂 Project Overview

1. **Started with an Excel dataset of 10,000 PAN numbers.**

2. **Converted the dataset into CSV format** for smooth database import.

3. **Imported the data into PostgreSQL** using SQL commands.

4. **Performed data cleaning**:
   - Trimmed spaces  
   - Converted values to UPPERCASE  
   - Removed blank or null entries  

5. **Implemented PAN format validation rules**:
   - **First 5 characters → Alphabets (A–Z)**
   - **Next 4 characters → Digits (0–9)**
   - **Last character → Alphabet (A–Z)**
   - Removed entries with **incomplete or missing values**

6. **Created custom SQL validation functions** to identify:
   - Adjacent repeating letters  
   - Sequential alphabetical patterns  
   - Structural format errors based on PAN rules

7. **Classified each PAN number** into categories:
   - ✔️ **Valid PAN**  
   - ❌ **Invalid PAN**  
   - ⚠️ **Incomplete / Missing Data**

## Summary & Categorization
<img width="634" height="119" alt="summary" src="https://github.com/user-attachments/assets/932bbaf1-4964-4835-a9f2-8dd1bbccef4e" /><img width="634" height="364" alt="categorization" src="https://github.com/user-attachments/assets/4696ca3a-d10c-451a-a3e3-fc81d84c23e7" />





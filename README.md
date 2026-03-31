Netflix Content Strategy Analysis

Overview
This project demonstrates an end-to-end data analytics workflow, transforming a raw dataset of approximately 8,000 records into actionable insights. It covers the full lifecycle: from database management in MySQL and advanced data cleaning to interactive visualization in Power BI and professional documentation in MS Word.

Dataset
The dataset includes Netflix titles with attributes such as:
 * Show ID & Type: Unique identifiers for Movies and TV Shows.
 * Content Details: Release Year, Rating, and Category.
 * Metadata: Director, Cast, and Country of origin.

Tools
 * SQL (MySQL): Database hosting, data cleaning, and complex querying.
 * Power BI: Data modeling (Star Schema) and interactive dashboarding.
 * MS Word: Professional reporting and insight documentation.

Steps
 * Data Loading & Cleaning: Imported raw data into MySQL. Handled null values, removed duplicates, and standardized date formats for consistency.
 * SQL Analysis: Executed queries using Windows , CTEs, and Aggregations to analyze content growth trends and genre distribution.
 * Visualization: Connected the cleaned SQL database to Power BI. Developed DAX measures to calculate KPIs like total titles and year-over-year growth.
 * Reporting: Compiled all findings and technical methodology into a structured MS Word report.

Dashboard & Results
The Power BI Dashboard provides a high-level view of the library, featuring:
 * Trend Analysis: A surge in content additions starting from 2016.
 * Content Mix: Movies currently dominate the library over TV shows.
 * Geographic Insights: The US and India lead in content production.
 * Demographics: A significant focus on the TV-MA (Mature) audience segment.

How to Run
 * SQL Setup: Execute the .sql scripts in MySQL Workbench to build the database.
 * Power BI: Open the .pbix file (ensure the data source points to your local MySQL instance).
 * Report: Reference the Project_Report.docx for the full technical breakdown.

-- ICCA Database Project
-- Search all Tables and Views for Column Names
-- This document searches all tables and views to find all instances of terms within column names in CISReportingDB
-- Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 24-08-2023


-- Set Database
USE CISReportingDB


-- Delete Procedure if it already exists
DROP PROCEDURE SearchAllColumnNames
GO


-- Define Search Procedure
CREATE PROC SearchAllColumnNames
(
	@SearchTerm nvarchar(100)
)
AS
BEGIN
	SELECT COLUMN_NAME AS 'ColumnName', TABLE_NAME AS 'TableName'
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE COLUMN_NAME LIKE @SearchTerm
	ORDER BY ColumnName, TableName
END
GO


-- Use Search Function
EXEC SearchAllColumnNames '%name%'
EXEC SearchAllColumnNames '%pt%'
EXEC SearchAllColumnNames '%medication%'
EXEC SearchAllColumnNames '%prescri%'    -- root for prescription, prescribe and so on
EXEC SearchAllColumnNames '%blood%'
EXEC SearchAllColumnNames '%pressure%'
EXEC SearchAllColumnNames '%bp%'
EXEC SearchAllColumnNames '%BP%'


-- ICCA Database Project
-- Search all Tables for Keywords
-- This document uses a search all tables code to find all instances of terms in CISReportingDB
-- Mr Narayana Vyas Kondreddi, Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 23-08-2023


-- Set Database
USE CISReportingDB


-- Delete Procedure if it already exists
DROP PROCEDURE SearchAllTables


-- MODIFIED STACKOVERFLOW CODE STARTS HERE
-- Narayana Vyas Kondreddi
-- Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.
-- Purpose: To search all columns of all tables for a given search string
-- Written by: Narayana Vyas Kondreddi
-- Site: http://vyaskn.tripod.com
-- Tested on: SQL Server 7.0 and SQL Server 2000
-- Date modified: 28th July 2002 22:50 GMT
GO
CREATE PROC SearchAllTables
(
	@SearchStr nvarchar(100)
)
AS
BEGIN

	DECLARE @Results TABLE(ColumnName nvarchar(370), ColumnValue nvarchar(3630))

	SET NOCOUNT ON

	DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
	SET  @TableName = ''
	SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')

	WHILE @TableName IS NOT NULL
	BEGIN
		SET @ColumnName = ''
		SET @TableName = 
		(
			SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
			FROM    INFORMATION_SCHEMA.TABLES
			WHERE       TABLE_TYPE = 'BASE TABLE'
				AND QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
				AND OBJECTPROPERTY(
						OBJECT_ID(
							QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
							 ), 'IsMSShipped'
							   ) = 0
		)

		WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
		BEGIN
			SET @ColumnName =
			(
				SELECT MIN(QUOTENAME(COLUMN_NAME))
				FROM    INFORMATION_SCHEMA.COLUMNS
				WHERE       TABLE_SCHEMA    = PARSENAME(@TableName, 2)
					AND TABLE_NAME  = PARSENAME(@TableName, 1)
					AND DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
					AND QUOTENAME(COLUMN_NAME) > @ColumnName
			)

			-- Skip these tables!
			IF ( @TableName NOT IN ('[dbo].[M_Source]', '[dbo].[M_SourceDb]', '[dbo].[M_Stats]', '[dbo].[M_StatsDetails]', '[dbo].[M_System]') )
			BEGIN
				IF @ColumnName IS NOT NULL
				BEGIN
					INSERT INTO @Results
					EXEC
					(
						'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
						FROM ' + @TableName + 
						' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
					)
				END
				PRINT @TableName + '.' + @ColumnName
			END
		END 
	END

	SELECT ColumnName, ColumnValue FROM @Results
END
GO
-- MODIFIED STACKOVERFLOW CODE ENDS HERE


-- main search
EXEC SearchAllTables '%vasospasm%'
EXEC SearchAllTables '%vaso%'


-- related conditions
EXEC SearchAllTables '%DCI%'
EXEC SearchAllTables '%delayed%'
EXEC SearchAllTables '%cerebral%'
EXEC SearchAllTables '%ischaemia%'
EXEC SearchAllTables '%subarachnoid%'
EXEC SearchAllTables '%haemorrhage%'
EXEC SearchAllTables '%hypertensed%'
EXEC SearchAllTables '%hypertense%'


-- medications
EXEC SearchAllTables '%noradrenaline%'
EXEC SearchAllTables '%metaraminol%'


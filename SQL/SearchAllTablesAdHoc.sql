-- ICCA Database Project
-- Search all Tables for Keywords
-- This document uses a search all tables code to find all instances of terms in CISReportingDB
-- This version uses an ad-hoc search as opposed to a saved procedure
-- Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 23-08-2023


USE CISReportingDB

-- MODIFIED STACKOVERFLOW CODE STARTS HERE
DECLARE @SearchStr nvarchar(100) = '%vasospasm%'
DECLARE @Results TABLE (ColumnName nvarchar(370), ColumnValue nvarchar(3630))

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
        FROM     INFORMATION_SCHEMA.TABLES
        WHERE         TABLE_TYPE = 'BASE TABLE'
            AND    QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
            AND    OBJECTPROPERTY(
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
            FROM     INFORMATION_SCHEMA.COLUMNS
            WHERE         TABLE_SCHEMA    = PARSENAME(@TableName, 2)
                AND    TABLE_NAME    = PARSENAME(@TableName, 1)
                AND    DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'int', 'decimal')
                AND    QUOTENAME(COLUMN_NAME) > @ColumnName
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
					FROM ' + @TableName + ' (NOLOCK) ' +
					' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
				)
			END
			PRINT 'Table = ' + @TableName + '	' + 'Column = ' + @ColumnName
		END
    END    
END

SELECT ColumnName, ColumnValue FROM @Results
-- MODIFIED STACKOVERFLOW CODE ENDS HERE





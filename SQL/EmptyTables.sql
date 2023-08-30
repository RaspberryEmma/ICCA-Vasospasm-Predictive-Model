-- ICCA Database Project
-- Empty Table Report
-- This document demonstrates checking how many tables in the db are empty
-- Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 20-07-2023


-- CISReportingActiveDB0 = Clinical Information System for currently admitted / recently discharged
-- CISReportingDB        = Clinical Information System for entire system lifetime
USE CISReportingDB


-- Total number of tables
SELECT COUNT(*) AS Number_of_Tables FROM sys.tables


-- print all empty tables
select schema_name(tab.schema_id) + '.' + tab.name as [empty_tables]
   from sys.tables tab
        inner join sys.partitions part
            on tab.object_id = part.object_id
where part.index_id IN (1, 0) -- 0 - table without PK, 1 table with PK
group by schema_name(tab.schema_id) + '.' + tab.name
having sum(part.rows) = 0
order by [empty_tables]

-- count empty tables
SELECT COUNT(*) AS number_empty FROM (
	select schema_name(tab.schema_id) + '.' + tab.name as [empty_tables]
	   from sys.tables tab
			inner join sys.partitions part
				on tab.object_id = part.object_id
	where part.index_id IN (1, 0) -- 0 - table without PK, 1 table with PK
	group by schema_name(tab.schema_id) + '.' + tab.name
	having sum(part.rows) = 0
) empty_tables



-- print all non-empty tables
select schema_name(tab.schema_id) + '.' + tab.name as [non_empty_tables]
   from sys.tables tab
        inner join sys.partitions part
            on tab.object_id = part.object_id
where part.index_id IN (1, 0) -- 0 - table without PK, 1 table with PK
group by schema_name(tab.schema_id) + '.' + tab.name
having sum(part.rows) != 0
order by [non_empty_tables]

-- count non-empty tables
SELECT COUNT(*) AS number_non_empty FROM (
	select schema_name(tab.schema_id) + '.' + tab.name as [non_empty_table]
	   from sys.tables tab
			inner join sys.partitions part
				on tab.object_id = part.object_id
	where part.index_id IN (1, 0) -- 0 - table without PK, 1 table with PK
	group by schema_name(tab.schema_id) + '.' + tab.name
	having sum(part.rows) != 0
) non_empty_tables



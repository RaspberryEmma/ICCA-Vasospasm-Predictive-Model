-- ICCA Database Project
-- Basics and SQL Setup
-- This document demonstrates basic functionality and establishes paramaters of DB design
-- Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 18-07-2023


-- CIS Reporting Database Access
USE CISReportingActiveDB0
SELECT TOP 5 * FROM D_Document
SELECT TOP 5 * FROM D_Intervention


-- CIS Database Parameters

---- Databases
SELECT COUNT(*) AS Number_of_Databases FROM sys.databases -- count number of databases in our server
SELECT * FROM sys.databases                               -- list of databases in our server

---- Tables
USE CISReportingActiveDB0                           -- restrict to one given database
SELECT COUNT(*) AS Number_of_Tables FROM sys.tables -- count number of tables in db (512)
SELECT name, object_id, modify_date FROM ( SELECT * FROM sys.tables ) table_alias ORDER BY table_alias.name ASC


-- Tables of Interest
USE CISReportingActiveDB0
SELECT COUNT(*) AS D_Attribute_Rows FROM D_Attribute
SELECT COUNT(*) AS D_Attribute_Cols FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'D_Attribute'
SELECT TOP 5 * FROM D_Attribute
SELECT COUNT(*) AS D_Diagnosis_Rows FROM D_Diagnosis
SELECT COUNT(*) AS D_Diagnosis_Cols FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'D_Diagnosis'
SELECT TOP 5 * FROM D_Diagnosis
SELECT COUNT(*) AS D_Intervention_Rows FROM D_Intervention
SELECT COUNT(*) AS D_Intervention_Cols FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'D_Intervention'
SELECT TOP 5 * FROM D_Intervention
SELECT COUNT(*) AS PtMedication_Rows FROM PtMedication
SELECT COUNT(*) AS PtMedication_Cols FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PtMedication'
SELECT TOP 5 * FROM PtMedication
SELECT COUNT(*) AS PtProcedure_Rows FROM PtProcedure
SELECT COUNT(*) AS PtProcedure_Cols FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PtProcedure'
SELECT TOP 5 * FROM PtProcedure
SELECT COUNT(*) AS PtService_Rows FROM PtService
SELECT COUNT(*) AS PtService_Cols FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PtService'
SELECT TOP 5 * FROM PtService
SELECT COUNT(*) AS PtTreatment_Rows FROM PtTreatment
SELECT COUNT(*) AS PtTreatment_Cols FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PtTreatment'
SELECT TOP 5 * FROM PtTreatment





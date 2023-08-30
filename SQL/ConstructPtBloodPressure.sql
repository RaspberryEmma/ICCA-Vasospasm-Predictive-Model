-- ICCA Database Project
-- Relating Patient ID's to Blood Pressure
-- This document builds a CSV containing the blood pressure summary for each given patient ID
-- Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 25-08-2023


-- CISReportingActiveDB0 = Clinical Information System for currently admitted / recently discharged
-- CISReportingDB        = Clinical Information System for entire system lifetime
USE CISReportingDB


-- (1) - Locating Key Variables

-- blood pressure

-- In general we search for variables in the D_Intervention table by pattern matching on the longLabel
SELECT * FROM D_Intervention WHERE longLabel  LIKE '%blood pressure%' -- 2860, 3974, 4496, 5126
SELECT * FROM D_Intervention WHERE shortLabel LIKE '%nbp%'            --  340, 4097, 5135, 5934


-- (3) - Construct List of Relevant Interventions (optimise here for performance on later join!)

-- Normal Intervention ID Codes
DECLARE @relevantInterventionIds TABLE (Value INT)
INSERT INTO @relevantInterventionIds VALUES (2860)
INSERT INTO @relevantInterventionIds VALUES (3974)
INSERT INTO @relevantInterventionIds VALUES (4496)
INSERT INTO @relevantInterventionIds VALUES (5126)
INSERT INTO @relevantInterventionIds VALUES ( 340)
INSERT INTO @relevantInterventionIds VALUES (4097)
INSERT INTO @relevantInterventionIds VALUES (5135)
INSERT INTO @relevantInterventionIds VALUES (5934)


-- Cis Intervention ID Codes (a given interventionId may have multiple cisInterventionId's !)
DECLARE @relevantInterventionCisIds TABLE (Value varchar(200))
INSERT INTO @relevantInterventionCisIds (Value)
SELECT cisInterventionId
FROM M_CisIntervention
WHERE M_CisIntervention.interventionId IN (SELECT Value FROM @relevantInterventionIds)

-- Check results
SELECT * FROM @relevantInterventionIds
SELECT * FROM @relevantInterventionCisIds


-- (2) - Relating Intervention ID's to Cis Intervention ID's
SELECT cisInterventionId, interventionId, shortLabel, longLabel
FROM M_CisIntervention
ORDER BY interventionId





-- (4) - Relating Blood Pressure Readings to Patient ID's

SELECT *
INTO #tempTable
FROM PtAssessment
WHERE interventionId IN (SELECT * FROM @relevantInterventionIds)

SELECT *
FROM #tempTable

SELECT ptAssessmentId, cisPatientId, interventionId, joined.encounterId, terseForm, verboseForm, valueNumber, unitOfMeasure, upperNormal, lowerNormal
INTO #resultsTable
FROM (
	#tempTable joined
	INNER JOIN M_CisEncounter encounter
	ON joined.encounterId = encounter.encounterId
)

SELECT *
FROM #resultsTable


-- clean memory!
DROP TABLE #tempTable
DROP TABLE #resultsTable

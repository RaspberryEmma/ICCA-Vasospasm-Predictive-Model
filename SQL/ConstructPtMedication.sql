-- ICCA Database Project
-- Relating Patient ID's to Medication Requests
-- This document builds a CSV containing individual medication requests, each order has one patient and one medication
-- Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 25-08-2023


-- CISReportingActiveDB0 = Clinical Information System for currently admitted / recently discharged
-- CISReportingDB        = Clinical Information System for entire system lifetime
USE CISReportingDB


-- (1) - Locating Key Medications

SELECT * FROM D_Intervention WHERE longLabel   LIKE '%noradrenaline%'  -- interventionId 5621
SELECT * FROM D_Intervention WHERE longLabel   LIKE '%norepinephrine%' -- no matches, alias of noradrenaline

SELECT * FROM D_Intervention WHERE longLabel   LIKE '%metaraminol%' -- 5765, 5875, 6112, 6218, 7860
SELECT * FROM D_Intervention WHERE longLabel   LIKE '%metaradrine%' -- no matches, alias of metaraminol


-- (2) - Relating Intervention ID's to Cis Intervention ID's
SELECT cisInterventionId, interventionId, shortLabel, longLabel
FROM M_CisIntervention
ORDER BY interventionId


-- (3) - Construct List of Relevant Interventions (optimise here for performance on later join!)

-- Normal Intervention ID Codes
DECLARE @relevantInterventionIds TABLE (Value INT)
INSERT INTO @relevantInterventionIds VALUES (5621)
INSERT INTO @relevantInterventionIds VALUES (5765)
INSERT INTO @relevantInterventionIds VALUES (5875)
INSERT INTO @relevantInterventionIds VALUES (6112)
INSERT INTO @relevantInterventionIds VALUES (6218)
INSERT INTO @relevantInterventionIds VALUES (7860)

-- Cis Intervention ID Codes (a given interventionId may have multiple cisInterventionId's !)
DECLARE @relevantInterventionCisIds TABLE (Value varchar(200))
INSERT INTO @relevantInterventionCisIds (Value)
SELECT cisInterventionId
FROM M_CisIntervention
WHERE M_CisIntervention.interventionId IN (SELECT Value FROM @relevantInterventionIds)

-- Check results
SELECT * FROM @relevantInterventionIds
SELECT * FROM @relevantInterventionCisIds


-- (3) - Relating Patient ID's to Medications

-- relates interventions to types, concepts and encounters
--SELECT *
--FROM M_CisIntervention
--ORDER BY storeTime DESC

-- relates interventions to encounters, attributes and concepts
--SELECT *
--FROM M_CisInterventionAttribute
--ORDER BY storeTime DESC

-- relates encounters to episodes, patients and state
--SELECT *
--FROM M_CisEncounter
--ORDER BY utcStoreTime DESC

-- relate episodes to patients
--SELECT *
--FROM M_CisEpisode
--ORDER BY utcStoreTime DESC


-- JOINS

-- relate episodes to encounters, retaining patients
SELECT episode.cisEpisodeId, episode.cisPatientId, encounter.cisEncounterId
INTO #tempTable
FROM (
	M_CisEpisode episode
	INNER JOIN M_CisEncounter encounter
	ON episode.cisEpisodeId = encounter.cisEpisodeId
)

SELECT *
FROM #tempTable


-- relate encounters to interventions, retaining patients
SELECT joined.cisEpisodeId, joined.cisPatientId, joined.cisEncounterId, intervention.cisInterventionId
INTO #tempTable2
FROM (
	#tempTable joined
	INNER JOIN M_CisInterventionAttribute intervention
	ON joined.cisEncounterId = intervention.ptEncounterId -- is this accurate?
)
WHERE intervention.cisInterventionId IN (SELECT * FROM @relevantInterventionCisIds)


SELECT *
FROM #tempTable2


-- lookup intervention labels
SELECT joined.cisPatientId, joined.cisEpisodeId, joined.cisEncounterId, joined.cisInterventionId, intervention.shortLabel, intervention.longLabel
INTO #resultsTable
FROM (
	#tempTable2 joined
	INNER JOIN M_CisIntervention intervention
	ON joined.cisInterventionId = intervention.cisInterventionId
)


SELECT *
FROM #resultsTable


-- clean memory!
DROP TABLE #tempTable
DROP TABLE #tempTable2
DROP TABLE #resultsTable





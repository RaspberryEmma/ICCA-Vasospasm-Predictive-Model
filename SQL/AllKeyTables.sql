-- ICCA Database Project
-- Exploring Key Tables
-- Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 25-08-2023

-- Note on Database Connections:
-- nbsvr624 = production, contains real data
-- nbsvr626 = dev clone, contains only test data, much more missingness, testing (paradoxically) quite difficult here because empty tables are frequent!

-- Set Database
USE CISReportingDB


SELECT * FROM D_Intervention

-- relate Intervention ID's to Cis Intervention ID's
SELECT cisInterventionId, interventionId, shortLabel, longLabel
FROM M_CisIntervention
ORDER BY interventionId


-- interventions
SELECT TOP 100 * FROM PtIntervention
SELECT TOP 100 * FROM M_CisIntervention
SELECT TOP 100 * FROM M_CisInterventionAttribute

-- various
SELECT TOP 100 * FROM PtAssessment
SELECT TOP 100 * FROM PtTreatment
SELECT TOP 100 * FROM PtDocument

-- medication orders
SELECT TOP 100 * FROM PtMedication
SELECT TOP 100 * FROM PtMedicationOrder
SELECT TOP 100 * FROM M_CisPtParent
SELECT TOP 100 * FROM PtMedicationOrder

-- episodes and encounters
SELECT TOP 100 * FROM M_CisEpisode
SELECT TOP 100 * FROM M_CisEncounter



-- ICCA Database Project
-- Database Access Secondary Working Example - Specifically Requested Text Notes
-- Demonstrates accessing specific text notes from the Phillips ICCA front-end system from the back-end
-- Mr Steve Fry, Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 02-08-2023


-- CISReportingActiveDB0 = Clinical Information System for currently admitted / recently discharged
-- CISReportingDB        = Clinical Information System for entire system lifetime
USE CISReportingDB


SELECT TOP 10 * FROM DAR.PtMedication
SELECT TOP 10 * FROM dbo.M_CisPtParent
SELECT TOP 10 * FROM DAR.PtMedicationOrder


-- ICCA > POD A > Discharged Pts > *clicks name* > Flowsheets > Flowsheet (Adult ICU) > Continuous Drug Infusion
SELECT *
FROM (
	DAR.PtMedication AS pmed
	JOIN dbo.M_CisPtParent AS mcparent ON mcparent.cisPtParentId = pmed.cisOrderId
	JOIN DAR.PtMedicationOrder AS pmedorder ON pmedorder.ongoingId = mcparent.ptParentId
)






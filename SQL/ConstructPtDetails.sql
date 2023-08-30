-- ICCA Database Project
-- Patient Unique ID's and Names
-- This document builds a CSV containing 2 columns: Unique Patient IDs and Names
-- Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 23-08-2023


-- CISReportingActiveDB0 = Clinical Information System for currently admitted / recently discharged
-- CISReportingDB        = Clinical Information System for entire system lifetime
USE CISReportingDB


-- unique patient ID's and corresponding cisPatientID codes (fact table)
SELECT * 
FROM dbo.M_CisPatient
ORDER BY patientId


-- patient full names, patient details and cisPatientID
SELECT *
FROM DAR.AllEncounter
ORDER BY cisPatientId

-- join the above
SELECT patientId, encounters.cisPatientId, patientFullName, patientLifetimeNumber, patientAge, patientDateOfBirth, patientGender, ethnicGroup
FROM DAR.AllEncounter encounters
INNER JOIN dbo.M_CisPatient patients
ON encounters.cisPatientId = patients.cisPatientId




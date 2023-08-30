-- ICCA Database Project
-- Working Example
-- This document demonstrates contains the working example provided by Jack via his instructional video
-- Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 18-07-2023


-- CISReportingActiveDB0 = Clinical Information System for currently admitted / recently discharged
-- CISReportingDB        = Clinical Information System for entire system lifetime
USE CISReportingDB


SELECT TOP 100 * FROM D_Intervention WHERE shortLabel LIKE '%azole%'

SELECT TOP 100 DI.interventionId as interventionId,
               MIN(DI.longLabel) as longLabel,
			   DA.attributeId as attributeId,
			   MIN(DA.shortLabel) as shortLabel
FROM D_Attribute DA
INNER JOIN PtMedication P
ON P.attributeId = DA.attributeId
INNER JOIN D_Intervention DI
ON DI.interventionId = P.interventionId
WHERE DI.interventionId in (6061)
GROUP BY DI.interventionId, DA.attributeId
--ORDER BY frequency DESC

SELECT * from PtMedication WHERE interventionId in (6061) and attributeId in (7388)







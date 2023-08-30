-- ICCA Database Project
-- ICNARC Document Locator
-- Dr Jack Ingham, Dr Christopher Newell, Miss Emma Tarmey
-- 25-08-2023


-- Looking for Vasospasm proxy in CISReportingActiveDB database
-- CISReportingActiveDB0 = Clinical Information System for currently admitted / recently discharged
-- CISReportingDB        = Clinical Information System for entire system lifetime
USE CISReportingDB

-- Key Information:
-- aneurysmal Subarachnoid haemorrhage in ICNARC primary diagnosis
-- delayed cerebral ischaemia (DCI)
-- freetext "vasospasm" in CTA imaging
-- patients with vasospasm "hypertensed" with either noradrenaline or metaraminol infusions,
-- documented on ICCA flowsheets and medications section


-- (1) - Locating Key Records

-- SELECT TOP 100 * FROM DAR.PatientAssessment

-- ID lookup (ptDocumentId, documentId, cisPatientDocumentId and so on)
SELECT TOP 100 * FROM DAR.PtDocument

-- types of record / ICU files
-- looking for ICNARC primary diagnosis, where freetext notes exist
SELECT TOP 100 * FROM DAR.Document WHERE conceptLabel LIKE '%ICNARC%'

-- disorders and findings
-- no there does not appear to exist a better SQL syntax for this
SELECT TOP 100 * FROM M_CisConcept WHERE conceptLabel LIKE '%vasospasm%' OR
                                         conceptLabel LIKE '%DCI%' OR
										 conceptLabel LIKE '%delayed%' OR
										 conceptLabel LIKE '%cerebral%' OR
										 conceptLabel LIKE '%ischemia%' OR
										 conceptLabel LIKE '%aneurysmal%' OR
										 conceptLabel LIKE '%subarachnoid%' OR
										 conceptLabel LIKE '%hemorrhage%' OR
										 conceptLabel LIKE '%hypertensed%'

-- standard units and qualifier values
SELECT TOP 100 * FROM M_ConceptMap


-- (2) - Find document ID's correspinding only to ICNARC
DECLARE @relevantDocumentIds TABLE (Value INT)
INSERT INTO @relevantDocumentIds SELECT documentID FROM DAR.Document WHERE conceptLabel LIKE '%ICNARC%'

-- check results
SELECT * FROM @relevantDocumentIds


-- (3) - Relating Patient ID's to ICNARC Documents

-- restrict ptDocument tablt to ICNARC only, relate ptDocumentIds to labels
SELECT ptDocs.ptdocumentId, ptDocs.documentId, ptDocs.encounterId, ptDocs.cisPtDocumentId, docs.label, docs.conceptLabel
INTO #tempTable
FROM (
	DAR.PtDocument ptDocs
	INNER JOIN DAR.Document docs
	ON ptDocs.documentId = docs.documentId
)
WHERE ptDocs.documentId IN (SELECT * FROM @relevantDocumentIds)
SELECT * FROM #tempTable

-- relate ptDocumentIds to patientIds
SELECT encounters.cisPatientId, joined.ptdocumentId, joined.documentId, joined.encounterId, joined.cisPtDocumentId, joined.label, joined.conceptLabel
INTO #tempTable2
FROM (
	#tempTable joined
	INNER JOIN M_CisEncounter encounters
	ON joined.encounterId = encounters.encounterId
)
ORDER BY encounters.cisPatientId
SELECT * FROM #tempTable2


-- clean memory!
DROP TABLE #tempTable
DROP TABLE #tempTable2



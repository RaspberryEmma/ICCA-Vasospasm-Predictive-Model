-- ICCA Database Project
-- Relating Patient ID's to Incidence of Vasospasm
-- This document builds a CSV containing a proxy for incidence of vasospasm for each given patient ID
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


-- extract text notes directly!
SELECT ptInterventionId, encounterId, verboseForm, valueString
INTO #tempTable
FROM PtIntervention
WHERE verboseForm LIKE '%vasospasm%' OR
      valueString LIKE '%vasospasm%'
SELECT * FROM #tempTable

-- relate vasospasm in notes to patient ID's
SELECT encounter.cisPatientId, interventions.ptInterventionId, interventions.encounterId, interventions.verboseForm, interventions.valueString
INTO #tempTable2
FROM (
	#tempTable interventions
	INNER JOIN M_CisEncounter encounter
	ON interventions.encounterId = encounter.encounterId
)
SELECT * FROM #tempTable2

-- clean memory!
DROP TABLE #tempTable
DROP TABLE #tempTable2

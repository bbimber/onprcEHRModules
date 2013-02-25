/*
 * Copyright (c) 2012-2013 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
--Please note:  All lab values = -1 is should be substitued with a Null value

SELECT
	t.ClinicalKey ,
	cast(t.Id as nvarchar(4000)) as Id,
	t.DATE ,
	--t.Specimen ,     --      Speciment database table
	--sp.Name,
	--sp.SNOMEDCODE as snomed,
	--t.MethodInt  ,
	s2.Value as Method,
	CASE
	  WHEN t.result = -1 THEN null
	  else t.result
    END as result,

	t.TestId,

	t.rowversion,
	(cast(t.objectid as varchar(38)) + '_' + t.TestId) as objectid,
	 t.objectid as runid

FROM (

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	ManualDiff as Result,
	'ManualDiff' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	WBC as Result,
	'WBC' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	RBC as Result,
	'RBC' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	Hemoglobin as Result,
	'Hemoglobin' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	Hematocrit as Result,
	'HCT' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	MCV as Result,
	'MCV' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	MCH as Result,
	'MCH' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	MCHC as Result,
	'MCHC' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	PlateletCount as Result,
	'PlateletCount' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	TotalProtein as Result,
	'TP' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	MPMN as Result,
	'Neut' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	IPMN as Result,
	'Bands' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	Lymphocyte as Result,
	'LY' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	Monocyte as Result,
	'Mono' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	Eosinophil as Result,
	'EO' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	Basophil as Result,
	'BAS' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	SEDRate as Result,
	'SEDRate' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	LUC as Result,
	'LUC' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	NRBC as Result,
	'NRBC' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	Reticulocyte as Result,
	'RETICULO' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	RBCHypochromic as Result,
	'Hypochromic RBC' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	RBCMicrocyte as Result,
	'Microcytic RBC' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	RBCPolychromasia as Result,
	'Polychromasia RBC' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	RBCMacrocyte as Result,
	'Macrocytic RBC' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

union all

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	RBCAnisocytosis as Result,
	'Anisocytosis' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_Hematology cln

UNION ALL


--TODO: does this belong here??
SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	TotalWBC as Result,
	'WBC' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_CerebralspinalFluid cln

UNION ALL

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	WBCNeurophils as Result,
	'Neut' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_CerebralspinalFluid cln

UNION ALL

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	WBCLymphocytes as Result,
	'LY' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_CerebralspinalFluid cln

UNION ALL

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	TotalProtein as Result,
	'TP' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_CerebralspinalFluid cln

UNION ALL

SELECT
	ClinicalKey ,
	AnimalID as Id  ,
	DATE ,
	Specimen as Specimen ,     --      Speciment database table
	Method as MethodInt  ,
	Glucose as Result,
	'GLUC' as TestId,
	cln.ts as rowversion,
	cln.objectid

FROM Cln_CerebralspinalFluid cln

) t

left join Sys_Parameters s2 on (s2.Flag = t.MethodInt And s2.Field = 'AnalysisMethodHematology')
--left join Specimen sp on (sp.Value = t.Specimen)

WHERE t.result != -1
  and t.rowversion > ?


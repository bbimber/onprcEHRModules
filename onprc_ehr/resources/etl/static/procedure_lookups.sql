--insert procedures, only if not already present
INSERT INTO labkey.ehr_lookups.procedures (name, category, active, major)
Select
	ProcedureName as name,
	'Surgery' as category,
	CASE
	  WHEN Status = 1 THEN 1
      ELSE 0
    END as active,					-- 1 = active, 0 = inactive
	--rsp.DisplayOrder,
	--Category as CategoryInt,
	CASE
	  WHEN s1.Value = 'Major Surgery' then 1
	  ELSE 0
    END as major
From IRIS_Production.dbo.Ref_SurgProcedure rsp
	left join IRIS_Production.dbo.Sys_Parameters s1 on (s1.Field = 'SurgeryCategory' and rsp.Category = s1.Flag)
	LEFT JOIN labkey.ehr_lookups.procedures p ON (rsp.ProcedureName = p.name)
	WHERE p.name IS NULL


--procedure comments
TRUNCATE TABLE labkey.ehr_lookups.procedure_default_comments;
INSERT INTO labkey.ehr_lookups."procedure_default_comments" (procedureid, comment)
Select
	--p0.ProcedureID,		--Ref_SurgProcedure
	(SELECT rowid from labkey.ehr_lookups.procedures p WHERE p.name = r.procedureName) as procedureid,
	cast(coalesce(p0.LogText, '') as nvarchar(4000)) + cast(coalesce(p1.LogPage, '') as nvarchar(4000)) + cast(coalesce(p2.LogText, '') as nvarchar(4000)) + cast(coalesce(p3.LogText, '') as nvarchar(4000)) + cast(coalesce(p4.LogText, '') as nvarchar(4000)) + cast(coalesce(p5.LogText, '') as nvarchar(4000)) as Comment

From IRIS_Production.dbo.Ref_SurgLog p0
LEFT JOIN IRIS_Production.dbo.Ref_SurgProcedure r on (p0.procedureid = r.procedureid)
LEFT JOIN IRIS_Production.dbo.Ref_SurgLog p1 ON (p0.ProcedureID = p1.ProcedureID AND p1.LogPage = 1)
LEFT JOIN IRIS_Production.dbo.Ref_SurgLog p2 ON (p0.ProcedureID = p2.ProcedureID AND p2.LogPage = 2)
LEFT JOIN IRIS_Production.dbo.Ref_SurgLog p3 ON (p0.ProcedureID = p3.ProcedureID AND p2.LogPage = 3)
LEFT JOIN IRIS_Production.dbo.Ref_SurgLog p4 ON (p0.ProcedureID = p4.ProcedureID AND p2.LogPage = 4)
LEFT JOIN IRIS_Production.dbo.Ref_SurgLog p5 ON (p0.ProcedureID = p5.ProcedureID AND p2.LogPage = 5)

WHERE p0.LogPage = 0


--procedure flags
TRUNCATE TABLE labkey.ehr_lookups.procedure_default_flags;
INSERT INTO labkey.ehr_lookups.procedure_default_flags (procedureId, flag, value)
Select
  (SELECT rowid from labkey.ehr_lookups.procedures p WHERE p.name = r.procedureName) as procedureid,
  'BreedImpair' as flag,
  'Y' as value

FROM IRIS_Production.dbo.Ref_SurgProcedure r
WHERE BreedImpairFlag = 1;

INSERT INTO labkey.ehr_lookups.procedure_default_flags (procedureId, flag, value)
Select
  (SELECT rowid from labkey.ehr_lookups.procedures p WHERE p.name = r.procedureName) as procedureid,
  'USDASurvival' as flag,
  'Y' as value

FROM IRIS_Production.dbo.Ref_SurgProcedure r
WHERE USDASurvivalFlag = 1;

INSERT INTO labkey.ehr_lookups.procedure_default_flags (procedureId, flag, value)
Select
  (SELECT rowid from labkey.ehr_lookups.procedures p WHERE p.name = r.procedureName) as procedureid,
  'Vessel Surgery' as flag,
  'Y' as value

FROM IRIS_Production.dbo.Ref_SurgProcedure r
WHERE VesselID = 1;


--procedure charges
TRUNCATE TABLE labkey.ehr_lookups.procedure_default_charges;
INSERT INTO labkey.ehr_lookups.procedure_default_charges (procedureid, chargeid, quantity)
SELECT
(SELECT rowid from labkey.ehr_lookups.procedures p WHERE p.name = procedurename) as procedureid,
--'PersonHours' as chargeid,
null as chargeId,
PersonHours as quantity
FROM IRIS_Production.dbo.Ref_SurgProcedure
WHERE PersonHours > 0;

TRUNCATE TABLE labkey.ehr_lookups.procedure_default_charges;
INSERT INTO labkey.ehr_lookups.procedure_default_charges (procedureid, chargeid, quantity)
SELECT
(SELECT rowid from labkey.ehr_lookups.procedures p WHERE p.name = procedurename) as procedureid,
--'Comsumables' as chargeid,
null as chargeId,
Comsumables as quantity
FROM IRIS_Production.dbo.Ref_SurgProcedure
WHERE PersonHours > 0;



--procedure medications
TRUNCATE TABLE labkey.ehr_lookups.procedure_default_treatments;
INSERT INTO labkey.ehr_lookups.procedure_default_treatments (procedureid, code, dosage, dosage_units, route, frequency)
Select
	(SELECT rowid from labkey.ehr_lookups.procedures p WHERE p.name = r.procedurename) as procedureid,
	Medication as code,
	rsm.Dose as dosage,
	s1.Value as dosage_units,
	--Route as RouteInt,
	s2.Value as Route,
	(SELECT rowid from labkey.ehr_lookups.treatment_frequency f WHERE f.meaning = s3.Value) as Frequency

From IRIS_Production.dbo.Ref_SurgMedications rsm
	left join IRIS_Production.dbo.Sys_Parameters s1 on (s1.Field = 'MedicationUnits' and s1.Flag = rsm.Units)
	left join IRIS_Production.dbo.Sys_Parameters s2 on (s2.Field = 'MedicationRoute' and s2.Flag = rsm.route)
	left join IRIS_Production.dbo.Sys_Parameters s3 on (s3.Field = 'MedicationFrequency' and s3.Flag = rsm.frequency)
	LEFT JOIN IRIS_Production.dbo.Ref_SurgProcedure r on (rsm.procedureid = r.procedureid);


--procedure_default_codes
TRUNCATE TABLE labkey.ehr_lookups.procedure_default_codes;
INSERT INTO labkey.ehr_lookups.procedure_default_codes (procedureid, sort_order, code)
Select
	(SELECT max(rowid) as rowid from labkey.ehr_lookups.procedures p WHERE p.name = p.name) as procedureid,
	s2.i as sort,
	s2.value as code

From IRIS_Production.dbo.Ref_SurgSnomed r
left join IRIS_Production.dbo.Ref_SurgProcedure p on (r.ProcedureID = p.ProcedureID)
cross apply IRIS_Production.dbo.fn_splitter(r.SnomedCodes, ',') s2
where s2.value is not null and s2.value != '';

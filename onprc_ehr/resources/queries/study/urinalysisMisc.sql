/*
 * Copyright (c) 2011 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 */
SELECT
  b.Id,
  b.date,
  b.method,
  b.testid,

  b.resultOORIndicator,
  b.result,
  b.units,
  b.qualresult,
  b.remark,
  b.qcstate,
  b.runId,
  b.taskid
FROM study."Urinalysis Results" b

WHERE (b.testId.includeInPanel = false or b.testId.includeInPanel IS NULL) and b.qcstate.publicdata = true


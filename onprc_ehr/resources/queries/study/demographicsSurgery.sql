/*
 * Copyright (c) 2010-2011 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 */
SELECT

s.id,

CASE
  WHEN (sum(CASE WHEN s.procedureid.major = true THEN 1 ELSE 0 END) > 0) THEN 'Yes'
  ELSE null
END AS majorSurgery,

true As anySurgery,

count(*) as numberOfSurgeries

FROM study.encounters s
WHERE s.qcstate.publicdata = true AND type = 'Surgery'

GROUP BY s.id



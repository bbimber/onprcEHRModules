/*
 * Copyright (c) 2010-2011 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 */
SELECT
  r.room,
  count(DISTINCT c.cage) as TotalCages,
  max(cbr.availableCages) as AvailableCages,
  count(DISTINCT h.cage) as CagesUsed,
  max(cbr.availableCages) - count(DISTINCT h.cage) as CagesEmpty,
  count(DISTINCT h.id) as TotalAnimals,


FROM ehr_lookups.rooms r
LEFT JOIN ehr_lookups.cage c ON (r.room = c.room)
LEFT JOIN study.housing h ON (r.room=h.room AND (c.cage=h.cage OR (c.cage is null and h.cage is null)) AND COALESCE(h.enddate, now()) >= now())
LEFT JOIN ehr_lookups.availableCagesByRoom cbr ON (cbr.room = r.room)
GROUP BY r.room


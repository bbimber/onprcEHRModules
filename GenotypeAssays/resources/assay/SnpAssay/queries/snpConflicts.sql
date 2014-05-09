SELECT
  s.subjectId,
  s.marker,
  s.ref_nt_name,
  s.position,
  s.category,
  GROUP_CONCAT(DISTINCT s.nt, chr(10)) as allles,
  COUNT(DISTINCT s.nt) as distinctResults,
  count(*) as totalDataPoints

FROM Data s

GROUP BY s.subjectId, s.marker, s.ref_nt_name, s.position, s.category

HAVING COUNT(DISTINCT s.nt) > 1
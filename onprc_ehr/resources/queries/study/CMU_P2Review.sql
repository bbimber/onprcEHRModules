SELECT c.Id,
       c.date,
       c.p2,
       (select group_concat(c4.p2, char(10))from clinremarks c4 where c4.id = c.id and c4.date in (Select max(c3.date) from Clinremarks c3 where c3.id = c.id
                                                                                                                                              and c3.date <> c.date and c3.p2 <> ''  group by c3.id, c3.date order by date desc limit 1)  ) as secondp2,
       c.remark,
       (select group_concat(f1.flag.value, char(10)) from flags f1 where f1.id = c.id And f1.flag.category = 'Alert' And f1.enddate is null) as alertflag,
       c.history

FROM clinremarks c
where  c.id.Demographics.calculated_status = 'alive'
  And c.date in (Select Max(c1.date) from clinremarks c1 where c.id = c1.id And c.p2 is not null)

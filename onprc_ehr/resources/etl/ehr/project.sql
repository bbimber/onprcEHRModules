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
  
select 
	coalesce(i2.eIACUCNum, rtrim(ltrim(lower(i2.IACUCCode)))) as protocol,
	t.*

FROM (
 
select 

    Rpi.ProjectId as project,
    rpi.IACUCCode,
    rtrim(ltrim(Rpi.IACUCCode)) as name,
	coalesce ((select top 1 
				ipc.projectparentid
				from Ref_ProjectsIACUC rpi2 join Ref_IACUCParentChildren ipc on (rpi2.ProjectID = ipc.ProjectParentID and ipc.datedisabled is null)
				where ipc.projectchildid = rpi.projectid order by ipc.datecreated desc), rpi.projectid) as protocolId,
				
	(select top 1 ohsuaccountnumber from Ref_ProjectAccounts rpa
				where rpi.projectid = rpa.ProjectID order by datecreated desc) as account,
	(ri.LastName + ', ' + ri.FirstName) as inves,
	-- avail
	Rpi.Title,
	-- research
	-- reqname
	-- contact_emails
	Rpi.StartDate,
	Rpi.EndDate,
	-- inves2	
	--pc.InvestigatorID,
	(select max(i.rowid) from labkey.onprc_ehr.investigators i where i.firstname = ri.firstname and i.lastname = ri.lastname group by i.LastName, i.firstname having count(*) <= 1) as investigatorId,
	rpi.objectid

From Ref_ProjectsIACUC rpi
	left join Ref_ProjInvest pc on (pc.ProjectID = rpi.ProjectID AND pc.DateDisabled is null and pc.PIFlag = 1 and pc.investigatorid != 0)
	left join Ref_Investigator ri on (ri.InvestigatorID = pc.investigatorid)

WHERE (rpi.ts > ? or pc.ts > ?)

) t

LEFT JOIN Ref_ProjectsIACUC i2 ON (i2.ProjectID = t.protocolId)


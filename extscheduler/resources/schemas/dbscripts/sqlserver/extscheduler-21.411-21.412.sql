EXEC core.fn_dropifexists 'Covid19_insertDCMtoPrime', 'extScheduler', 'PROCEDURE', NULL;
GO


SET ANSI_NULLS ON
    GO
SET QUOTED_IDENTIFIER ON
    GO
    -- =============================================
-- Author:		jonesga
-- Create date: 2021-04-22
-- Description:	Inserts parsed user information from SP on groups to Events

    EXEC core.fn_dropifexists 'Covid19_insertDCMtoPrime', 'extScheduler', 'PROCEDURE', NULL;
GO


CREATE PROCEDURE [extscheduler].[Covid19_insertDCMtoPrime]

AS
BEGIN
INSERT INTO [extscheduler].[Events]
([ResourceId]
    ,[Name]
    ,[StartDate]
    ,[EndDate]
    ,[UserId]
    ,[Container]
    ,[CreatedBy]
    ,[Created]
    ,[Quantity]
    ,[Comments])
Select
    ResourceId,
    name,
    StartDate,
    startDate,
    UserId,
    Container,
    1101,
    '4/23/2021',
    1,
    'Created from group schedule ID#' + Cast(eventid as varchar(20))
from [extscheduler].[vw_Covid19DCMSchedule]
where EventID != EventID
END


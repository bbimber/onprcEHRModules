SELECT
    Id,
    Date,
    examNum,
    accessionNum,
    PMICType,
    PETRadioisotope,
    PETDoseMCI,
    PETDoseMBQ,
    route,
    CTACType,
    CTScanRange,
    CTDIvol,
    phantom,
    DLP,
    --totalExamDLP,
    wetLabUse,
    ligandAndComments,
    --imageUploadLink,
    taskid,
    qcstate,
    performedby,
    created,
    createdBy
from study.PMIC_PETImagingData

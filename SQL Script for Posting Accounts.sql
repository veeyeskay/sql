/*******************************************************************
Created on Nov 23, 2010 by Sivakumar Venkataraman
For updates see http://cvakumar.com/msdynamics/
This query provides the details of the posting accounts that
have been setup in Dynamics GP. 
*******************************************************************/
SELECT  CASE WHEN A.SERIES = 2 THEN 'Financial'
             WHEN A.SERIES = 3 THEN 'Sales'
             WHEN A.SERIES = 4 THEN 'Purchasing'
             WHEN A.SERIES = 5 THEN 'Inventory'
             WHEN A.SERIES = 7 THEN 'Project'
             ELSE 'Miscellaneous'
        END AS SERIES,
        A.PTGACDSC AS POSTINGACCDESC,
        ISNULL(RTRIM(C.ACTNUMST), '') AS ACCOUNTNO,
        ISNULL(RTRIM(B.ACTDESCR), '') AS ACCOUNTDESC
FROM    dbo.SY01100 A
        LEFT OUTER JOIN dbo.GL00100 B ON A.ACTINDX = B.ACTINDX
        LEFT OUTER JOIN GL00105 C ON A.ACTINDX = C.ACTINDX
ORDER BY A.SERIES,
        A.PTGACDSC
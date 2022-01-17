SELECT  Z.*
FROM    ( SELECT    RTRIM(B.[ACTNUMST]) AS GPACCOUNTNO ,
                    RTRIM(C.[ACTDESCR]) AS DESCRIPTION ,
                    A.[YEAR1] AS FISCALYEAR ,
                    A.[PERIODID] AS FISCALPERIOD ,
                    E.[PERNAME] AS FISCALPERIODNAME ,
                    ISNULL(A.[PERDBLNC], 0) AS NETCHANGE ,
                    ( SELECT    ISNULL(SUM(D.[PERDBLNC]), 0)
                      FROM      [dbo].[GL10110] D
                      WHERE     D.[ACTINDX] = A.[ACTINDX]
                                AND D.[YEAR1] = A.[YEAR1]
                                AND D.[PERIODID] <= A.[PERIODID]
                    ) AS PERIODBALANCE
          FROM      [dbo].[GL10110] A
                    INNER JOIN [dbo].[GL00105] B ON B.[ACTINDX] = A.[ACTINDX]
                    INNER JOIN [dbo].[GL00100] C ON C.[ACTINDX] = A.[ACTINDX]
                    INNER JOIN [dbo].[SY40100] E ON E.[YEAR1] = A.[YEAR1]
                                                    AND E.[PERIODID] = A.[PERIODID]
                                                    AND E.[SERIES] = 0
          UNION ALL
          SELECT    RTRIM(B.[ACTNUMST]) AS GPACCOUNTNO ,
                    RTRIM(C.[ACTDESCR]) AS DESCRIPTION ,
                    A.[YEAR1] AS FISCALYEAR ,
                    A.[PERIODID] AS FISCALPERIOD ,
                    E.[PERNAME] AS FISCALPERIODNAME ,
                    ISNULL(A.[PERDBLNC], 0) AS NETCHANGE ,
                    ( SELECT    ISNULL(SUM(D.[PERDBLNC]), 0)
                      FROM      [dbo].[GL10111] D
                      WHERE     D.[ACTINDX] = A.[ACTINDX]
                                AND D.[YEAR1] = A.[YEAR1]
                                AND D.[PERIODID] <= A.[PERIODID]
                    ) AS PERIODBALANCE
          FROM      [dbo].[GL10111] A
                    INNER JOIN [dbo].[GL00105] B ON B.[ACTINDX] = A.[ACTINDX]
                    INNER JOIN [dbo].[GL00100] C ON C.[ACTINDX] = A.[ACTINDX]
                    INNER JOIN [dbo].[SY40100] E ON E.[YEAR1] = A.[YEAR1]
                                                    AND E.[PERIODID] = A.[PERIODID]
                                                    AND E.[SERIES] = 0
        ) Z
ORDER BY Z.[GPACCOUNTNO] ,
        Z.[FISCALYEAR] ,
        Z.[FISCALPERIOD];
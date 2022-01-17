DECLARE @ASOFDATE AS DATETIME
 
SET @ASOFDATE = '2017-04-12'
 
SELECT  Z.*
FROM    ( SELECT    A.[OPENYEAR] TRXYEAR,
                    A.[ORTRXSRC] AS ARAUDITTRAIL,
                    A.[ORMSTRID] AS ARCUSTOMERNO,
                    A.[ORCTRNUM] AS ARDOCUMENTNO,
                    A.[ORTRXTYP] AS ARDOCUMENTTYPE,
                    A.[TRXDATE] AS TRANSACTIONDATE,
                    RTRIM(B.[ACTNUMST]) AS GPACCOUNTNO,
                    SUM([DEBITAMT] - [CRDTAMNT]) AS GLAMOUNT
          FROM      [dbo].[GL20000] A
                    INNER JOIN GL00105 B ON A.[ACTINDX] = B.[ACTINDX]
          WHERE     A.[ACTINDX] IN ( SELECT [PMAPINDX]
                                     FROM   [dbo].[PM00200] )
          GROUP BY  A.[OPENYEAR],
                    A.[ORTRXSRC],
                    A.[ORMSTRID],
                    A.[ORCTRNUM],
                    A.[ORTRXTYP],
                    A.[TRXDATE],
                    B.[ACTNUMST]
          UNION
          SELECT    A.[HSTYEAR] TRXYEAR,
                    A.[ORTRXSRC] AS ARAUDITTRAIL,
                    A.[ORMSTRID] AS ARCUSTOMERNO,
                    A.[ORCTRNUM] AS ARDOCUMENTNO,
                    A.[ORTRXTYP] AS ARDOCUMENTTYPE,
                    A.[TRXDATE] AS TRANSACTIONDATE,
                    RTRIM(B.[ACTNUMST]) AS GPACCOUNTNO,
                    SUM([DEBITAMT] - [CRDTAMNT]) AS GLAMOUNT
          FROM      [dbo].[GL30000] A
                    INNER JOIN GL00105 B ON A.[ACTINDX] = B.[ACTINDX]
          WHERE     A.[ACTINDX] IN ( SELECT [PMAPINDX]
                                     FROM   [dbo].[PM00200] )
          GROUP BY  A.[HSTYEAR],
                    A.[ORTRXSRC],
                    A.[ORMSTRID],
                    A.[ORCTRNUM],
                    A.[ORTRXTYP],
                    A.[TRXDATE],
                    B.[ACTNUMST]
        ) Z
WHERE   Z.[TRANSACTIONDATE] <= @ASOFDATE
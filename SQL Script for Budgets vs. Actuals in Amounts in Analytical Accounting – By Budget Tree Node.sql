IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[CVA_aaGetLvlCodeString]')
                    AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
    DROP FUNCTION [dbo].[CVA_aaGetLvlCodeString]
 
GO
 
/******************************************************************
Created June 16, 2011 by Sivakumar Venkataraman - Interdyn AKA
This function returns a string which contains the AA codes for 
a specific distribution line from the AA tables for a specific
budget tree.
 
Tables used: 
 - AAG00901 - AA Budget Tree Trx Dim Master
 - AAG30000 - aaGLHdr
 - AAG30001 - aaGLDist
 - AAG30002 - aaGLAssign
 - AAG30003 - aaGLCode
 ******************************************************************/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CVA_aaGetLvlCodeString]
    (
      @aaBudgetTreeID INT ,
      @aaGLHdrID INT ,
      @aaGLDistID INT ,
      @aaGLAssignID INT
    )
RETURNS NVARCHAR(51)
AS
    BEGIN
        DECLARE @aaLvlCodeString AS NVARCHAR(51)
        SELECT  @aaLvlCodeString = CASE WHEN @aaLvlCodeString IS NULL THEN ''
                                        ELSE @aaLvlCodeString + ','
                                   END + LTRIM(RTRIM(STR(A.aaTrxCodeID)))
        FROM    ( SELECT    E.aaOrder ,
                            D.aaTrxCodeID
                  FROM      dbo.AAG30000 A
                            INNER JOIN dbo.AAG30001 B ON A.aaGLHdrID = B.aaGLHdrID
                            INNER JOIN dbo.AAG30002 C ON B.aaGLHdrID = C.aaGLHdrID
                                                         AND B.aaGLDistID = C.aaGLDistID
                            INNER JOIN dbo.AAG30003 D ON C.aaGLHdrID = D.aaGLHdrID
                                                         AND C.aaGLDistID = D.aaGLDistID
                                                         AND C.aaGLAssignID = D.aaGLAssignID
                            INNER JOIN dbo.AAG00901 E ON D.aaTrxDimID = E.aaTrxDimID
                  WHERE     E.aaBudgetTreeID = @aaBudgetTreeID
                            AND D.aaGLHdrID = @aaGLHdrID
                            AND D.aaGLDistID = @aaGLDistID
                            AND D.aaGLAssignID = @aaGLAssignID
                ) A
        ORDER BY A.aaOrder
        RETURN @aaLvlCodeString
    END
 
/******************************************************************
Created June 16, 2011 by Sivakumar Venkataraman - Interdyn AKA
This script is to return budget vs. actual values from AA module
 
Tables used: 
 - AAG00905 - AA Budget Tree Account Balance
 - AAG00903 - AA Budget Master
 - AAG00902 - AA Budget Tree Trx Dim Code Master
 - AAG00900 - AA Budget Tree Master
 - AAG00401 - aaTrxDimCodeSetp
 - AAG30000 - aaGLHdr
 - AAG30001 - aaGLDist
 - AAG30002 - aaGLAssign
 - AAG30003 - aaGLCode
 - GL00100 - Account Master
 - GL00102 - Account Category Master
 - GL00105 - Account Index Master
 - SY40100 - Period Setup 
 
Custom Functions used:
 - CVA_aaGetLvlCodeString()
 ******************************************************************/
DECLARE @aaBudgetID INTEGER
 
--Define the Budget ID for analysis purposes
SET @aaBudgetID = 3
 
SELECT  B.aaBudget ,
        B.aaBudgetDescr ,
        C.aaBudgetTree ,
        C.aaBudgetTreeDescr ,
        J.YEAR1 AS glFiscalYear ,
        J.PERNAME AS glPeriodName ,
        CASE WHEN J.PERIODID <> 0
             THEN REPLICATE('0', 2 - LEN(J.PERIODID))
                  + ( LTRIM(RTRIM(STR(J.PERIODID))) + ':'
                      + ( LEFT({FN MONTHNAME(J.PERIODDT)}, 3) ) + ''''
                      + SUBSTRING(LTRIM(RTRIM(STR(J.YEAR1))), 3, 2) )
             ELSE '00:BBF''' + SUBSTRING(LTRIM(RTRIM(STR(J.YEAR1 - 1))), 3, 2)
        END AS glFiscalPeriod ,
        RTRIM(H.ACTNUMST) AS glAccountNo ,
        RTRIM(G.ACTDESCR) AS glAccountDesc ,
        RTRIM(I.ACCATDSC) AS glAccountCategory ,
        K.aaTrxDim AS aaTrxDimChild ,
        E.aaTrxDimCode AS aaTrxDimCodeChild ,
        ISNULL(L.aaTrxDim, '') AS aaTrxDimParent ,
        ISNULL(F.aaTrxDimCode, '') AS aaTrxDimCodeParent ,
        A.Balance AS aaBudgetAmount ,
        D.aaLvlCodeString ,
        ISNULL(( SELECT SUM(Z1.DEBITAMT - Z1.CRDTAMNT)
                 FROM   ( SELECT DISTINCT
                                    C1.DEBITAMT ,
                                    C1.CRDTAMNT
                          FROM      dbo.AAG30000 A1
                                    INNER JOIN dbo.AAG30001 B1 ON A1.aaGLHdrID = B1.aaGLHdrID
                                    INNER JOIN dbo.AAG30002 C1 ON B1.aaGLHdrID = C1.aaGLHdrID
                                                              AND B1.aaGLDistID = C1.aaGLDistID
                                    INNER JOIN dbo.AAG30003 D1 ON C1.aaGLHdrID = D1.aaGLHdrID
                                                              AND C1.aaGLDistID = D1.aaGLDistID
                                                              AND C1.aaGLAssignID = D1.aaGLAssignID
                                    INNER JOIN dbo.SY40100 E1 ON A1.GLPOSTDT >= E1.PERIODDT
                                                              AND A1.GLPOSTDT <= E1.PERDENDT
                          WHERE     E1.SERIES = 0
                                    AND E1.PERIODDT = A.PERIODDT
                                    AND B1.ACTINDX = A.ACTINDX
                                    AND dbo.CVA_aaGetLvlCodeString(C.aaBudgetTreeID,
                                                              C1.aaGLHdrID,
                                                              C1.aaGLDistID,
                                                              C1.aaGLAssignID) = D.aaLvlCodeString
                        ) Z1
               ), 0) AS aaActualAmount
FROM    dbo.AAG00905 A
        INNER JOIN dbo.AAG00903 B ON A.aaBudgetID = B.aaBudgetID
        INNER JOIN dbo.AAG00900 C ON B.aaBudgetTreeID = C.aaBudgetTreeID
        INNER JOIN dbo.AAG00902 D ON B.aaBudgetTreeID = D.aaBudgetTreeID
                                     AND A.aaCodeSequence = D.aaCodeSequence
        INNER JOIN dbo.AAG00401 E ON E.aaTrxDimCodeID = D.aaTrxDimCodeID
        LEFT OUTER JOIN dbo.AAG00401 F ON F.aaTrxDimCodeID = D.aaTrxDimParCodeID
        INNER JOIN dbo.AAG00400 K ON E.aaTrxDimID = K.aaTrxDimID
        LEFT OUTER JOIN dbo.AAG00400 L ON F.aaTrxDimID = L.aaTrxDimID
        INNER JOIN dbo.GL00100 G ON A.ACTINDX = G.ACTINDX
        INNER JOIN dbo.GL00105 H ON A.ACTINDX = H.ACTINDX
        INNER JOIN dbo.GL00102 I ON G.ACCATNUM = I.ACCATNUM
        INNER JOIN dbo.SY40100 J ON A.PERIODDT = J.PERIODDT
WHERE   J.SERIES = 0
        AND A.aaBudgetID = @aaBudgetID
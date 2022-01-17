/*******************************************************************
Created on Nov 09, 2010 by Sivakumar Venkataraman
For updates see http://cvakumar.com/msdynamics/
This query provides the period summary multicurrency balances at
dimension code level. 
The result of this query would tie back to the multicurrency balances 
stored in the MC00201 at the GP account level.
*******************************************************************/
SELECT  Z.GPACCOUNTNO ,
        Z.DIMENSION ,
        Z.DIMENSIONCODE ,
        Z.FYSTATUS ,
        Z.FISCALYEAR ,
        Z.FISCALPERIOD ,
        Z.PERIODNAME ,
        Z.CURRENCYID ,
        Z.ORIGNETCHANGE ,
        Z.FUNCNETCHANGE
FROM    ( SELECT    RTRIM(H.ACTNUMST) AS GPACCOUNTNO ,
                    F.aaTrxDim AS DIMENSION ,
                    E.aaTrxDimCode AS DIMENSIONCODE ,
                    'Open' AS FYSTATUS ,
                    B.YEAR1 AS FISCALYEAR ,
                    G.PERIODID AS FISCALPERIOD ,
                    G.PERNAME AS PERIODNAME ,
                    A.CURNCYID AS CURRENCYID ,
                    SUM(C.ORDBTAMT - C.ORCRDAMT) AS ORIGNETCHANGE ,
                    SUM(C.DEBITAMT - C.CRDTAMNT) AS FUNCNETCHANGE
          FROM      dbo.AAG30001 A
                    INNER JOIN dbo.AAG30000 B ON B.aaGLHdrID = A.aaGLHdrID
                    INNER JOIN dbo.AAG30002 C ON C.aaGLHdrID = A.aaGLHdrID
                                                 AND C.aaGLDistID = A.aaGLDistID
                    INNER JOIN dbo.AAG30003 D ON D.aaGLHdrID = C.aaGLHdrID
                                                 AND D.aaGLDistID = C.aaGLDistID
                                                 AND D.aaGLAssignID = C.aaGLAssignID
                    LEFT OUTER JOIN dbo.AAG00401 E ON D.aaTrxDimID = E.aaTrxDimID
                                                      AND D.aaTrxCodeID = E.aaTrxDimCodeID
                    LEFT OUTER JOIN dbo.AAG00400 F ON E.aaTrxDimID = F.aaTrxDimID
                    INNER JOIN dbo.SY40100 G ON B.YEAR1 = G.YEAR1
                                                AND B.GLPOSTDT >= G.PERIODDT
                                                AND B.GLPOSTDT <= G.PERDENDT
                                                AND G.SERIES = 0
                    INNER JOIN GL00105 H ON A.ACTINDX = H.ACTINDX
          GROUP BY  H.ACTNUMST ,
                    F.aaTrxDim ,
                    E.aaTrxDimCode ,
                    B.YEAR1 ,
                    G.PERIODID ,
                    G.PERNAME ,
                    A.CURNCYID
          UNION ALL
          SELECT    RTRIM(H.ACTNUMST) AS GPACCOUNTNO ,
                    F.aaTrxDim AS DIMENSION ,
                    E.aaTrxDimCode AS DIMENSIONCODE ,
                    'Historical' AS FYSTATUS ,
                    B.YEAR1 AS FISCALYEAR ,
                    G.PERIODID AS FISCALPERIOD ,
                    G.PERNAME AS PERIODNAME ,
                    A.CURNCYID AS CURRENCYID ,
                    SUM(C.ORDBTAMT - C.ORCRDAMT) AS ORIGNETCHANGE ,
                    SUM(C.DEBITAMT - C.CRDTAMNT) AS FUNCNETCHANGE
          FROM      dbo.AAG40001 A
                    INNER JOIN dbo.AAG40000 B ON B.aaGLHdrID = A.aaGLHdrID
                    INNER JOIN dbo.AAG40002 C ON C.aaGLHdrID = A.aaGLHdrID
                                                 AND C.aaGLDistID = A.aaGLDistID
                    INNER JOIN dbo.AAG40003 D ON D.aaGLHdrID = C.aaGLHdrID
                                                 AND D.aaGLDistID = C.aaGLDistID
                                                 AND D.aaGLAssignID = C.aaGLAssignID
                    LEFT OUTER JOIN dbo.AAG00401 E ON D.aaTrxDimID = E.aaTrxDimID
                                                      AND D.aaTrxCodeID = E.aaTrxDimCodeID
                    LEFT OUTER JOIN dbo.AAG00400 F ON E.aaTrxDimID = F.aaTrxDimID
                    INNER JOIN dbo.SY40100 G ON B.YEAR1 = G.YEAR1
                                                AND B.GLPOSTDT >= G.PERIODDT
                                                AND B.GLPOSTDT <= G.PERDENDT
                                                AND G.SERIES = 0
                    INNER JOIN GL00105 H ON A.ACTINDX = H.ACTINDX
          GROUP BY  H.ACTNUMST ,
                    F.aaTrxDim ,
                    E.aaTrxDimCode ,
                    B.YEAR1 ,
                    G.PERIODID ,
                    G.PERNAME ,
                    A.CURNCYID
        ) Z
WHERE   Z.CURRENCYID NOT IN ( SELECT    FUNLCURR
                              FROM      dbo.MC40000 )
ORDER BY Z.GPACCOUNTNO ,
        Z.DIMENSION ,
        Z.DIMENSIONCODE ,
        Z.FYSTATUS ,
        Z.FISCALYEAR ,
        Z.FISCALPERIOD ,
        Z.PERIODNAME ,
        Z.CURRENCYID;
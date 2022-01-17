SELECT  BvA.aaBudget ,
        BvA.glFiscalYear ,
        BvA.glFiscalPeriod ,
        BvA.glAccountCategory ,
        BvA.glAccountNo ,
        BvA.glAccountDesc ,
        BvA.aaTrxDim ,
        BvA.aaTrxDimCode ,
        BvA.aaTrxDimCodeDescr ,
        BvA.aaActualAmount AS aaActualAmount ,
        BvA.aaBudgetAmount AS aaBudgetAmount ,
        ( BvA.aaBudgetAmount - BvA.aaActualAmount ) AS aaVariance ,
        CASE WHEN BvA.aaBudgetAmount <> 0
             THEN CONVERT(NUMERIC(5, 2), ROUND(( ( ( BvA.aaBudgetAmount
                                                     - BvA.aaActualAmount )
                                                   / BvA.aaBudgetAmount )
                                                 * 100 ), 2))
             ELSE CONVERT(NUMERIC(19, 2), BvA.aaBudgetAmount)
        END AS aaVariancePercent
FROM    ( SELECT  DISTINCT
                    B.aaBudget ,
                    RTRIM(B.aaBudgetDescr) AS aaBudgetDescr ,
                    J.YEAR1 AS glFiscalYear ,
                    CASE WHEN J.PERIODID <> 0 THEN {FN MONTHNAME(J.PERIODDT)}
                         ELSE 'BBF'
                    END AS glPeriodName ,
                    CASE WHEN J.PERIODID <> 0
                         THEN REPLICATE('0', 2 - LEN(J.PERIODID))
                              + ( LTRIM(RTRIM(STR(J.PERIODID))) + ':'
                                  + ( LEFT({FN MONTHNAME(J.PERIODDT)}, 3) )
                                  + '''' + SUBSTRING(LTRIM(RTRIM(STR(J.YEAR1))),
                                                     3, 2) )
                         ELSE '00:BBF''' + SUBSTRING(LTRIM(RTRIM(STR(J.YEAR1
                                                              - 1))), 3, 2)
                    END AS glFiscalPeriod ,
                    RTRIM(H.ACTNUMST) AS glAccountNo ,
                    RTRIM(G.ACTDESCR) AS glAccountDesc ,
                    RTRIM(I.ACCATDSC) AS glAccountCategory ,
                    RTRIM(E1.aaTrxDim) AS aaTrxDim ,
                    RTRIM(E.aaTrxDimCode) AS aaTrxDimCode ,
                    RTRIM(E.aaTrxDimCodeDescr) AS aaTrxDimCodeDescr ,
                    A.Balance AS aaBudgetAmount ,
                    ISNULL(( SELECT SUM(C1.DEBITAMT - C1.CRDTAMNT)
                             FROM   dbo.AAG30000 A1
                                    INNER JOIN dbo.AAG30001 B1 ON A1.aaGLHdrID = B1.aaGLHdrID
                                    INNER JOIN dbo.AAG30002 C1 ON B1.aaGLHdrID = C1.aaGLHdrID
                                                              AND B1.aaGLDistID = C1.aaGLDistID
                                    INNER JOIN dbo.AAG30003 D1 ON C1.aaGLHdrID = D1.aaGLHdrID
                                                              AND C1.aaGLDistID = D1.aaGLDistID
                                                              AND C1.aaGLAssignID = D1.aaGLAssignID
                                    INNER JOIN dbo.SY40100 E1 ON A1.GLPOSTDT >= E1.PERIODDT
                                                              AND A1.GLPOSTDT <= E1.PERDENDT
                             WHERE  E1.SERIES = 0
                                    AND E1.PERIODDT = A.PERIODDT
                                    AND B1.ACTINDX = A.ACTINDX
                                    AND D1.aaTrxCodeID = D.aaTrxDimCodeID
                           ), 0) AS aaActualAmount
          FROM      dbo.AAG00905 A
                    INNER JOIN dbo.AAG00903 B ON A.aaBudgetID = B.aaBudgetID
                    INNER JOIN dbo.AAG00902 D ON B.aaBudgetTreeID = D.aaBudgetTreeID
                                                 AND A.aaCodeSequence = D.aaCodeSequence
                    INNER JOIN dbo.AAG00401 E ON E.aaTrxDimCodeID = D.aaTrxDimCodeID
                    INNER JOIN dbo.AAG00400 E1 ON E.aaTrxDimID = E1.aaTrxDimID
                    INNER JOIN dbo.GL00100 G ON A.ACTINDX = G.ACTINDX
                    INNER JOIN dbo.GL00105 H ON A.ACTINDX = H.ACTINDX
                    INNER JOIN dbo.GL00102 I ON G.ACCATNUM = I.ACCATNUM
                    INNER JOIN dbo.SY40100 J ON A.PERIODDT = J.PERIODDT
                    LEFT OUTER JOIN SY03900 K ON B.NOTEINDX = K.NOTEINDX
          WHERE     J.SERIES = 0
        ) BvA;
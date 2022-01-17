/******************************************************************
Created July 21, 2011 by Sivakumar Venkataraman - Interdyn AKA
This view is for the Receivables HATB for aging by document
date (using the payment terms on the document) and
picking transactions using the Document Date.
 
Tables used: 
 - RM20101 - RM Open File
 - RM30101 - RM History File
 - RM20201 - RM Apply Open File
 - RM30201 - RM Apply History File
 - RM40401 - Document Type Setup File
 - RM40201 - RM Period Setup
 ******************************************************************/
 
DECLARE @ASOFDATE DATETIME;
 
SET @ASOFDATE = '2017-04-12';
 
SELECT  X.CUSTOMERNUMBER ,
        X.CORPORATECUSTNUMBER ,
        X.DOCUMENTNO ,
        X.DOCUMENTTYPE ,
        X.DOCUMENTDATE ,
        X.GLPOSTINGDATE ,
        X.DUEDATE ,
        X.DAYSDUE ,
        CASE WHEN X.DAYSDUE > 999 THEN ( SELECT TOP 1
                                                RMPERDSC
                                         FROM   dbo.RM40201
                                         ORDER BY RMPEREND DESC
                                       )
             WHEN X.DAYSDUE < 0 THEN 'Not Due'
             ELSE ISNULL(( SELECT TOP 1
                                    RMPERDSC
                           FROM     dbo.RM40201 AG
                           WHERE    X.DAYSDUE <= AG.RMPEREND
                           ORDER BY RMPEREND
                         ), '')
        END AS AGINGBUCKET ,
        X.DOCUMENTAMT ,
        X.APPLIEDAMT ,
        X.WRITEOFFAMT ,
        X.DISCTAKENAMT ,
        X.REALGAINLOSSAMT ,
        ( X.DOCUMENTAMT - X.APPLIEDAMT - X.WRITEOFFAMT - X.DISCTAKENAMT
          + X.REALGAINLOSSAMT ) AS CURRENTAMT
FROM    ( SELECT    Z.CUSTNMBR AS CUSTOMERNUMBER ,
                    Z.CPRCSTNM AS CORPORATECUSTNUMBER ,
                    Z.DOCNUMBR AS DOCUMENTNO ,
                    Z.DOCTYPE AS DOCUMENTTYPE ,
                    Z.DOCDATE AS DOCUMENTDATE ,
                    Z.GLPOSTINGDATE AS GLPOSTINGDATE ,
                    Z.DUEDATE ,
                    DATEDIFF(dd, Z.DUEDATE, @ASOFDATE) AS DAYSDUE ,
                    Z.ORTRXAMT AS DOCUMENTAMT ,
                    CASE WHEN Z.[RMDTYPAL] <= 6
                         THEN ISNULL(( SELECT   SUM(Y.[ActualApplyToAmount])
                                       FROM     ( SELECT    [CUSTNMBR] ,
                                                            [DATE1] ,
                                                            [APFRDCDT] ,
                                                            [APTODCNM] ,
                                                            [APTODCTY] ,
                                                            [ActualApplyToAmount]
                                                  FROM      dbo.[RM20201]
                                                  UNION
                                                  SELECT    [CUSTNMBR] ,
                                                            [DATE1] ,
                                                            [APFRDCDT] ,
                                                            [APTODCNM] ,
                                                            [APTODCTY] ,
                                                            [ActualApplyToAmount]
                                                  FROM      dbo.[RM30201]
                                                ) Y
                                       WHERE    Y.[DATE1] <= @ASOFDATE
                                                AND Y.[APFRDCDT] <= @ASOFDATE
                                                AND Y.[CUSTNMBR] = Z.CUSTNMBR
                                                AND Y.[APTODCNM] = Z.DOCNUMBR
                                                AND Y.[APTODCTY] = Z.RMDTYPAL
                                     ), 0)
                         WHEN Z.[RMDTYPAL] > 7
                              AND Z.[RMDTYPAL] <= 9
                         THEN ISNULL(( SELECT   SUM(Y.[ActualApplyToAmount])
                                       FROM     ( SELECT    [CUSTNMBR] ,
                                                            [DATE1] ,
                                                            [APTODCDT] ,
                                                            [APFRDCNM] ,
                                                            [APFRDCTY] ,
                                                            [ActualApplyToAmount]
                                                  FROM      dbo.[RM20201]
                                                  UNION
                                                  SELECT    [CUSTNMBR] ,
                                                            [DATE1] ,
                                                            [APTODCDT] ,
                                                            [APFRDCNM] ,
                                                            [APFRDCTY] ,
                                                            [ActualApplyToAmount]
                                                  FROM      dbo.[RM30201]
                                                ) Y
                                       WHERE    Y.[DATE1] <= @ASOFDATE
                                                AND Y.[APTODCDT] <= @ASOFDATE
                                                AND Y.[CUSTNMBR] = Z.CUSTNMBR
                                                AND Y.[APFRDCNM] = Z.DOCNUMBR
                                                AND Y.[APFRDCTY] = Z.RMDTYPAL
                                     ), 0)
                         ELSE 0
                    END AS APPLIEDAMT ,
                    CASE WHEN Z.[RMDTYPAL] <= 6
                         THEN ISNULL(( SELECT   SUM(Y.[WROFAMNT])
                                       FROM     ( SELECT    [CUSTNMBR] ,
                                                            [DATE1] ,
                                                            [APFRDCDT] ,
                                                            [APTODCNM] ,
                                                            [APTODCTY] ,
                                                            [WROFAMNT]
                                                  FROM      dbo.[RM20201]
                                                  UNION
                                                  SELECT    [CUSTNMBR] ,
                                                            [DATE1] ,
                                                            [APFRDCDT] ,
                                                            [APTODCNM] ,
                                                            [APTODCTY] ,
                                                            [WROFAMNT]
                                                  FROM      dbo.[RM30201]
                                                ) Y
                                       WHERE    Y.[DATE1] <= @ASOFDATE
                                                AND Y.[APFRDCDT] <= @ASOFDATE
                                                AND Y.[CUSTNMBR] = Z.CUSTNMBR
                                                AND Y.[APTODCNM] = Z.DOCNUMBR
                                                AND Y.[APTODCTY] = Z.RMDTYPAL
                                     ), 0)
                         ELSE 0
                    END AS WRITEOFFAMT ,
                    CASE WHEN Z.[RMDTYPAL] <= 6
                         THEN ISNULL(( SELECT   SUM(Y.[DISTKNAM])
                                       FROM     ( SELECT    [CUSTNMBR] ,
                                                            [DATE1] ,
                                                            [APFRDCDT] ,
                                                            [APTODCNM] ,
                                                            [APTODCTY] ,
                                                            [DISTKNAM]
                                                  FROM      dbo.[RM20201]
                                                  UNION
                                                  SELECT    [CUSTNMBR] ,
                                                            [DATE1] ,
                                                            [APFRDCDT] ,
                                                            [APTODCNM] ,
                                                            [APTODCTY] ,
                                                            [DISTKNAM]
                                                  FROM      dbo.[RM30201]
                                                ) Y
                                       WHERE    Y.[DATE1] <= @ASOFDATE
                                                AND Y.[APFRDCDT] <= @ASOFDATE
                                                AND Y.[CUSTNMBR] = Z.CUSTNMBR
                                                AND Y.[APTODCNM] = Z.DOCNUMBR
                                                AND Y.[APTODCTY] = Z.RMDTYPAL
                                     ), 0)
                         ELSE 0
                    END AS DISCTAKENAMT ,
                    CASE WHEN Z.[RMDTYPAL] > 7
                              AND Z.[RMDTYPAL] <= 9
                         THEN ISNULL(( SELECT   SUM(Y.[RLGANLOS])
                                       FROM     ( SELECT    [CUSTNMBR] ,
                                                            [DATE1] ,
                                                            [APTODCDT] ,
                                                            [APFRDCNM] ,
                                                            [APFRDCTY] ,
                                                            [RLGANLOS]
                                                  FROM      dbo.[RM20201]
                                                  UNION
                                                  SELECT    [CUSTNMBR] ,
                                                            [DATE1] ,
                                                            [APTODCDT] ,
                                                            [APFRDCNM] ,
                                                            [APFRDCTY] ,
                                                            [RLGANLOS]
                                                  FROM      dbo.[RM30201]
                                                ) Y
                                       WHERE    Y.[DATE1] <= @ASOFDATE
                                                AND Y.[APTODCDT] <= @ASOFDATE
                                                AND Y.[CUSTNMBR] = Z.CUSTNMBR
                                                AND Y.[APFRDCNM] = Z.DOCNUMBR
                                                AND Y.[APFRDCTY] = Z.RMDTYPAL
                                     ), 0)
                         ELSE 0
                    END AS REALGAINLOSSAMT
          FROM      ( SELECT    A.[CUSTNMBR] ,
                                A.[CPRCSTNM] ,
                                A.[DOCNUMBR] ,
                                A.[RMDTYPAL] ,
                                B.[DOCDESCR] AS DOCTYPE ,
                                A.[DOCDATE] ,
                                A.[GLPOSTDT] AS GLPOSTINGDATE ,
                                A.[PYMTRMID] AS PAYMENTTERM ,
                                DATEADD(dd, ISNULL(C.DUEDTDS, 0), A.DOCDATE) AS DUEDATE ,
                                A.[ORTRXAMT]
                      FROM      [dbo].[RM20101] A
                                INNER JOIN RM40401 B ON A.[RMDTYPAL] = B.[RMDTYPAL]
                                LEFT OUTER JOIN dbo.SY03300 C ON A.PYMTRMID = C.PYMTRMID
                      WHERE     [VOIDSTTS] = 0
                      UNION
                      SELECT    A.[CUSTNMBR] ,
                                A.[CPRCSTNM] ,
                                A.[DOCNUMBR] ,
                                A.[RMDTYPAL] ,
                                B.[DOCDESCR] AS DOCTYPE ,
                                A.[DOCDATE] ,
                                A.[VOIDDATE] AS GLPOSTINGDATE ,
                                A.[PYMTRMID] AS PAYMENTTERM ,
                                DATEADD(dd, ISNULL(C.DUEDTDS, 0), A.DOCDATE) AS DUEDATE ,
                                A.[ORTRXAMT] * -1
                      FROM      [dbo].[RM20101] A
                                INNER JOIN [dbo].[RM40401] B ON A.[RMDTYPAL] = B.[RMDTYPAL]
                                LEFT OUTER JOIN dbo.SY03300 C ON A.PYMTRMID = C.PYMTRMID
                      WHERE     [VOIDSTTS] = 1
                      UNION
                      SELECT    A.[CUSTNMBR] ,
                                A.[CPRCSTNM] ,
                                A.[DOCNUMBR] ,
                                A.[RMDTYPAL] ,
                                B.[DOCDESCR] AS DOCTYPE ,
                                A.[DOCDATE] ,
                                A.[GLPOSTDT] AS GLPOSTINGDATE ,
                                A.[PYMTRMID] AS PAYMENTTERM ,
                                DATEADD(dd, ISNULL(C.DUEDTDS, 0), A.DOCDATE) AS DUEDATE ,
                                A.[ORTRXAMT]
                      FROM      [dbo].[RM30101] A
                                INNER JOIN [dbo].[RM40401] B ON A.[RMDTYPAL] = B.[RMDTYPAL]
                                LEFT OUTER JOIN dbo.SY03300 C ON A.PYMTRMID = C.PYMTRMID
                      WHERE     [VOIDSTTS] = 0
                      UNION
                      SELECT    A.[CUSTNMBR] ,
                                A.[CPRCSTNM] ,
                                A.[DOCNUMBR] ,
                                A.[RMDTYPAL] ,
                                B.[DOCDESCR] AS DOCTYPE ,
                                A.[DOCDATE] ,
                                A.[VOIDDATE] AS GLPOSTINGDATE ,
                                A.[PYMTRMID] AS PAYMENTTERM ,
                                DATEADD(dd, ISNULL(C.DUEDTDS, 0), A.DOCDATE) AS DUEDATE ,
                                A.[ORTRXAMT] * -1
                      FROM      [dbo].[RM30101] A
                                INNER JOIN [dbo].[RM40401] B ON A.[RMDTYPAL] = B.[RMDTYPAL]
                                LEFT OUTER JOIN dbo.SY03300 C ON A.PYMTRMID = C.PYMTRMID
                      WHERE     [VOIDSTTS] = 1
                    ) Z
          WHERE     Z.DOCDATE <= @ASOFDATE
        ) X;
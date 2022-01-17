IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[vw_GLTrialBalancev2010]')
                    AND OBJECTPROPERTY(id, N'IsView') = 1 )
    DROP VIEW [dbo].[vw_GLTrialBalancev2010];
GO
 
SET QUOTED_IDENTIFIER ON;
GO
SET ANSI_NULLS ON;
GO
 
CREATE VIEW dbo.vw_GLTrialBalancev2010
AS
    SELECT  A.OPENYEAR AS [FISCALYEAR] ,
            A.JRNENTRY AS [JVNUMBER] ,
            A.REFRENCE AS REFERENCE ,
            A.DSCRIPTN AS [DISTREFERENCE] ,
            A.TRXDATE AS [JVDATE] ,
            WEEKNO = CASE WHEN YEAR(A.TRXDATE) = A.OPENYEAR
                          THEN 'Week ' + REPLICATE('0',
                                                   2
                                                   - LEN({FN WEEK(A.TRXDATE)}))
                               + LTRIM(RTRIM(STR({FN WEEK(A.TRXDATE)})))
                          ELSE '00:BBF'''
                               + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                           3, 2)
                     END ,
            PERIOD = CASE WHEN YEAR(A.TRXDATE) = A.OPENYEAR
                          THEN REPLICATE('0', 2 - LEN(MONTH(A.TRXDATE)))
                               + ( LTRIM(RTRIM(STR(MONTH(A.TRXDATE)))) + ':'
                                   + ( LEFT({FN MONTHNAME(A.TRXDATE)}, 3) )
                                   + ''''
                                   + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                               3, 2) )
                          ELSE '00:BBF'''
                               + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                           3, 2)
                     END ,
            QUARTERNO = CASE WHEN YEAR(A.TRXDATE) = A.OPENYEAR
                                  AND {FN QUARTER(A.TRXDATE)} = 1
                             THEN 'Q1:Jan' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2) + '-Mar' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2)
                             WHEN YEAR(A.TRXDATE) = A.OPENYEAR
                                  AND {FN QUARTER(A.TRXDATE)} = 2
                             THEN 'Q2:Apr' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2) + '-Jun' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2)
                             WHEN YEAR(A.TRXDATE) = A.OPENYEAR
                                  AND {FN QUARTER(A.TRXDATE)} = 3
                             THEN 'Q3:Jul' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2) + '-Sep' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2)
                             WHEN YEAR(A.TRXDATE) = A.OPENYEAR
                                  AND {FN QUARTER(A.TRXDATE)} = 4
                             THEN 'Q4:Oct' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2) + '-Dec' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2)
                             ELSE '00:BBF'''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2)
                        END ,
            D.ACTNUMST AS [ACCOUNTNUMBER] ,
            B.ACTNUMBR_1 AS SEGMENT1 ,
            B.ACTNUMBR_2 AS SEGMENT2 ,
            B.ACTNUMBR_3 AS SEGMENT3 ,
            B.ACTDESCR AS ACCOUNTDESCRIPTION ,
            C.ACCATDSC AS CATEGORY ,
            CASE B.ACCTTYPE
              WHEN 1 THEN 'Posting Account'
              WHEN 2 THEN 'Unit Account'
              WHEN 3 THEN 'Posting Allocation Account'
              WHEN 4 THEN 'Unit Allocation Account'
            END AS [ACCOUNTTYPE] ,
            CASE B.ACTIVE
              WHEN 1 THEN 'Active'
              WHEN 0 THEN 'Inactive'
            END AS [STATUS] ,
            CASE B.PSTNGTYP
              WHEN 0 THEN 'Balance Sheet'
              WHEN 1 THEN 'Profit & Loss'
            END AS [POSTINGTYPE] ,
            A.TRXSORCE AS [AUDITTRAIL] ,
            A.USWHPSTD AS [POSTEDUSER] ,
            CASE A.SERIES
              WHEN 1 THEN 'All'
              WHEN 2 THEN 'Financial'
              WHEN 3 THEN 'Sales'
              WHEN 4 THEN 'Purchasing'
              WHEN 5 THEN 'Inventory'
              WHEN 6 THEN 'Payroll'
              WHEN 7 THEN 'Project'
            END AS SERIES ,
            A.ORDOCNUM AS [ORIGDOCNUMBER] ,
            A.ORMSTRNM AS [ORIGMASTERNAME] ,
            A.ORTRXSRC AS [ORIGAUDITTRAIL] ,
            A.CURNCYID AS [CURRENCYID] ,
            A.ORDBTAMT AS [ORIGDEBIT] ,
            A.ORCRDAMT AS [ORIGCREDIT] ,
            ( A.ORDBTAMT - A.ORCRDAMT ) ORIGNETAMOUNT ,
            A.DEBITAMT AS [FUNCDEBIT] ,
            A.CRDTAMNT AS [FUNCCREDIT] ,
            ( A.DEBITAMT - A.CRDTAMNT ) FUNCNETAMOUNT ,
            A.SOURCDOC ,
            E.GROUPID ANALYSISGROUPID ,
            E.GROUPAMT ANALYSISGROUPAMOUNT ,
            F.CODEID ANALYSISCODEID ,
            F.POSTDESC ANALYSISPOSTINGDESC ,
            F.CODEAMT ANALYSISCODEAMOUNT
    FROM    dbo.GL20000 A
            INNER JOIN dbo.GL00100 B ON A.ACTINDX = B.ACTINDX
            INNER JOIN dbo.GL00102 C ON B.ACCATNUM = C.ACCATNUM
            INNER JOIN dbo.GL00105 D ON B.ACTINDX = D.ACTINDX
            LEFT OUTER JOIN dbo.DTA10100 E ON E.JRNENTRY = A.JRNENTRY
                                              AND E.ACTINDX = A.ACTINDX
            LEFT OUTER JOIN dbo.DTA10200 F ON F.DTAREF = E.DTAREF
    UNION ALL
    SELECT  A.HSTYEAR AS [FISCALYEAR] ,
            A.JRNENTRY AS [JVNUMBER] ,
            A.REFRENCE AS REFERENCE ,
            A.DSCRIPTN AS [DISTREFERENCE] ,
            A.TRXDATE AS [JVDATE] ,
            WEEKNO = CASE WHEN YEAR(A.TRXDATE) = A.HSTYEAR
                          THEN 'Week ' + REPLICATE('0',
                                                   2
                                                   - LEN({FN WEEK(A.TRXDATE)}))
                               + LTRIM(RTRIM(STR({FN WEEK(A.TRXDATE)})))
                          ELSE '00:BBF'''
                               + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                           3, 2)
                     END ,
            PERIOD = CASE WHEN YEAR(A.TRXDATE) = A.HSTYEAR
                          THEN REPLICATE('0', 2 - LEN(MONTH(A.TRXDATE)))
                               + ( LTRIM(RTRIM(STR(MONTH(A.TRXDATE)))) + ':'
                                   + ( LEFT({FN MONTHNAME(A.TRXDATE)}, 3) )
                                   + ''''
                                   + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                               3, 2) )
                          ELSE '00:BBF'''
                               + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                           3, 2)
                     END ,
            QUARTERNO = CASE WHEN YEAR(A.TRXDATE) = A.HSTYEAR
                                  AND {FN QUARTER(A.TRXDATE)} = 1
                             THEN 'Q1:Jan' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2) + '-Mar' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2)
                             WHEN YEAR(A.TRXDATE) = A.HSTYEAR
                                  AND {FN QUARTER(A.TRXDATE)} = 2
                             THEN 'Q2:Apr' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2) + '-Jun' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2)
                             WHEN YEAR(A.TRXDATE) = A.HSTYEAR
                                  AND {FN QUARTER(A.TRXDATE)} = 3
                             THEN 'Q3:Jul' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2) + '-Sep' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2)
                             WHEN YEAR(A.TRXDATE) = A.HSTYEAR
                                  AND {FN QUARTER(A.TRXDATE)} = 4
                             THEN 'Q4:Oct' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2) + '-Dec' + ''''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2)
                             ELSE '00:BBF'''
                                  + SUBSTRING(LTRIM(RTRIM(STR(YEAR(A.TRXDATE)))),
                                              3, 2)
                        END ,
            D.ACTNUMST AS [ACCOUNTNUMBER] ,
            B.ACTNUMBR_1 AS SEGMENT1 ,
            B.ACTNUMBR_2 AS SEGMENT2 ,
            B.ACTNUMBR_3 AS SEGMENT3 ,
            B.ACTDESCR AS ACCOUNTDESCRIPTION ,
            C.ACCATDSC AS CATEGORY ,
            CASE B.ACCTTYPE
              WHEN 1 THEN 'Posting Account'
              WHEN 2 THEN 'Unit Account'
              WHEN 3 THEN 'Posting Allocation Account'
              WHEN 4 THEN 'Unit Allocation Account'
            END AS [ACCOUNTTYPE] ,
            CASE B.ACTIVE
              WHEN 1 THEN 'Active'
              WHEN 0 THEN 'Inactive'
            END AS [STATUS] ,
            CASE B.PSTNGTYP
              WHEN 0 THEN 'Balance Sheet'
              WHEN 1 THEN 'Profit & Loss'
            END AS [POSTINGTYPE] ,
            A.TRXSORCE AS [AUDITTRAIL] ,
            A.USWHPSTD AS [POSTEDUSER] ,
            CASE A.SERIES
              WHEN 1 THEN 'All'
              WHEN 2 THEN 'Financial'
              WHEN 3 THEN 'Sales'
              WHEN 4 THEN 'Purchasing'
              WHEN 5 THEN 'Inventory'
              WHEN 6 THEN 'Payroll'
              WHEN 7 THEN 'Project'
            END AS SERIES ,
            A.ORDOCNUM AS [ORIGDOCNUMBER] ,
            A.ORMSTRNM AS [ORIGMASTERNAME] ,
            A.ORTRXSRC AS [ORIGAUDITTRAIL] ,
            A.CURNCYID AS [CURRENCYID] ,
            A.ORDBTAMT AS [ORIGDEBIT] ,
            A.ORCRDAMT AS [ORIGCREDIT] ,
            ( A.ORDBTAMT - A.ORCRDAMT ) ORIGNETAMOUNT ,
            A.DEBITAMT AS [FUNCDEBIT] ,
            A.CRDTAMNT AS [FUNCCREDIT] ,
            ( A.DEBITAMT - A.CRDTAMNT ) FUNCNETAMOUNT ,
            A.SOURCDOC ,
            E.GROUPID ANALYSISGROUPID ,
            E.GROUPAMT ANALYSISGROUPAMOUNT ,
            F.CODEID ANALYSISCODEID ,
            F.POSTDESC ANALYSISPOSTINGDESC ,
            F.CODEAMT ANALYSISCODEAMOUNT
    FROM    dbo.GL30000 A
            INNER JOIN dbo.GL00100 B ON A.ACTINDX = B.ACTINDX
            INNER JOIN dbo.GL00102 C ON B.ACCATNUM = C.ACCATNUM
            INNER JOIN dbo.GL00105 D ON B.ACTINDX = D.ACTINDX
            LEFT OUTER JOIN dbo.DTA10100 E ON E.JRNENTRY = A.JRNENTRY
                                              AND E.ACTINDX = A.ACTINDX
            LEFT OUTER JOIN dbo.DTA10200 F ON F.DTAREF = E.DTAREF;
 
GO
 
GRANT SELECT ON vw_GLTrialBalancev2010 TO DYNGRP;
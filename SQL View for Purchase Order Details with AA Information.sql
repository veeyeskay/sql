IF EXISTS ( SELECT  *
            FROM    sys.views
            WHERE   object_id = OBJECT_ID(N'[dbo].[vw_POInformation]') )
    DROP VIEW [dbo].[vw_POInformation];
 
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
 
/******************************************************************
Created May 09, 2011 by Sivakumar Venkataraman - Interdyn AKA
This view is to return the PO information (header and lines) from
both work and history tables.
 
View Name: vw_POInformation
Tables used: 
 - POP10100 - PO Work Header 
 - POP10110 - PO Work Line 
 - POP30100 - PO History Header 
 - POP30110 - PO History Line 
 - GL00100  - GL Account Master
 - GL00105  - GL Account Index Master
 ******************************************************************/
CREATE VIEW [dbo].[vw_POInformation]
AS
    SELECT  'Work' AS POSTATUS ,
            A.PONUMBER ,
            CASE WHEN A.POTYPE = 1 THEN 'Standard'
                 WHEN A.POTYPE = 2 THEN 'Drop-ship'
                 WHEN A.POTYPE = 3 THEN 'Blanket'
                 WHEN A.POTYPE = 4 THEN 'Drop-ship Blanket'
                 ELSE ''
            END AS POTYPE ,
            A.DOCDATE ,
            A.VENDORID ,
            A.VENDNAME ,
            A.VADCDPAD ,
            A.PRBTADCD ,
            A.PRSTADCD ,
            A.PYMTRMID ,
            A.CURNCYID ,
            A.RATETPID ,
            A.EXGTBLID ,
            A.XCHGRATE ,
            A.EXCHDATE ,
            A.RATECALC ,
            A.ORSUBTOT ,
            A.ORTDISAM ,
            A.ORFRTAMT ,
            A.OMISCAMT ,
            A.ORTAXAMT ,
            A.BUYERID ,
            A.Revision_Number ,
            B.ORD ,
            B.ITEMNMBR ,
            B.ITEMDESC ,
            B.VNDITNUM ,
            B.VNDITDSC ,
            B.LOCNCODE ,
            B.UOFM ,
            B.QTYORDER ,
            B.UNITCOST ,
            B.EXTDCOST ,
            D.ACTNUMST ,
            C.ACTDESCR
    FROM    TWO.dbo.POP10100 A
            INNER JOIN TWO.dbo.POP10110 B ON A.PONUMBER = B.PONUMBER
            INNER JOIN TWO.dbo.GL00100 C ON C.ACTINDX = B.INVINDX
            INNER JOIN TWO.dbo.GL00105 D ON D.ACTINDX = C.ACTINDX
    UNION
    SELECT  'History' AS POSTATUS ,
            A.PONUMBER ,
            CASE WHEN A.POTYPE = 1 THEN 'Standard'
                 WHEN A.POTYPE = 2 THEN 'Drop-ship'
                 WHEN A.POTYPE = 3 THEN 'Blanket'
                 WHEN A.POTYPE = 4 THEN 'Drop-ship Blanket'
                 ELSE ''
            END AS POTYPE ,
            A.DOCDATE ,
            A.VENDORID ,
            A.VENDNAME ,
            A.VADCDPAD ,
            A.PRBTADCD ,
            A.PRSTADCD ,
            A.PYMTRMID ,
            A.CURNCYID ,
            A.RATETPID ,
            A.EXGTBLID ,
            A.XCHGRATE ,
            A.EXCHDATE ,
            A.RATECALC ,
            A.ORSUBTOT ,
            A.ORTDISAM ,
            A.ORFRTAMT ,
            A.OMISCAMT ,
            A.ORTAXAMT ,
            A.BUYERID ,
            A.Revision_Number ,
            B.ORD ,
            B.ITEMNMBR ,
            B.ITEMDESC ,
            B.VNDITNUM ,
            B.VNDITDSC ,
            B.LOCNCODE ,
            B.UOFM ,
            B.QTYORDER ,
            B.UNITCOST ,
            B.EXTDCOST ,
            D.ACTNUMST ,
            C.ACTDESCR
    FROM    TWO.dbo.POP30100 A
            INNER JOIN TWO.dbo.POP30110 B ON A.PONUMBER = B.PONUMBER
            INNER JOIN TWO.dbo.GL00100 C ON C.ACTINDX = B.INVINDX
            INNER JOIN TWO.dbo.GL00105 D ON D.ACTINDX = C.ACTINDX;
 
GO
IF EXISTS ( SELECT  *
            FROM    sys.views
            WHERE   object_id = OBJECT_ID(N'[dbo].[vw_POPAAInformation]') )
    DROP VIEW [dbo].[vw_POPAAInformation];
 
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
/******************************************************************
Created May 09, 2011 by Sivakumar Venkataraman - Interdyn AKA
This view is to return the Analytical Accounting information 
for the PO lines (work and history PO's).
 
View Name: vw_POPAAInformation
Tables used: 
 - AAG20000 - AA SubLedger Header 
 - AAG20001 - AA SubLedger Distribution 
 - AAG20002 - AA SubLedger Distribution Assign 
 - AAG20003 - AA SubLedger Dimension Code 
 - AAG00400 - AA Transaction Dimension Master
 - AAG00401 - AA Transaction Dimension Code Master
 ******************************************************************/
CREATE VIEW [dbo].[vw_POPAAInformation]
AS
    SELECT  A.DOCNUMBR ,
            B.SEQNUMBR ,
            B.ACTINDX ,
            B.CURNCYID ,
            C.DEBITAMT ,
            C.CRDTAMNT ,
            C.ORDBTAMT ,
            C.ORCRDAMT ,
            E.aaTrxDim ,
            E.aaTrxDimDescr ,
            F.aaTrxDimCode ,
            F.aaTrxDimCodeDescr
    FROM    dbo.AAG20000 A
            INNER JOIN dbo.AAG20001 B ON B.aaSubLedgerHdrID = A.aaSubLedgerHdrID
            INNER JOIN dbo.AAG20002 C ON B.aaSubLedgerHdrID = C.aaSubLedgerHdrID
                                         AND B.aaSubLedgerDistID = C.aaSubLedgerDistID
            INNER JOIN dbo.AAG20003 D ON C.aaSubLedgerHdrID = D.aaSubLedgerHdrID
                                         AND C.aaSubLedgerDistID = D.aaSubLedgerDistID
                                         AND C.aaSubLedgerAssignID = D.aaSubLedgerAssignID
            INNER JOIN dbo.AAG00400 E ON D.aaTrxDimID = E.aaTrxDimID
            INNER JOIN dbo.AAG00401 F ON F.aaTrxDimID = D.aaTrxDimID
                                         AND F.aaTrxDimCodeID = D.aaTrxCodeID
    WHERE   ( A.SERIES = 12 );
 
GO
IF EXISTS ( SELECT  *
            FROM    sys.views
            WHERE   object_id = OBJECT_ID(N'[dbo].[vw_POInformationwithAA]') )
    DROP VIEW [dbo].[vw_POInformationwithAA];
 
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
/******************************************************************
Created May 09, 2011 by Sivakumar Venkataraman - Interdyn AKA
This view is to return the PO information (header and lines) 
along with the transaction dimension information for each PO.
 
View Name: vw_POInformationwithAA
Views used: 
 - vw_POInformation
 - vw_POPAAInformation
 ******************************************************************/
CREATE VIEW [dbo].[vw_POInformationwithAA]
AS
    SELECT  A.POSTATUS ,
            A.PONUMBER ,
            A.POTYPE ,
            A.DOCDATE ,
            A.VENDORID ,
            A.VENDNAME ,
            A.CURNCYID ,
            A.ITEMNMBR ,
            A.ITEMDESC ,
            A.VNDITNUM ,
            A.VNDITDSC ,
            A.LOCNCODE ,
            A.UOFM ,
            A.UMQTYINB ,
            A.UNITCOST ,
            A.EXTDCOST ,
            A.ACTNUMST ,
            A.ACTDESCR ,
            B.ORDBTAMT ,
            B.ORCRDAMT ,
            B.DEBITAMT ,
            B.CRDTAMNT ,
            B.aaTrxDim ,
            B.aaTrxDimDescr ,
            B.aaTrxDimCode ,
            B.aaTrxDimCodeDescr
    FROM    dbo.vw_POInformation A
            LEFT OUTER JOIN dbo.vw_POPAAInformation B ON A.PONUMBER = B.DOCNUMBR
                                                         AND A.ORD = B.SEQNUMBR;
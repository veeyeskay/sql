IF EXISTS ( SELECT  *
            FROM    sys.views
            WHERE   object_id = OBJECT_ID(N'[dbo].[vw_POPRcptInformation]') )
    DROP VIEW [dbo].[vw_POPRcptInformation];
GO
 
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
/******************************************************************
Created May 20, 2011 by Sivakumar Venkataraman - Interdyn AKA
This view is to return the PO Receipt information (header and lines) 
from both work and history tables.
 
View Name: vw_POInformation
Tables used: 
 - POP10300 - POP Receipt Work Header 
 - POP10310 - POP Receipt Work Line 
 - POP10500 - POP Line Distribution
 - POP30300 - POP Receipt History Header 
 - POP30310 - POP Receipt History Line 
 ******************************************************************/
CREATE VIEW [dbo].[vw_POPRcptInformation]
AS
    SELECT  A.POPRCTNM ,
            A.VNDDOCNM ,
            A.receiptdate ,
            A.POPTYPE ,
            A.VENDORID ,
            A.VENDNAME ,
            A.SUBTOTAL ,
            A.TRDISAMT ,
            A.FRTAMNT ,
            A.MISCAMNT ,
            A.TAXAMNT ,
            A.PYMTRMID ,
            A.DUEDATE ,
            A.CURNCYID ,
            A.RATETPID ,
            A.EXGTBLID ,
            A.XCHGRATE ,
            A.EXCHDATE ,
            A.ORSUBTOT ,
            A.ORTDISAM ,
            A.ORFRTAMT ,
            A.ORMISCAMT ,
            A.ORTAXAMT ,
            B.RCPTLNNM ,
            B.PONUMBER ,
            B.ITEMNMBR ,
            B.ITEMDESC ,
            B.VNDITNUM ,
            B.VNDITDSC ,
            B.UOFM ,
            B.UNITCOST ,
            B.EXTDCOST ,
            B.LOCNCODE ,
            B.ORUNTCST ,
            B.OREXTCST ,
            C.QTYSHPPD ,
            C.QTYINVCD ,
            C.QTYREJ ,
            C.QTYMATCH
    FROM    TWO.dbo.POP10300 A
            INNER JOIN TWO.dbo.POP10310 B ON A.POPRCTNM = B.POPRCTNM
            INNER JOIN TWO.dbo.POP10500 C ON B.POPRCTNM = C.POPRCTNM
                                             AND B.RCPTLNNM = C.RCPTLNNM
    UNION ALL
    SELECT  A.POPRCTNM ,
            A.VNDDOCNM ,
            A.receiptdate ,
            A.POPTYPE ,
            A.VENDORID ,
            A.VENDNAME ,
            A.SUBTOTAL ,
            A.TRDISAMT ,
            A.FRTAMNT ,
            A.MISCAMNT ,
            A.TAXAMNT ,
            A.PYMTRMID ,
            A.DUEDATE ,
            A.CURNCYID ,
            A.RATETPID ,
            A.EXGTBLID ,
            A.XCHGRATE ,
            A.EXCHDATE ,
            A.ORSUBTOT ,
            A.ORTDISAM ,
            A.ORFRTAMT ,
            A.ORMISCAMT ,
            A.ORTAXAMT ,
            B.RCPTLNNM ,
            B.PONUMBER ,
            B.ITEMNMBR ,
            B.ITEMDESC ,
            B.VNDITNUM ,
            B.VNDITDSC ,
            B.UOFM ,
            B.UNITCOST ,
            B.EXTDCOST ,
            B.LOCNCODE ,
            B.ORUNTCST ,
            B.OREXTCST ,
            C.QTYSHPPD ,
            C.QTYINVCD ,
            C.QTYREJ ,
            C.QTYMATCH
    FROM    TWO.dbo.POP30300 A
            INNER JOIN TWO.dbo.POP30310 B ON A.POPRCTNM = B.POPRCTNM
            INNER JOIN TWO.dbo.POP10500 C ON B.POPRCTNM = C.POPRCTNM
                                             AND B.RCPTLNNM = C.RCPTLNNM;
 
GO
 
IF EXISTS ( SELECT  *
            FROM    sys.views
            WHERE   object_id = OBJECT_ID(N'[dbo].[vw_POPRcptAAInformation]') )
    DROP VIEW [dbo].[vw_POPRcptAAInformation];
 
GO	
 
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
/******************************************************************
Created May 20, 2011 by Sivakumar Venkataraman - Interdyn AKA
This view is to return the Analytical Accounting information 
for the POP Receipt lines (work and history).
 
View Name: vw_POPAAInformation
Tables used: 
 - AAG20000 - AA SubLedger Header 
 - AAG20001 - AA SubLedger Distribution 
 - AAG20002 - AA SubLedger Distribution Assign 
 - AAG20003 - AA SubLedger Dimension Code 
 - AAG00400 - AA Transaction Dimension Master
 - AAG00401 - AA Transaction Dimension Code Master
 ******************************************************************/
CREATE VIEW [dbo].[vw_POPRcptAAInformation]
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
    FROM    TWO.dbo.AAG20000 A
            INNER JOIN TWO.dbo.AAG20001 B ON B.aaSubLedgerHdrID = A.aaSubLedgerHdrID
            INNER JOIN TWO.dbo.AAG20002 C ON B.aaSubLedgerHdrID = C.aaSubLedgerHdrID
                                             AND B.aaSubLedgerDistID = C.aaSubLedgerDistID
            INNER JOIN TWO.dbo.AAG20003 D ON C.aaSubLedgerHdrID = D.aaSubLedgerHdrID
                                             AND C.aaSubLedgerDistID = D.aaSubLedgerDistID
                                             AND C.aaSubLedgerAssignID = D.aaSubLedgerAssignID
            INNER JOIN TWO.dbo.AAG00400 E ON D.aaTrxDimID = E.aaTrxDimID
            INNER JOIN TWO.dbo.AAG00401 F ON F.aaTrxDimID = D.aaTrxDimID
                                             AND F.aaTrxDimCodeID = D.aaTrxCodeID
    WHERE   ( A.SERIES = 12
              AND A.DOCTYPE = 1
            );
 
GO
 
IF EXISTS ( SELECT  *
            FROM    sys.views
            WHERE   object_id = OBJECT_ID(N'[dbo].[vw_POPRcptInformationwithAA]') )
    DROP VIEW [dbo].[vw_POPRcptInformationwithAA];
 
GO
 
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
/******************************************************************
Created May 20, 2011 by Sivakumar Venkataraman - Interdyn AKA
This view is to return the POP Receipt information (header and lines) 
along with the transaction dimension information for each POP Receipt
Transaction.
 
View Name: vw_POInformationwithAA
Views used: 
 - vw_POPRcptInformation
 - vw_POPRcptAAInformation
 ******************************************************************/
CREATE VIEW [dbo].[vw_POPRcptInformationwithAA]
AS
    SELECT  A.POPRCTNM ,
            A.receiptdate ,
            A.POPTYPE ,
            A.VENDORID ,
            A.VENDNAME ,
            A.CURNCYID ,
            A.ORSUBTOT ,
            A.ORTDISAM ,
            A.ORFRTAMT ,
            A.ORMISCAMT ,
            A.ORTAXAMT ,
            A.VNDITNUM ,
            A.VNDITDSC ,
            A.UOFM ,
            A.LOCNCODE ,
            A.QTYSHPPD ,
            A.QTYINVCD ,
            A.ORUNTCST ,
            A.OREXTCST ,
            B.ORDBTAMT ,
            B.ORCRDAMT ,
            B.aaTrxDim ,
            B.aaTrxDimDescr ,
            B.aaTrxDimCode ,
            B.aaTrxDimCodeDescr
    FROM    dbo.vw_POPRcptInformation A
            LEFT OUTER JOIN dbo.vw_POPRcptAAInformation B ON A.POPRCTNM = B.DOCNUMBR
                                                             AND A.RCPTLNNM = B.SEQNUMBR;
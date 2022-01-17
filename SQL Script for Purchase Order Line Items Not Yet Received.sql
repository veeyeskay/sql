/******************************************************************
Created June 23, 2011 by Sivakumar Venkataraman - Interdyn AKA
This view returns a returns the details of the PO Line which has
not been received fully. It provides the details of the quantity
to be received and the value of the line item to be received in
originating currency.
 
Tables used: 
 - POP10100 - Purchase Order Work
 - POP10110 - Purchase Order Line
 - POP10500 - Purchasing Receipt Line Quantities
 ******************************************************************/
SELECT  PO.[PO NUMBER] ,
        PO.[PO STATUS] ,
        PO.[PO TYPE] ,
        PO.[PO DATE] ,
        PO.[Currency ID] ,
        PO.[Vendor ID] ,
        PO.[Vendor Name] ,
        PO.[PO Line NUMBER] ,
        PO.[Item NUMBER] ,
        PO.[Item DESC] ,
        PO.[Vendor Item NUMBER] ,
        PO.[Vendor Item DESC] ,
        PO.[Location Code] ,
        PO.[UoM] ,
        ( ( PO.[Qty Ordered] - PO.[Qty Canceled] ) - PO.[Qty Shipped] ) AS [Qty TO Recv] ,
        ( ( ( PO.[Qty Ordered] - PO.[Qty Canceled] ) - PO.[Qty Shipped] )
          * PO.[Orig Unit Cost] ) AS [PO Line Remain VALUE]
FROM    ( SELECT    A.PONUMBER AS [PO NUMBER] ,
                    CASE WHEN A.POSTATUS = 1 THEN 'New'
                         WHEN A.POSTATUS = 2 THEN 'Released'
                         WHEN A.POSTATUS = 3 THEN 'Change Order'
                         WHEN A.POSTATUS = 4 THEN 'Received'
                         WHEN A.POSTATUS = 5 THEN 'Closed'
                         ELSE 'Canceled'
                    END AS [PO STATUS] ,
                    CASE WHEN A.POTYPE = 1 THEN 'Standard'
                         WHEN A.POTYPE = 2 THEN 'Drop-ship'
                         WHEN A.POTYPE = 3 THEN 'Blanket'
                         WHEN A.POTYPE = 4 THEN 'Drop-ship Blanket'
                         ELSE ''
                    END AS [PO TYPE] ,
                    A.DOCDATE AS [PO DATE] ,
                    A.CURNCYID AS [Currency ID] ,
                    A.ORSUBTOT AS [Orig Subtotal] ,
                    A.ORTDISAM AS [Orig Trade Disc] ,
                    A.ORFRTAMT AS [Orig Freight Amt] ,
                    A.OMISCAMT AS [Orig Misc Amt] ,
                    A.ORTAXAMT AS [Orig Tax Amt] ,
                    A.VENDORID AS [Vendor ID] ,
                    A.VENDNAME AS [Vendor Name] ,
                    B.ORD AS [PO Line NUMBER] ,
                    CASE WHEN B.POLNESTA = 1 THEN 'New'
                         WHEN B.POLNESTA = 2 THEN 'Released'
                         WHEN B.POLNESTA = 3 THEN 'Change Order'
                         WHEN B.POLNESTA = 4 THEN 'Received'
                         WHEN B.POLNESTA = 5 THEN 'Closed'
                         ELSE 'Canceled'
                    END AS [PO Line STATUS] ,
                    B.ITEMNMBR AS [Item NUMBER] ,
                    B.ITEMDESC AS [Item DESC] ,
                    B.VNDITNUM AS [Vendor Item NUMBER] ,
                    B.VNDITDSC AS [Vendor Item DESC] ,
                    B.LOCNCODE AS [Location Code] ,
                    B.UOFM AS [UoM] ,
                    B.QTYORDER AS [Qty Ordered] ,
                    B.QTYCANCE AS [Qty Canceled] ,
                    B.ORUNTCST AS [Orig Unit Cost] ,
                    B.OREXTCST AS [Orig Extd Cost] ,
                    ISNULL(( SELECT SUM(C.QTYSHPPD)
                             FROM   TWO.dbo.POP10500 C
                             WHERE  C.PONUMBER = B.PONUMBER
                                    AND C.POLNENUM = B.ORD
                                    AND C.POPTYPE IN ( 1, 2, 3 )
                           ), 0) AS [Qty Shipped] ,
                    ISNULL(( SELECT SUM(C.QTYINVCD)
                             FROM   TWO.dbo.POP10500 C
                             WHERE  C.PONUMBER = B.PONUMBER
                                    AND C.POLNENUM = B.ORD
                                    AND C.POPTYPE IN ( 1, 2, 3 )
                           ), 0) AS [Qty Invoiced] ,
                    ISNULL(( SELECT SUM(C.QTYRESERVED)
                             FROM   TWO.dbo.POP10500 C
                             WHERE  C.PONUMBER = B.PONUMBER
                                    AND C.POLNENUM = B.ORD
                                    AND C.POPTYPE IN ( 1, 2, 3 )
                           ), 0) AS [Qty Returned]
          FROM      TWO.dbo.POP10100 A
                    INNER JOIN TWO.dbo.POP10110 B ON A.PONUMBER = B.PONUMBER
        ) PO
WHERE   ( ( PO.[Qty Ordered] - PO.[Qty Canceled] ) - PO.[Qty Shipped] ) > 0
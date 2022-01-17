/*******************************************************************
Created on Nov 23, 2010 by Sivakumar Venkataraman
For updates see http://cvakumar.com/msdynamics/
This query provides the last purchase cost of various items
and the vendor combination that have been processed in Dynamics GP. 
 
The Last_Originating_Cost is the cost price of the last 
purchase made for that item from the specific vendor. 
The Last_Currency_ID is the currency ID for the last purchase made
for that item from the specific vendor.
*******************************************************************/
SELECT  A.VENDORID ,
        B.ITEMDESC ,
        A.VENDORID ,
        C.VENDNAME ,
        A.VNDITNUM ,
        A.VNDITDSC ,
        A.Last_Currency_ID ,
        A.Last_Originating_Cost
FROM    dbo.IV00103 A
        INNER JOIN IV00101 B ON A.ITEMNMBR = B.ITEMNMBR
        INNER JOIN dbo.PM00200 C ON A.VENDORID = C.VENDORID;
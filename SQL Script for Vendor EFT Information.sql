SELECT  A.VENDORID ,
        A.VENDNAME ,
        A.VNDCHKNM ,
        A.VENDSHNM ,
        A.VNDCLSID ,
        C.VNDCLDSC ,
        B.ADRSCODE ,
        B.VNDCNTCT ,
        B.ADDRESS1 ,
        B.ADDRESS2 ,
        B.ADDRESS3 ,
        B.CITY ,
        B.STATE ,
        B.ZIPCODE ,
        B.COUNTRY ,
        B.PHNUMBR1 ,
        B.FAXNUMBR ,
        D.EFTBankType ,
        D.BANKNAME ,
        D.EFTBankAcct ,
        D.EFTBankBranch ,
        D.EFTBankCode ,
        D.EFTBankBranchCode ,
        D.EFTBankCheckDigit ,
        D.EFTTransitRoutingNo ,
        D.EFTTransferMethod ,
        D.CURNCYID ,
        D.EFTAccountType ,
        D.EFTPrenoteDate ,
        D.EFTTerminationDate ,
        D.BNKCTRCD ,
        D.SWIFTADDR ,
        D.IntlBankAcctNum
FROM    TWO.dbo.PM00200 A
        INNER JOIN TWO.dbo.PM00300 B ON A.VENDORID = B.VENDORID
        LEFT OUTER JOIN TWO.dbo.PM00100 C ON A.VNDCLSID = C.VNDCLSID
        LEFT OUTER JOIN TWO.dbo.SY06000 D ON B.ADRSCODE = D.ADRSCODE
                                             AND B.VENDORID = D.CustomerVendor_ID
                                             AND D.SERIES = 4;
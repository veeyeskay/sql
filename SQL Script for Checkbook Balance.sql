SELECT Z.CHECKBOOKID,
        Z.GPACCOUNTNO,
        Z.DOCUMENTNO,
        Z.DOCTYPE,
        Z.DOCTYPENAME,
        Z.POSTINGDATE,
        Z.DOCUMENTAMOUNT
 FROM   ( SELECT    A.CHEKBKID AS CHECKBOOKID,
                    RTRIM(D.ACTNUMST) AS GPACCOUNTNO,
                    A.CMTrxNum AS DOCUMENTNO,
                    C.DOCABREV AS DOCTYPE,
                    C.DOCTYNAM AS DOCTYPENAME,
                    A.GLPOSTDT AS POSTINGDATE,
                    ( A.TRXAMNT * -1 ) AS DOCUMENTAMOUNT
          FROM      dbo.CM20200 A
                    INNER JOIN dbo.CM00100 B ON A.CHEKBKID = B.CHEKBKID
                    INNER JOIN dbo.CM40101 C ON A.CMTrxType = C.CMTrxType
                    INNER JOIN dbo.GL00105 D ON B.ACTINDX = D.ACTINDX
          WHERE     A.VOIDED = 0
          UNION ALL
          SELECT    A.CHEKBKID AS CHECKBOOKID,
                    RTRIM(D.ACTNUMST) AS GPACCOUNTNO,
                    A.CMTrxNum AS DOCUMENTNO,
                    C.DOCABREV AS DOCTYPE,
                    C.DOCTYNAM AS DOCTYPENAME,
                    A.GLPOSTDT AS POSTINGDATE,
                    A.TRXAMNT AS DOCUMENTAMOUNT
          FROM      dbo.CM20200 A
                    INNER JOIN dbo.CM00100 B ON A.CHEKBKID = B.CHEKBKID
                    INNER JOIN dbo.CM40101 C ON A.CMTrxType = C.CMTrxType
                    INNER JOIN dbo.GL00105 D ON B.ACTINDX = D.ACTINDX
          WHERE     A.VOIDED = 1
          UNION ALL
          SELECT    A.CHEKBKID AS CHECKBOOKID,
                    RTRIM(D.ACTNUMST) AS GPACCOUNTNO,
                    A.RCPTNMBR AS DOCUMENTNO,
                    C.DOCABREV AS DOCTYPE,
                    C.DOCTYNAM AS DOCTYPENAME,
                    A.GLPOSTDT AS POSTINGDATE,
                    A.RCPTAMT AS DOCUMENTAMOUNT
          FROM      dbo.CM20300 A
                    INNER JOIN dbo.CM00100 B ON A.CHEKBKID = B.CHEKBKID
                    INNER JOIN dbo.CM40101 C ON A.RcpType = C.CMTrxType
                    INNER JOIN dbo.GL00105 D ON B.ACTINDX = D.ACTINDX
          WHERE     VOIDED = 0
          UNION ALL
          SELECT    A.CHEKBKID AS CHECKBOOKID,
                    RTRIM(D.ACTNUMST) AS GPACCOUNTNO,
                    A.RCPTNMBR AS DOCUMENTNO,
                    C.DOCABREV AS DOCTYPE,
                    C.DOCTYNAM AS DOCTYPENAME,
                    A.GLPOSTDT AS POSTINGDATE,
                    ( A.RCPTAMT * -1 ) AS DOCUMENTAMOUNT
          FROM      dbo.CM20300 A
                    INNER JOIN dbo.CM00100 B ON A.CHEKBKID = B.CHEKBKID
                    INNER JOIN dbo.CM40101 C ON A.RcpType = C.CMTrxType
                    INNER JOIN dbo.GL00105 D ON B.ACTINDX = D.ACTINDX
          WHERE     VOIDED = 1
        ) Z
 ORDER BY Z.CHECKBOOKID,
        Z.GPACCOUNTNO,
        Z.DOCUMENTNO,
        Z.DOCTYPE,
        Z.DOCTYPENAME,
        Z.POSTINGDATE
SELECT  A.CHEKBKID ,
        A.PSTGDATE ,
        ISNULL(( SELECT SUM(B.DOCAMNT)
                 FROM   dbo.PM30200 B
                 WHERE  B.DOCTYPE = 6
                        AND B.CHEKBKID = A.CHEKBKID
                        AND B.PSTGDATE = A.PSTGDATE
               ), 0) AS CHECKAMOUNT ,
        ISNULL(( SELECT SUM(B.DOCAMNT)
                 FROM   dbo.PM30200 B
                 WHERE  B.DOCTYPE = 6
                        AND B.CHEKBKID = A.CHEKBKID
                        AND B.PSTGDATE = A.PSTGDATE
                        AND B.VOIDED = 1
               ), 0) AS VOIDEDCHECKS
FROM    dbo.PM30200 A
WHERE   A.DOCTYPE = 6
        AND A.PSTGDATE <> '1900-01-01'
GROUP BY A.CHEKBKID ,
        A.PSTGDATE;
/******************************************************************
Created July 25, 2011 by Sivakumar Venkataraman - Interdyn AKA
This view is for the Payables HATB for aging by due date and
picking transactions using the GL Posting Date.
 
Tables used: 
 - PM20000 - PM Transaction OPEN File
 - PM30200 - PM Paid Transaction History File
 - PM10200 - PM Apply To WORK OPEN File
 - PM30300 - PM Apply To History File
 - PM40101 - PM Period Setup File
 - PM40102 - Payables Document Types
 ******************************************************************/
 
DECLARE @EMPTYDATE AS DATETIME;
DECLARE @ASOFDATE AS DATETIME;
 
SET @EMPTYDATE = '1900-01-01';
SET @ASOFDATE = '2017-04-12';
 
SELECT  W.VENDORID ,
        W.VCHRNMBR ,
        W1.DOCTYNAM AS DOCTYPE ,
        W.DOCNUMBR ,
        W.DOCDATE ,
        W.TRXSORCE ,
        W.PSTGDATE ,
        W.DUEDATE ,
        W.AGINGBUCKET ,
        W.DOCUMENTAMT ,
        W.CURTRXAMT
FROM    ( SELECT    X.VENDORID ,
                    X.VCHRNMBR ,
                    X.DOCTYPE ,
                    X.DOCNUMBR ,
                    X.DOCDATE ,
                    X.TRXSORCE ,
                    X.VOIDED ,
                    X.PSTGDATE ,
                    X.DUEDATE ,
                    X.DAYSDUE ,
                    CASE WHEN X.DAYSDUE > 999 THEN ( SELECT TOP 1
                                                            DSCRIPTN
                                                     FROM   dbo.PM40101
                                                     ORDER BY ENDGPDYS DESC
                                                   )
                         WHEN X.DAYSDUE < 0 THEN 'Not Due'
                         ELSE ISNULL(( SELECT TOP 1
                                                DSCRIPTN
                                       FROM     dbo.PM40101 AG
                                       WHERE    X.DAYSDUE <= AG.ENDGPDYS
                                       ORDER BY ENDGPDYS
                                     ), '')
                    END AS AGINGBUCKET ,
                    X.VOIDPDATE ,
                    X.DOCUMENTAMT ,
                    X.APPLIEDAMT ,
                    X.WRITEOFFAMT ,
                    X.DISCTAKENAMT ,
                    X.REALGAINLOSSAMT ,
                    CASE WHEN X.DOCTYPE <= 3
                         THEN ( X.DOCUMENTAMT - X.APPLIEDAMT - X.WRITEOFFAMT
                                - X.DISCTAKENAMT + X.REALGAINLOSSAMT )
                         ELSE ( X.DOCUMENTAMT - X.APPLIEDAMT - X.WRITEOFFAMT
                                - X.DISCTAKENAMT + X.REALGAINLOSSAMT ) * -1
                    END AS CURTRXAMT
          FROM      ( SELECT    Z.VCHRNMBR ,
                                Z.VENDORID ,
                                Z.DOCTYPE ,
                                Z.DOCDATE ,
                                Z.DOCNUMBR ,
                                Z.DOCAMNT AS DOCUMENTAMT ,
                                CASE WHEN DOCTYPE <= 3
                                     THEN ISNULL(( SELECT   SUM(Y.APPLDAMT)
                                                   FROM     ( SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APPLDAMT
                                                              FROM
                                                              dbo.PM10200
                                                              UNION
                                                              SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APPLDAMT
                                                              FROM
                                                              dbo.PM30300
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                            AND Y.VENDORID = Z.VENDORID
                                                            AND Y.APTVCHNM = Z.VCHRNMBR
                                                            AND Y.APTODCTY = Z.DOCTYPE
                                                 ), 0)
                                     WHEN DOCTYPE > 3
                                          AND DOCTYPE <= 6
                                     THEN ISNULL(( SELECT   SUM(Y.APPLDAMT)
                                                   FROM     ( SELECT
                                                              VENDORID ,
                                                              GLPOSTDT ,
                                                              APPLDAMT ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              ApplyToGLPostDate
                                                              FROM
                                                              dbo.PM10200
                                                              UNION
                                                              SELECT
                                                              VENDORID ,
                                                              GLPOSTDT ,
                                                              APPLDAMT ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              ApplyToGLPostDate
                                                              FROM
                                                              dbo.PM30300
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <> @EMPTYDATE
                                                            AND Y.VENDORID = Z.VENDORID
                                                            AND Y.VCHRNMBR = Z.VCHRNMBR
                                                            AND Y.DOCTYPE = Z.DOCTYPE
                                                 ), 0)
                                     ELSE 0
                                END AS APPLIEDAMT ,
                                CASE WHEN DOCTYPE <= 3
                                     THEN ISNULL(( SELECT   SUM(Y.WROFAMNT)
                                                   FROM     ( SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              WROFAMNT
                                                              FROM
                                                              dbo.PM10200
                                                              UNION
                                                              SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              WROFAMNT
                                                              FROM
                                                              dbo.PM30300
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                            AND Y.VENDORID = Z.VENDORID
                                                            AND Y.APTVCHNM = Z.VCHRNMBR
                                                            AND Y.APTODCTY = Z.DOCTYPE
                                                 ), 0)
                                     ELSE 0
                                END AS WRITEOFFAMT ,
                                CASE WHEN DOCTYPE <= 3
                                     THEN ISNULL(( SELECT   SUM(Y.DISTKNAM)
                                                   FROM     ( SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              DISTKNAM
                                                              FROM
                                                              dbo.PM10200
                                                              UNION
                                                              SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              DISTKNAM
                                                              FROM
                                                              dbo.PM30300
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                            AND Y.VENDORID = Z.VENDORID
                                                            AND Y.APTVCHNM = Z.VCHRNMBR
                                                            AND Y.APTODCTY = Z.DOCTYPE
                                                 ), 0)
                                     ELSE 0
                                END AS DISCTAKENAMT ,
                                CASE WHEN DOCTYPE > 3
                                     THEN ISNULL(( SELECT   SUM(Y.RLGANLOS)
                                                   FROM     ( SELECT
                                                              VENDORID ,
                                                              GLPOSTDT ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              ApplyToGLPostDate ,
                                                              RLGANLOS
                                                              FROM
                                                              dbo.PM10200
                                                              UNION
                                                              SELECT
                                                              VENDORID ,
                                                              GLPOSTDT ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              ApplyToGLPostDate ,
                                                              RLGANLOS
                                                              FROM
                                                              dbo.PM30300
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <> @EMPTYDATE
                                                            AND Y.VENDORID = Z.VENDORID
                                                            AND Y.VCHRNMBR = Z.VCHRNMBR
                                                            AND Y.DOCTYPE = Z.DOCTYPE
                                                 ), 0)
                                     ELSE 0
                                END AS REALGAINLOSSAMT ,
                                Z.TRXSORCE ,
                                Z.VOIDED ,
                                Z.PSTGDATE ,
                                Z.DUEDATE ,
                                DATEDIFF(dd, Z.DUEDATE, @ASOFDATE) AS DAYSDUE ,
                                Z.VOIDPDATE
                      FROM      ( SELECT    VCHRNMBR ,
                                            VENDORID ,
                                            DOCTYPE ,
                                            DOCDATE ,
                                            DOCNUMBR ,
                                            DOCAMNT ,
                                            BACHNUMB ,
                                            TRXSORCE ,
                                            BCHSOURC ,
                                            DISCDATE ,
                                            VOIDED ,
                                            PSTGDATE ,
                                            CASE WHEN DUEDATE = '1900-01-01'
                                                 THEN @ASOFDATE
                                                 ELSE [DUEDATE]
                                            END AS DUEDATE ,
                                            @EMPTYDATE AS VOIDPDATE
                                  FROM      dbo.PM20000
                                  UNION ALL
                                  SELECT    VCHRNMBR ,
                                            VENDORID ,
                                            DOCTYPE ,
                                            DOCDATE ,
                                            DOCNUMBR ,
                                            DOCAMNT ,
                                            BACHNUMB ,
                                            TRXSORCE ,
                                            BCHSOURC ,
                                            DISCDATE ,
                                            VOIDED ,
                                            PSTGDATE ,
                                            CASE WHEN DUEDATE = '1900-01-01'
                                                 THEN @ASOFDATE
                                                 ELSE [DUEDATE]
                                            END AS DUEDATE ,
                                            VOIDPDATE
                                  FROM      dbo.PM30200
                                ) Z
                      WHERE     Z.PSTGDATE <= @ASOFDATE
                                AND Z.VOIDED = 0
                    ) X
          UNION ALL
          SELECT    X.VENDORID ,
                    X.VCHRNMBR ,
                    X.DOCTYPE ,
                    X.DOCNUMBR ,
                    X.DOCDATE ,
                    X.TRXSORCE ,
                    X.VOIDED ,
                    X.PSTGDATE ,
                    X.DUEDATE ,
                    X.DAYSDUE ,
                    CASE WHEN X.DAYSDUE > 999 THEN ( SELECT TOP 1
                                                            DSCRIPTN
                                                     FROM   dbo.PM40101
                                                     ORDER BY ENDGPDYS DESC
                                                   )
                         WHEN X.DAYSDUE < 0 THEN 'Not Due'
                         ELSE ISNULL(( SELECT TOP 1
                                                DSCRIPTN
                                       FROM     dbo.PM40101 AG
                                       WHERE    X.DAYSDUE <= AG.ENDGPDYS
                                       ORDER BY ENDGPDYS
                                     ), '')
                    END AS AGINGBUCKET ,
                    X.VOIDPDATE ,
                    X.DOCUMENTAMT ,
                    X.APPLIEDAMT ,
                    X.WRITEOFFAMT ,
                    X.DISCTAKENAMT ,
                    X.REALGAINLOSSAMT ,
                    ( X.DOCUMENTAMT - X.APPLIEDAMT - X.WRITEOFFAMT
                      - X.DISCTAKENAMT + X.REALGAINLOSSAMT ) * -1 AS CURTRXAMT
          FROM      ( SELECT    Z.VCHRNMBR ,
                                Z.VENDORID ,
                                Z.DOCTYPE ,
                                Z.DOCDATE ,
                                Z.DOCNUMBR ,
                                Z.DOCAMNT AS DOCUMENTAMT ,
                                CASE WHEN DOCTYPE <= 3
                                     THEN ISNULL(( SELECT   SUM(Y.APPLDAMT)
                                                   FROM     ( SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APPLDAMT
                                                              FROM
                                                              dbo.PM10200
                                                              UNION
                                                              SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APPLDAMT
                                                              FROM
                                                              dbo.PM30300
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                            AND Y.VENDORID = Z.VENDORID
                                                            AND Y.APTVCHNM = Z.VCHRNMBR
                                                            AND Y.APTODCTY = Z.DOCTYPE
                                                 ), 0)
                                     WHEN DOCTYPE > 3
                                          AND DOCTYPE <= 6
                                     THEN ISNULL(( SELECT   SUM(Y.APPLDAMT)
                                                   FROM     ( SELECT
                                                              VENDORID ,
                                                              GLPOSTDT ,
                                                              APPLDAMT ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              ApplyToGLPostDate
                                                              FROM
                                                              dbo.PM10200
                                                              UNION
                                                              SELECT
                                                              VENDORID ,
                                                              GLPOSTDT ,
                                                              APPLDAMT ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              ApplyToGLPostDate
                                                              FROM
                                                              dbo.PM30300
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <> @EMPTYDATE
                                                            AND Y.VENDORID = Z.VENDORID
                                                            AND Y.VCHRNMBR = Z.VCHRNMBR
                                                            AND Y.DOCTYPE = Z.DOCTYPE
                                                 ), 0)
                                     ELSE 0
                                END AS APPLIEDAMT ,
                                CASE WHEN DOCTYPE <= 3
                                     THEN ISNULL(( SELECT   SUM(Y.WROFAMNT)
                                                   FROM     ( SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              WROFAMNT
                                                              FROM
                                                              dbo.PM10200
                                                              UNION
                                                              SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              WROFAMNT
                                                              FROM
                                                              dbo.PM30300
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                            AND Y.VENDORID = Z.VENDORID
                                                            AND Y.APTVCHNM = Z.VCHRNMBR
                                                            AND Y.APTODCTY = Z.DOCTYPE
                                                 ), 0)
                                     ELSE 0
                                END AS WRITEOFFAMT ,
                                CASE WHEN DOCTYPE <= 3
                                     THEN ISNULL(( SELECT   SUM(Y.DISTKNAM)
                                                   FROM     ( SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              DISTKNAM
                                                              FROM
                                                              dbo.PM10200
                                                              UNION
                                                              SELECT
                                                              VENDORID ,
                                                              ApplyFromGLPostDate ,
                                                              GLPOSTDT ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              DISTKNAM
                                                              FROM
                                                              dbo.PM30300
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                            AND Y.VENDORID = Z.VENDORID
                                                            AND Y.APTVCHNM = Z.VCHRNMBR
                                                            AND Y.APTODCTY = Z.DOCTYPE
                                                 ), 0)
                                     ELSE 0
                                END AS DISCTAKENAMT ,
                                CASE WHEN DOCTYPE > 3
                                     THEN ISNULL(( SELECT   SUM(Y.RLGANLOS)
                                                   FROM     ( SELECT
                                                              VENDORID ,
                                                              GLPOSTDT ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              ApplyToGLPostDate ,
                                                              RLGANLOS
                                                              FROM
                                                              dbo.PM10200
                                                              UNION
                                                              SELECT
                                                              VENDORID ,
                                                              GLPOSTDT ,
                                                              VCHRNMBR ,
                                                              DOCTYPE ,
                                                              APTVCHNM ,
                                                              APTODCTY ,
                                                              ApplyToGLPostDate ,
                                                              RLGANLOS
                                                              FROM
                                                              dbo.PM30300
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <> @EMPTYDATE
                                                            AND Y.VENDORID = Z.VENDORID
                                                            AND Y.VCHRNMBR = Z.VCHRNMBR
                                                            AND Y.DOCTYPE = Z.DOCTYPE
                                                 ), 0)
                                     ELSE 0
                                END AS REALGAINLOSSAMT ,
                                Z.TRXSORCE ,
                                Z.VOIDED ,
                                Z.PSTGDATE ,
                                Z.DUEDATE ,
                                DATEDIFF(dd, Z.DUEDATE, @ASOFDATE) AS DAYSDUE ,
                                Z.VOIDPDATE
                      FROM      ( SELECT    VCHRNMBR ,
                                            VENDORID ,
                                            DOCTYPE ,
                                            DOCDATE ,
                                            DOCNUMBR ,
                                            DOCAMNT ,
                                            BACHNUMB ,
                                            TRXSORCE ,
                                            BCHSOURC ,
                                            DISCDATE ,
                                            VOIDED ,
                                            PSTGDATE ,
                                            CASE WHEN DUEDATE = '1900-01-01'
                                                 THEN @ASOFDATE
                                                 ELSE [DUEDATE]
                                            END AS DUEDATE ,
                                            @EMPTYDATE AS VOIDPDATE
                                  FROM      dbo.PM20000
                                  UNION
                                  SELECT    VCHRNMBR ,
                                            VENDORID ,
                                            DOCTYPE ,
                                            DOCDATE ,
                                            DOCNUMBR ,
                                            DOCAMNT ,
                                            BACHNUMB ,
                                            TRXSORCE ,
                                            BCHSOURC ,
                                            DISCDATE ,
                                            VOIDED ,
                                            PSTGDATE ,
                                            CASE WHEN DUEDATE = '1900-01-01'
                                                 THEN @ASOFDATE
                                                 ELSE [DUEDATE]
                                            END AS DUEDATE ,
                                            VOIDPDATE
                                  FROM      dbo.PM30200
                                ) Z
                      WHERE     Z.PSTGDATE <= @ASOFDATE
                                AND Z.VOIDED = 1
                                AND Z.VOIDPDATE > @ASOFDATE
                    ) X
        ) W
        INNER JOIN dbo.PM40102 W1 ON W.DOCTYPE = W1.DOCTYPE
WHERE   W.CURTRXAMT <> 0;
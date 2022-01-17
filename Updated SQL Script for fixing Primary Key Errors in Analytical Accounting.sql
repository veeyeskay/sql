DECLARE @aaRowID INT;
DECLARE @CMPANYID INT;
 
SELECT  @CMPANYID = CMPANYID
FROM    DYNAMICS.dbo.SY01500
WHERE   INTERID = DB_NAME();
 
--Update the keys for AAG00201 table
SELECT  @aaRowID = ISNULL(MAX(aaAcctClassID), 0)
FROM    dbo.AAG00201;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 201 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 201
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 201, @CMPANYID, @aaRowID );
            END;
    END;	
 
--Update the keys for AAG00301 table
SELECT  @aaRowID = ISNULL(MAX(aaDistrQueryID), 0)
FROM    dbo.AAG00301;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 301 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 301
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        		
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 301, @CMPANYID, @aaRowID );
            END;
    END;	
 
--Update the keys for AAG00310 table
SELECT  @aaRowID = ISNULL(MAX(aaMLQueryID), 0)
FROM    dbo.AAG00310;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 310 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 310
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 310, @CMPANYID, @aaRowID );
            END;
    END;	
 
--Update the keys for AAG00400 table
SELECT  @aaRowID = ISNULL(MAX(aaTrxDimID), 0)
FROM    dbo.AAG00400;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 400 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 400
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 400, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG00401 table
SELECT  @aaRowID = ISNULL(MAX(aaTrxDimCodeID), 0)
FROM    dbo.AAG00401;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 401 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 401
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 401, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG00402 table
SELECT  @aaRowID = ISNULL(MAX(aaTrxDimCodeNumID), 0)
FROM    dbo.AAG00402;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 402 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 402
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 402, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG00403 table
SELECT  @aaRowID = ISNULL(MAX(aaTrxDimCodeBoolID), 0)
FROM    dbo.AAG00403;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 403 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 403
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 403, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG00404 table
SELECT  @aaRowID = ISNULL(MAX(aaTrxDimCodeDateID), 0)
FROM    dbo.AAG00404;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 404 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 404
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 404, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG00500 table
SELECT  @aaRowID = ISNULL(MAX(aaDateID), 0)
FROM    dbo.AAG00500;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 500 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 500
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 500, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG00600 table
SELECT  @aaRowID = ISNULL(MAX(aaTreeID), 0)
FROM    dbo.AAG00600;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 600 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 600
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 600, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG00601 table
SELECT  @aaRowID = ISNULL(MAX(aaNodeID), 0)
FROM    dbo.AAG00601;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 601 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 601
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 601, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG00700 table
SELECT  @aaRowID = ISNULL(MAX(aaOption), 0)
FROM    dbo.AAG00700;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 700 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 700
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 700, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG00800 table
SELECT  @aaRowID = ISNULL(MAX(aaAliasID), 0)
FROM    dbo.AAG00800;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 800 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 800
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 800, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG00900 table
SELECT  @aaRowID = ISNULL(MAX(aaBudgetTreeID), 0)
FROM    dbo.AAG00900;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 900 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 900
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 900, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG01000 table
SELECT  @aaRowID = ISNULL(MAX(aaUDFID), 0)
FROM    dbo.AAG01000;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 1000 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 1000
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 1000, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG10000 table
SELECT  @aaRowID = ISNULL(MAX(aaGLWorkHdrID), 0)
FROM    dbo.AAG10000;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 10000 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 10000
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 10000, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG20000 table
SELECT  @aaRowID = ISNULL(MAX(aaSubLedgerHdrID), 0)
FROM    dbo.AAG20000;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 20000 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 20000
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 20000, @CMPANYID, @aaRowID );
            END;
    END;
 
--Update the keys for AAG30000 table
SELECT  @aaRowID = ISNULL(MAX(aaGLHdrID), 0)
FROM    dbo.AAG30000;
IF EXISTS ( SELECT  *
            FROM    DYNAMICS.dbo.AAG00102
            WHERE   aaTableID = 30000 )
    BEGIN
        UPDATE  DYNAMICS.dbo.AAG00102
        SET     aaRowID = @aaRowID
        WHERE   aaTableID = 30000
                AND CMPANYID = @CMPANYID;
    END;
ELSE
    BEGIN
        IF @aaRowID > 0
            BEGIN		        				
                INSERT  INTO DYNAMICS.dbo.AAG00102
                        ( aaTableID, CMPANYID, aaRowID )
                VALUES  ( 30000, @CMPANYID, @aaRowID );
            END;
    END;